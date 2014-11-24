Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:54814 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbaKXOfC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:02 -0500
Received: by mail-wi0-f181.google.com with SMTP id r20so6002801wiv.8
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:00 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/75] iwlwifi: mvm: use correct type for firmware status
Date: Mon, 24 Nov 2014 16:33:39 +0200
Message-Id: <1416839691-28533-3-git-send-email-egrumbach@gmail.com> (sfid-20141124_153508_964706_EEAFD663)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The status variable should be unsigned as the function call
requires a u32 not int pointer, fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/sta.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index dd0dc5b..74a7c91 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -1077,7 +1077,8 @@ static int iwl_mvm_send_sta_key(struct iwl_mvm *mvm,
 {
 	struct iwl_mvm_add_sta_key_cmd cmd = {};
 	__le16 key_flags;
-	int ret, status;
+	int ret;
+	u32 status;
 	u16 keyidx;
 	int i;
 
@@ -1285,7 +1286,8 @@ int iwl_mvm_remove_sta_key(struct iwl_mvm *mvm,
 	struct iwl_mvm_sta *mvm_sta;
 	struct iwl_mvm_add_sta_key_cmd cmd = {};
 	__le16 key_flags;
-	int ret, status;
+	int ret;
+	u32 status;
 	u8 sta_id;
 
 	lockdep_assert_held(&mvm->mutex);
-- 
1.9.1

