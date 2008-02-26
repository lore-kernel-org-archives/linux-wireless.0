Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.191]:44684 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005AbYBZTMs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 14:12:48 -0500
Received: by gv-out-0910.google.com with SMTP id s4so966374gve.37
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2008 11:12:46 -0800 (PST)
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: "Ivo Van Doorn" <ivdoorn@gmail.com>
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Date: Tue, 26 Feb 2008 19:11:39 +0000
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com> <200802252104.32416.chris2553@googlemail.com> <a32f33a40802251409ofbdab60w4a95c8aaefaad70a@mail.gmail.com>
In-Reply-To: <a32f33a40802251409ofbdab60w4a95c8aaefaad70a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802261911.39577.chris2553@googlemail.com> (sfid-20080226_191253_523241_FE367BB9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> >   I've bisected anyway and although the results are not absolutely
> > conclusive, as I neared the end of the process, I was amongst a bunch of
> > mac80211 patches. This set me on a path that resulted in me discovering
> > that with the rt61pci driver, I can freeze my wireless network connection
> > almost at will if I set mac82011's ieee80211_default_rc_algo parameter to
> > 'pid'. if the parametre is set to 'simple', the network seems to be
> > reliable. I've just let the ping application run on and ping another box
> > on my network almost 1500 times whilst repeatedly transferring a kernel
> > source tarball by ftp from another box and the network connection was
> > mantained That's with the parameter set to 'simple', if \I set it to
> > 'pid' the connection rarely survives more than 40 pings even without the
> > ftp activity.
> >
> >  If I replace my wireless card with one that uses the rtl8180 driver, the
> >  network connection seems to be reliable regardless of how I set the
> >  parameter, although I admit that i have not tested this extensively yet.
> > I'll do that now and report later.
>

I've rerun my tests with the rtl8180 driver and found the network to be 
reliable with the mac82011 module's ieee80211_default_rc_algo parameter set 
to either 'simple' or 'pid'. 

> I'm about to send 4 patches to this (linux-wireless) list with patches
> for rt2x00,
> most of them you already tested individually, but several people reported
> success after those patches.
>
> Hopefully it will be working for you as well. :)
>

Sorry, but that's not the case. I find the same results as without the 
patches. With the parameter set to 'pid', the network connection fails very 
quickly, but with it set to 'simple' I can ping and ftp files to and from my 
laptop as much as I like and the connection stays up. In fact, if anything 
the patches seem to have made the network even more fragile, in that it fails 
almost instantly once I start some network activity ( < 10 pings).

I'm sure this is not the hardware - it works perfectly with Windows XP, with 
2.6.23.14 plus the out-of-tree rt61 driver from serialmonkey, with the 
in-tree driver from 2.6.24.x and with 2.6.25-rc3 with the mac82011's 
ieee80211_default_rc_algo parameter set to 'simple'.

Like I say above, sorry!

Chris

> Ivo

-- 
Beauty is in the eye of the beerholder.
