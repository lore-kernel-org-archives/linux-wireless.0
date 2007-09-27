Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ranger.systems.pipex.net ([62.241.162.32]:53901 "EHLO
	ranger.systems.pipex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbXI0WjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 18:39:22 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Kernel BUG when using ad-hoc mode in rt2x00
Date: Thu, 27 Sep 2007 23:00:29 +0100
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net, jbenc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>
References: <200708082324.17186.linux@baker-net.org.uk> <1190754547.18521.326.camel@johannes.berg> <1190755233.18521.328.camel@johannes.berg>
In-Reply-To: <1190755233.18521.328.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200709272300.29829.linux@baker-net.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 25 September 2007 22:20, Johannes Berg wrote:
> On Tue, 2007-09-25 at 23:09 +0200, Johannes Berg wrote:
> > On Tue, 2007-08-21 at 12:34 +0200, Johannes Berg wrote:
> > > At that point, sdata->bss should point to the master device, which
> > > apparently hasn't been initialised yet. The device initialisation code
> > > is pretty black magic to me, Jiri/Michael?
> >
> > No reply. Can you try this patch?
>
> Ah, no, there's a bug in this. Try this:
> http://johannes.sipsolutions.net/patches/kernel/all/2007-09-25-21%3a19/005-
>mac80211-fix-register-netdevice-error-return-oops.patch
>

I can't currently test it the way I was testing before because rt2x00 
currently Oopses on unplug (I'll investigate that tomorrow) but it did 
occasionally crash on scanning even if the interface had been up for a long 
time before and with this patch it has survived quite a few scans.

I'll keep testing but it looks promising.

Adam Baker
