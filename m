Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:43268 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab2AQHdn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 02:33:43 -0500
Date: Tue, 17 Jan 2012 10:33:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mwl8k: fix condition in mwl8k_cmd_encryption_remove_key()
Message-ID: <20120117073322.GE11358@elgon.mountain> (sfid-20120117_083347_710600_0E800BFD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The intent here was to check whether key->cipher was WEP40 or WEP104.
We do a similar check correctly in several other places in this file.
The current condition is always true.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 7becea3..d187ea2 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -4066,7 +4066,7 @@ static int mwl8k_cmd_encryption_remove_key(struct ieee80211_hw *hw,
 		goto done;
 
 	if (key->cipher == WLAN_CIPHER_SUITE_WEP40 ||
-			WLAN_CIPHER_SUITE_WEP104)
+			key->cipher == WLAN_CIPHER_SUITE_WEP104)
 		mwl8k_vif->wep_key_conf[key->keyidx].enabled = 0;
 
 	cmd->action = cpu_to_le32(MWL8K_ENCR_REMOVE_KEY);
