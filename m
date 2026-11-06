Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.77.101.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793958794;
	b=GjGL4jcQl3/fB2eKYMqn6+G16zth4JFaU4xNBtviOqvFb8f++D0yb8MPgVe0Zyr5pKlH
	 3WqeYVuBqMJ04UFfAiuVI5nZKAaj+4VodYwSzOjJP5PVRMVa+J4QDRPVQ8gY2i1EKR66t
	 qW4QzoCn/rQb/lN7lgGqcm/w6I+Jp/8V++hesMMH8h3fTuAbFSEoMgD3DgdVBEtheuStt
	 vgwWKkXG6JQIKAYOcwIaYDHrSWeK5oVdSRsIcxnusImtzbz9xBH/g172ZfS+4ZhWCgYf3
	 bZt5q3jjBW/7aEQjrk9guXh4iSq8gvIc3C0BWaKqR1XKKZ3Uwu8p8SZqANUzkc0KEAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793958794;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-WP-MailID:X-WP-AV:X-WP-SPAM;
	bh=ttpDjyPqx6TUv3R54jrYgCR6gO2i74vSzxsahiw3hAM=;
	b=d4rZRZY8008LHI+WimSY4ix+iMpi6WIcgDmiO7+/N5gWzj5wjeAioU/mOa6oyEq06n7A
	 EgIyp6Xv5Z1lyhb+jMU3C33SBkJqpY3qVsEsV5cSbQvBUlWA/KJUp+fOvLC+afv6U/I/k
	 u5LrvMYEX8RGBkcQZpPg8i93P6yg2y17xzjqXbLt/RNIMKLU4Ow6G2LaTABeONbWtm7SH
	 HLKiGWwkDbRdsGbpC2jvxxd2tcSwhVpIr4256CKxX3UKKaUNwMtWE29odzJA8BFpVX6Oy
	 ACu/UJtgOvb3MdqMoQnC6Cy1vrpR7LVfEZ0YkdYcg2QKK+APNil4Gw/14ljRvi4Ie2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wp.pl;
	spf=pass smtp.mailfrom=wp.pl;
	dkim=pass header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=QB3rrJtJ;
	arc=none smtp.remote-ip=212.77.101.11
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0F9606A32F
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 09:53:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F0F9606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=QB3rrJtJ
Received: (wp-smtpd smtp.wp.pl 24102 invoked from network); 6 Nov 2026 10:53:04 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1793958784; bh=ttpDjyPqx6TUv3R54jrYgCR6gO2i74vSzxsahiw3hAM=;
          h=From:To:Cc:Subject;
          b=QB3rrJtJmCLYbyFIr4/dNwrd9RiOvwFypJWrkLjYbWlIFYLSW2kd7b6/R8SGybNwh
           rFWvUlW4xtOkzRaU9lzUr4b1UYuQfRY/n3VlPpKXYVWdTJcFZBXttgYqJiZy7L1yl8
           WijpJAuAUGC/Uzu1SD5zhanTFRXnrTFSEnyl/A21CTcdYdzU52SZLVSTAffnIINzv/
           uVrggqhMOAVj7c4xkN/MooKsPP1xKNmkJe7N3dX/RwM03EAyy+BxBOPn5lwNJInqYB
           bWkKMF95kSDx+bVhEiRCUq5W8ogxcz1UEuB9Vq3DQFcrR0BugC2Wo5mimSwLsUiO5S
           vxOsZCeIGG86Q==
Received: from localhost (77-236-11-168.static.play.pl [77.236.11.168])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <hjf3108@gmail.com>; 6 Nov 2026 10:53:04 +0100
Date: Fri, 6 Nov 2026 10:53:03 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Jie Feng <hjf3108@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless-next v2 6/7] wifi: rt2800usb: enable RX bulk
 aggregation
Message-ID: <20261106095303.GA69354@wp.pl>
References: <20261031165117.2868671-1-hjf3108@gmail.com>
 <20261031165117.2868671-7-hjf3108@gmail.com>
 <20261105081000.GF64923@wp.pl>
 <CABOQOSVW+KwgdTbUC_9RDS9mOCW-2Xj-7HdfpCUiGtdQ+f9zVw@mail.gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABOQOSVW+KwgdTbUC_9RDS9mOCW-2Xj-7HdfpCUiGtdQ+f9zVw@mail.gmail.com>
X-WP-MailID: 49a3a7674b483376c67438390e259c6f
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [caM0]                               

