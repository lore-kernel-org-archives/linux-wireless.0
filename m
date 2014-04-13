Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35126 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbaDMTUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:43 -0400
Received: by mail-wi0-f180.google.com with SMTP id q5so3132464wiv.13
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:42 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/47] iwlwifi: mvm: don't enable bcast filtering on P2P client
Date: Sun, 13 Apr 2014 22:19:37 +0300
Message-Id: <1397416802-32403-22-git-send-email-egrumbach@gmail.com> (sfid-20140413_213514_441721_0A219877)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The firmware doesn't support broadcast filtering on P2P
client. Trying to enable it makes the firmware assert.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 4dd9ff4..01b4228 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1223,6 +1223,10 @@ static int iwl_mvm_configure_bcast_filter(struct iwl_mvm *mvm,
 	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BCAST_FILTERING))
 		return 0;
 
+	/* bcast filtering isn't supported for P2P client */
+	if (vif->p2p)
+		return 0;
+
 	if (!iwl_mvm_bcast_filter_build_cmd(mvm, &cmd))
 		return 0;
 
-- 
1.8.3.2

