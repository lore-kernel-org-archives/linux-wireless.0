Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21396 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3KAKaH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 06:30:07 -0400
Date: Fri, 1 Nov 2013 13:27:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: emmanuel.grumbach@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: re: iwlwifi: mvm: new BT Coex API
Message-ID: <20131101102702.GH29795@longonot.mountain> (sfid-20131101_113013_102488_B99B80F8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Emmanuel Grumbach,

This is a semi-automatic email about new static checker warnings.

The patch dac94da8dba3: "iwlwifi: mvm: new BT Coex API" from Jun 18, 
2013, leads to the following Smatch complaint:

drivers/net/wireless/iwlwifi/mvm/bt-coex.c:754 iwl_mvm_bt_coex_notif_handle()
	 error: we previously assumed 'data.primary' could be null (see line 709)

drivers/net/wireless/iwlwifi/mvm/bt-coex.c
   708	
   709		if (data.primary) {
                    ^^^^^^^^^^^^
Patch introcudes a NULL check.

   710			struct ieee80211_chanctx_conf *chan = data.primary;
   711			if (WARN_ON(!chan->def.chan)) {
   712				rcu_read_unlock();
   713				return;
   714			}
   715	
   716			if (chan->def.width < NL80211_CHAN_WIDTH_40) {
   717				ci_bw_idx = 0;
   718				cmd.co_run_bw_primary = 0;
   719			} else {
   720				cmd.co_run_bw_primary = 1;
   721				if (chan->def.center_freq1 >
   722				    chan->def.chan->center_freq)
   723					ci_bw_idx = 2;
   724				else
   725					ci_bw_idx = 1;
   726			}
   727	
   728			cmd.bt_primary_ci =
   729				iwl_ci_mask[chan->def.chan->hw_value][ci_bw_idx];
   730			cmd.primary_ch_phy_id = *((u16 *)data.primary->drv_priv);
   731		}
   732	
   733		if (data.secondary) {
   734			struct ieee80211_chanctx_conf *chan = data.secondary;
   735			if (WARN_ON(!data.secondary->def.chan)) {
   736				rcu_read_unlock();
   737				return;
   738			}
   739	
   740			if (chan->def.width < NL80211_CHAN_WIDTH_40) {
   741				ci_bw_idx = 0;
   742				cmd.co_run_bw_secondary = 0;
   743			} else {
   744				cmd.co_run_bw_secondary = 1;
   745				if (chan->def.center_freq1 >
   746				    chan->def.chan->center_freq)
   747					ci_bw_idx = 2;
   748				else
   749					ci_bw_idx = 1;
   750			}
   751	
   752			cmd.bt_secondary_ci =
   753				iwl_ci_mask[chan->def.chan->hw_value][ci_bw_idx];
   754			cmd.secondary_ch_phy_id = *((u16 *)data.primary->drv_priv);
                                                           ^^^^^^^^^^^^^^^^^^^^^^
Patch introduces unchecked dereference.

   755		}
   756	

It's possible that a non-null data.secondary implies data.primary is
non-null.  If so please disregard this one-time email.

regards,
dan carpenter
