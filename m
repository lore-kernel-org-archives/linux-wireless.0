Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:41887 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaIOFNQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:16 -0400
Received: by mail-wg0-f45.google.com with SMTP id z12so3236802wgg.4
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:15 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/28] iwlwifi: mvm: fail temp test enabling if the ucode is not loaded
Date: Mon, 15 Sep 2014 08:12:39 +0300
Message-Id: <1410757980-2138-7-git-send-email-egrumbach@gmail.com> (sfid-20140915_071321_053132_48329682)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

If the ucode is not loaded, don't allow the temperature test to be
started, but allow it to be changed or stopped if already running.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index d98ee10..85eb847 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -288,6 +288,9 @@ static ssize_t iwl_dbgfs_set_nic_temperature_write(struct iwl_mvm *mvm,
 {
 	int temperature;
 
+	if (!mvm->ucode_loaded && !mvm->temperature_test)
+		return -EIO;
+
 	if (kstrtoint(buf, 10, &temperature))
 		return -EINVAL;
 	/* not a legal temperature */
-- 
1.9.1

