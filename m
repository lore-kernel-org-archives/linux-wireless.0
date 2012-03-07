Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:4468 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759704Ab2CGTGg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 14:06:36 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Amit Beka <amit.beka@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 21/35] iwlwifi: fixed testmode notifications length
Date: Wed,  7 Mar 2012 09:52:30 -0800
Message-Id: <1331142764-5750-22-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120307_200645_423664_8E0BA9BD)
In-Reply-To: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
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

