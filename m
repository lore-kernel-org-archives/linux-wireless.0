Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:42501 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab1CQAGR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 20:06:17 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 09/11] mwifiex: optimize add_key callback function
Date: Wed, 16 Mar 2011 17:09:32 -0700
Message-Id: <1300320574-10793-10-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
References: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Previously in add_key callback function we used to call
mwifiex_sec_ioctl_encrypt_key() routine twice. First call was to
modify key in driver's database and second was to update default
tx key index.
Now we will be implementing set_default_key handler. So second call
can be skipped.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h        |    2 --
 drivers/net/wireless/mwifiex/sta_ioctl.c |   22 ++--------------------
 2 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 49d76fd..a5a9547 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -120,8 +120,6 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 enum MWIFIEX_802_11_WEP_STATUS {
 	MWIFIEX_802_11_WEP_ENABLED,
 	MWIFIEX_802_11_WEP_DISABLED,
-	MWIFIEX_802_11_WEP_KEY_ABSENT,
-	MWIFIEX_802_11_WEP_NOT_SUPPORTED
 };
 
 #define CAL_SNR(RSSI, NF)		((s16)((s16)(RSSI)-(s16)(NF)))
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index bda00dd..0fd24cb 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1767,14 +1767,7 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
 		       encrypt_key->key_len);
 		wep_key->key_index = index;
 		wep_key->key_length = encrypt_key->key_len;
-		if (priv->sec_info.wep_status != MWIFIEX_802_11_WEP_ENABLED)
-			/*
-			 * The status is set as Key Absent
-			 * so as to make sure we display the
-			 * keys when iwlist mwifiexX key is used
-			 */
-			priv->sec_info.wep_status =
-				MWIFIEX_802_11_WEP_KEY_ABSENT;
+		priv->sec_info.wep_status = MWIFIEX_802_11_WEP_ENABLED;
 	}
 	if (wep_key->key_length) {
 		/* Send request to firmware */
@@ -2283,6 +2276,7 @@ mwifiex_set_encode(struct mwifiex_private *priv, u32 cipher, const u8 *key,
 	if (!wait)
 		return -ENOMEM;
 
+	memset(&encrypt_key, 0, sizeof(struct mwifiex_ds_encrypt_key));
 	encrypt_key.key_len = key_len;
 	if (!disable) {
 		if (cipher != WLAN_CIPHER_SUITE_WEP40 &&
@@ -2296,18 +2290,6 @@ mwifiex_set_encode(struct mwifiex_private *priv, u32 cipher, const u8 *key,
 		}
 		encrypt_key.key_index = key_index;
 		memcpy(encrypt_key.key_material, key, key_len);
-
-		if (cipher == WLAN_CIPHER_SUITE_WEP40
-		    || cipher == WLAN_CIPHER_SUITE_WEP104) {
-			status = mwifiex_sec_ioctl_encrypt_key(priv, wait,
-							       &encrypt_key);
-			if (mwifiex_request_ioctl(priv, wait, status,
-						  MWIFIEX_IOCTL_WAIT)) {
-				ret = -EFAULT;
-				goto done;
-			}
-			encrypt_key.key_len = 0;
-		}
 	} else {
 		encrypt_key.key_disable = true;
 	}
-- 
1.7.0.2

