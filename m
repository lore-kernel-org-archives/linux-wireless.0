Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:47559 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaEXPQi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2014 11:16:38 -0400
Received: by mail-we0-f172.google.com with SMTP id k48so6204175wev.17
        for <linux-wireless@vger.kernel.org>; Sat, 24 May 2014 08:16:37 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: oku@masqmail.cx, joerg.albert@gmx.de, alex@foogod.com,
	n0_5p4m_p13453@hotmail.com, proski@gnu.org, agx@sigxcpu.org,
	kalle.valo@iki.fi, sesmo@gmx.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH 2/2] at76c50x-usb: Make WEP encryption working.
Date: Sat, 24 May 2014 17:16:18 +0200
Message-Id: <1400944578-16374-1-git-send-email-andrea.merello@gmail.com> (sfid-20140524_171642_215922_986BD129)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the driver uses HW encryption.
Whenever mac80211 calls the set_key() callback the driver restarts the
whole HW configuration procedure, in order to set (also) the new
WEP key.
However, by doing this, it causes the card to loose association information,
and the HW becomes unable to communicate with the BSS.

This patch adds support for sending another HW command, that sets only
the wep key, instead of resetting all.
Mac80211 key-set requests are thus handled via this new command.

Tested on my at76c503
---
 drivers/net/wireless/at76c50x-usb.c | 40 ++++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/at76c50x-usb.h | 25 ++++++++++++-----------
 2 files changed, 52 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 9e6e9fc..10fd12e 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -2039,6 +2039,44 @@ static void at76_configure_filter(struct ieee80211_hw *hw,
 	ieee80211_queue_work(hw, &priv->work_set_promisc);
 }
 
+static int at76_set_wep(struct at76_priv *priv)
+{
+	int ret = 0;
+	struct mib_mac_wep *mib_data = &priv->mib_buf.data.wep_mib;
+
+	priv->mib_buf.type = MIB_MAC_WEP;
+	priv->mib_buf.size = sizeof(struct mib_mac_wep);
+	priv->mib_buf.index = 0;
+
+	memset(mib_data, 0, sizeof(*mib_data));
+
+	if (priv->wep_enabled) {
+		if (priv->wep_keys_len[priv->wep_key_id] > WEP_SMALL_KEY_LEN)
+			mib_data->encryption_level = 2;
+		else
+			mib_data->encryption_level = 1;
+
+		/* always exclude unencrypted if WEP is active */
+		mib_data->exclude_unencrypted = 1;
+	} else {
+		mib_data->exclude_unencrypted = 0;
+		mib_data->encryption_level = 0;
+	}
+
+	mib_data->privacy_invoked = priv->wep_enabled;
+	mib_data->wep_default_key_id = priv->wep_key_id;
+	memcpy(mib_data->wep_default_keyvalue, priv->wep_keys,
+	       sizeof(priv->wep_keys));
+
+	ret = at76_set_mib(priv, &priv->mib_buf);
+
+	if (ret < 0)
+		wiphy_err(priv->hw->wiphy,
+			  "set_mib (wep) failed: %d\n", ret);
+
+	return ret;
+}
+
 static int at76_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			struct ieee80211_vif *vif, struct ieee80211_sta *sta,
 			struct ieee80211_key_conf *key)
@@ -2081,7 +2119,7 @@ static int at76_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			priv->wep_enabled = 1;
 	}
 
-	at76_startup_device(priv);
+	at76_set_wep(priv);
 
 	mutex_unlock(&priv->mtx);
 
diff --git a/drivers/net/wireless/at76c50x-usb.h b/drivers/net/wireless/at76c50x-usb.h
index f14a654..4718aa5 100644
--- a/drivers/net/wireless/at76c50x-usb.h
+++ b/drivers/net/wireless/at76c50x-usb.h
@@ -219,18 +219,6 @@ struct at76_req_join {
 	u8 reserved;
 } __packed;
 
-struct set_mib_buffer {
-	u8 type;
-	u8 size;
-	u8 index;
-	u8 reserved;
-	union {
-		u8 byte;
-		__le16 word;
-		u8 addr[ETH_ALEN];
-	} data;
-} __packed;
-
 struct mib_local {
 	u16 reserved0;
 	u8 beacon_enable;
@@ -334,6 +322,19 @@ struct mib_mdomain {
 	u8 channel_list[14];	/* 0 for invalid channels */
 } __packed;
 
+struct set_mib_buffer {
+	u8 type;
+	u8 size;
+	u8 index;
+	u8 reserved;
+	union {
+		u8 byte;
+		__le16 word;
+		u8 addr[ETH_ALEN];
+		struct mib_mac_wep wep_mib;
+	} data;
+} __packed;
+
 struct at76_fw_header {
 	__le32 crc;		/* CRC32 of the whole image */
 	__le32 board_type;	/* firmware compatibility code */
-- 
1.9.1

