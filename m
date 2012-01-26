Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:55372 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751963Ab2AZMjq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 07:39:46 -0500
Received: by mail-gx0-f170.google.com with SMTP id i2so202686ggn.29
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 04:39:45 -0800 (PST)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>
Subject: [RFC 7/9] nl80211/cfg80211: add DFS feature flag
Date: Thu, 26 Jan 2012 14:38:02 +0200
Message-Id: <1327581484-22047-8-git-send-email-victorg@ti.com> (sfid-20120126_133953_936102_932F1A0E)
In-Reply-To: <1327581484-22047-1-git-send-email-victorg@ti.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new NL80211_FEATURE_DFS attribute which indicates
that driver/HW supports radar detection.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/linux/nl80211.h |    2 ++
 include/net/cfg80211.h  |    3 +++
 net/wireless/nl80211.c  |   17 ++++++++++++++++-
 3 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 8a004fc..0ec7956 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -2829,10 +2829,12 @@ enum nl80211_ap_sme_features {
  *	TX status to the socket error queue when requested with the
  *	socket option.
  * @NL80211_FEATURE_HT_IBSS: This driver supports IBSS with HT datarates.
+ * @NL80211_FEATURE_DFS: Radar detection is supported in the HW/driver.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS	= 1 << 0,
 	NL80211_FEATURE_HT_IBSS		= 1 << 1,
+	NL80211_FEATURE_DFS		= 1 << 2,
 };
 
 /**
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 824883a..363ff09 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1762,6 +1762,8 @@ struct cfg80211_ops {
  *	responds to probe-requests in hardware.
  * @WIPHY_FLAG_OFFCHAN_TX: Device supports direct off-channel TX.
  * @WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL: Device supports remain-on-channel call.
+ * @WIPHY_FLAG_SUPPORTS_DFS: The device supports radar detection
+ *	in the HW/driver.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1785,6 +1787,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD	= BIT(19),
 	WIPHY_FLAG_OFFCHAN_TX			= BIT(20),
 	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	= BIT(21),
+	WIPHY_FLAG_SUPPORTS_DFS			= BIT(22),
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8fe7e59..3bb83c4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -695,6 +695,20 @@ nla_put_failure:
 	return -ENOBUFS;
 }
 
+static int nl80211_put_feature_flags(struct wiphy *wiphy,
+				     struct sk_buff *msg)
+{
+	if (wiphy->flags & WIPHY_FLAG_SUPPORTS_DFS)
+		wiphy->features |= NL80211_FEATURE_DFS;
+
+
+	NLA_PUT_U32(msg, NL80211_ATTR_FEATURE_FLAGS, wiphy->features);
+
+	return 0;
+nla_put_failure:
+	return -ENOBUFS;
+}
+
 static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 			      struct cfg80211_registered_device *dev)
 {
@@ -1038,7 +1052,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		NLA_PUT_U32(msg, NL80211_ATTR_DEVICE_AP_SME,
 			    dev->wiphy.ap_sme_capa);
 
-	NLA_PUT_U32(msg, NL80211_ATTR_FEATURE_FLAGS, dev->wiphy.features);
+	if (nl80211_put_feature_flags(&dev->wiphy, msg))
+		goto nla_put_failure;
 
 	if (dev->wiphy.ht_capa_mod_mask)
 		NLA_PUT(msg, NL80211_ATTR_HT_CAPABILITY_MASK,
-- 
1.7.5.4

