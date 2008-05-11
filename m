Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:54940 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbYEKLXG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2008 07:23:06 -0400
Received: by ug-out-1314.google.com with SMTP id h2so498533ugf.16
        for <linux-wireless@vger.kernel.org>; Sun, 11 May 2008 04:23:04 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 4/5] rt2x00: Convert rt2x00 to read control info from skb->cb
Date: Sun, 11 May 2008 13:33:14 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805101349.19481.IvDoorn@gmail.com> <1210454412.12837.16.camel@johannes.berg> <200805111113.53138.IvDoorn@gmail.com>
In-Reply-To: <200805111113.53138.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805111333.14214.IvDoorn@gmail.com> (sfid-20080511_132313_393990_43CC382F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 11 May 2008, Ivo van Doorn wrote:
> On Saturday 10 May 2008, Johannes Berg wrote:
> > 
> > > +	/*
> > > +	 * Don't automatically kick the beacon queue.
> > > +	 */
> > > +	tx_info->flags &= ~IEEE80211_TX_CTL_READY_FOR_TX;
> > >  
> > >  	/*
> > >  	 * Fill in skb descriptor
> > >  	 */
> > >  	skbdesc = get_skb_frame_desc(skb);
> > >  	memset(skbdesc, 0, sizeof(*skbdesc));
> > > -	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
> > 
> > Could you live w/o that change? I'm pondering removing that flag again
> > since it doesn't have any meaning any more with the fragmentation/busy
> > reschedule rewrite I'll do.
> 
> Not a problem, I had already removed a few instances where I used that,
> and will remove the remaining bits as well.

Hmm, things could be much easier for rt2x00 if there was a mac80211 flag
that would indicate if the tx_status should be called or not upon txdone.

I used the IEEE80211_TX_CTL_READY_FOR_TX to make sure RTS and CTS frames
were not reported to mac80211 when they were send, but would it perhaps be
better if I used the flag IEEE80211_TX_CTL_REQ_TX_STATUS for that?
I remember that some time ago drivers weren't supposed to check for that
flag, or at least not to determine if the tx_status should be called, but has
this changed and can the flag be used or should rt2x00 keep track of what
should be reported and what not?

Ivo
