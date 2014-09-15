Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:55539 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaIOFK4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:10:56 -0400
Received: by mail-we0-f171.google.com with SMTP id p10so3324453wes.30
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:10:54 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/12] iwlwifi: mvm: BT Coex - remove shadowing variable
Date: Mon, 15 Sep 2014 08:10:38 +0300
Message-Id: <1410757848-1827-2-git-send-email-egrumbach@gmail.com> (sfid-20140915_071058_940433_213A8BCC)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The variable 'u32 mode' exists twice, the latter shadowing
the former - remove the latter since there's no need for
two variables.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 2291bbc..75178f3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -585,8 +585,6 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 	lockdep_assert_held(&mvm->mutex);
 
 	if (unlikely(mvm->bt_force_ant_mode != BT_FORCE_ANT_DIS)) {
-		u32 mode;
-
 		switch (mvm->bt_force_ant_mode) {
 		case BT_FORCE_ANT_BT:
 			mode = BT_COEX_BT;
-- 
1.9.1

