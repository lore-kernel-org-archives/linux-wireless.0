Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32992 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbbALVaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 16:30:13 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>, ilw@linux.intel.com,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwlwifi: document switch case fall-through in iwl_mvm_send_sta_key
Date: Mon, 12 Jan 2015 16:18:11 -0500
Message-Id: <1421097491-29574-1-git-send-email-linville@tuxdriver.com> (sfid-20150112_223024_176525_753A4630)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a comment indicating that the WLAN_CIPHER_SUITE_WEP104 case falls
through to the WLAN_CIPHER_SUITE_WEP40 case in iwl_mvm_send_sta_key.
This will document that the lack of a break is intentional.

Coverity: CID 1260023

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
This seems to work, so I'm guessing that the fall-through is
intentional...

 drivers/net/wireless/iwlwifi/mvm/sta.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index d86fe432e51f..c0fc4fc0161b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -1196,6 +1196,7 @@ static int iwl_mvm_send_sta_key(struct iwl_mvm *mvm,
 		break;
 	case WLAN_CIPHER_SUITE_WEP104:
 		key_flags |= cpu_to_le16(STA_KEY_FLG_WEP_13BYTES);
+		/* fall through */
 	case WLAN_CIPHER_SUITE_WEP40:
 		key_flags |= cpu_to_le16(STA_KEY_FLG_WEP);
 		memcpy(cmd.key + 3, keyconf->key, keyconf->keylen);
-- 
2.1.0

