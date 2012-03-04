Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54587 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196Ab2CDUnM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:12 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Amit Beka <amit.beka@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 087/101] iwlwifi: fixed testmode notifications length
Date: Sun,  4 Mar 2012 11:29:41 -0800
Message-Id: <1330889395-533-88-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214442_706242_4D92EE6A)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amit Beka <amit.beka@intel.com>

The length of iwl_rx_packet doesn't include the
dword for the length itself, so add it manually.

Signed-off-by: Amit Beka <amit.beka@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-testmode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index b8044bc..b06c676 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -185,7 +185,8 @@ static void iwl_testmode_ucode_rx_pkt(struct iwl_priv *priv,
 		return;
 	}
 	NLA_PUT_U32(skb, IWL_TM_ATTR_COMMAND, IWL_TM_CMD_DEV2APP_UCODE_RX_PKT);
-	NLA_PUT(skb, IWL_TM_ATTR_UCODE_RX_PKT, length, data);
+	/* the length doesn't include len_n_flags field, so add it manually */
+	NLA_PUT(skb, IWL_TM_ATTR_UCODE_RX_PKT, length + sizeof(__le32), data);
 	cfg80211_testmode_event(skb, GFP_ATOMIC);
 	return;
 
-- 
1.7.0.4

