Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40445 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab3C0UNc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 16:13:32 -0400
Message-ID: <1364415196.8388.26.camel@jlt4.sipsolutions.net> (sfid-20130327_211336_495611_8268A50A)
Subject: Re: iwlwifi unable to reconnect after suspend since v3.9-rc1
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Date: Wed, 27 Mar 2013 21:13:16 +0100
In-Reply-To: <87k3oszk2g.fsf@sycorax.lbl.gov>
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
	 <87k3oszk2g.fsf@sycorax.lbl.gov>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-03-27 at 13:03 -0700, Alex Romosan wrote:

> > Could you try this patch?
> >
> > http://p.sipsolutions.net/617a8667db243e11.txt
> 
> with this patch applied i can take the network down and bring it back
> again. this is the log:

> [   84.440148] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
> [   84.442819] iwlwifi 0000:03:00.0: I iwl_trans_pcie_reclaim [Q 0] 0 -> 1 (1)
> [   84.442844] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx TXQ 0 status PASSIVE_NO_RX (0x00000090) rate_n_flags 0x800d retries 0
> [   84.442855] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx FrameCnt = 1, idx=0
> [   84.442884] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx TXQ 0 status PASSIVE_NO_RX (0x00000090)
> [   84.442896] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx                               initial_rate 0x800d retries 0, idx=0 ssn=1 seq_ctl=0x90
> [   84.532849] iwlwifi 0000:03:00.0: I iwl_trans_pcie_reclaim [Q 0] 1 -> 2 (2)
> [   84.532867] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx TXQ 0 status SUCCESS (0x00000201)
> [   84.532875] iwlwifi 0000:03:00.0: I iwlagn_rx_reply_tx                               initial_rate 0x400d retries 0, idx=1 ssn=2 seq_ctl=0x0

Ah so it's even the same packet because we set
IEEE80211_TX_STAT_TX_FILTERED.

Note the delay here -- roughly between 84.4428 and 84.5328 we wait for a
beacon.

I'll apply the patch and add your tested-by, like this:

http://p.sipsolutions.net/7e871bfb5a0b272a.txt

OK?

johannes

