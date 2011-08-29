Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42902 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab1H2IxL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 04:53:11 -0400
From: Vivek Natarajan <nataraja@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <hostap@lists.shmoo.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211/nl80211: Indicate roaming feature capability to userspace.
Date: Mon, 29 Aug 2011 14:23:03 +0530
Message-ID: <1314607983-4918-1-git-send-email-nataraja@qca.qualcomm.com> (sfid-20110829_105315_822735_FCD504E6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the rssi of the current AP drops, both wpa_supplicant and the
firmware may do a background scan to find a better AP and try to
associate. Since firmware based roaming is faster, inform
wpa_supplicant to avoid roaming and let the firmware decide to
roam if necessary.

For fullmac drivers like ath6kl, it is just enough to provide the
ESSID and the firmware will decide on the BSSID. Since it is not
possible to do pre-auth during roaming for fullmac drivers, the
wpa_supplicant needs to completely disconnect with the old AP and
reconnect with the new AP. This consumes lot of time and it is
better to leave the roaming decision to the firmware.

Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
---
 include/linux/nl80211.h |    5 +++++
 include/net/cfg80211.h  |    3 +++
 net/wireless/nl80211.c  |    4 ++++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 0343504..f2d75e3 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1045,6 +1045,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_STA_WME: Nested attribute containing the wme configuration
  *	of the station, see &enum nl80211_sta_wme_attr.
  *
+ * @NL80211_ATTR_ROAM_SUPPORT: Indicates whether the firmware is capable of
+ *	roaming to another AP in the same ESS if the signal lever is low.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1257,6 +1260,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_STA_WME,
 
+	NL80211_ATTR_ROAM_SUPPORT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 50eb84e..cba062d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1619,6 +1619,8 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_MESH_AUTH: The device supports mesh authentication by routing
  *	auth frames to userspace. See @NL80211_MESH_SETUP_USERSPACE_AUTH.
  * @WIPHY_FLAG_SUPPORTS_SCHED_SCAN: The device supports scheduled scans.
+ * @WIPHY_FLAG_SUPPORTS_FW_ROAM: The device supports roaming feature in the
+ *	firmware.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1633,6 +1635,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_MESH_AUTH			= BIT(10),
 	WIPHY_FLAG_SUPPORTS_SCHED_SCAN		= BIT(11),
 	WIPHY_FLAG_ENFORCE_COMBINATIONS		= BIT(12),
+	WIPHY_FLAG_SUPPORTS_FW_ROAM		= BIT(13),
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bddb559..ad13903 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -189,6 +189,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 					 .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_IE_ASSOC_RESP] = { .type = NLA_BINARY,
 					 .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_ROAM_SUPPORT] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -720,6 +721,9 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	if (dev->wiphy.flags & WIPHY_FLAG_MESH_AUTH)
 		NLA_PUT_FLAG(msg, NL80211_ATTR_SUPPORT_MESH_AUTH);
 
+	if (dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_FW_ROAM)
+		NLA_PUT_FLAG(msg, NL80211_ATTR_ROAM_SUPPORT);
+
 	NLA_PUT(msg, NL80211_ATTR_CIPHER_SUITES,
 		sizeof(u32) * dev->wiphy.n_cipher_suites,
 		dev->wiphy.cipher_suites);
-- 
1.7.1

