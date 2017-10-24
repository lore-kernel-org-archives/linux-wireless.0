Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:17837 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751904AbdJXItI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Oct 2017 04:49:08 -0400
From: <yintang@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v7 1/5] mac80211: Enable TDLS peer buffer STA feature
Date: Tue, 24 Oct 2017 16:51:10 +0800
Message-ID: <1508835074-3384-2-git-send-email-yintang@qti.qualcomm.com> (sfid-20171024_104957_642658_19FE3A43)
In-Reply-To: <1508835074-3384-1-git-send-email-yintang@qti.qualcomm.com>
References: <TDLS for ath10k patch v7>
 <1508835074-3384-1-git-send-email-yintang@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yingying Tang <yintang@qti.qualcomm.com>

Enable TDLS peer buffer STA feature.
Set extended capability bit to enable buffer STA when driver
support it.

Signed-off-by: Yingying Tang <yintang@qti.qualcomm.com>
---
 include/net/mac80211.h |    4 ++++
 net/mac80211/debugfs.c |    1 +
 net/mac80211/tdls.c    |    5 ++++-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f8149ca..5928123 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2067,6 +2067,9 @@ struct ieee80211_txq {
  *	The stack will not do fragmentation.
  *	The callback for @set_frag_threshold should be set as well.
  *
+ * @IEEE80211_HW_SUPPORTS_TDLS_BUFFER_STA: Hardware support buffer STA when
+ *	TDLS is established.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2109,6 +2112,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TX_FRAG_LIST,
 	IEEE80211_HW_REPORTS_LOW_ACK,
 	IEEE80211_HW_SUPPORTS_TX_FRAG,
+	IEEE80211_HW_SUPPORTS_TDLS_BUFFER_STA,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 5fae001..1f466d1 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -211,6 +211,7 @@ static ssize_t reset_write(struct file *file, const char __user *user_buf,
 	FLAG(TX_FRAG_LIST),
 	FLAG(REPORTS_LOW_ACK),
 	FLAG(SUPPORTS_TX_FRAG),
+	FLAG(SUPPORTS_TDLS_BUFFER_STA),
 #undef FLAG
 };
 
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 91093d4..8231466 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -47,6 +47,8 @@ static void ieee80211_tdls_add_ext_capab(struct ieee80211_sub_if_data *sdata,
 			   NL80211_FEATURE_TDLS_CHANNEL_SWITCH;
 	bool wider_band = ieee80211_hw_check(&local->hw, TDLS_WIDER_BW) &&
 			  !ifmgd->tdls_wider_bw_prohibited;
+	bool buffer_sta = ieee80211_hw_check(&local->hw,
+					     SUPPORTS_TDLS_BUFFER_STA);
 	struct ieee80211_supported_band *sband = ieee80211_get_sband(sdata);
 	bool vht = sband && sband->vht_cap.vht_supported;
 	u8 *pos = skb_put(skb, 10);
@@ -56,7 +58,8 @@ static void ieee80211_tdls_add_ext_capab(struct ieee80211_sub_if_data *sdata,
 	*pos++ = 0x0;
 	*pos++ = 0x0;
 	*pos++ = 0x0;
-	*pos++ = chan_switch ? WLAN_EXT_CAPA4_TDLS_CHAN_SWITCH : 0;
+	*pos++ = (chan_switch ? WLAN_EXT_CAPA4_TDLS_CHAN_SWITCH : 0) |
+		 (buffer_sta ? WLAN_EXT_CAPA4_TDLS_BUFFER_STA : 0);
 	*pos++ = WLAN_EXT_CAPA5_TDLS_ENABLED;
 	*pos++ = 0;
 	*pos++ = 0;
-- 
1.7.9.5
