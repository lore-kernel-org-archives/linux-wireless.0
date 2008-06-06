Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:32954 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbYFFSrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2008 14:47:43 -0400
Received: by wa-out-1112.google.com with SMTP id j37so833756waf.23
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jun 2008 11:47:42 -0700 (PDT)
Subject: Re: [PATCH 4/7] mac80211: make ieee80211_get_hdrlen_from_skb
	return unsigned
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200806062024.24681.mb@bu3sch.de>
References: <1212774672.6340.78.camel@brick>
	 <200806062024.24681.mb@bu3sch.de>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 11:47:41 -0700
Message-Id: <1212778061.6340.85.camel@brick> (sfid-20080606_204802_090675_2D7DF474)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-06-06 at 20:24 +0200, Michael Buesch wrote:
> On Friday 06 June 2008 19:51:12 Harvey Harrison wrote:
> > -int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
> > +unsigned int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
> >  {
> >  	const struct ieee80211_hdr *hdr = (const struct ieee80211_hdr *) skb->data;
> > -	int hdrlen;
> > +	unsigned int hdrlen;
> >  
> > -	if (unlikely(skb->len < 10))
> > +	if (skb->len < 10)
> 
> Why are you removing the unlikely()? This should actually be pretty unlikely.
> Sane firmware will drop short packets, so the kernel won't ever see them.
> 

When all that is in the if-block is a return, there's not much point.
It's a trivial test/return and gcc does a fine job with this.

> >  		return 0;
> > -	hdrlen = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control));
> > -	if (unlikely(hdrlen > skb->len))
> > +	hdrlen = ieee80211_hdrlen(hdr->frame_control);
> > +	if (hdrlen > skb->len)
> 
> I think this also is unlikely, as it can only come from corrupted packets.
> 

unlikely() isn't some magic make-me-faster function, it just moves code
to the end of the function to get it out of the icache and jumps to it
in the unlikely case it is taken.  When all there is is a return, I
don't think it even makes any difference.  In both these cases a comment
is probably more appropriate.

Harvey

