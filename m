Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:44217 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbaIHQ40 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 12:56:26 -0400
Received: by mail-wi0-f180.google.com with SMTP id ex7so3060791wid.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2014 09:56:25 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/12] iwlwifi: mvm: BT Coex - remove shadowing variable
Date: Mon,  8 Sep 2014 19:56:07 +0300
Message-Id: <1410195377-10075-2-git-send-email-egrumbach@gmail.com> (sfid-20140908_185629_670530_D7C2826D)
In-Reply-To: <540DDF37.5030801@gmail.com>
References: <540DDF37.5030801@gmail.com>
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

