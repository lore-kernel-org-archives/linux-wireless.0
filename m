Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f215.google.com ([209.85.219.215]:35417 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932794AbZKXUEs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 15:04:48 -0500
Received: by ewy7 with SMTP id 7so10690ewy.28
        for <linux-wireless@vger.kernel.org>; Tue, 24 Nov 2009 12:04:52 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH v2 8/8] rt2x00: Properly request tx headroom for alignment operations.
Date: Tue, 24 Nov 2009 21:04:42 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <1259012694-14869-1-git-send-email-gwingerde@gmail.com> <200911241819.29685.IvDoorn@gmail.com> <4B0C3035.7010003@gmail.com>
In-Reply-To: <4B0C3035.7010003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911242104.42899.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 24 November 2009, Gertjan van Wingerde wrote:
> On 11/24/09 18:19, Ivo van Doorn wrote:
> > On Monday 23 November 2009, Gertjan van Wingerde wrote:
> >> Current rt2x00 drivers may result in a "ieee80211_tx_status: headroom too
> >> small" error message when a frame needs to be properly aligned before
> >> transmitting it.
> >> This is because the space needed to ensure proper alignment isn't
> >> requested from mac80211.
> >> Fix this by adding sufficient amount of alignment space to the amount
> >> of headroom requested for TX frames.
> >>
> >> Reported-by: David Ellingsworth <david@identd.dyndns.org>
> >> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> >> ---
> >>  drivers/net/wireless/rt2x00/rt2x00.h    |    6 ++++++
> >>  drivers/net/wireless/rt2x00/rt2x00dev.c |   12 +++++++++++-
> >>  2 files changed, 17 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> >> index 4d841c0..dcfc8c2 100644
> >> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> >> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> >> @@ -113,6 +113,12 @@
> >>  	(  ((unsigned long)((__skb)->data + (__header))) & 3 )
> >>  
> >>  /*
> >> + * Constants for extra TX headroom for alignment purposes.
> >> + */
> >> +#define RT2X00_ALIGN_SIZE	4 /* Only whole frame needs alignment */
> >> +#define RT2X00_L2PAD_SIZE	8 /* Both header & payload need alignment */
> > 
> > Now that I think of it, why do we need 8 byte for L2 padding?
> > Shouldn't we need the same size for regular alignment, L2 padding only indicates
> > the padding occurs between header and payload rather then before the header only.
> > So unless I am mistaken about how I coded the header & payload moving in rt2x00lib,
> > you always need at most 4 bytes.
> > 
> 
> Nope. If I read the code right then the header can be moved by more than 4 bytes, namely
> when the payload needs to be shifted more than the header. In that case the header is
> shifted an extra 4 bytes to make room for the payload. However, 8 is the obvious maximum.

Ah right, well 8bytes is ok then. :)

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
