Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16724 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaJAO4L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 10:56:11 -0400
Date: Wed, 1 Oct 2014 17:55:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: eyal@wizery.com
Cc: Eyal Shapira <eyal@wizery.com>, linux-wireless@vger.kernel.org
Subject: re: iwlwifi: mvm: rs: refactor to allow direct rs updating
Message-ID: <20141001145553.GA32299@mwanda> (sfid-20141001_165703_054696_6FCCF1A9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Eyal Shapira,

This is a semi-automatic email about new static checker warnings.

The patch 1ebc8f2ef83d: "iwlwifi: mvm: rs: refactor to allow direct
rs updating" from Sep 14, 2014, leads to the following Smatch
complaint:

drivers/net/wireless/iwlwifi/mvm/rs.c:1228 iwl_mvm_rs_tx_status()
	 warn: variable dereferenced before check 'sta' (see line 1037)

drivers/net/wireless/iwlwifi/mvm/rs.c
  1036		u8 reduced_txp = (uintptr_t)info->status.status_driver_data[0];
  1037		struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
                                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Patch introduces a new unchecked "sta" dereference.

  1038		struct iwl_lq_sta *lq_sta = &mvmsta->lq_sta;
  1039	
  1040		/* Treat uninitialized rate scaling data same as non-existing. */
  1041		if (!lq_sta) {
  1042			IWL_DEBUG_RATE(mvm, "Station rate scaling not created yet.\n");
  1043			return;
  1044		} else if (!lq_sta->pers.drv) {
  1045			IWL_DEBUG_RATE(mvm, "Rate scaling not initialized yet.\n");
  1046			return;
  1047		}
  1048	

[ snip ]

  1223		/* The last TX rate is cached in lq_sta; it's set in if/else above */
  1224		lq_sta->last_rate_n_flags = ucode_rate;
  1225		IWL_DEBUG_RATE(mvm, "reduced txpower: %d\n", reduced_txp);
  1226	done:
  1227		/* See if there's a better rate or modulation mode to try. */
  1228		if (sta && sta->supp_rates[info->band])
                    ^^^
The existing code assumes "sta" can be NULL.

  1229			rs_rate_scale_perform(mvm, sta, lq_sta, tid);
  1230	}

regards,
dan carpenter
