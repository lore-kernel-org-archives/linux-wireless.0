Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793942337;
	b=zu55HB+sC3eyu2NdOChLZGagSMFhO3XMkBDugW6DMVp8iQ+X9WK1fTMFuuxvI2TF7H2/
	 RsoaE+ewm6b6eKWFlK+o2qeQIzOT1Pr1G9cSdXCIq739xewD1C93s41rD467f0BJ20yqK
	 tZbyvc7JsYx0CEdcVCGW+MgiEgmt610toN49r2TsNENERg+OPVYd10K2ym/Tc9L4LYV2q
	 Ye4YE3l9+A+1VvWldvdIhuCTOcZR3hvDZD6clE6foGfZlPX2s/+pfNISxD/UfQ2Vv2knm
	 wJAj1Cwkg9QSqcAF1lAfQhNU7fsa57bu7TgDmxnVaSi6YsbSedCp4BMsCwJB2RNkuTg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793942337;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=loW1li7alaCOtU/5BmjclmN5Lf1RKbPb6XNoyq8GzBY=;
	b=gCmZEappTKqV+YH3haQwc4b926nU16ddCLW7pwv00blFxGwNG/9gHqecR24G3PP5UBmo
	 2Q1zaXhtJYbJtic1u8KLdWq86xsiHjDBsW3+7/Z5EPwrhwvDJibX+QHrLdrGEZ+/9+x8F
	 Pf3mx4hx4N9HUQ2kX1q4ki3y82xFan+LMzoDs/R7PuSKFak3rDOZlRvbNU5PsZIrvrP7P
	 w3noiRLEq2n8AAGs8jZRMqj6C1H62Sc710NJVSJZoYL9lXqDQICCQmcm4HMZggEqGWq4/
	 /2dbq5XjuOBSNY7J6XcK/0LKPld62woYtUHm0yVqCFa0uL76elkkM4C30mSczOh5okg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NijjtoWT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.46
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E779A606A331
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 05:18:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E779A606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NijjtoWT
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-46556b9e02cso228770fac.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 21:18:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793942335; cv=none;
        d=google.com; s=arc-20260327;
        b=boc1OIkjqPvK9qz71lu1xWBXFZr0IUNZCIlS5a9x6WwzfObwdMZ3mJjCsyV/obbz9y
         GVMY9rTFyh3rnwQm6QFW/oRvSmci1re/VX6/Q9cY4ckuoPBcqzfZc9t/soJz9woBQp/l
         aMR0w5k1vd0PuuqB3ZipRIvNdWAnUojwZoR+umgpMAZifBf4lmmIWHz0TxjRX3L+Yh7l
         zdZLcndMk/dasAXqBKWSUf8EKwnIbfRi9tqn+PhIApBlKlKwg51iZALmRnceEpKeLtLk
         ezj2UWez/fQQTcgi0gSU6mWKllo6rVtwgZYX0XArJqZbberEdC8QFTyTaRqQF4O5VLlf
         Kilg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=loW1li7alaCOtU/5BmjclmN5Lf1RKbPb6XNoyq8GzBY=;
        fh=Gb8RSDLQoV+qgJjwh3JErt+C3hloosFkdHxORzYl2ZY=;
        b=CtsKj0Lz3QYN5dBeIAXch6Tz8l1mR2y7KXy2aJTzp5jn4Q7cJGTQrYeeJd9XQpLjXz
         FNuHYa5JGf+eIm7LiwWkwvdx5zM/pm1j5K7EVld+UIpncJXyhP+iHabMDILS+eEO9Akt
         SL9DqTDE7MMs1/pjAg2iFAdNUBTKXevSi5MWpZWgTihqdTlsnHuGcyNszwEk2bJe9Fli
         qS30eVa19HUNvBIgfb7cjiD+S4Bp0p9C2uf9lewNZ5XXvFG7RB8o+34oMjlWVrGV4E4U
         IiwTWCNhT5wVkzjhtG99K+k0eonvb2Z45bgvKVftI/qjAOC6OBhamTVa/Lzgy2hTXY30
         uZ7Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793942335; x=1794547135; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=loW1li7alaCOtU/5BmjclmN5Lf1RKbPb6XNoyq8GzBY=;
        b=NijjtoWT8ACZg9+T7J/snUkIgPzyvJbVPg7ROuphkqR9Da7wVL/ZoXX1EmHLLdODyP
         XUZvuwty6cJX/E7JJZM+4xS3m2rYGj0VJ4NTVm776ZSWYMx0p85H0Lecx8dI2xBgIQ5W
         B16fYVh8UjtwN50DorVQ5Wez7zAZom371Bhmeu4dKV+HJ/Da4qq0fQxN0E1rHQ3DA9bS
         Id5RHgDc4p9hucXrC7Cf6XkdAd8y7ZzlbBtZNqFZNlnHtNqlC6BYBmLM2yj6RgOjUJ5V
         c9wRxBQM4cz7ZuacTgcDRsZYZS08boLRfgh1K5qs86WkdWm+ZE6ZghohCWl2o5HjIhOb
         WHVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793942335; x=1794547135;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=loW1li7alaCOtU/5BmjclmN5Lf1RKbPb6XNoyq8GzBY=;
        b=bSyZcCt6ZD7ouCWwsjGxzqGb+X68ErCfF/7foeK9toRI34aYreIrNA7iOyurgwVw3o
         udPGAqxZBsDw2h7Cex01ldnp8hntW3hS7t/4538TucBKJKqCo9pIwU63JBZ7EM1mkjEM
         1n7EIcLZWXOHfJO57veLMylB2G9iTRVxLdxPBdu3vVJpxlj6kY2VsEaphOefZ7GaLFNF
         SENJICbt1S1BJ1br8UBi4mv0oOh1MOVEovoKcYV8oBLgc+mfLjVuuaO7ZvB4jhlT+l0e
         UK0eN9waeCiPUlupDoDri3RoF+G74cXwqIRJFs+uAe51jQ0x9Nv9qNGFN50bZ1brlsfe
         gwFA==
