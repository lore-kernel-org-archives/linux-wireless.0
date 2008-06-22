Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:5975 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbYFVUaH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 16:30:07 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1732803wfd.4
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jun 2008 13:30:06 -0700 (PDT)
Subject: Re: [RFC-PATCH] mac80211: add helpers for skb manipulation
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200806221618.47366.IvDoorn@gmail.com>
References: <1213939944.6591.13.camel@brick>
	 <200806221618.47366.IvDoorn@gmail.com>
Content-Type: text/plain
Date: Sun, 22 Jun 2008 13:30:07 -0700
Message-Id: <1214166608.21092.5.camel@brick> (sfid-20080622_223012_323940_B5A57DC6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-06-22 at 16:18 +0200, Ivo van Doorn wrote:
> > diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> > index ce62b16..493ce19 100644
> > --- a/net/mac80211/util.c
> > +++ b/net/mac80211/util.c
> > @@ -176,6 +176,40 @@ unsigned int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
> >  }
> >  EXPORT_SYMBOL(ieee80211_get_hdrlen_from_skb);
> >  
> > +unsigned int
> > +ieee80211_hdrlen_check_skb(const struct sk_buff *skb, unsigned int slack)
> > +{
> > +	const struct ieee80211_hdr *hdr;
> > +	unsigned int hdrlen;
> > +
> > +	hdr = (const struct ieee80211_hdr *)skb->data;
> > +	hdrlen = ieee80211_hdrlen(hdr->frame_control);
> 
> 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
> 
> That way you don't need the  const struct ieee80211_hdr *hdr variable.
> 

The problem is that ieee80211_get_hdrlen_from_skb returns 0 if the skb
is too short for the ieee80211_hdr...which is precisely what I'm
interested in with this helper (plus some slack).

So instead of checking for the length of the skb once in ...from_skb
and then again with some slack, I'm opencoding it here and just checking
the skb->len once against hdrlen + slack.


Cheers,

Harvey

