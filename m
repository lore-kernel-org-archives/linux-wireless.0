Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab2HUOTD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 10:19:03 -0400
Date: Tue, 21 Aug 2012 16:18:43 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Sergei Poselenov <sposelenov@emcraft.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: Re: [rt2x00-users] [PATCH] compat-wireless:rt2800usb: Added rx
 packet length validity check
Message-ID: <20120821141842.GF2380@redhat.com> (sfid-20120821_161910_654609_BCF3CAAA)
References: <20120820205355.7ccc0450@emcraft.com>
 <20120821114343.GB2380@redhat.com>
 <CAOZOX0V5ehfSZKQ=tPpowH35ct230nBXk6wSBiTcb10UUbieCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOZOX0V5ehfSZKQ=tPpowH35ct230nBXk6wSBiTcb10UUbieCA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 21, 2012 at 03:39:41PM +0200, Ivo Van Doorn wrote:
> On Tue, Aug 21, 2012 at 1:43 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > On Mon, Aug 20, 2012 at 08:53:55PM +0400, Sergei Poselenov wrote:
> >> On our system (ARM Cortex-M3 SOC running linux-2.6.33 with
> >> compat-wireless-3.4-rc3-1 modules configured for rt2x00) frequent
> > Please remove compat-wireless reference here and in the subject.
> >
> >> crashes were observed in rt2800usb module because of the invalid
> >> length of the received packet (3392, 46920...). This patch adds
> >> the sanity check on the packet legth. In case of the bad length,
> >> mark the packet as with CRC error.
> >>
> >> The fix was also tested on the latest
> >> compat-wireless-3.5.1-1-snpc.tar.bz2, applies cleanly.
> >>
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Sergei Poselenov <sposelenov@emcraft.com>
> >> ---
> >>  drivers/net/wireless/rt2x00/rt2800usb.c |   10 ++++++++--
> >>  1 files changed, 8 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/usbwifi/compat-wireless-3.4-rc3-1/drivers/net/wireless/rt2x00/rt2800usb.c b/usbwifi/compat-wireless-3.4-rc3-1/drivers/net/wireless/rt2x00/rt2800usb.c
> >> index 001735f..6776ec8 100644
> >> --- a/usbwifi/compat-wireless-3.4-rc3-1/drivers/net/wireless/rt2x00/rt2800usb.c
> >> +++ b/usbwifi/compat-wireless-3.4-rc3-1/drivers/net/wireless/rt2x00/rt2800usb.c
> >> @@ -662,13 +662,18 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
> >>       rx_pkt_len = rt2x00_get_field32(word, RXINFO_W0_USB_DMA_RX_PKT_LEN);
> >>
> >>       /*
> >> -      * Remove the RXINFO structure from the sbk.
> >> +      * Remove the RXINFO structure from the skb.
> >>        */
> >>       skb_pull(entry->skb, RXINFO_DESC_SIZE);
> > Would be great if you could post this as separate patch.
> >
> >>       /*
> >> -      * FIXME: we need to check for rx_pkt_len validity
> >> +      * Check for rx_pkt_len validity, mark as failed.
> >>        */
> >> +     if (rx_pkt_len > entry->skb->len) {
> >> +             rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
> >> +             goto procrxwi;
> >
> > I would rather prefer something like
> >
> > if (unlikely(rx_pkt_len == 0 || rx_pkt_len > entry->queue->data_size)) {
> >         /* Process error in rt2x00lib_rxdone() */
> >         rxdesc->size = rx_pkt_len;
> >         return;
> > }
> 
> But how do you know the packet is correct then?
Non zero rx_pkt_len smaller than data_size indicate correct package.

> Obviously something is wrong,
> so just resetting the rxdesc->size wouldn't be a solution right?

rt2x00lib_rxdone has rxdesc->size check too, if ->size is bad it 
prints warning, and requeue skb. 

Perhaps this could be coded in some cleaner way (avoid double check),
but basically this should do the job. 

Stanislaw
