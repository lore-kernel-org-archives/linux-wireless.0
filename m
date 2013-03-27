Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sycorax.lbl.gov ([128.3.11.121]:40360 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab3C0Tdr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 15:33:47 -0400
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Subject: Re: iwlwifi unable to reconnect after suspend since v3.9-rc1
References: <87li993mug.fsf@sycorax.lbl.gov>
	<1364390086.8388.7.camel@jlt4.sipsolutions.net>
	<87r4j021ac.fsf@sycorax.lbl.gov>
	<1364406085.8388.11.camel@jlt4.sipsolutions.net>
	<87ip4cg1qg.fsf@sycorax.lbl.gov>
	<1364410962.8388.19.camel@jlt4.sipsolutions.net>
	<87txnwacdw.fsf@sycorax.lbl.gov>
	<1364411696.8388.21.camel@jlt4.sipsolutions.net>
Date: Wed, 27 Mar 2013 12:33:42 -0700
In-Reply-To: <1364411696.8388.21.camel@jlt4.sipsolutions.net> (message from
	Johannes Berg on Wed, 27 Mar 2013 20:14:56 +0100)
Message-ID: <871ub0zlgp.fsf@sycorax.lbl.gov> (sfid-20130327_203351_837132_0BA88626)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Ah, right, I guess I'm a little surprised it ever works at all ... We'll
> see in the log though.

this is when it works on startup:

[   18.336462] wlan0: authenticate with xx:xx:xx:xx:xx:xx
[   18.377276] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[   18.395294] iwlwifi 0000:03:00.0: I iwl_trans_pcie_reclaim [Q 0] 0 -> 1 (1)
[   18.395309] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx TXQ 0 status SUCCESS (0x00000201)
[   18.395317] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx                               initial_rate 0x800d retries 0, idx=0 ssn=1 seq_ctl=0xc0
[   18.395349] wlan0: authenticated
[   18.412835] wlan0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[   18.428858] iwlwifi 0000:03:00.0: I iwl_trans_pcie_reclaim [Q 0] 1 -> 2 (2)
[   18.428874] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx TXQ 0 status SUCCESS (0x00000201)
[   18.428882] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx                               initial_rate 0x400d retries 0, idx=1 ssn=2 seq_ctl=0xd0
[   18.428983] wlan0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x401 status=0 aid=1)
[   18.449793] wlan0: associated

and then after i take the interface down and try to bring it back up:

[   99.097061] wlan0: deauthenticating from xx:xx:xx:xx:xx:xx by local choice (reason=3)
[   99.099874] iwlwifi 0000:03:00.0: I iwl_trans_pcie_reclaim [Q 0] 43 -> 44 (44)
[   99.099891] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx TXQ 0 status SUCCESS (0x00000201)
[   99.099901] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx                               initial_rate 0x400d retries 0, idx=43 ssn=44 seq_ctl=0x110
[   99.103816] cfg80211: Calling CRDA to update world regulatory domain
[   99.116363] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   99.116596] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[   99.247069] cfg80211: World regulatory domain updated:
[   99.247082] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   99.247090] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   99.247096] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   99.247102] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   99.247107] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   99.247112] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  110.171839] wlan0: authenticate with xx:xx:xx:xx:xx:xx
[  110.182503] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[  110.185173] iwlwifi 0000:03:00.0: I iwl_trans_pcie_reclaim [Q 0] 0 -> 1 (1)
[  110.185191] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx TXQ 0 status PASSIVE_NO_RX (0x00000090)
[  110.185200] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx                               initial_rate 0x800d retries 0, idx=0 ssn=1 seq_ctl=0x60
[  110.187879] iwlwifi 0000:03:00.0: I iwl_trans_pcie_reclaim [Q 0] 1 -> 2 (2)
[  110.187890] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx TXQ 0 status PASSIVE_NO_RX (0x00000090)
[  110.187899] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx                               initial_rate 0x400d retries 0, idx=1 ssn=2 seq_ctl=0x60
[  110.187927] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 2/3)
[  110.190721] iwlwifi 0000:03:00.0: I iwl_trans_pcie_reclaim [Q 0] 2 -> 3 (3)
[  110.190742] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx TXQ 0 status PASSIVE_NO_RX (0x00000090)
[  110.190752] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx                               initial_rate 0x800d retries 0, idx=2 ssn=3 seq_ctl=0x70
[  110.193598] iwlwifi 0000:03:00.0: I iwl_trans_pcie_reclaim [Q 0] 3 -> 4 (4)
[  110.193616] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx TXQ 0 status PASSIVE_NO_RX (0x00000090)
[  110.193625] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx                               initial_rate 0x400d retries 0, idx=3 ssn=4 seq_ctl=0x70
[  110.194594] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 3/3)
[  110.197333] iwlwifi 0000:03:00.0: I iwl_trans_pcie_reclaim [Q 0] 4 -> 5 (5)
[  110.197351] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx TXQ 0 status PASSIVE_NO_RX (0x00000090)
[  110.197361] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx                               initial_rate 0x800d retries 0, idx=4 ssn=5 seq_ctl=0x80
[  110.200088] iwlwifi 0000:03:00.0: I iwl_trans_pcie_reclaim [Q 0] 5 -> 6 (6)
[  110.200105] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx TXQ 0 status PASSIVE_NO_RX (0x00000090)
[  110.200115] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx                               initial_rate 0x400d retries 0, idx=5 ssn=6 seq_ctl=0x80
[  110.200184] wlan0: authentication with xx:xx:xx:xx:xx:xx timed out

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
