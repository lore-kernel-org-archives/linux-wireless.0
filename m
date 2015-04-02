Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40007 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbbDBGm1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:42:27 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/31] iwlwifi: mvm: Fix wrongfully flushing frames in the roc/off channel queue
Date: Thu,  2 Apr 2015 09:41:12 +0300
Message-Id: <1427956879-11725-24-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_090417_835193_54DE07ED)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

Sending multiple action frames off channel, one after the other can create
a race that will result in a timeout:

1. Start sending action frame off channel.
2. Once the frame is sent or the time event is over, the flow will
eventually call ieee80211_start_next_roc to start the next roc frame &
iwl_mvm_roc_finished schedules to schedule a work to flush the queue.
3. Start sending new roc frame and write it to the queue before the
flush work has started.
4. The work is called and it flushes the new packet that was placed on the
on the queue so the packet is lost.

This causes the frame to be removed & not sent, that causes a timeout in
userspace.

Flush the work queue that flushes the roc/off channel queue before starting
to send a new frame off channel, in order to avoid a race between the new
frame that is transmitted off channel & the flushing of the queue.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 0dd999c..0bd3373 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3080,6 +3080,8 @@ static int iwl_mvm_roc(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(mvm, "enter (%d, %d, %d)\n", channel->hw_value,
 			   duration, type);
 
+	flush_work(&mvm->roc_done_wk);
+
 	mutex_lock(&mvm->mutex);
 
 	switch (vif->type) {
-- 
1.9.1

