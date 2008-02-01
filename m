Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:60028 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbYBAWzC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 17:55:02 -0500
Date: Fri, 1 Feb 2008 17:53:45 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: ath5k: reset for 5424-based card
Message-ID: <20080201225345.GA15922@hash.localnet> (sfid-20080201_225507_642924_417650E0)
References: <20080131155901.GA7997@hash.localnet> <40f31dec0801310856p28513848nd22c4b3c590b7a46@mail.gmail.com> <20080201040358.GA13428@hash.localnet> <40f31dec0802010409i47374309o5da3d76fb1bc7025@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0802010409i47374309o5da3d76fb1bc7025@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 01, 2008 at 02:09:26PM +0200, Nick Kossifidis wrote:
> 
> Do you have an AP so you can run the testbed-trace as described here ?
> http://madwifi.org/wiki/DevDocs/MadwifiTrace

Yeah I have an AP but it's broadcom based.  I'll try to do the traces this
weekend.

> One more question: can you plz describe card's behaviour with ath5k ?
> What error message does it return on reset-failure ?

Well, with the change from my original post, the card appears to
function somewhat but the cpu gets busy and the whole machine crawls.
Note, I didn't make any changes for initvals.  

I can associate but not for very long.  dmesg looks like this:

ath5k phy0: Atheros AR5424 chip found (MAC: 0xa3, PHY: 0x61)
NET: Registered protocol family 17
ath0: Initial auth_alg=0
ath0: authenticate with AP 00:1a:70:da:a9:cd
ath0: RX authentication from 00:1a:70:da:a9:cd (alg=0 transaction=2
status=0)
ath0: authenticated
ath0: associate with AP 00:1a:70:da:a9:cd
ath0: RX AssocResp from 00:1a:70:da:a9:cd (capab=0x411 status=0 aid=2)
ath0: associated
ath0: switched to long barker preamble (BSSID=00:1a:70:da:a9:cd)
ath5k_hw_get_isr: 0x00000020
ath5k_hw_get_isr: 0x00000020
ath5k_hw_get_isr: 0x00000020
ath5k_hw_get_isr: 0x00000020
[repeats a ton]
ath0: No ProbeResp from current AP 00:1a:70:da:a9:cd - assume out of
range
printk: 81 messages suppressed.
ath5k_hw_get_isr: 0x00000020
printk: 36 messages suppressed.
ath5k_hw_get_isr: 0x00000020

and sometimes:
ath5k phy3: noise floor calibration timeout (2462MHz)

With debug on these were the resets I was seeing, may be normal but I
didn't know:

ath5k trace ath5k_hw_stop_tx_dma:1241
ath5k trace ath5k_hw_stop_pcu_recv:2433
ath5k trace ath5k_hw_set_rx_filter:2518
ath5k trace ath5k_hw_stop_rx_dma:1143
ath5k trace ath5k_hw_reset:573
ath5k trace ath5k_hw_get_rf_gain:1349
ath5k trace ath5k_hw_nic_wakeup:290
ath5k trace ath5k_hw_set_power:1058
ath5k trace ath5k_hw_set_power:1058
ath5k trace ath5k_hw_nic_reset:1011
ath5k trace ath5k_hw_txpower:2012
ath5k trace ath5k_hw_get_rate_table:401
ath5k trace ath5k_hw_disable_pspoll:4342
ath5k trace ath5k_hw_set_opmode:2187
ath5k trace ath5k_hw_reset_tx_queue:3173

> Thanx a lot for the feedback ;-)

np!

-- 
Bob Copeland %% www.bobcopeland.com 

