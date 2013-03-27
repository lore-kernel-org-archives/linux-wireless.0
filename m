Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sycorax.lbl.gov ([128.3.11.121]:40369 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316Ab3C0UD5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 16:03:57 -0400
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
	<871ub0zlgp.fsf@sycorax.lbl.gov>
	<1364413484.8388.23.camel@jlt4.sipsolutions.net>
Date: Wed, 27 Mar 2013 13:03:51 -0700
In-Reply-To: <1364413484.8388.23.camel@jlt4.sipsolutions.net> (message from
	Johannes Berg on Wed, 27 Mar 2013 20:44:44 +0100)
Message-ID: <87k3oszk2g.fsf@sycorax.lbl.gov> (sfid-20130327_210405_386095_B6DFD5B5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Unfortunately I can't reproduce it, I suspect my environment isn't clean
> enough any more (somebody else bought a 5 GHz AP recently ...)
>
> Could you try this patch?
>
> http://p.sipsolutions.net/617a8667db243e11.txt

with this patch applied i can take the network down and bring it back
again. this is the log:

[   84.204759] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   84.204965] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[   84.429015] wlan0: authenticate with xx:xx:xx:xx:xx:xx
[   84.440148] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[   84.442819] iwlwifi 0000:03:00.0: I iwl_trans_pcie_reclaim [Q 0] 0 -> 1 (1)
[   84.442844] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx TXQ 0 status PASSIVE_NO_RX (0x00000090) rate_n_flags 0x800d retries 0
[   84.442855] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx FrameCnt = 1, idx=0
[   84.442884] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx TXQ 0 status PASSIVE_NO_RX (0x00000090)
[   84.442896] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx                               initial_rate 0x800d retries 0, idx=0 ssn=1 seq_ctl=0x90
[   84.532849] iwlwifi 0000:03:00.0: I iwl_trans_pcie_reclaim [Q 0] 1 -> 2 (2)
[   84.532867] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx TXQ 0 status SUCCESS (0x00000201)
[   84.532875] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx                               initial_rate 0x400d retries 0, idx=1 ssn=2 seq_ctl=0x0
[   84.533043] wlan0: authenticated
[   84.534066] wlan0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[   84.535599] iwlwifi 0000:03:00.0: I iwl_trans_pcie_reclaim [Q 0] 2 -> 3 (3)
[   84.535616] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx TXQ 0 status SUCCESS (0x00000201)
[   84.535624] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx                               initial_rate 0x800d retries 0, idx=2 ssn=3 seq_ctl=0x10
[   84.535701] wlan0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x401 status=0 aid=1)
[   84.539789] wlan0: associated
[   89.818453] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx Next reclaimed packet:1
[   89.818464] iwlwifi 0000:03:00.0: I iwl_trans_pcie_reclaim [Q 2] 0 -> 1 (1)
[   89.818474] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx Next reclaimed packet:1
[   89.818482] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx TXQ 2 status SUCCESS (0x00000201)
[   89.818489] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx                               initial_rate 0x400d retries 0, idx=0 ssn=1 seq_ctl=0x0

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
