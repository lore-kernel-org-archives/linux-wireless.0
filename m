Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:18328 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab0GVHjK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 03:39:10 -0400
Subject: Re: [PATCH] wl1251: fix sparse-generated warnings
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "ext John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>
In-Reply-To: <1279780458.2322.25.camel@powerslave>
References: <1279729917-4451-1-git-send-email-linville@tuxdriver.com>
	 <1279780458.2322.25.camel@powerslave>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 10:38:47 +0300
Message-ID: <1279784327.2322.33.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-07-22 at 08:34 +0200, Coelho Luciano (Nokia-MS/Helsinki)
wrote:
> > @@ -191,11 +191,13 @@ static int wl1251_tx_send_packet(struct wl1251 *wl, struct sk_buff *skb,
> >  	if (control->control.hw_key &&
> >  	    control->control.hw_key->alg == ALG_TKIP) {
> >  		int hdrlen;
> > -		u16 fc;
> > +		__le16 fc;
> > +		u16 length;
> >  		u8 *pos;
> >  
> > -		fc = *(u16 *)(skb->data + sizeof(*tx_hdr));
> > -		tx_hdr->length += WL1251_TKIP_IV_SPACE;
> > +		fc = *(__le16 *)(skb->data + sizeof(*tx_hdr));
> 
> Is this going to work? sizeof(*tx_hdr), and the operation, will be in
> the cpu's endianess, right? Wouldn't the following be the right thing to
> do then?
> 
> fc = cpu_to_le16(le16_to_cpu(skb->data) + sizeof(*tx_hdr));

Ugh, as Johannes pointed out, what I said here is completely non-sense.
Please ignore this before-my-morning-coffee lapse. ;)


-- 
Cheers,
Luca.

