Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45746 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754948AbdHYI1k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Aug 2017 04:27:40 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 25 Aug 2017 11:27:30 +0300
Message-Id: <20170825082730.31388-3-luca@coelho.fi> (sfid-20170825_102750_541930_D5A8F6EF)
In-Reply-To: <20170825082730.31388-1-luca@coelho.fi>
References: <20170825082730.31388-1-luca@coelho.fi>
Subject: [PATCH 2/2] iwlwifi: mvm: Avoid deffering non bufferable frames
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Use bcast station for all non bufferable frames on AP and AD-HOC.

The host is no longer aware of STAs PS status because of buffer
station offload, so we can't rely on mac80211 to toggle on
IEEE80211_TX_CTL_NO_PS_BUFFER bit.

A possible issue with buffering such frames, beside the obvious spec
violation, is when a station disconnects while in PS but the AP isn't
aware of that. In such scenarios the AP won't be able to send probe
responses or auth frames so the STA won't be able to reconnect and
the AP will have a queue hang.

Fixes: 3e56eadfb6a1 ("iwlwifi: mvm: implement AP/GO uAPSD support")
Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index d7feb1ab4dc9..15f2d826bb4b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -810,10 +810,11 @@ static void iwl_mvm_mac_tx(struct ieee80211_hw *hw,
 	    !test_bit(IWL_MVM_STATUS_ROC_AUX_RUNNING, &mvm->status))
 		goto drop;
 
-	/* treat non-bufferable MMPDUs as broadcast if sta is sleeping */
-	if (unlikely(info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER &&
-		     ieee80211_is_mgmt(hdr->frame_control) &&
-		     !ieee80211_is_bufferable_mmpdu(hdr->frame_control)))
+	/* treat non-bufferable MMPDUs on AP interfaces as broadcast */
+	if ((info->control.vif->type == NL80211_IFTYPE_AP ||
+	     info->control.vif->type == NL80211_IFTYPE_ADHOC) &&
+	    ieee80211_is_mgmt(hdr->frame_control) &&
+	    !ieee80211_is_bufferable_mmpdu(hdr->frame_control))
 		sta = NULL;
 
 	if (sta) {
-- 
2.14.1
