Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:12120 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbYJXCmo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 22:42:44 -0400
Subject: Re: [PATCH] wireless: add regulatory_struct_hint
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1224585110.5521.8.camel@johannes.berg>
References: <1224585110.5521.8.camel@johannes.berg>
Content-Type: multipart/mixed; boundary="=-xlgomRz5AZ3fR5BRFykX"
Date: Fri, 24 Oct 2008 10:43:03 +0800
Message-Id: <1224816184.2917.162.camel@debian.sh.intel.com> (sfid-20081024_044255_449802_CE7CB035)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xlgomRz5AZ3fR5BRFykX
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2008-10-21 at 03:31 -0700, Johannes Berg wrote:
> This adds a new function, regulatory_struct_hint, which acts
> as a hint to the wireless core which regdomain a card thinks
> the system is operating in, but given in terms of the actual
> regdomain definition. Multiple hints are permitted when the
> specified bands do not overlap.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Thanks for the patch. I think this implemnted what we called the
per-band regulatory hint as we discussed. I'll test it.

It should solve the *real* problem. But in theory, it is still not
correct. I couldn't find a real example here. Let me just suppose a
non-exist device D, which is known to be broken for its channel 6. The
device excludes channel 6 on its EEPROM, thus the driver
regulatory_struct_hint() without channel 6. Then user insert the second
card. The second card works also without channel 6 support!

The real problem here is the mess up of device capabiliy vs. regulatory
rules. The channles a CARDx in a system with n wifi cards can be used
is:

(CARD1_REG & CARD2_REG & ... & CARDn_REG) & CARDx_CAPA

Given a device with the information of (CARDx_REG & CARDx_CAPA) in the
EEPROM, use it as the regulatory rules for the whole system is wrong. It
ends out CARDy is constrained with the capability of CARDx!

(CARD1_REG & ... & CARDx_REG & CARDx_CAPA & ...) & CARDy_CAPA

Although I couldn't find a real example in reality. And the valid dual
bands example is solved by this patch. So I don't have strong argument
on solving something not existed. But the logic is wrong!

I've attached my implmentation to this problem.

Thanks,
-yi

--=-xlgomRz5AZ3fR5BRFykX
Content-Disposition: attachment; filename=reg.patch
Content-Type: message/rfc822; name=reg.patch

From: "Zhu, Yi" <yi.zhu@intel.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "Zhu, Yi" <yi.zhu@intel.com>
Date: Wed, 22 Oct 2008 03:11:09 -0600
Subject: [RFC] wireless: add hardware supported regulatory domain
	enforcement
Thread-Topic: [RFC] wireless: add hardware supported regulatory domain
	enforcement
Thread-Index: Ack0JvPLytdQNTNtS+GuQt5m9YUWLg==
Message-ID: <1224666669-4538-1-git-send-email-yi.zhu@intel.com>
Accept-Language: en-US
X-MS-Exchange-Organization-AuthAs: Internal
X-MS-Exchange-Organization-AuthMechanism: 0b
X-MS-Exchange-Organization-AuthSource: azsmsx601.amr.corp.intel.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originalarrivaltime: 22 Oct 2008 09:16:47.0304 (UTC)
	FILETIME=[E8A10C80:01C93426]
x-ironport-av: E=Sophos;i="4.33,463,1220252400"; d="scan'208";a="454250261"
x-extloop1: 1
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

The patch extends the current regulatory framework to support regulatory
enforcement by device hardware (firmware). If the regulatory check is
performed by hardware, the driver uses a special flag to indicate the
regulatory framework, so that the regulatory framework will bypass all
the regulatory checks for this device and delegate it to the hardware.

The implementation of this "bypass" introduces a virtual regulatory domain
which is a super set of all the existed regdomains. Note the virtual
regdomain allows to be overwritten by any other regdomains from user,
country IE, core, or other drivers.

