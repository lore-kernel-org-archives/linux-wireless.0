Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40386 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab3C0To6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 15:44:58 -0400
Message-ID: <1364413484.8388.23.camel@jlt4.sipsolutions.net> (sfid-20130327_204504_474452_529BD52E)
Subject: Re: iwlwifi unable to reconnect after suspend since v3.9-rc1
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Date: Wed, 27 Mar 2013 20:44:44 +0100
In-Reply-To: <871ub0zlgp.fsf@sycorax.lbl.gov>
References: <87li993mug.fsf@sycorax.lbl.gov>
	 <1364390086.8388.7.camel@jlt4.sipsolutions.net>
	 <87r4j021ac.fsf@sycorax.lbl.gov>
	 <1364406085.8388.11.camel@jlt4.sipsolutions.net>
	 <87ip4cg1qg.fsf@sycorax.lbl.gov>
	 <1364410962.8388.19.camel@jlt4.sipsolutions.net>
	 <87txnwacdw.fsf@sycorax.lbl.gov>
	 <1364411696.8388.21.camel@jlt4.sipsolutions.net>
	 <871ub0zlgp.fsf@sycorax.lbl.gov>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-03-27 at 12:33 -0700, Alex Romosan wrote:

> [   18.377276] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
> [   18.395294] iwlwifi 0000:03:00.0: I iwl_trans_pcie_reclaim [Q 0] 0 -> 1 (1)
> [   18.395309] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx TXQ 0 status SUCCESS (0x00000201)
> [   18.395317] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx                               initial_rate 0x800d retries 0, idx=0 ssn=1 seq_ctl=0xc0
> [   18.395349] wlan0: authenticated


> [  110.182503] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
> [  110.185173] iwlwifi 0000:03:00.0: I iwl_trans_pcie_reclaim [Q 0] 0 -> 1 (1)
> [  110.185191] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx TXQ 0 status PASSIVE_NO_RX (0x00000090)
> [  110.185200] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx                               initial_rate 0x800d retries 0, idx=0 ssn=1 seq_ctl=0x60
> [  110.187879] iwlwifi 0000:03:00.0: I iwl_trans_pcie_reclaim [Q 0] 1 -> 2 (2)
> [  110.187890] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx TXQ 0 status PASSIVE_NO_RX (0x00000090)
> [  110.187899] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx                               initial_rate 0x400d retries 0, idx=1 ssn=2 seq_ctl=0x60

As I had expected. Not sure why it's two frames every time?

Unfortunately I can't reproduce it, I suspect my environment isn't clean
enough any more (somebody else bought a 5 GHz AP recently ...)

Could you try this patch?

http://p.sipsolutions.net/617a8667db243e11.txt

johannes

