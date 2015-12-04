Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26915 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbbLDNRZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2015 08:17:25 -0500
Date: Fri, 4 Dec 2015 16:17:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mwifiex: remove an unneeded condition
Message-ID: <20151204131715.GD12792@mwanda> (sfid-20151204_141729_693546_02EEE64F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We already know that "wep_key->key_length" is set so there is no need to
check again.  Also the last curly brace was indented too far.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index a6c8a4f..80f5064 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -923,9 +923,8 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_private *priv,
 		if (encrypt_key->key_disable) {
 			memset(&priv->wep_key[index], 0,
 			       sizeof(struct mwifiex_wep_key));
-			if (wep_key->key_length)
-				goto done;
-			}
+			goto done;
+		}
 
 		if (adapter->key_api_major_ver == KEY_API_VER_MAJOR_V2)
 			enc_key = encrypt_key;