On Fri, Nov 06, 2026 at 01:18:19PM +0800, Jie Feng wrote:
> On Thu, 5 Nov 2026 at 16:10, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
> >
> > On Sun, Nov 01, 2026 at 12:51:13AM +0800, Ho Jie Feng wrote:
> > > Enable RX bulk aggregation on high speed USB, to receive more
> > > frames per URB.
> > >
> > > RX buffers are now 24KB, so reduce it to 16 buffers instead of 128,
> > > so that they take 512 KB in total instead of 4 MB.
> > >
> > > Test results:
> > >    before after
> > > TX 30.5   30.5
> > > RX 67.8   80.9
>  ...
> > > --- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
> > > +++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
> > > @@ -301,15 +301,15 @@ static int rt2800usb_enable_radio(struct rt2x00_dev *rt2x00dev)
> > >               return -EIO;
> > >
> > >       rt2x00_set_field32(&reg, USB_DMA_CFG_PHY_CLEAR, 0);
> > > -     rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_EN, 0);
> > > +     rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_EN,
> > > +                        rt2x00dev->rx->usb_maxpacket == 512);
> >
> > Any idea why this condition ? We can not have aggregation on slower
> > or faster USB?
> usb_maxpacket is 512 for high-speed and 64 for full-speed, and I don't think
> rt2800usb has any superspeed devices? In that case I could make it into
> a maxpacket >= 512 check instead for robustness.
> 
> Both the ralink drivers and mt7601 disable it on full speed usb. My best guess
> would be that waiting for a large aggregated buffer over full speed is slow
> and increases latency.
> 
> https://github.com/boundarydevices/rt5572/blob/master/common/cmm_mac_usb.c#L1333

Ok, so this is fine.

> ...
> > > +static unsigned int rt2800usb_get_rx_seg_len(void *data, unsigned int len)
> > > +{
> > > +     unsigned int min_seg_len = RXINFO_DESC_SIZE + RXWI_DESC_SIZE_4WORDS +
> > > +                                RXD_DESC_SIZE;
> > > +     unsigned int rx_pkt_len;
> > > +     u32 word;
> > > +
> > > +     if (len < min_seg_len)
> > > +             return 0;
> > > +
> > > +     word = rt2x00_desc_read(data, 0);
> > > +     rx_pkt_len = rt2x00_get_field32(word, RXINFO_W0_USB_DMA_RX_PKT_LEN);
> > > +
> > > +     if (!rx_pkt_len ||
> > > +         RXINFO_DESC_SIZE + rx_pkt_len + RXD_DESC_SIZE > len ||
> > > +         rx_pkt_len & 0x3)
> >
> > This is indication of we do something wrong, similar when len < min_seg_len.
> > Maybe wrap those with WARN_ON_ONCE() ?
> >
> Should I put one WARN_ON_ONCE for the full condition, or wrap it individually
> Wrapping it individually might be easier for debugging if someone
> sends their dmesg.

For this condition, I would add one WARN_ON_ONCE for rx_pkt_len non-zero
and alignment validity, and another one for <= len validity.

> > >
> > > +
> > > +     return RXINFO_DESC_SIZE + rx_pkt_len + RXD_DESC_SIZE;
> > > +}
> > > +
> > >  static void rt2800usb_fill_rxdone(struct queue_entry *entry,
> > >                                 struct rxdone_entry_desc *rxdesc)
> > >  {
> > > @@ -706,6 +727,7 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
> > >       .clear_beacon           = rt2800_clear_beacon,
> > >       .get_tx_data_len        = rt2800usb_get_tx_data_len,
> > >       .fill_rxdone            = rt2800usb_fill_rxdone,
> > > +     .get_rx_seg_len         = rt2800usb_get_rx_seg_len,
> > >       .config_shared_key      = rt2800_config_shared_key,
> > >       .config_pairwise_key    = rt2800_config_pairwise_key,
> > >       .config_filter          = rt2800_config_filter,
> > > @@ -725,8 +747,8 @@ static void rt2800usb_queue_init(struct data_queue *queue)
> > >
> > >       switch (queue->qid) {
> > >       case QID_RX:
> > > -             queue->limit = 128;
> > > -             queue->data_size = AGGREGATION_SIZE;
> > > +             queue->limit = 16;
> > > +             queue->data_size = MAX_RXBULK_SIZE;
> >
> > Since we enable aggregation conditionally, this probably should also be
> > conditional. But the issue is that we do not have
> > rt2x00dev->rx->usb_maxpacket value available yet.
> Due to full-speed USB being 40x slower than high speed, I think
> the reduction in queue limit might not be a problem.

Ok, it makes sense then do change this unconditionally.

> > We could just enable aggregation unconditionally,
> > but I'm not sure it will work with some older chips like RT2870?
> On my tests it works on RT3070 too, but I don't have any others to
> test. The ralink driver also does it for all chips too.

I tested on RT3071, RT5370, RT5572. I was worried about older
chips, but looked at old staging driver for RT2860 and it enables
USB aggregation too:
https://github.com/torvalds/linux/blob/v2.6.35/drivers/staging/rt2860/common/cmm_mac_usb.c#L738

So we are fine to do this change.

Regards
Stanislaw
