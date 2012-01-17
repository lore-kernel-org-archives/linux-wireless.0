Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:50677 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab2AQJSG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 04:18:06 -0500
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout4.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1Rn5B5-0000Og-0k
	for linux-wireless@vger.kernel.org; Tue, 17 Jan 2012 10:18:03 +0100
Received: from localhost ([::1]:43801 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Rn5B4-0006vZ-TE
	for linux-wireless@vger.kernel.org; Tue, 17 Jan 2012 10:18:03 +0100
Received: from [195.4.92.23] (port=59672 helo=13.mx.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Rn58i-000617-Lf
	for linux-wireless@vger.kernel.org; Tue, 17 Jan 2012 10:15:36 +0100
Received: from [2002:4fde:619:2:5054:ff:feb8:40bd] (port=41363 helo=mail.maya.org)
	by 13.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1Rn58h-0008G0-Oz
	for linux-wireless@vger.kernel.org; Tue, 17 Jan 2012 10:15:36 +0100
Message-Id: <201201170909.q0H993w5003154@mail.maya.org> (sfid-20120117_101813_625705_3390580D)
Date: Tue, 17 Jan 2012 10:09:01 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
In-Reply-To: <CAGXE3d_jW7NFnekMfwn6JPXX0xB4UWM3ttbRVLv-ZbsoMOoWEw@mail.gmail.com>
References: <4EFF12D9.3010602@01019freenet.de>
	<2766356.70ylY68Gqi@helmutmobil.site>
	<4F040FEA.3080703@01019freenet.de>
	<1408490.qSFZVkU7fA@helmutmobil.site>
	<4F0562DF.3000200@dualc.maya.org>
	<CAGXE3d8b5qtbhesPjRy3EXvkiwshUg0eZqcDBzb1OhKK3j6z6A@mail.gmail.com>
	<4F0AEBAB.9020104@01019freenet.de>
	<CAGXE3d-cOeTEHugbgWMoz8-Dymw0=JHxykdK4ZkBmCJZ9tSPmg@mail.gmail.com>
	<201201100803.q0A83nsQ003757@mail.maya.org>
	<CAGXE3d_jW7NFnekMfwn6JPXX0xB4UWM3ttbRVLv-ZbsoMOoWEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Helmut,

Am Tue, 10 Jan 2012 10:50:16 +0100
schrieb Helmut Schaa <helmut.schaa@googlemail.com>:

> On Tue, Jan 10, 2012 at 9:03 AM, Andreas Hartmann
> <andihartmann@01019freenet.de> wrote:
[...]
> > Looks as if sending of any package is reported as broken at some
> > point of time and this circle cannot be left anymore.
> 
> Not necessarily since mac80211 will only retry the BAR if a data frame
> transmission was successful. Hence, it seems as if only the BARs TX
> status is reported incorrectly ...
> 
> I see two issues here:
> 1) rt2800pci seems to have problems delivering the BAR _or_ doesn't
>    report the tx status correctly
> 2) If the same BAR fails consecutively we should maybe really tear down
>    the BA session as it was done before
> 
> 2 is done in the below untested patch and will also work around 1.
> Mind to give it a try?

I encountered some temporary, short stalls during low bandwith
(running X terminal sessions tunneled through ssh). Therefore I set 

	MAX_BAR_RETRIES=0

This means, 

ieee80211_send_bar(&sta->sdata->vif, addr, tid,
		   tid_tx->failed_bar_ssn);

isn't called any more. But that's not all: the BA session isn't torn
down any more, too - but it's working fine (high bandwith, too) anyway!?
Why? (If I remove your patch again, the session completely stalls as
ever).

Behavior looks like this now:

