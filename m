Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28738 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbbKZMDZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 07:03:25 -0500
Date: Thu, 26 Nov 2015 15:03:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: johannes.berg@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: (bug report) iwlwifi: inconsitent NULL checking
Message-ID: <20151126120317.GJ10556@mwanda> (sfid-20151126_130328_960203_265EA1F6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[ All old wireless warnings are showing up as new because the files
  moved around in linux-next.  - dan ]

Hello Johannes Berg,

The patch 8ca151b568b6: "iwlwifi: add the MVM driver" from Jan 24,
2013, leads to the following static checker warning:

	drivers/net/wireless/intel/iwlwifi/mvm/rs.c:2802 rs_get_rate()
	error: we previously assumed 'lq_sta' could be null (see line 2793)

drivers/net/wireless/intel/iwlwifi/mvm/rs.c
  2790          /* TODO: handle rate_idx_mask and rate_idx_mcs_mask */
  2791  
  2792          /* Treat uninitialized rate scaling data same as non-existing. */
  2793          if (lq_sta && !lq_sta->pers.drv) {
                    ^^^^^^
Check.

  2794                  IWL_DEBUG_RATE(mvm, "Rate scaling not initialized yet.\n");
  2795                  mvm_sta = NULL;
  2796          }
  2797  
  2798          /* Send management frames and NO_ACK data using lowest rate. */
  2799          if (rate_control_send_low(sta, mvm_sta, txrc))
  2800                  return;
  2801  
  2802          iwl_mvm_hwrate_to_tx_rate(lq_sta->last_rate_n_flags,
                                          ^^^^^^^^^^^^^^^^^^^^^^^^^
Uchecked dereference.

  2803                                    info->band, &info->control.rates[0]);
  2804          info->control.rates[0].count = 1;
  2805  

See also:
drivers/net/wireless/intel/iwlwifi/dvm/rs.c:2742 rs_get_rate() error: we previously assumed 'lq_sta' could be null (see line 2733)


regards,
dan carpenter
