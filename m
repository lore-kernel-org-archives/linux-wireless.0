Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23262 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751113AbaLRG3a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 01:29:30 -0500
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>, <kvalo@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH v2 2/4] mwifiex: do not send key material cmd when delete wep key
Date: Thu, 18 Dec 2014 17:28:44 +0530
Message-ID: <1418903926-11859-2-git-send-email-patila@marvell.com> (sfid-20141218_072938_548858_ECC10401)
In-Reply-To: <1418903926-11859-1-git-send-email-patila@marvell.com>
References: <1418903926-11859-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch fixes memory corruption reported by community developer.

"Memory corruption occurs in mwifiex_ret_802_11_key_material_v1()
when a short command response is received without a key length
causing non initialised memory to be interpreted as the key
length resulting in a memcpy() overwriting the part of the
driver's private data structure beyond the key area."

For v1 key material API firmwares, there is no need to send
command to delete WEP key. WEP encryption/decryption is controlled
by mac_control command.

This patch avoids sending key material command in del_key case.

Reported-by: Martin Fuzzey <mfuzzey@parkeon.com>
Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 1626868..fb9c5fc 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -902,9 +902,12 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_private *priv,
 	if (wep_key->key_length) {
 		void *enc_key;
 
-		if (encrypt_key->key_disable)
+		if (encrypt_key->key_disable) {
 			memset(&priv->wep_key[index], 0,
 			       sizeof(struct mwifiex_wep_key));
+			if (wep_key->key_length)
+				goto done;
+			}
 
 		if (adapter->key_api_major_ver == KEY_API_VER_MAJOR_V2)
 			enc_key = encrypt_key;
@@ -918,6 +921,7 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_private *priv,
 			return ret;
 	}
 
+done:
 	if (priv->sec_info.wep_enabled)
 		priv->curr_pkt_filter |= HostCmd_ACT_MAC_WEP_ENABLE;
 	else
-- 
1.8.1.4

