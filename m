Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:5880 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbYFUJqi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2008 05:46:38 -0400
Received: by an-out-0708.google.com with SMTP id d40so374572and.103
        for <linux-wireless@vger.kernel.org>; Sat, 21 Jun 2008 02:46:37 -0700 (PDT)
To: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Subject: Re: [PATCH] rt2x00: Remove duplicate deinitialization
Date: Sat, 21 Jun 2008 12:04:19 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200806202210.54248.IvDoorn@gmail.com> <485C25CA.6000607@kpnplanet.nl>
In-Reply-To: <485C25CA.6000607@kpnplanet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806211204.21129.IvDoorn@gmail.com> (sfid-20080621_114642_096146_6BF2CE81)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

> > @@ -509,16 +498,11 @@ static int rt2x00queue_alloc_rxskbs(struct rt2x00_dev *rt2x00dev,
> >  	for (i = 0; i < queue->limit; i++) {
> >  		skb = rt2x00queue_alloc_rxskb(rt2x00dev, &queue->entries[i]);
> >  		if (!skb)
> > -			goto exit;
> > +			return -ENOMEM;
> >  		queue->entries[i].skb = skb;
> >  	}
> >  
> >  	return 0;
> > -
> > -exit:
> > -	rt2x00queue_free_skbs(rt2x00dev, queue);
> > -
> > -	return -ENOMEM;
> >  }
> >  
> >  int rt2x00queue_initialize(struct rt2x00_dev *rt2x00dev)
> >   
> 
> 
> I find this last hunk of the patch a bit dubious. IMHO a function should 
> never rely on letting his caller do the right thing and clean up for it, 
> in case of failures; it should always clean up after itself. It is true 
> that in this case the caller will also attempt to clean up these 
> structures, but that doesn't mean that any potential future users of 
> such a function should be bothered with doing the same thing.

True but rt2x00queue_alloc_rxskbs and rt2x00queue_free_rxskbs are only
called once. And there isn't any reason why they should be called anywhere
else other then initialize() and uninitialize().

And this approach is the same as other allocation/free paths like in rt2x00pci/usb
and rt2x00lib.

Ivo
