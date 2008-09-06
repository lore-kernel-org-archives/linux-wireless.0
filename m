Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:5967 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbYIFWoF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 18:44:05 -0400
Received: by ey-out-2122.google.com with SMTP id 6so429481eyi.37
        for <linux-wireless@vger.kernel.org>; Sat, 06 Sep 2008 15:44:03 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: make conf_tx non-atomic
Date: Sun, 7 Sep 2008 00:43:59 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1220717588.5376.0.camel@johannes.berg> <200809061950.36213.IvDoorn@gmail.com> <1220725734.10102.7.camel@johannes.berg>
In-Reply-To: <1220725734.10102.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200809070044.00074.IvDoorn@gmail.com> (sfid-20080907_004408_975009_E3309192)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 06 September 2008, Johannes Berg wrote:
> On Sat, 2008-09-06 at 19:50 +0200, Ivo van Doorn wrote:
> > On Saturday 06 September 2008, Johannes Berg wrote:
> > > The conf_tx callback currently needs to be atomic, this requirement
> > > is just because it can be called from scanning. This rearranges it
> > > slightly to only update while not scanning (which is fine, we'll be
> > > getting beacons when associated) and thus removes the atomic
> > > requirement.
> > 
> > Oops. Ehm how many oopses were reported since I submitted patch:
> > 	47909b24a7e6c67ad635f36f5312839e04c7617c
> > 	rt2x00: Initialize txop during conf_tx() callback
> > 
> > Because apparently that patch broke rt73usb (I completely overlooked
> > the conf_tx() atomic requirements). :S
> 
> Heh, I don't know.
> 
> > Fortunately this patch would fix it again. :)
> 
> :)
> 
> > >  	/* Do not send changes to driver if we are scanning. This removes
> > > -	 * requirement that driver's bss_info_changed function needs to be
> > > -	 * atomic. */
> > > +	 * requirement that a driver's bss_info_changed/conf_tx functions
> > > +	 * need to be atomic.
> > > +	 * This is really ugly code, we should rewrite scanning and make
> > > +	 * all this more understandable for humans.
> > > +	 */
> > 
> > So bss_info_changed() is now non-atomic as well? Because that would be
> > very useful for rt2x00. :)
> 
> Yeah, it's been for a while, in fact.

Ah ok. Well I'll create a oatch to cleanup rt2x00 then. :)

Thanks,

Ivo
