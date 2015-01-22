Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445AbbAVUec (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:32 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 28/38] iwlwifi: mvm: document switch case fall-through in iwl_mvm_send_sta_key
Date: Thu, 22 Jan 2015 22:33:19 +0200
Message-Id: <1421958809-3371-28-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214445_812744_89222D24)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>

Add a comment indicating that the WLAN_CIPHER_SUITE_WEP104 case falls
through to the WLAN_CIPHER_SUITE_WEP40 case in iwl_mvm_send_sta_key.
This will document that the lack of a break is intentional.

Coverity: CID 1260023

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/sta.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index b93a177..8e413d3 100644
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
1.9.1

