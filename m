Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.179]:62841 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbYHQI7B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Aug 2008 04:59:01 -0400
Received: by ik-out-1112.google.com with SMTP id c28so1791930ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 17 Aug 2008 01:58:59 -0700 (PDT)
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] Fixing rt2500pci [PATCH]
Date: Sun, 17 Aug 2008 10:58:56 +0200
Cc: John Linville <linville@tuxdriver.com>, stable@kernel.org,
	linux-wireless@vger.kernel.org,
	Peter Chubb <peterc@gelato.unsw.edu.au>,
	linux-kernel@vger.kernel.org
References: <87tze8vu18.wl%peterc@chubb.wattle.id.au> <200808121201.26544.IvDoorn@gmail.com> <20080816233249.GA9714@kroah.com>
In-Reply-To: <20080816233249.GA9714@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808171058.56532.IvDoorn@gmail.com> (sfid-20080817_105912_579539_D633E971)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 17 August 2008, Greg KH wrote:
> On Tue, Aug 12, 2008 at 12:01:26PM +0200, Ivo van Doorn wrote:
> > On Thursday 31 July 2008, Peter Chubb wrote:
> > > 
> > > In kernel version 2.6.26-rc9 my wireless LAN card worked; but in the
> > > released 2.6.26, my RaLink rt2500 card wouldn't associate.
> > > 
> > > Git-bisect led me to this patch:
> > > 
> > > 	61486e0f68d1f8966c09b734566a187d42d65c54
> > > 	rt2x00: Remove ieee80211_tx_control argument from write_tx_desc()
> > > 
> > > I believe that there is a problem with that patch --- it
> > > (inadvertantly) removes an extra line of code, that used to set the
> > > DATABYTE_COUNT field.
> > >  
> > > This patch reinstates that line, and with it my card works again.
> > >  
> > > Signed-off-by: Peter Chubb <peterc@gelato.unsw.edu.au>
> > > Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
> > 
> > [stable@kernel.org added to CC]
> > 
> > The 2.6.27 version of the patch has already been pushed upstream,
> > this one is for 2.6.26-stable since this fixes a regression introduced after 2.6.25.
> 
> Are you sure?  Looking at 2.6.26, the code in that function looks like
> it is properly setting the TXD_W0_DATABYTE_COUNT, field.
> 
> If it's really a problem, can you send stable@kernel.org a patch that
> applies to 2.6.26.2?

Hmm, that is weird, that line is indeed present, which means that the
commit which was responsible for the breakage wasn't in 2.6.26.
I guess peter tested a git checkout from after 2.6.26 or something. :S

Ivo

