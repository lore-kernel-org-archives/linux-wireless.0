Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173009pub.verizon.net ([206.46.173.9]:35730 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782AbZAUEiT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 23:38:19 -0500
Received: from depotrd.localnet ([96.237.19.106]) by vms173009.mailsrvcs.net
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 with ESMTPA id <0KDS00AFSXVNRN92@vms173009.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Tue, 20 Jan 2009 21:33:23 -0600 (CST)
Date: Tue, 20 Jan 2009 22:38:08 -0500
From: Glenn Burkhardt <gbburkhardt@verizon.net>
Subject: Re: poor performance with ath5k; reverting to ath_pci
In-reply-to: <b6c5339f0901160733u433b1154sfb8b5662c4fe991c@mail.gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless@vger.kernel.org
Message-id: <200901202238.08756.gbburkhardt@verizon.net> (sfid-20090121_053839_776648_DA19422F)
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
References: <200901140003.31693.gbburkhardt@verizon.net>
 <200901151734.46144.gbburkhardt@verizon.net>
 <b6c5339f0901160733u433b1154sfb8b5662c4fe991c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 16 January 2009 10:33:13 Bob Copeland wrote:
> On Thu, Jan 15, 2009 at 5:34 PM, Glenn Burkhardt
>
> <gbburkhardt@verizon.net> wrote:
> > ath5k_pci 0000:00:07.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> > ath5k_pci 0000:00:07.0: registered as 'phy0'
> > phy0: Selected rate control algorithm 'pid'
>
> Can you change the rate control algorithm to minstrel and retry?

I built a 2.6.28.1-9 kernel to get the minstrel code for ath5k.  The 
kernel for Suse 11.1 is 2.6.27.7-9.  But that means that more could have 
changed besides the rate control code.

It looks like minstrel and pid give about the same result, a bit worse that 
the ath_pci driver right now.  Performance seems to vary from day to day.  
I'll experiment some more, and switch transmission channels.  I'm not getting 
the really poor performance with ath5k right now.

I haven't looked yet - is there a way to switch to 'pid' rate control without 
rebuilding the kernel?