The patch resolves the problem a wireless device doesn't export enough
information for the regulatory domain it uses. This information is
unnecessary if the regulatory check can be done by the hardware.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    4 ++
 include/net/cfg80211.h                 |    4 ++
 include/net/wireless.h                 |    5 ++-
 net/wireless/reg.c                     |   52 ++++++++++++++++++++++++++++----
 4 files changed, 58 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 9882c65..6c4fe96 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4322,6 +4322,10 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
        if (err)
                goto out_remove_sysfs;

+       err = regulatory_hint(priv->hw->wiphy, NULL, NULL, REGULATORY_HARDWARE);
+       if (err)
+               printk("regulatory_hint returns %d\n", err);
+
        err = iwl_dbgfs_register(priv, DRV_NAME);
        if (err)
                IWL_ERROR("failed to create debugfs files\n");
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0e85ec3..b829b17 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -299,6 +299,9 @@ struct bss_parameters {
  * @REGDOM_SET_BY_COUNTRY_IE: the wireless core has received an 802.11 country
  *     information element with regulatory information it thinks we
  *     should consider.
+ * @REGDOM_SET_BY_HARDWARE: a wireless device has the ability to perform
+ *     regulatory enforcement. The wireless core should delegate the regulatory
+ *     rules checking to the hardware.
  */
 enum reg_set_by {
        REGDOM_SET_BY_INIT,
@@ -306,6 +309,7 @@ enum reg_set_by {
        REGDOM_SET_BY_USER,
        REGDOM_SET_BY_DRIVER,
        REGDOM_SET_BY_COUNTRY_IE,
+       REGDOM_SET_BY_HARDWARE,
 };

 struct ieee80211_freq_range {
diff --git a/include/net/wireless.h b/include/net/wireless.h
index c0aa0fb..08ff1e9 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -367,6 +367,8 @@ ieee80211_get_channel(struct wiphy *wiphy, int freq)
  */
 extern int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
                const char *alpha2, struct ieee80211_regdomain *rd);
+
+#define        REGULATORY_HARDWARE     BIT(0)
 /**
  * regulatory_hint - driver hint to the wireless core a regulatory domain
  * @wiphy: the driver's very own &struct wiphy
@@ -376,6 +378,7 @@ extern int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
  *     alpha2.
  * @rd: a complete regulatory domain provided by the driver. If passed
  *     the driver does not need to worry about freeing it.
+ * @flags: regulatory flags passed by the driver
  *
  * Wireless drivers can use this function to hint to the wireless core
  * what it believes should be the current regulatory domain by
@@ -391,5 +394,5 @@ extern int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
  * See __regulatory_hint() documentation for possible return values.
  */
 extern int regulatory_hint(struct wiphy *wiphy,
-               const char *alpha2, struct ieee80211_regdomain *rd);
+               const char *alpha2, struct ieee80211_regdomain *rd, u32 flags);
 #endif /* __NET_WIRELESS_H */
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 626dbb6..cb1df45 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -81,9 +81,30 @@ static const struct ieee80211_regdomain world_regdom = {
        }
 };

+/* A virtual regdomain which is the super set for all existed domains */
+static const struct ieee80211_regdomain virtual_regdom = {
+       .n_reg_rules = 4,
+       .alpha2 =  "01",
+       .reg_rules = {
+               /* IEEE 802.11b/g, channels 1..14 */
+               REG_RULE(2412-10, 2484+10, 40, 6, 27, 0),
+               /* IEEE 802.11a, channel 36..64 */
+               REG_RULE(5170-10, 5320+10, 40, 6, 23, 0),
+               /* IEEE 802.11a, channels 100..140 */
+               REG_RULE(5500-10, 5700+10, 40, 6, 30,
+                       NL80211_RRF_NO_IBSS |
+                       NL80211_RRF_DFS),
+               /* IEEE 802.11a, channels 149..165, outdoor */
+               REG_RULE(5745-10, 5825+10, 40, 6, 30, 0),
+       }
+};
+
 static const struct ieee80211_regdomain *cfg80211_world_regdom =
        &world_regdom;

