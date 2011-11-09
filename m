Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:55991 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab1KIKtm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 05:49:42 -0500
Date: Wed, 9 Nov 2011 13:49:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: johannes.berg@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: re: iwlagn: use 6 Mbps rate for no-CCK scans
Message-ID: <20111109104926.GA19993@elgon.mountain> (sfid-20111109_114956_885304_81137F1F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes Berg,

This is a semi-automatic email about new static checker warnings.

The patch 3a8aea098c8e: "iwlagn: use 6 Mbps rate for no-CCK scans" 
from Oct 14, 2011, leads to the following Smatch complaint:

drivers/net/wireless/iwlwifi/iwl-scan.c +782 iwlagn_request_scan()
	 error: we previously assumed 'priv->scan_request' could be null (see line 681)

drivers/net/wireless/iwlwifi/iwl-scan.c
   680					       >> RXON_FLG_CHANNEL_MODE_POS;
   681			if ((priv->scan_request && priv->scan_request->no_cck) ||
                             ^^^^^^^^^^^^^^^^^^
newly introduced check.  (Probably not needed.  Nothing else in this
function checks this).

   682			    chan_mod == CHANNEL_MODE_PURE_40) {
   683				rate = IWL_RATE_6M_PLCP;
   684			} else {
   685				rate = IWL_RATE_1M_PLCP;
   686				rate_flags = RATE_MCS_CCK_MSK;
   687			}
   688			/*
   689			 * Internal scans are passive, so we can indiscriminately set
   690			 * the BT ignore flag on 2.4 GHz since it applies to TX only.
   691			 */
   692			if (priv->cfg->bt_params &&
   693			    priv->cfg->bt_params->advanced_bt_coexist)
   694				scan->tx_cmd.tx_flags |= TX_CMD_FLG_IGNORE_BT;
   695			break;
   696		case IEEE80211_BAND_5GHZ:
   697			rate = IWL_RATE_6M_PLCP;
   698			break;
   699		default:
   700			IWL_WARN(priv, "Invalid scan band\n");
   701			return -EIO;
   702		}
   703	
   704		/*
   705		 * If active scanning is requested but a certain channel is
   706		 * marked passive, we can do active scanning if we detect
   707		 * transmissions.
   708		 *
   709		 * There is an issue with some firmware versions that triggers
   710		 * a sysassert on a "good CRC threshold" of zero (== disabled),
   711		 * on a radar channel even though this means that we should NOT
   712		 * send probes.
   713		 *
   714		 * The "good CRC threshold" is the number of frames that we
   715		 * need to receive during our dwell time on a channel before
   716		 * sending out probes -- setting this to a huge value will
   717		 * mean we never reach it, but at the same time work around
   718		 * the aforementioned issue. Thus use IWL_GOOD_CRC_TH_NEVER
   719		 * here instead of IWL_GOOD_CRC_TH_DISABLED.
   720		 *
   721		 * This was fixed in later versions along with some other
   722		 * scan changes, and the threshold behaves as a flag in those
   723		 * versions.
   724		 */
   725		if (priv->new_scan_threshold_behaviour)
   726			scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH_DEFAULT :
   727							IWL_GOOD_CRC_TH_DISABLED;
   728		else
   729			scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH_DEFAULT :
   730							IWL_GOOD_CRC_TH_NEVER;
   731	
   732		band = priv->scan_band;
   733	
   734		if (priv->cfg->scan_rx_antennas[band])
   735			rx_ant = priv->cfg->scan_rx_antennas[band];
   736	
   737		if (band == IEEE80211_BAND_2GHZ &&
   738		    priv->cfg->bt_params &&
   739		    priv->cfg->bt_params->advanced_bt_coexist) {
   740			/* transmit 2.4 GHz probes only on first antenna */
   741			scan_tx_antennas = first_antenna(scan_tx_antennas);
   742		}
   743	
   744		priv->scan_tx_ant[band] = iwl_toggle_tx_ant(priv,
   745							    priv->scan_tx_ant[band],
   746							    scan_tx_antennas);
   747		rate_flags |= iwl_ant_idx_to_flags(priv->scan_tx_ant[band]);
   748		scan->tx_cmd.rate_n_flags = iwl_hw_set_rate_n_flags(rate, rate_flags);
   749	
   750		/* In power save mode use one chain, otherwise use all chains */
   751		if (test_bit(STATUS_POWER_PMI, &priv->shrd->status)) {
   752			/* rx_ant has been set to all valid chains previously */
   753			active_chains = rx_ant &
   754					((u8)(priv->chain_noise_data.active_chains));
   755			if (!active_chains)
   756				active_chains = rx_ant;
   757	
   758			IWL_DEBUG_SCAN(priv, "chain_noise_data.active_chains: %u\n",
   759					priv->chain_noise_data.active_chains);
   760	
   761			rx_ant = first_antenna(active_chains);
   762		}
   763		if (priv->cfg->bt_params &&
   764		    priv->cfg->bt_params->advanced_bt_coexist &&
   765		    priv->bt_full_concurrent) {
   766			/* operated as 1x1 in full concurrency mode */
   767			rx_ant = first_antenna(rx_ant);
   768		}
   769	
   770		/* MIMO is not used here, but value is required */
   771		rx_chain |=
   772			hw_params(priv).valid_rx_ant << RXON_RX_CHAIN_VALID_POS;
   773		rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS;
   774		rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_SEL_POS;
   775		rx_chain |= 0x1 << RXON_RX_CHAIN_DRIVER_FORCE_POS;
   776		scan->rx_chain = cpu_to_le16(rx_chain);
   777		switch (priv->scan_type) {
   778		case IWL_SCAN_NORMAL:
   779			cmd_len = iwl_fill_probe_req(priv,
   780						(struct ieee80211_mgmt *)scan->data,
   781						vif->addr,
   782						priv->scan_request->ie,
                                                ^^^^^^^^^^^^^^^^^^^^
unchecked dereference.

   783						priv->scan_request->ie_len,
   784						IWL_MAX_SCAN_SIZE - sizeof(*scan));

regards,
dan carpenter

