Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:43038 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab0GVIE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 04:04:27 -0400
Subject: Re: [PATCH] wl1251: fix sparse-generated warnings
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Kalle Valo <kalle.valo@iki.fi>
Cc: "ext John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4C47F706.4060102@iki.fi>
References: <1279729917-4451-1-git-send-email-linville@tuxdriver.com>
	 <1279780458.2322.25.camel@powerslave>  <4C47F706.4060102@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 10:57:23 +0300
Message-ID: <1279785443.2322.37.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-07-22 at 09:45 +0200, ext Kalle Valo wrote:
> On 07/22/2010 08:34 AM, Luciano Coelho wrote:
> >> @@ -191,11 +191,13 @@ static int wl1251_tx_send_packet(struct wl1251 *wl, struct sk_buff *skb,
> >>  	if (control->control.hw_key &&
> >>  	    control->control.hw_key->alg == ALG_TKIP) {
> >>  		int hdrlen;
> >> -		u16 fc;
> >> +		__le16 fc;
> >> +		u16 length;
> >>  		u8 *pos;
> >>  
> >> -		fc = *(u16 *)(skb->data + sizeof(*tx_hdr));
> >> -		tx_hdr->length += WL1251_TKIP_IV_SPACE;
> >> +		fc = *(__le16 *)(skb->data + sizeof(*tx_hdr));
> > 
> > Is this going to work? sizeof(*tx_hdr), and the operation, will be in
> > the cpu's endianess, right?
> 
> I think this is correct. We first calculate a pointer to a __le16 value
> and then dereference that value to a __le16 variable.

Yes, you're right, I got totally confused for some reason, as I already
pointed out on my other email.  I completely missed the fact that we
were dealing with pointers here.  It seems like my brain works as that
of a Java programmer before my morning dose of caffeine :P

-- 
Cheers,
Luca.