Jan 17 08:13:06 ap kernel: [ 4247.178448] rt2800_txdone_entry - tx failed
Jan 17 08:13:06 ap kernel: [ 4247.178456] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 113
Jan 17 08:13:06 ap kernel: [ 4247.178467] __set_bit ENTRY_TXD_HT_AMPDU
Jan 17 08:13:06 ap kernel: [ 4247.178478] rt2800_txdone_entry - tx failed
Jan 17 08:13:06 ap kernel: [ 4247.178481] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 114
Jan 17 08:13:06 ap kernel: [ 4247.178487] __set_bit ENTRY_TXD_HT_AMPDU
Jan 17 08:13:06 ap kernel: [ 4247.178493] rt2800_txdone_entry - tx failed
Jan 17 08:13:06 ap kernel: [ 4247.178495] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 115
Jan 17 08:13:06 ap kernel: [ 4247.178500] __set_bit ENTRY_TXD_HT_AMPDU
Jan 17 08:13:06 ap kernel: [ 4247.178506] rt2800_txdone_entry - tx failed
Jan 17 08:13:06 ap kernel: [ 4247.178508] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 116
Jan 17 08:13:06 ap kernel: [ 4247.178513] __set_bit ENTRY_TXD_HT_AMPDU
Jan 17 08:13:06 ap kernel: [ 4247.178518] rt2800_txdone_entry - tx failed
Jan 17 08:13:06 ap kernel: [ 4247.178521] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 117
Jan 17 08:13:06 ap kernel: [ 4247.178525] __set_bit ENTRY_TXD_HT_AMPDU
Jan 17 08:13:06 ap kernel: [ 4247.178530] rt2800_txdone_entry - tx failed
Jan 17 08:13:06 ap kernel: [ 4247.178533] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 118
Jan 17 08:13:06 ap kernel: [ 4247.178537] __set_bit ENTRY_TXD_HT_AMPDU
Jan 17 08:13:06 ap kernel: [ 4247.178542] rt2800_txdone_entry - tx failed
Jan 17 08:13:06 ap kernel: [ 4247.178545] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 119
Jan 17 08:13:06 ap kernel: [ 4247.178550] __set_bit ENTRY_TXD_HT_AMPDU
Jan 17 08:13:06 ap kernel: [ 4247.185886] rt2800_txdone_entry - tx failed
Jan 17 08:13:07 ap kernel: [ 4247.185894] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 120
Jan 17 08:13:07 ap kernel: [ 4247.185900] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4320>
Jan 17 08:13:07 ap kernel: [ 4247.196303] rt2800_txdone_entry - tx failed
Jan 17 08:13:07 ap kernel: [ 4247.196310] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 121
Jan 17 08:13:07 ap kernel: [ 4247.196315] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4336>
Jan 17 08:13:07 ap kernel: [ 4247.211337] rt2800_txdone_entry - tx failed
Jan 17 08:13:07 ap kernel: [ 4247.211346] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 122
Jan 17 08:13:07 ap kernel: [ 4247.211352] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4352>
Jan 17 08:13:07 ap kernel: [ 4247.217669] rt2800_txdone_entry - tx failed
Jan 17 08:13:07 ap kernel: [ 4247.217673] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 123
Jan 17 08:13:07 ap kernel: [ 4247.217675] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4368>
Jan 17 08:13:07 ap kernel: [ 4247.226812] rt2800_txdone_entry - tx failed
Jan 17 08:13:07 ap kernel: [ 4247.226821] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 124
Jan 17 08:13:07 ap kernel: [ 4247.226826] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4384>
Jan 17 08:13:07 ap kernel: [ 4247.234151] rt2800_txdone_entry - tx failed
Jan 17 08:13:07 ap kernel: [ 4247.234159] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 125
Jan 17 08:13:07 ap kernel: [ 4247.234165] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4400>
Jan 17 08:13:07 ap kernel: [ 4247.244042] rt2800_txdone_entry - tx failed
Jan 17 08:13:07 ap kernel: [ 4247.244050] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 126
Jan 17 08:13:07 ap kernel: [ 4247.244056] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4> ssn: <4416>




BTW:
I can see, that RX A-MPDU is switched on - why not for TX, too? Where
can I see if a hardware is capable to use A-MPDU?

iw list prints for the AP device (2,4 GHz):

