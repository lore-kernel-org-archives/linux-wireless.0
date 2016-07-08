Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.xplot.org ([23.30.144.12]:39438 "EHLO www.xplot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400AbcGHQiL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 12:38:11 -0400
From: Tim Shepard <shep@alum.mit.edu>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
cc: linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org,
	Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v3] ath9k: Switch to using mac80211 intermediate software queues. 
In-reply-to: Your message of Wed, 06 Jul 2016 21:34:17 +0200.
             <20160706193417.13080-1-toke@toke.dk>
Date: Fri, 08 Jul 2016 12:38:02 -0400
Message-Id: <E1bLYmw-0004wm-00@www.xplot.org> (sfid-20160708_183819_231027_AC18FE4D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The old code path in ath_tx_start that would queue packets has been
> removed completely, 

It seems to me that this breaks the ath9k driver when non-data packets
which mac80211 will not queue on the new intermediate queues, see
ieee80211_drv_tx( ) in mac80211/tx.c where it says

	if (!ieee80211_is_data(hdr->frame_control))
		goto tx_normal;

This means that non-data packets can come down from mac80211 via
ath_tx --> ath_tx_start which might be for a vif that is not on the
same channel, and so cannot be sent straight away but must be queued.
Maybe this problem should be fixed in mac80211, but as of now this is
a problem.   It appears to me that your new patch just sends them on
the wrong channel.

Maybe I'm confused about something, hints appreciated.


> as has the qlen limit tunables (since there's no
> longer a queue in the driver to limit).

> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
> index 5294595..daf972c 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -91,7 +91,6 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
>  #define ATH_RXBUF               512
>  #define ATH_TXBUF               512
>  #define ATH_TXBUF_RESERVE       5
> -#define ATH_MAX_QDEPTH          (ATH_TXBUF / 4 - ATH_TXBUF_RESERVE)
>  #define ATH_TXMAXTRY            13
>  #define ATH_MAX_SW_RETRIES      30

I thought the purpose of ATH_MAX_QDEPTH was due to a limit on the
depth of a hardware FIFO.  Not all packets that get handed to the
hardware come through a software queue (e.g. those that bypass the
intermediate queueing in mac80211 now) and (it seems to me) there
needs to be a limit to prevent overflowing a hardware fifo.   Yes,
normal data packets are (much) further limited as you taught me a few
weeks ago, but not all packets are subject to that constraint (as far
as I can understand at the moment).   I'm not entirely sure of the
details, but I think it is the sorts of packets sent directly by
hostapd and wpa_supplicant that bypass all the queueing.  And maybe
those things aren't likely to be sending a burst of hundreds of
packets in a very short period of time (where it could overrun the
FIFO), but there may be other tools that send raw 802.11 non-data
packets which could then overflow the above limit, and it seems you
are removing the check.    Actually I think my original version of
this patch may have had a flaw in that some combination of non-data
and data packets could be combined to overflow this limit (since I
failed to check overflowing this limit where I pulled from the
mac80211 intermediate queue).



My hope is that I'm just confused and you all understand what's really
going on better than I do and have an explanation why all the above
doesn't matter and is handled in some other way.   But in case you
don't, I don't want these issues to be overlooked.

(I'm not testing using vifs on multiple channels.   But even if I was,
 I'm not sure if normal operation of wpa_supplicant or hostapd would
 be enough to trigger these problems.)



			-Tim Shepard
			 shep@alum.mit.edu

