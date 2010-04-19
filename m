Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:45929 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab0DSR5o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 13:57:44 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH v2 7/9] mac80211: add flags for STBC (Space-Time Block Coding)
Date: Mon, 19 Apr 2010 19:57:35 +0200
Message-Id: <1271699857-12366-7-git-send-email-nbd@openwrt.org>
In-Reply-To: <1271699857-12366-6-git-send-email-nbd@openwrt.org>
References: <1271699857-12366-1-git-send-email-nbd@openwrt.org>
 <1271699857-12366-2-git-send-email-nbd@openwrt.org>
 <1271699857-12366-3-git-send-email-nbd@openwrt.org>
 <1271699857-12366-4-git-send-email-nbd@openwrt.org>
 <1271699857-12366-5-git-send-email-nbd@openwrt.org>
 <1271699857-12366-6-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/linux/ieee80211.h |    1 +
 include/net/mac80211.h    |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 1252ba1..97b2eae 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -876,6 +876,7 @@ struct ieee80211_ht_cap {
 #define IEEE80211_HT_CAP_SGI_40			0x0040
 #define IEEE80211_HT_CAP_TX_STBC		0x0080
 #define IEEE80211_HT_CAP_RX_STBC		0x0300
+#define		IEEE80211_HT_CAP_RX_STBC_SHIFT	8
 #define IEEE80211_HT_CAP_DELAY_BA		0x0400
 #define IEEE80211_HT_CAP_MAX_AMSDU		0x0800
 #define IEEE80211_HT_CAP_DSSSCCK40		0x1000
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 75056dd..3d85b0a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -275,6 +275,8 @@ struct ieee80211_bss_conf {
  *	MLME command (internal to mac80211 to figure out whether to send TX
  *	status to user space)
  * @IEEE80211_TX_CTL_LDPC: tells the driver to use LDPC for this frame
+ * @IEEE80211_TX_CTL_STBC: Enables Space-Time Block Coding (STBC) for this 
+ *	frame and selects the maximum number of streams that it can use.
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
@@ -299,6 +301,8 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_INTFL_HAS_RADIOTAP		= BIT(20),
 	IEEE80211_TX_INTFL_NL80211_FRAME_TX	= BIT(21),
 	IEEE80211_TX_CTL_LDPC			= BIT(22),
+	IEEE80211_TX_CTL_STBC			= BIT(23) | BIT(24),
+#define IEEE80211_TX_CTL_STBC_SHIFT		23
 };
 
 /**
-- 
1.6.4.2

