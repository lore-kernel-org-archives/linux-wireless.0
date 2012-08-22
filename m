Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758804Ab2HVJ1e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2012 05:27:34 -0400
Date: Wed, 22 Aug 2012 11:27:16 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	Sergei Poselenov <sposelenov@emcraft.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: Re: [rt2x00-users] [PATCH] compat-wireless:rt2800usb: Added rx
 packet length validity check
Message-ID: <20120822092715.GC4959@redhat.com> (sfid-20120822_112738_307321_9C739FFE)
References: <20120820205355.7ccc0450@emcraft.com>
 <20120821114343.GB2380@redhat.com>
 <CAOZOX0V5ehfSZKQ=tPpowH35ct230nBXk6wSBiTcb10UUbieCA@mail.gmail.com>
 <20120821141842.GF2380@redhat.com>
 <A1D107E0-1E78-4123-88C1-9550064DC9AC@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <A1D107E0-1E78-4123-88C1-9550064DC9AC@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 21, 2012 at 10:07:03PM +0200, Gertjan van Wingerde wrote:
> >>>> +     if (rx_pkt_len > entry->skb->len) {
> >>>> +             rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
> >>>> +             goto procrxwi;
> >>> 
> >>> I would rather prefer something like
> >>> 
> >>> if (unlikely(rx_pkt_len == 0 || rx_pkt_len > entry->queue->data_size)) {
> >>>        /* Process error in rt2x00lib_rxdone() */
> >>>        rxdesc->size = rx_pkt_len;
> >>>        return;
> >>> }
> >> 
> >> But how do you know the packet is correct then?
> > Non zero rx_pkt_len smaller than data_size indicate correct package.
> 
> To be honest, I think the original approach of Sergei is better. Not touching rxdesc beyond setting the flag will ensure that rt2x00lib_rxdone will simply bounce the skb without handing an invalid packet over to mac80211. That said, it isn't necessary to set the flag. Just returning from the function is good enough.
> 
> However, the check that Sergei does is not correct either. The real check that should be done is checking whether the skb has enough data to hold both rx_pkt_len bytes + the size of the rxd, which is 1 word (4 bytes). If only rx_pkt_len are left we don't have an rxd, and is the usb packet invalid as well.

Yes, but there is also usb alignment on skb->len, so is better to use
queue->data_size to validate rx_pkt (data) length IMHO.

> >> Obviously something is wrong,
> >> so just resetting the rxdesc->size wouldn't be a solution right?
> > 
> > rt2x00lib_rxdone has rxdesc->size check too, if ->size is bad it 
> > prints warning, and requeue skb. 
> > 
> > Perhaps this could be coded in some cleaner way (avoid double check),
> > but basically this should do the job. 
> 
> As I mentioned above, simply bailing out if rt2800usb_fill_rxdone without doing anything (not even setting a flag) should do the trick and IMHO is the cleanest approach.

IIRC this is basically what I proposed, except without setting
rxdesc->size, unlikely() and rx_pkt_len == 0 check. It will work as
rxdesc->size will be 0. But I think it would be better, if WARNING on
rt2x00lib_rxdone() will print actual corrupted size instead of 0.
Having unlikely is good too - this must be unlikely situation.

BTW: would be good to fix reason of that corruption if possible
(as long this is not a H/W or F/W bug). But for now, let just
stop kernel crashing. Printing WARNING on this situation will
help to identify there is something wrong if someone will observe
performance problems or similar.

Thanks
Stanislaw