+static const struct ieee80211_regdomain *cfg80211_virtual_regdom =
+       &virtual_regdom;
+
 #ifdef CONFIG_WIRELESS_OLD_REGULATORY
 static char *ieee80211_regdom = "US";
 module_param(ieee80211_regdom, charp, 0444);
@@ -184,11 +205,14 @@ static inline bool is_old_static_regdom(const struct ieee80211_regdomain *rd)
 static void reset_regdomains(void)
 {
        /* avoid freeing static information or freeing something twice */
-       if (cfg80211_regdomain == cfg80211_world_regdom)
+       if ((cfg80211_regdomain == cfg80211_world_regdom) ||
+           (cfg80211_regdomain == cfg80211_virtual_regdom))
                cfg80211_regdomain = NULL;
-       if (cfg80211_world_regdom == &world_regdom)
+       if ((cfg80211_world_regdom == &world_regdom) ||
+           (cfg80211_world_regdom == &virtual_regdom))
                cfg80211_world_regdom = NULL;
-       if (cfg80211_regdomain == &world_regdom)
+       if ((cfg80211_regdomain == &world_regdom) ||
+           (cfg80211_regdomain == &virtual_regdom))
                cfg80211_regdomain = NULL;
        if (is_old_static_regdom(cfg80211_regdomain))
                cfg80211_regdomain = NULL;
@@ -314,6 +338,11 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
        last_request = list_first_entry(&regulatory_requests,
                struct regulatory_request, list);

+       /* Any request can overwrite the virtual regdomain set by hardware. */
+       if ((last_request->initiator == REGDOM_SET_BY_HARDWARE) &&
+           (set_by != REGDOM_SET_BY_HARDWARE))
+               return 0;
+
        switch (set_by) {
        case REGDOM_SET_BY_INIT:
                return -EINVAL;
@@ -390,6 +419,10 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
                if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
                        return -EOPNOTSUPP;
                return 0;
+       case REGDOM_SET_BY_HARDWARE:
+               if (last_request->initiator == REGDOM_SET_BY_CORE)
+                       return 0;
+               return -EALREADY;
        default:
                return -EINVAL;
        }
@@ -600,6 +633,7 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
        case REGDOM_SET_BY_COUNTRY_IE:
        case REGDOM_SET_BY_DRIVER:
        case REGDOM_SET_BY_USER:
+       case REGDOM_SET_BY_HARDWARE:
                request = kzalloc(sizeof(struct regulatory_request),
                        GFP_KERNEL);
                if (!request)
@@ -629,14 +663,19 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,

 /* If rd is not NULL and if this call fails the caller must free it */
 int regulatory_hint(struct wiphy *wiphy, const char *alpha2,
-       struct ieee80211_regdomain *rd)
+       struct ieee80211_regdomain *rd, u32 flags)
 {
        int r;
-       BUG_ON(!rd && !alpha2);
+       enum reg_set_by setby = (flags & REGULATORY_HARDWARE) ?
+                               REGDOM_SET_BY_HARDWARE : REGDOM_SET_BY_DRIVER;
+
+       BUG_ON(!rd && !alpha2 && !flags);
+       if (flags & REGULATORY_HARDWARE)
+               rd = (struct ieee80211_regdomain *) cfg80211_virtual_regdom;

        mutex_lock(&cfg80211_drv_mutex);

-       r = __regulatory_hint(wiphy, REGDOM_SET_BY_DRIVER, alpha2, rd);
+       r = __regulatory_hint(wiphy, setby, alpha2, rd);
        if (r || !rd)
                goto unlock_and_exit;

@@ -752,6 +791,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
        case REGDOM_SET_BY_CORE:
        case REGDOM_SET_BY_DRIVER:
        case REGDOM_SET_BY_USER:
+       case REGDOM_SET_BY_HARDWARE:
                if (!is_valid_rd(rd)) {
                        printk(KERN_ERR "cfg80211: Invalid "
                                "regulatory domain detected:\n");
--
1.5.3.6

--=-xlgomRz5AZ3fR5BRFykX--

