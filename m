Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbbF3OSp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 10:18:45 -0400
Message-ID: <1435673924.9390.4.camel@redhat.com> (sfid-20150630_161848_547380_D7BC52C5)
Subject: Re: [PATCH v4] Add new mac80211 driver mwlwifi.
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Lin <dlin@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	Pete Hsieh <peteh@marvell.com>
Date: Tue, 30 Jun 2015 09:18:44 -0500
In-Reply-To: <1435652491.2082.5.camel@sipsolutions.net>
References: <cf8d3fa226704acea770a987100f4d4e@SC-EXCH02.marvell.com>
	 <1435652491.2082.5.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-06-30 at 10:21 +0200, Johannes Berg wrote:
> On Tue, 2015-06-30 at 01:49 +0000, David Lin wrote:
> > +++ b/drivers/net/wireless/mwlwifi/Kconfig
> > @@ -0,0 +1,17 @@
> > +config MWLWIFI
> > +	tristate "Marvell Wireless WiFi driver (mwlwifi)"
> > +	depends on PCI && MAC80211 && MWIFIEX_PCIE=n
> 
> I still think you need to get rid of this so we can build-test this
> driver properly.

The OLPC 8388 is another device that has two drivers, libertas and
libertas_tf.  I don't think there's any protection between then, you get
whatever gets loaded first by the kernel.  In that case, I think the
answer was either (a) only put the driver you want onto the system, or
(b) manually manage from userspace.  Given that this Marvell hardware is
likely intended for more customized use-cases (AP, embedded, etc?)
perhaps this would be an acceptable option for now...

I tend to agree with Johannes here; the builder of the kernel can
certainly adjust CONFIG_MWLWIFI and CONFIG_MWIFIEX to fit their
scenario, including leaving both enabled.

Dan

> > +	select FW_LOADER
> > +	select OF
> 
> This looks OK, though I get a very strange dependency loop warning from
> Kconfig here.
> 
> Looks like the driver now builds almost cleanly with sparse/smatch on
> 64-bit.
> 
> Two warnings remain, both are bugs:
> 
> > writew(0x00, (void __iomem *)&priv->pcmd_buf[1]);
> 
> cannot be right. This memory isn't __iomem, it's dma_alloc_coherent, so
> a simple write should be done.
> 
> in mwl_rx_ring_init:
> 
> >                         rx_hndl->psk_buff =
> >                                 dev_alloc_skb(desc->rx_buf_size);
> > 
> >                         if (skb_linearize(rx_hndl->psk_buff)) {
> 
> *crash*. You also later check rx_hndl->psk_buff, but well after it
> already crashed.
> 
> Also, this code sequence is utterly bogus. Please try to understand why
> and then remove it.
> 
> You should also use paged RX since you're allocating *very large* buffe
> rs. We found that even alloc_pages(1) will fail eventually, you're
> doing an order-2 allocation here for every RX skb. At least used paged
> RX to get it down to order-1.
> 
> johannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


