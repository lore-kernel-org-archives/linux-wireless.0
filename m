Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:35846 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3LaRQc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:32 -0500
Received: by mail-ea0-f178.google.com with SMTP id d10so5569805eaj.37
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:31 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/28] iwlwifi: mvm: squash a spurious warning on chnctx change
Date: Tue, 31 Dec 2013 19:15:50 +0200
Message-Id: <1388510157-23345-21-git-send-email-egrumbach@gmail.com> (sfid-20131231_183436_062007_1ED9BC25)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

If the channel min-width changes, we can update the PHY ctx, even if
it has multiple references.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Reviewed-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index e9eff30..abe7514 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1649,7 +1649,8 @@ static void iwl_mvm_change_chanctx(struct ieee80211_hw *hw,
 	if (WARN_ONCE((phy_ctxt->ref > 1) &&
 		      (changed & ~(IEEE80211_CHANCTX_CHANGE_WIDTH |
 				   IEEE80211_CHANCTX_CHANGE_RX_CHAINS |
-				   IEEE80211_CHANCTX_CHANGE_RADAR)),
+				   IEEE80211_CHANCTX_CHANGE_RADAR |
+				   IEEE80211_CHANCTX_CHANGE_MIN_WIDTH)),
 		      "Cannot change PHY. Ref=%d, changed=0x%X\n",
 		      phy_ctxt->ref, changed))
 		return;
-- 
1.7.9.5

