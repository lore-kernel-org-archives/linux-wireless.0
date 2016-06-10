Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56612 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753364AbcFJMkI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 08:40:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Ayala Beker <ayala.beker@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 10 Jun 2016 15:39:56 +0300
Message-Id: <1465562397-1402-4-git-send-email-luca@coelho.fi> (sfid-20160610_144056_537948_FAD52661)
In-Reply-To: <1465562397-1402-1-git-send-email-luca@coelho.fi>
References: <1465562195.29614.5.camel@coelho.fi>
 <1465562397-1402-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 4/5] iwlwifi: mvm: set the encryption type of an IGTK key
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

The FW expect the driver to set the encryption algorithm type when
installing the IGTK key in the HW.
Currently when installing CMAC IGTK key we don't set the algorithm type
and as a result the FW fails to calculate the MIC of multicast management
frames.
Fix it.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 0454bfe..b23ab4a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1961,6 +1961,14 @@ static int iwl_mvm_send_sta_igtk(struct iwl_mvm *mvm,
 		struct ieee80211_key_seq seq;
 		const u8 *pn;
 
+		switch (keyconf->cipher) {
+		case WLAN_CIPHER_SUITE_AES_CMAC:
+			igtk_cmd.ctrl_flags |= cpu_to_le32(STA_KEY_FLG_CCM);
+			break;
+		default:
+			return -EINVAL;
+		}
+
 		memcpy(igtk_cmd.IGTK, keyconf->key, keyconf->keylen);
 		ieee80211_get_key_rx_seq(keyconf, 0, &seq);
 		pn = seq.aes_cmac.pn;
-- 
2.8.1

