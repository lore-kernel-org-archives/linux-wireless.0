Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from MGW2.Sony.CO.JP ([137.153.0.14]:49759 "EHLO mgw2.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbXG3MDA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2007 08:03:00 -0400
Received: from mail35.sony.co.jp (localhost [127.0.0.1])
	by mail35.sony.co.jp (R8/Sony) with ESMTP id l6UC2vuW014361
	for <linux-wireless@vger.kernel.org>; Mon, 30 Jul 2007 21:02:57 +0900 (JST)
Received: from smail1.sm.sony.co.jp (smail1.sm.sony.co.jp [43.11.253.1])
	by mail35.sony.co.jp (R8/Sony) with ESMTP id l6UC2va2014358
	for <linux-wireless@vger.kernel.org>; Mon, 30 Jul 2007 21:02:57 +0900 (JST)
Received: from imail.sm.sony.co.jp (imail.sm.sony.co.jp [43.4.141.32]) by smail1.sm.sony.co.jp (8.11.6p2/8.11.6) with ESMTP id l6UC2vQ03905 for <linux-wireless@vger.kernel.org>; Mon, 30 Jul 2007 21:02:57 +0900 (JST)
Received: from [43.4.146.40] (bluenote.sm.sony.co.jp [43.4.146.40])
	by imail.sm.sony.co.jp (8.12.11/3.7W) with ESMTP id l6UC2tCH025115
	for <linux-wireless@vger.kernel.org>; Mon, 30 Jul 2007 21:02:55 +0900 (JST)
Date: Mon, 30 Jul 2007 21:02:56 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] remove duplicated ioctl entries in compat_ioctl.c
In-Reply-To: <20070727215847.GA17991@bougret.hpl.hp.com>
References: <20070727191053.GA7572@tuxdriver.com> <20070727215847.GA17991@bougret.hpl.hp.com>
Message-Id: <20070730145358.327D.MOKUNO@sm.sony.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Hi

I'd like to talk some about the patch.


I've noticed that 32bit compiled wireless tools on 64 bit kernel (PS3 runs
with powerpc 64 kernel) sometimes did not work properly than I expected,
especially 'iwlist eth0 scanning' would show messed results.

Although I also noticed there was no problem found if I'd used 64bit
wireless tools, I thought it was good that I first investigated this
problem some before I started to work on rewriting PS3 wireless support.

After some investigation, I found there was a mistake (which I believed)
in the table for handlers to deal with 32bit ioctls.  Two handlers were
defined simultaneously for one wireless ioctl as you can see.  After
brief look into these handlers, I thought the HANDLE_IOCTL(SIOCGIWPRIV,
do_wireless_ioctl) seemed to be better.  Then I made the patch that kept
the latter (do_wireless_ioctl) and submitted it.

And after that, I noticed that at least one of the causes of this iwlist
problem was that the size and alignment of iw_point structure differed
between 32bit and 64bit.  So I sent a mail that asked how we should deal
with it.

Then I got a reply that people in this ml had already knew it and worked
around in userland applications.  So I tried to use wirelesstools 29
pre22 and found that its iwlist showed reasonable scan results and I did
no further test nor investigation.

With these experiences, I thought that wireless experts here had already
agreement that it should be fixed basically by working around in
userland apps, and that I'd just brought up the settled issue again.

Some days later, John gave me the mail that referred about my patch.  I
understood that he asked me that only the former COMPATIBLE_IOCTL one
was used, but the latter HANDLE_IOCTL never used due to the nature of
compat_sys_ioctl().  That was exactly what I'd found, so I replied yes.
I meant yes in that sense.

In second half of the mail, I understood the he asked how about keeping
used one (COMPATIBLE_IOCTL) instead of HANDLE_IOCTL one, considering
compatibilities.  As I can esteem the idea that sometimes the compatibilities
are more important than changing something and I didn't think my patch
could address all problems of the issue and I had much time to test more,
I replied with the intention that I didn't stick to the patch if all
userland application could work around perfectly.

I should search much closer whether similar argument or reports existed
before sending my patch/mail, when I think of it now.  Sorry for my not
supplying suffcient information for my patch and/or concern.

--
Masakazu MOKUNO

