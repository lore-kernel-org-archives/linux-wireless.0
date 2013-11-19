Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:61372 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab3KSUwT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 15:52:19 -0500
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/7] iwlwifi: mvm: check sta_id/drain values in debugfs
Date: Tue, 19 Nov 2013 22:52:00 +0200
Message-Id: <1384894326-24676-1-git-send-email-egrumbach@gmail.com> (sfid-20131119_215224_108229_0F7A10FD)
In-Reply-To: <528BCEDB.8010703@gmail.com>
References: <528BCEDB.8010703@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The station ID must be valid, if it's out of range then
the array access may crash. Validate the station ID to
the array length, and also validate the drain value even
if that doesn't matter all that much.

Cc: stable@vger.kernel.org
Fixes: 8ca151b568b6 ("iwlwifi: add the MVM driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 9864d71..a8fe6b4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -119,6 +119,10 @@ static ssize_t iwl_dbgfs_sta_drain_write(struct file *file,
 
 	if (sscanf(buf, "%d %d", &sta_id, &drain) != 2)
 		return -EINVAL;
+	if (sta_id < 0 || sta_id >= IWL_MVM_STATION_COUNT)
+		return -EINVAL;
+	if (drain < 0 || drain > 1)
+		return -EINVAL;
 
 	mutex_lock(&mvm->mutex);
 
-- 
1.7.9.5

