Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52396 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbZAUPPu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 10:15:50 -0500
Date: Wed, 21 Jan 2009 10:14:35 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Glenn Burkhardt <gbburkhardt@verizon.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: poor performance with ath5k; reverting to ath_pci
Message-ID: <20090121151435.GB3643@tuxdriver.com> (sfid-20090121_161555_547699_1CF15612)
References: <200901140003.31693.gbburkhardt@verizon.net> <200901151734.46144.gbburkhardt@verizon.net> <b6c5339f0901160733u433b1154sfb8b5662c4fe991c@mail.gmail.com> <200901202238.08756.gbburkhardt@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200901202238.08756.gbburkhardt@verizon.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 20, 2009 at 10:38:08PM -0500, Glenn Burkhardt wrote:
> On Friday 16 January 2009 10:33:13 Bob Copeland wrote:
> > On Thu, Jan 15, 2009 at 5:34 PM, Glenn Burkhardt
> >
> > <gbburkhardt@verizon.net> wrote:
> > > ath5k_pci 0000:00:07.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> > > ath5k_pci 0000:00:07.0: registered as 'phy0'
> > > phy0: Selected rate control algorithm 'pid'
> >
> > Can you change the rate control algorithm to minstrel and retry?
> 
> I built a 2.6.28.1-9 kernel to get the minstrel code for ath5k.  The 
> kernel for Suse 11.1 is 2.6.27.7-9.  But that means that more could have 
> changed besides the rate control code.
> 
> It looks like minstrel and pid give about the same result, a bit worse that 
> the ath_pci driver right now.  Performance seems to vary from day to day.  
> I'll experiment some more, and switch transmission channels.  I'm not getting 
> the really poor performance with ath5k right now.
> 
> I haven't looked yet - is there a way to switch to 'pid' rate control without 
> rebuilding the kernel?

If you configure your kernel to include multiple rate control
algorithms then you can use the 'ieee80211_default_rc_algo' module
option for mac80211.  Of course, changing that only works if you
rmmod/insmod mac80211.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
