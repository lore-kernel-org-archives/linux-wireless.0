Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:50177 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbYLPHhJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 02:37:09 -0500
Received: by ewy10 with SMTP id 10so3508441ewy.13
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2008 23:37:07 -0800 (PST)
Message-ID: <eb3ff54b0812152337m6157d035sde23f0a913da67ab@mail.gmail.com> (sfid-20081216_083725_992364_AA6FDB14)
Date: Tue, 16 Dec 2008 09:37:07 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH] [v2] iwlwifi: remove a parameter (dest) from *_fill_beacon_frame() methods.
Cc: linux-wireless@vger.kernel.org, reinette.chatre@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes a parameter (dest) from iwl_fill_beacon_frame() (iwl-agn.c)
 and from iwl3945_fill_beacon_frame(). (iwl-3945.c,iwl-3945.h)

(wireless-testing).

Signed-off-by: Rami Rosen <ramirose@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c
b/drivers/net/wireless/iwlwifi/iwl-3945.c
index f2f2d8f..2327dd2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2483,7 +2483,6 @@ unsigned int iwl3945_hw_get_beacon_cmd(struct
iwl3945_priv *priv,

 	frame_size = iwl3945_fill_beacon_frame(priv,
 				tx_beacon_cmd->frame,
-				iwl3945_broadcast_addr,
 				sizeof(frame->u) - sizeof(*tx_beacon_cmd));

 	BUG_ON(frame_size > MAX_MPDU_SIZE);
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h
b/drivers/net/wireless/iwlwifi/iwl-3945.h
index ec6084c..ffe5a8d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -590,8 +590,7 @@ extern int iwl3945_send_cmd_pdu(struct
iwl3945_priv *priv, u8 id, u16 len,
 extern int __must_check iwl3945_send_cmd(struct iwl3945_priv *priv,
 		struct iwl3945_host_cmd *cmd);
 extern unsigned int iwl3945_fill_beacon_frame(struct iwl3945_priv *priv,
-					struct ieee80211_hdr *hdr,
-					const u8 *dest, int left);
+					struct ieee80211_hdr *hdr,int left);
 extern int iwl3945_rx_queue_update_write_ptr(struct iwl3945_priv *priv,
 					 struct iwl3945_rx_queue *q);
 extern int iwl3945_send_statistics_request(struct iwl3945_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c
b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 9d50fad..ecf19b3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -372,7 +372,7 @@ static void iwl_free_frame(struct iwl_priv *priv,
struct iwl_frame *frame)

 static unsigned int iwl_fill_beacon_frame(struct iwl_priv *priv,
 					  struct ieee80211_hdr *hdr,
-					  const u8 *dest, int left)
+					  int left)
 {
 	if (!iwl_is_associated(priv) || !priv->ibss_beacon ||
 	    ((priv->iw_mode != NL80211_IFTYPE_ADHOC) &&
@@ -425,7 +425,6 @@ static unsigned int iwl_hw_get_beacon_cmd(struct
iwl_priv *priv,
 	tx_beacon_cmd->tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;

 	frame_size = iwl_fill_beacon_frame(priv, tx_beacon_cmd->frame,
-				iwl_bcast_addr,
 				sizeof(frame->u) - sizeof(*tx_beacon_cmd));

 	BUG_ON(frame_size > MAX_MPDU_SIZE);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c
b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 161d812..1af0420 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1404,7 +1404,7 @@ static void iwl3945_free_frame(struct
iwl3945_priv *priv, struct iwl3945_frame *

 unsigned int iwl3945_fill_beacon_frame(struct iwl3945_priv *priv,
 				struct ieee80211_hdr *hdr,
-				const u8 *dest, int left)
+				int left)
 {

 	if (!iwl3945_is_associated(priv) || !priv->ibss_beacon ||
