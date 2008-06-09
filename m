Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:46885 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbYFIQYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 12:24:24 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1362724ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2008 09:24:23 -0700 (PDT)
Subject: Re: [PATCH 3/7] mac80211: add utility function to get header length
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240806090301h2a1a3350x606cfe1d83be066a@mail.gmail.com>
References: <1212774672.6340.77.camel@brick>
	 <1213002964.698.67.camel@johannes.berg>
	 <1ba2fa240806090301h2a1a3350x606cfe1d83be066a@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 09:24:20 -0700
Message-Id: <1213028660.5974.9.camel@brick> (sfid-20080609_182428_268561_39D87703)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-09 at 13:01 +0300, Tomas Winkler wrote:
> On Mon, Jun 9, 2008 at 12:16 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> >>  /**
> >> + * ieee80211_hdrlen - get header length in bytes from frame control
> >> + * @fc: frame control field in little-endian format
> >> + */
> >> +unsigned int ieee80211_hdrlen(__le16 fc);
> >> +
> >
> >> +EXPORT_SYMBOL(ieee80211_hdrlen);
> >
> > Do we really need to export that?
> 
> so now we have hdrlen(u16) and hdrlen(__le16)  it will be fun.
> 
> So I guess will we converting idioms
> u16 fc = le16_to_cpu(hdr->frame_control);
> int hdr_len = ieee80211_get_hdrlen(fc);
> to
> int hdr_len = ieee80211_hdrlen(hdr->frame_control)
> 
> This is how it used in driver code so it make sense to export this
> function and remove ieee80211_get_hdrlen(fc)

Yes, that was my thinking, I just did it this way to avoid the flag day
change, I'll trickle the changes in and then remove _get_hdrlen.

> 
> Since all fc operations are bitwise 'and' and 'or'
> u16 rx->fc can be dropped in future as well

I was going to convert it to a __le16, but if it is just a copy of the
->frame_control in the header, I'll look at removing it instead.

Cheers,

Harvey

