Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37402 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751124AbcITNQz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 09:16:55 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8KDEbhu026366
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2016 06:16:54 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 25h5bp9xhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2016 06:16:54 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Ganapathi Bhat <gbhat@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v3] mwifiex: cfg80211 set_default_mgmt_key handler
Date: Tue, 20 Sep 2016 18:46:23 +0530
Message-ID: <1474377383-12600-1-git-send-email-akarwar@marvell.com> (sfid-20160920_151659_834101_223B9B89)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ganapathi Bhat <gbhat@marvell.com>

Previously device used to start using IGTK key as Tx key as soon as it
gets downloaded in add_key(). This patch implements set_default_mgmt_key
handler. We will update Tx key ID in set_default_mgmt_key().

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v2: v1 had a dummy handler. v2 addresses a corner case problem
    pointed by Jouni in which AP may send frames encrypted with new key
    when some of the stations are still using old key.
v3: Use eth_broadcast_addr instead of copying broadcast address manually
    through a local variable.(Kalle Valo)
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 24 ++++++++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/fw.h       |  1 +
 drivers/net/wireless/marvell/mwifiex/ioctl.h    |  1 +
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c  |  5 +++++
 4 files changed, 31 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index c7f2faa..39ce76a 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -484,6 +484,29 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
 }
 
 /*
+ * CFG802.11 operation handler to set default mgmt key.
+ */
+static int
+mwifiex_cfg80211_set_default_mgmt_key(struct wiphy *wiphy,
+				      struct net_device *netdev,
+				      u8 key_index)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(netdev);
+	struct mwifiex_ds_encrypt_key encrypt_key;
+
+	wiphy_dbg(wiphy, "set default mgmt key, key index=%d\n", key_index);
+
+	memset(&encrypt_key, 0, sizeof(struct mwifiex_ds_encrypt_key));
+	encrypt_key.key_len = WLAN_KEY_LEN_CCMP;
+	encrypt_key.key_index = key_index;
+	encrypt_key.is_igtk_def_key = true;
+	eth_broadcast_addr(encrypt_key.mac_addr);
+
+	return mwifiex_send_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
+				HostCmd_ACT_GEN_SET, true, &encrypt_key, true);
+}
+
+/*
  * This function sends domain information to the firmware.
  *
  * The following information are passed to the firmware -
@@ -4082,6 +4105,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.leave_ibss = mwifiex_cfg80211_leave_ibss,
 	.add_key = mwifiex_cfg80211_add_key,
 	.del_key = mwifiex_cfg80211_del_key,
+	.set_default_mgmt_key = mwifiex_cfg80211_set_default_mgmt_key,
 	.mgmt_tx = mwifiex_cfg80211_mgmt_tx,
 	.mgmt_frame_register = mwifiex_cfg80211_mgmt_frame_register,
 	.remain_on_channel = mwifiex_cfg80211_remain_on_channel,
diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 18aa525..4b1894b 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -78,6 +78,7 @@ enum KEY_TYPE_ID {
 	KEY_TYPE_ID_AES,
 	KEY_TYPE_ID_WAPI,
 	KEY_TYPE_ID_AES_CMAC,
+	KEY_TYPE_ID_AES_CMAC_DEF,
 };
 
 #define WPA_PN_SIZE		8
diff --git a/drivers/net/wireless/marvell/mwifiex/ioctl.h b/drivers/net/wireless/marvell/mwifiex/ioctl.h
index 7042981..536ab83 100644
--- a/drivers/net/wireless/marvell/mwifiex/ioctl.h
+++ b/drivers/net/wireless/marvell/mwifiex/ioctl.h
@@ -260,6 +260,7 @@ struct mwifiex_ds_encrypt_key {
 	u8 is_igtk_key;
 	u8 is_current_wep_key;
 	u8 is_rx_seq_valid;
+	u8 is_igtk_def_key;
 };
 
 struct mwifiex_power_cfg {
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index 49048b4..2a162c3 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -598,6 +598,11 @@ static int mwifiex_set_aes_key_v2(struct mwifiex_private *priv,
 		memcpy(km->key_param_set.key_params.cmac_aes.key,
 		       enc_key->key_material, enc_key->key_len);
 		len += sizeof(struct mwifiex_cmac_aes_param);
+	} else if (enc_key->is_igtk_def_key) {
+		mwifiex_dbg(adapter, INFO,
+			    "%s: Set CMAC default Key index\n", __func__);
+		km->key_param_set.key_type = KEY_TYPE_ID_AES_CMAC_DEF;
+		km->key_param_set.key_idx = enc_key->key_index & KEY_INDEX_MASK;
 	} else {
 		mwifiex_dbg(adapter, INFO,
 			    "%s: Set AES Key\n", __func__);
-- 
1.9.1
