Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:32349 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbYEWQFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 12:05:36 -0400
Received: by fg-out-1718.google.com with SMTP id 19so429139fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2008 09:05:34 -0700 (PDT)
To: Andrew Price <andy@andrewprice.me.uk>
Subject: Re: BUG: scheduling while atomic (2.6.26-rc3...)
Date: Fri, 23 May 2008 18:06:39 +0200
Cc: linux-wireless@vger.kernel.org
References: <g158ou$ts7$1@ger.gmane.org> <200805231628.39152.IvDoorn@gmail.com> <g16nh3$iqd$1@ger.gmane.org>
In-Reply-To: <g16nh3$iqd$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805231806.39280.IvDoorn@gmail.com> (sfid-20080523_180540_268005_F61DEA05)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 May 2008, Andrew Price wrote:
> Hi Ivo,
> 
> On 23/05/08 15:28, Ivo van Doorn wrote:
> > Andew: Could you try below patch to see if that works?
> 
> It looks good. wlan0 came up fine and dmesg looks clean, I can ping and
> read email...

Excellent, I'll push the patch upstream then. :)

Ivo

> Seems that some traffic (ssh, http, ...) is having problems though so
> I'm back on -rc1 to email you but I expect that's a different problem
> altogether and I'll see if I can track it down.
> 
> > ---
> > diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> > index 5645140..669d942 100644
> > --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> > +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> > @@ -481,9 +481,9 @@ void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev)
> >  	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
> >  		return;
> >  
> > -	ieee80211_iterate_active_interfaces(rt2x00dev->hw,
> > -					    rt2x00lib_beacondone_iter,
> > -					    rt2x00dev);
> > +	ieee80211_iterate_active_interfaces_atomic(rt2x00dev->hw,
> > +						   rt2x00lib_beacondone_iter,
> > +						   rt2x00dev);
> >  
> >  	queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->intf_work);
> >  }
> > 
> 
> Thanks,
> 
> --
> Andy Price
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


