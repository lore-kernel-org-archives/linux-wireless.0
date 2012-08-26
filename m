Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ocean.emcraft.com ([213.221.7.182]:45566 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab2HZNTS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 09:19:18 -0400
Subject: Re: [rt2x00-users] [PATCH] compat-wireless:rt2800usb: Added rx
 packet length validity check
From: Sergei Poselenov <sposelenov@emcraft.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Sun, 26 Aug 2012 17:19:10 +0400
In-Reply-To: <70A1AEFB-59F7-4947-B2A0-A89C29C3108B@gmail.com>
References: <20120820205355.7ccc0450@emcraft.com>
	 <20120821114343.GB2380@redhat.com>
	 <CAOZOX0V5ehfSZKQ=tPpowH35ct230nBXk6wSBiTcb10UUbieCA@mail.gmail.com>
	 <20120821141842.GF2380@redhat.com>
	 <A1D107E0-1E78-4123-88C1-9550064DC9AC@gmail.com>
	 <20120822092715.GC4959@redhat.com>
	 <70A1AEFB-59F7-4947-B2A0-A89C29C3108B@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Message-ID: <1345987150.8610.6.camel@mehome> (sfid-20120826_151925_078459_E531682F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All, 

On Wed, 2012-08-22 at 22:41 +0200, Gertjan van Wingerde wrote:
> Hi Stanislaw,
> 
> On 22 aug. 2012, at 11:27, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> 
> > On Tue, Aug 21, 2012 at 10:07:03PM +0200, Gertjan van Wingerde wrote:
> >>>>>> +     if (rx_pkt_len > entry->skb->len) {
> >>>>>> +             rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
> >>>>>> +             goto procrxwi;
> >>>>> 
> >>>>> I would rather prefer something like
> >>>>> 
> >>>>> if (unlikely(rx_pkt_len == 0 || rx_pkt_len > entry->queue->data_size)) {
> >>>>>       /* Process error in rt2x00lib_rxdone() */
> >>>>>       rxdesc->size = rx_pkt_len;
> >>>>>       return;
> >>>>> }
> >>>> 
> >>>> But how do you know the packet is correct then?
> >>> Non zero rx_pkt_len smaller than data_size indicate correct package.
> >> 
> >> To be honest, I think the original approach of Sergei is better. Not touching rxdesc beyond setting the flag will ensure that rt2x00lib_rxdone will simply bounce the skb without handing an invalid packet over to mac80211. That said, it isn't necessary to set the flag. Just returning from the function is good enough.
> >> 
> >> However, the check that Sergei does is not correct either. The real check that should be done is checking whether the skb has enough data to hold both rx_pkt_len bytes + the size of the rxd, which is 1 word (4 bytes). If only rx_pkt_len are left we don't have an rxd, and is the usb packet invalid as well.
> > 
> > Yes, but there is also usb alignment on skb->len, so is better to use
> > queue->data_size to validate rx_pkt (data) length IMHO.
> 
> Oh, well it's an (almost) equivalent test anyway, so I guess I don't care.
> 
> > 
> >>>> Obviously something is wrong,
> >>>> so just resetting the rxdesc->size wouldn't be a solution right?
> >>> 
> >>> rt2x00lib_rxdone has rxdesc->size check too, if ->size is bad it 
> >>> prints warning, and requeue skb. 
> >>> 
> >>> Perhaps this could be coded in some cleaner way (avoid double check),
> >>> but basically this should do the job. 
> >> 
> >> As I mentioned above, simply bailing out if rt2800usb_fill_rxdone without doing anything (not even setting a flag) should do the trick and IMHO is the cleanest approach.
> > 
> > IIRC this is basically what I proposed, except without setting
> > rxdesc->size, unlikely() and rx_pkt_len == 0 check. It will work as
> > rxdesc->size will be 0. But I think it would be better, if WARNING on
> > rt2x00lib_rxdone() will print actual corrupted size instead of 0.
> > Having unlikely is good too - this must be unlikely situation.
> 
> OK, I agree with the use of unlikely(). An rx_pkt_len of 0 doesn't seem to happen in practice, so testing for it seems superfluous, but may be providing some extra safety. Don't really care about that. I really don't think we should set rxdesc->size, as we cannot determine it. If we want to print the value, then do it in this function. Adding a hack to having it printed somewhere else doesn't seem right to me.

OK, I modified the check and changed WARNING() to ERROR() in
rt2x00lib_rxdone() as Stanislaw suggested.

Now the error messages looks like follows:
...
phy0 -> rt2800usb_fill_rxdone: Error - Bad frame length 12354, forcing to 0
phy0 -> rt2x00lib_rxdone: Error - Wrong frame size 0 max 3840.
...

OK to submit the final patch?

Regards,
Sergei

> Also, it should be an error log message, not a WARNING. There's no need to have a stack trace as the buffer is filled by HW, not by some other function. So, the use of WARNING, with its stack dumping functionality is overkill.
> 
> 
> > 
> > BTW: would be good to fix reason of that corruption if possible
> > (as long this is not a H/W or F/W bug). But for now, let just
> > stop kernel crashing. Printing WARNING on this situation will
> > help to identify there is something wrong if someone will observe
> > performance problems or similar.
> 
> I think this is a HW issue. As mentioned above, I believe a WARNING here is overkill, as we don't need the stack trace.
> 
> Anyway, Sergei, would you be able to modify the patch along the lines of the discussion?
> 
> ---
> Gertjan


