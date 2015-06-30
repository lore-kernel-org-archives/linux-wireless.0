Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:55474 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbbF3W0d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 18:26:33 -0400
Date: Wed, 1 Jul 2015 08:26:10 +1000
From: James Cameron <quozl@laptop.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	David Lin <dlin@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	Pete Hsieh <peteh@marvell.com>
Subject: Re: [PATCH v4] Add new mac80211 driver mwlwifi.
Message-ID: <20150630222610.GB30901@us.netrek.org> (sfid-20150701_002640_378564_57539CBA)
References: <cf8d3fa226704acea770a987100f4d4e@SC-EXCH02.marvell.com>
 <1435652491.2082.5.camel@sipsolutions.net>
 <1435673924.9390.4.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435673924.9390.4.camel@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 30, 2015 at 09:18:44AM -0500, Dan Williams wrote:
> On Tue, 2015-06-30 at 10:21 +0200, Johannes Berg wrote:
> > On Tue, 2015-06-30 at 01:49 +0000, David Lin wrote:
> > > +++ b/drivers/net/wireless/mwlwifi/Kconfig
> > > @@ -0,0 +1,17 @@
> > > +config MWLWIFI
> > > +	tristate "Marvell Wireless WiFi driver (mwlwifi)"
> > > +	depends on PCI && MAC80211 && MWIFIEX_PCIE=n
> > 
> > I still think you need to get rid of this so we can build-test this
> > driver properly.
> 
> The OLPC 8388 is another device that has two drivers, libertas and
> libertas_tf.

Also 8686.

> I don't think there's any protection between then, you get
> whatever gets loaded first by the kernel.  In that case, I think the
> answer was either (a) only put the driver you want onto the system,
> or

Yes, for end-user.

> (b) manually manage from userspace.

Yes, for developer testing.

> Given that this Marvell hardware is likely intended for more
> customized use-cases (AP, embedded, etc?)  perhaps this would be an
> acceptable option for now...
> 
> I tend to agree with Johannes here; the builder of the kernel can
> certainly adjust CONFIG_MWLWIFI and CONFIG_MWIFIEX to fit their
> scenario, including leaving both enabled.
> 
> Dan
> 
> > > +	select FW_LOADER
> > > +	select OF
> > 
> > This looks OK, though I get a very strange dependency loop warning from
> > Kconfig here.
> > 
> > Looks like the driver now builds almost cleanly with sparse/smatch on
> > 64-bit.
> > 
> > Two warnings remain, both are bugs:
> > 
> > > writew(0x00, (void __iomem *)&priv->pcmd_buf[1]);
> > 
> > cannot be right. This memory isn't __iomem, it's dma_alloc_coherent, so
> > a simple write should be done.
> > 
> > in mwl_rx_ring_init:
> > 
> > >                         rx_hndl->psk_buff =
> > >                                 dev_alloc_skb(desc->rx_buf_size);
> > > 
> > >                         if (skb_linearize(rx_hndl->psk_buff)) {
> > 
> > *crash*. You also later check rx_hndl->psk_buff, but well after it
> > already crashed.
> > 
> > Also, this code sequence is utterly bogus. Please try to understand why
> > and then remove it.
> > 
> > You should also use paged RX since you're allocating *very large* buffe
> > rs. We found that even alloc_pages(1) will fail eventually, you're
> > doing an order-2 allocation here for every RX skb. At least used paged
> > RX to get it down to order-1.
> > 
> > johannes
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
James Cameron
http://quozl.linux.org.au/
