Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:7099 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722AbYGRTCQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 15:02:16 -0400
Received: by nf-out-0910.google.com with SMTP id d3so163116nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2008 12:02:14 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 6/6] rt2x00: Fix GCC warning because aifs is now unsigned
Date: Fri, 18 Jul 2008 21:16:24 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200807182043.08990.IvDoorn@gmail.com> <200807182045.24303.IvDoorn@gmail.com> <1216407221.27738.47.camel@johannes.berg>
In-Reply-To: <1216407221.27738.47.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807182116.25152.IvDoorn@gmail.com> (sfid-20080718_210219_596747_82D69ECD)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 18 July 2008, Johannes Berg wrote:
> On Fri, 2008-07-18 at 20:45 +0200, Ivo van Doorn wrote:
> > The aifs type has recently been changed to unsigned,
> > this triggered the following gcc warning:
> > 
> >   CC [M]  drivers/net/wireless/rt2x00/rt2x00mac.o
> >   drivers/net/wireless/rt2x00/rt2x00mac.c: In function 'rt2x00mac_conf_tx':
> >   drivers/net/wireless/rt2x00/rt2x00mac.c:557: warning: comparison is always true due to limited range of data type
> > 
> > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> > ---
> >  drivers/net/wireless/rt2x00/rt2x00mac.c |    5 +----
> >  1 files changed, 1 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
> > index 77af1df..f1dcbaa 100644
> > --- a/drivers/net/wireless/rt2x00/rt2x00mac.c
> > +++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
> > @@ -554,10 +554,7 @@ int rt2x00mac_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
> >  	else
> >  		queue->cw_max = 10; /* cw_min: 2^10 = 1024. */
> >  
> > -	if (params->aifs >= 0)
> > -		queue->aifs = params->aifs;
> > -	else
> > -		queue->aifs = 2;
> > +	queue->aifs = params->aifs;
> 
> davem already took my patch doing exactly that into his tree, it just
> hasn't arrived back yet.

Oh, I must have missed that patch then. :)
I've found it in your patch directory as well now,

John, please skip this patch

Ivo
