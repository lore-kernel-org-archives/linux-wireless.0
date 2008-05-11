Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:55618 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbYEKJDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2008 05:03:46 -0400
Received: by ug-out-1314.google.com with SMTP id h2so484319ugf.16
        for <linux-wireless@vger.kernel.org>; Sun, 11 May 2008 02:03:43 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 4/5] rt2x00: Convert rt2x00 to read control info from skb->cb
Date: Sun, 11 May 2008 11:13:52 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805101349.19481.IvDoorn@gmail.com> <200805101351.11467.IvDoorn@gmail.com> <1210454412.12837.16.camel@johannes.berg>
In-Reply-To: <1210454412.12837.16.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805111113.53138.IvDoorn@gmail.com> (sfid-20080511_110414_325425_9D1C7436)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 10 May 2008, Johannes Berg wrote:
> 
> > +	/*
> > +	 * Don't automatically kick the beacon queue.
> > +	 */
> > +	tx_info->flags &= ~IEEE80211_TX_CTL_READY_FOR_TX;
> >  
> >  	/*
> >  	 * Fill in skb descriptor
> >  	 */
> >  	skbdesc = get_skb_frame_desc(skb);
> >  	memset(skbdesc, 0, sizeof(*skbdesc));
> > -	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
> 
> Could you live w/o that change? I'm pondering removing that flag again
> since it doesn't have any meaning any more with the fragmentation/busy
> reschedule rewrite I'll do.

Not a problem, I had already removed a few instances where I used that,
and will remove the remaining bits as well.

Ivo