Wiphy phy0
        Band 1:
                HT capabilities: 0x02f2
                        * 20/40 MHz operation
                        * static SM PS
                        * HT-greenfield
                        * 20 MHz short GI
                        * 40 MHz short GI
                        * TX STBC
                        * RX STBC 2 streams
                        * max A-MSDU len 3839
                HT A-MPDU factor: 0x0003 (65535 bytes)
                HT A-MPDU density: 0x0004 (2 usec)
                HT MCS set: ff ff 00 00 01 00 00 00 00 00 00 00 07 00 00 00
                HT RX MCS rate indexes supported:
                        MCS index 0
                        MCS index 1
                        MCS index 2
                        MCS index 3
                        MCS index 4
                        MCS index 5
                        MCS index 6
                        MCS index 7
                        MCS index 8
                        MCS index 9
                        MCS index 10
                        MCS index 11
                        MCS index 12
                        MCS index 13
                        MCS index 14
                        MCS index 15
                        MCS index 32
TX unequal modulation not supported
                HT TX Max spatiel streams: 5
                HT TX MCS rate indexes supported may differ
                Frequencies:
                        * 2412 MHz [1] (20.0 dBm)
                        * 2417 MHz [2] (20.0 dBm)
                        * 2422 MHz [3] (20.0 dBm)
                        * 2427 MHz [4] (20.0 dBm)
                        * 2432 MHz [5] (20.0 dBm)
                        * 2437 MHz [6] (20.0 dBm)
                        * 2442 MHz [7] (20.0 dBm)
                        * 2447 MHz [8] (20.0 dBm)
                        * 2452 MHz [9] (20.0 dBm)
                        * 2457 MHz [10] (20.0 dBm)
                        * 2462 MHz [11] (20.0 dBm)
                        * 2467 MHz [12] (20.0 dBm)
                        * 2472 MHz [13] (20.0 dBm)
                        * 2484 MHz [14] (disabled)
                Bitrates (non-HT):
                        * 1.0 Mbps
                        * 2.0 Mbps (short preamble supported)
                        * 5.5 Mbps (short preamble supported)
                        * 11.0 Mbps (short preamble supported)
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps

Kind regards,
Andreas


> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> index a18f524..983994b 100644
> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -122,7 +122,7 @@ struct tid_ampdu_tx {
>  	u8 buf_size;
> 
>  	u16 failed_bar_ssn;
> -	bool bar_pending;
> +	unsigned int bar_pending;
>  };
> 
>  /**
> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
> index 30c265c..ea782f1 100644
> --- a/net/mac80211/status.c
> +++ b/net/mac80211/status.c
> @@ -17,6 +17,7 @@
>  #include "led.h"
>  #include "wme.h"
> 
> +#define MAX_BAR_RETRIES 3
> 
>  void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
>  				 struct sk_buff *skb)
> @@ -171,8 +172,17 @@ static void ieee80211_check_pending_bar(struct
> sta_info *sta, u8 *addr, u8 tid)
>  	if (!tid_tx || !tid_tx->bar_pending)
>  		return;
> 
> -	tid_tx->bar_pending = false;
> -	ieee80211_send_bar(&sta->sdata->vif, addr, tid, tid_tx->failed_bar_ssn);
> +	if (--tid_tx->bar_pending) {
> +		ieee80211_send_bar(&sta->sdata->vif, addr, tid,
> +				   tid_tx->failed_bar_ssn);
> +		return;
> +	}
> +
> +	/*
> +	 * The same BAR failed multiple times, something is clearly wrong
> +	 * -> Stop the BA session.
> +	 */
> +	ieee80211_stop_tx_ba_session(&sta->sta, tid);
>  }
> 
>  static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
> @@ -225,8 +235,16 @@ static void ieee80211_set_bar_pending(struct
> sta_info *sta, u8 tid, u16 ssn)
>  	if (!tid_tx)
>  		return;
> 
> +	/*
> +	 * A BAR for the same SSN is still pending, don't
> +	 * update the pending count.
> +	 */
> +	if (tid_tx->failed_bar_ssn == ssn &&
> +	    tid_tx->bar_pending)
> +		return;
> +
>  	tid_tx->failed_bar_ssn = ssn;
> -	tid_tx->bar_pending = true;
> +	tid_tx->bar_pending = MAX_BAR_RETRIES;
>  }
> 
>  static int ieee80211_tx_radiotap_len(struct ieee80211_tx_info *info)