X-Gm-Message-State: APuU4Z+6WtVhB77QeDC8XEaHbBjCr/9tacabhEDP0WCf1Fs4bUzXY2K9
	QFBN+k9tnd9qd/GDYZ5D3UaOdflxbQsUVPABaL6whZ47sDWjNkP8P2S2G1sOdDIGzUmQbtlXVjJ
	NI4hbL24Dnwu0AvY3u1ySjVrlVhqS5y0BE9fE8fg=
X-Gm-Gg: AYBFou0OuogXli8J+p3ICfUM4gzlO+spurWOJ5GxJvf3JuY8yoKh43iIJHFM03y7lWl
	dy+SGwqYJmhL86ekZ29sKPkslBmyRipSqubzQ6lHA+h/dumg+IznxR1JA9QNbbEyexZ/4V1LQPN
	b7wAFLTiB2M4xl1ySc7+ugyoNyfaCftCOTt2fhUD8eAN2QYbyFS74x7y+7EzrWzrDKbGrgThHTP
	uDAYYrsnPvqaB9xbwK3YJipmvbdiJXQ+l0RZe1e1LzKvKp6zS2VvDZyrDwBgPHsPDlEO7UGjwPR
	eidnEDeuVtbWWSre05b1BFmHj6QMq2Mx+64hVY2ynwTZTrM+ejjbxliI02OqtfwKRR+yjBK1Elf
	beBWEEpdGn5Z93wctNbrpwq7ifILr1v92PPNfa/eSQt87KCiNb2WKHIun19UZJi/d16JzqOQ=
X-Received: by 2002:a05:6870:be8e:b0:464:13bb:5b63 with SMTP id
 586e51a60fabf-4ad6afcda7dmr2937363fac.5.1793942335519; Thu, 05 Nov 2026
 21:18:55 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261031165117.2868671-1-hjf3108@gmail.com> <20261031165117.2868671-7-hjf3108@gmail.com>
 <20261105081000.GF64923@wp.pl>
In-Reply-To: <20261105081000.GF64923@wp.pl>
From: Jie Feng <hjf3108@gmail.com>
Date: Fri, 6 Nov 2026 13:18:19 +0800
X-Gm-Features: AclHuK_fiDFrQ87gno9MouRhE8h3dnRf10gG0aroYP5mIgUq8TVgCF74HX90xik
Message-ID: <CABOQOSVW+KwgdTbUC_9RDS9mOCW-2Xj-7HdfpCUiGtdQ+f9zVw@mail.gmail.com>
Subject: Re: [PATCH wireless-next v2 6/7] wifi: rt2800usb: enable RX bulk aggregation
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Nov 2026 at 16:10, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
>
> On Sun, Nov 01, 2026 at 12:51:13AM +0800, Ho Jie Feng wrote:
> > Enable RX bulk aggregation on high speed USB, to receive more
> > frames per URB.
> >
> > RX buffers are now 24KB, so reduce it to 16 buffers instead of 128,
> > so that they take 512 KB in total instead of 4 MB.
> >
> > Test results:
> >    before after
> > TX 30.5   30.5
> > RX 67.8   80.9
 ...
