Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:63684 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbXJJTXU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 15:23:20 -0400
Date: Wed, 10 Oct 2007 12:21:48 -0700
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Subject: Re: wext 64-bit: network manager and wpa_supplicant
Message-ID: <20071010192148.GA13734@bougret.hpl.hp.com> (sfid-20071010_202327_708980_8FA1792A)
Reply-To: jt@hpl.hp.com
References: <1190292526.18521.52.camel@johannes.berg> <20070920165545.GA29452@bougret.hpl.hp.com> <1190307669.18521.94.camel@johannes.berg> <20070920205602.GA15373@bougret.hpl.hp.com> <1190385414.18521.148.camel@johannes.berg> <20070926235135.GA16051@bougret.hpl.hp.com> <1191921316.4013.5.camel@johannes.berg> <20071010022041.GL14401@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071010022041.GL14401@jm.kir.nu>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 09, 2007 at 07:20:41PM -0700, Jouni Malinen wrote:
> On Tue, Oct 09, 2007 at 11:15:16AM +0200, Johannes Berg wrote:
> 
> > If I were to venture a guess I'd say that Jouni would accept a (sane)
> > replacement if you were to license it under dual BSD/GPL as the rest of
> > wpa_supplicant/hostapd.
> 
> Maybe, maybe not. License is just one of the reasons (but a strong one;
> there's no way I would use GPL-only library here). The other part is in
> the likelyhood of target systems having the library available. If it is
> not expected to be available in more or less all targets, I do not
> really like to start requiring it. wpa_supplicant/hostapd are used in
> number of embedded designs and the less external libraries are required
> the better.
> 
> Unfortunately, I do not have a device that would show the 64-bit issue.
> Could you please remind me which devices are affected and how common
> they are? So far, not very many people have complained about the issues
> with wpa_supplicant on 64-bit systems.

	When I sent you the original patch for WT, I proposed you some
test vectors. I never heard back from you.

> > Could you try wpa_supplicant with kernel patch below on your 32-bit
> > machine? I think this should make the problem show up on 32-bit
> > machines. Not having a 64-bit machine needn't stop you from fixing the
> > alignment problems :) I can then verify that it works and didn't break
> > 64/64 setups if you want.
> 
> This sounds like an interesting way of resolving the lack of hardware
> part of the problem.. ;-)  If this approach is confirmed to work, I
> would be quite a bit more likely to actually find time to take a closer
> look at the problem.

	You don't really need all that complex stuff. Here are a few
test vectors for i386 (see below). You stuff that in the buffer you
got from the kernel and attempt to parse it. That's what I used to fix
the bug and it worked for me.
	Note : one of the thing to take care is to not screw up 64 bit
userspace on 64 bit kernel. That's why you should pay attention to the
way I did it in my patch.
	Note2 : both the Scanning and the Event code need to be fixed.

> Jouni Malinen                                            PGP id EFC895FA

	Have fun...

	Jean

--------------------------------------------------------------

  //static unsigned char	hack[] = { 0x19, 0x00, 0x1B, 0x8B, 0x50, 0x8A, 0x35, 0xE0, 0x09, 0x00, 0x01, 0x00, 0x50, 0x8A, 0x35, 0xF0, 0x47, 0x6F, 0x6C, 0x6F, 0x73, 0x4E, 0x65, 0x74, 0x7A };
  //static unsigned char	hack[] = { 0x18, 0x00, 0x15, 0x8B, 0x50, 0x8A, 0x35, 0xE0, 0x00, 0x01, 0x00, 0xC0, 0x02, 0xE1, 0xB8, 0x0E, 0xC0, 0x00, 0x00, 0x00, 0x50, 0x8A, 0x35, 0xF0 };
  static unsigned char	hack[] = { 0x18, 0x00, 0x01, 0x8B, 0x50, 0x8A, 0x35, 0xE0, 0x49, 0x45, 0x45, 0x45, 0x20, 0x38, 0x30, 0x32, 0x2E, 0x31, 0x31, 0x62, 0x67, 0x00, 0x35, 0xF0 };
  //static unsigned char	hack[] = { 0x0C, 0x00, 0x07, 0x8B, 0x50, 0x8A, 0x35, 0xE0, 0x03, 0x00, 0x00, 0x00 };
  //static unsigned char	hack[] = { 0x19, 0x00, 0x1B, 0x8B, 0x00, 0x00, 0x00, 0x00, 0x09, 0x00, 0x01, 0x00, 0x50, 0x8A, 0x35, 0xF0, 0x47, 0x6F, 0x6C, 0x6F, 0x73, 0x4E, 0x65, 0x74, 0x7A };
  //static unsigned char	hack[] = { 0x10, 0x00, 0x05, 0x8B, 0x50, 0x8A, 0x35, 0xE0, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x32 };
  //static unsigned char	hack[] = { 0x10, 0x00, 0x2B, 0x8B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x67, 0x00, 0x35, 0xF0 };
  //static unsigned char	hack[] = { 0x70, 0x00, 0x21, 0x8B, 0x50, 0x8A, 0x35, 0xE0, 0x40, 0x42, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x32, 0x80, 0x84, 0x1E, 0x00, 0x00, 0x00, 0x00, 0x32, 0x60, 0xEC, 0x53, 0x00, 0x00, 0x00, 0x00, 0x32, 0x80, 0x8D, 0x5B, 0x00, 0x00, 0x00, 0x00, 0x32, 0x40, 0x54, 0x89, 0x00, 0x00, 0x00, 0x00, 0x32, 0xC0, 0xD8, 0xA7, 0x00, 0x00, 0x00, 0x00, 0x00 };
  static int	hacksize = sizeof(hack);
