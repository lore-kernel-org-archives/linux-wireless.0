Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58126 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab0GVNaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 09:30:12 -0400
Date: Thu, 22 Jul 2010 09:16:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wl1251: fix sparse-generated warnings
Message-ID: <20100722131627.GA18742@tuxdriver.com>
References: <1279729917-4451-1-git-send-email-linville@tuxdriver.com>
 <1279780458.2322.25.camel@powerslave>
 <4C47F706.4060102@iki.fi>
 <AANLkTimh-2cuWdJKgf2TUkCQmGXDC0-86xVhbA-kiPGR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTimh-2cuWdJKgf2TUkCQmGXDC0-86xVhbA-kiPGR@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 22, 2010 at 08:04:02AM -0400, Bob Copeland wrote:
> On Thu, Jul 22, 2010 at 3:45 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> >>> @@ -191,11 +191,13 @@ static int wl1251_tx_send_packet(struct wl1251 *wl, struct sk_buff *skb,
> >>>      if (control->control.hw_key &&
> >>>          control->control.hw_key->alg == ALG_TKIP) {
> >>>              int hdrlen;
> >>> -            u16 fc;
> >>> +            __le16 fc;
> >>> +            u16 length;
> >>>              u8 *pos;
> [...]
> >>> +            length = le16_to_cpu(tx_hdr->length) + WL1251_TKIP_IV_SPACE;
> >>> +            tx_hdr->length = cpu_to_le16(length);
> >>
> >> ...which is treated correctly here.
> >
> > This is different. Here we are adding something to a __le16 value, not
> > calculating with pointers.
> 
> Just throwing in my 2 cents, unless there's some other reason to add the
> length temporary, here you can just do:
> 
>     le16_add_cpu(&tx_hdr->length, WL1251_TKIP_IV_SPACE);

Ah, thanks!  I thought there was something like that, but I couldn't remember. :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