> > --- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
> > @@ -301,15 +301,15 @@ static int rt2800usb_enable_radio(struct rt2x00_dev *rt2x00dev)
> >               return -EIO;
> >
> >       rt2x00_set_field32(&reg, USB_DMA_CFG_PHY_CLEAR, 0);
> > -     rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_EN, 0);
> > +     rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_EN,
> > +                        rt2x00dev->rx->usb_maxpacket == 512);
>
> Any idea why this condition ? We can not have aggregation on slower
> or faster USB?
usb_maxpacket is 512 for high-speed and 64 for full-speed, and I don't think
rt2800usb has any superspeed devices? In that case I could make it into
a maxpacket >= 512 check instead for robustness.

Both the ralink drivers and mt7601 disable it on full speed usb. My best guess
would be that waiting for a large aggregated buffer over full speed is slow
and increases latency.

https://github.com/boundarydevices/rt5572/blob/master/common/cmm_mac_usb.c#L1333

...
> > +static unsigned int rt2800usb_get_rx_seg_len(void *data, unsigned int len)
> > +{
> > +     unsigned int min_seg_len = RXINFO_DESC_SIZE + RXWI_DESC_SIZE_4WORDS +
> > +                                RXD_DESC_SIZE;
> > +     unsigned int rx_pkt_len;
> > +     u32 word;
> > +
> > +     if (len < min_seg_len)
> > +             return 0;
> > +
> > +     word = rt2x00_desc_read(data, 0);
> > +     rx_pkt_len = rt2x00_get_field32(word, RXINFO_W0_USB_DMA_RX_PKT_LEN);
> > +
> > +     if (!rx_pkt_len ||
> > +         RXINFO_DESC_SIZE + rx_pkt_len + RXD_DESC_SIZE > len ||
> > +         rx_pkt_len & 0x3)
>
> This is indication of we do something wrong, similar when len < min_seg_len.
> Maybe wrap those with WARN_ON_ONCE() ?
>
Should I put one WARN_ON_ONCE for the full condition, or wrap it individually
Wrapping it individually might be easier for debugging if someone
sends their dmesg.

> >
> > +
> > +     return RXINFO_DESC_SIZE + rx_pkt_len + RXD_DESC_SIZE;
> > +}
> > +
> >  static void rt2800usb_fill_rxdone(struct queue_entry *entry,
> >                                 struct rxdone_entry_desc *rxdesc)
> >  {
> > @@ -706,6 +727,7 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
> >       .clear_beacon           = rt2800_clear_beacon,
> >       .get_tx_data_len        = rt2800usb_get_tx_data_len,
> >       .fill_rxdone            = rt2800usb_fill_rxdone,
> > +     .get_rx_seg_len         = rt2800usb_get_rx_seg_len,
> >       .config_shared_key      = rt2800_config_shared_key,
> >       .config_pairwise_key    = rt2800_config_pairwise_key,
> >       .config_filter          = rt2800_config_filter,
> > @@ -725,8 +747,8 @@ static void rt2800usb_queue_init(struct data_queue *queue)
> >
> >       switch (queue->qid) {
> >       case QID_RX:
> > -             queue->limit = 128;
> > -             queue->data_size = AGGREGATION_SIZE;
> > +             queue->limit = 16;
> > +             queue->data_size = MAX_RXBULK_SIZE;
>
> Since we enable aggregation conditionally, this probably should also be
> conditional. But the issue is that we do not have
> rt2x00dev->rx->usb_maxpacket value available yet.
Due to full-speed USB being 40x slower than high speed, I think
the reduction in queue limit might not be a problem.

> We could just enable aggregation unconditionally,
> but I'm not sure it will work with some older chips like RT2870?
On my tests it works on RT3070 too, but I don't have any others to
test. The ralink driver also does it for all chips too.

> So perhaps better would be set a capability flag during probe for
> chips that know to work with the aggregation and use it here and
> when configuring USB_DMA register? Or base on usb_maxpacket
> but check it during probe?
A flag looks good for this if we decide to conditionally gate it on
more than just usb speed.

> Regards
> Stanislaw
>
>
