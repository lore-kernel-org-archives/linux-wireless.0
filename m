Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:34764 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964Ab2HICYh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 22:24:37 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ying Luo <luoy@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: fix 'smatch' warning in preparing key_material cmd
Date: Wed,  8 Aug 2012 19:01:52 -0700
Message-Id: <1344477712-15818-1-git-send-email-bzhao@marvell.com> (sfid-20120809_042512_465182_B2CCBCC2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The key length can be 32 bytes for TKIP and 16 bytes for AES_CMAC.
'smatch' warns on memcpy using key_len variable to copy data to
a 16 bytes buffer. Use fixed length to avoid the warning.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_cmd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 9af9692..0cc3406 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -690,7 +690,7 @@ mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 
 			memcpy(param->ipn, enc_key->pn, IGTK_PN_LEN);
 			memcpy(param->key, enc_key->key_material,
-			       enc_key->key_len);
+			       WLAN_KEY_LEN_AES_CMAC);
 
 			key_param_len = sizeof(struct mwifiex_cmac_param);
 			key_material->key_param_set.key_len =
-- 
1.7.0.2

