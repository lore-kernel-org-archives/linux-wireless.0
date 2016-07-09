Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:38751 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbcGIPo4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2016 11:44:56 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Tim Shepard <shep@alum.mit.edu>
Cc: linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org,
	Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v3] ath9k: Switch to using mac80211 intermediate software
	queues.
References: <E1bLYmw-0004wm-00@www.xplot.org>
Date: Sat, 09 Jul 2016 17:44:48 +0200
In-Reply-To: <E1bLYmw-0004wm-00@www.xplot.org> (Tim Shepard's message of "Fri,
	08 Jul 2016 12:38:02 -0400")
Message-ID: <874m7ylssv.fsf@toke.dk> (sfid-20160709_174505_900400_A28BAC05)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tim Shepard <shep@alum.mit.edu> writes:

>> The old code path in ath_tx_start that would queue packets has been
>> removed completely, 
>
> It seems to me that this breaks the ath9k driver when non-data packets
> which mac80211 will not queue on the new intermediate queues, see
> ieee80211_drv_tx( ) in mac80211/tx.c where it says
>
> 	if (!ieee80211_is_data(hdr->frame_control))
> 		goto tx_normal;
>
> This means that non-data packets can come down from mac80211 via
> ath_tx --> ath_tx_start which might be for a vif that is not on the
> same channel, and so cannot be sent straight away but must be queued.
> Maybe this problem should be fixed in mac80211, but as of now this is
> a problem.   It appears to me that your new patch just sends them on
> the wrong channel.

Well, the idea is that the chanctx code will call ieee80211_stop_queue()
to make sure that packets for the wrong context are not pushed down to
the driver.

>> as has the qlen limit tunables (since there's no
>> longer a queue in the driver to limit).
>
>> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
>> index 5294595..daf972c 100644
>> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
>> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
>> @@ -91,7 +91,6 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
>>  #define ATH_RXBUF               512
>>  #define ATH_TXBUF               512
>>  #define ATH_TXBUF_RESERVE       5
>> -#define ATH_MAX_QDEPTH          (ATH_TXBUF / 4 - ATH_TXBUF_RESERVE)
>>  #define ATH_TXMAXTRY            13
>>  #define ATH_MAX_SW_RETRIES      30
>
> I thought the purpose of ATH_MAX_QDEPTH was due to a limit on the
> depth of a hardware FIFO.

It's not. The limit is way too high for that. I'm a little fuzzy on the
details, but the hardware queue depth is somewhat lower:

#define ATH_TXFIFO_DEPTH           8

The ATH_MAX_QDEPTH was supposed to keep the number of packets queued in
the driver under control. And since we're no longer queueing in the
driver, there's no longer a need for it.

> Not all packets that get handed to the hardware come through a
> software queue (e.g. those that bypass the intermediate queueing in
> mac80211 now) and (it seems to me) there needs to be a limit to
> prevent overflowing a hardware fifo. Yes, normal data packets are
> (much) further limited as you taught me a few weeks ago, but not all
> packets are subject to that constraint (as far as I can understand at
> the moment). I'm not entirely sure of the details, but I think it is
> the sorts of packets sent directly by hostapd and wpa_supplicant that
> bypass all the queueing. And maybe those things aren't likely to be
> sending a burst of hundreds of packets in a very short period of time
> (where it could overrun the FIFO), but there may be other tools that
> send raw 802.11 non-data packets which could then overflow the above
> limit, and it seems you are removing the check. Actually I think my
> original version of this patch may have had a flaw in that some
> combination of non-data and data packets could be combined to overflow
> this limit (since I failed to check overflowing this limit where I
> pulled from the mac80211 intermediate queue).

Hmm, I'm not sure I can confidently say that what you describe would
never happen. But I'm pretty sure that ATH_MAX_QDEPTH wasn't what was
keeping it from happening...

-Toke
