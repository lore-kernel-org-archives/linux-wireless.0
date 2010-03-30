Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:33398 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab0C3Rdt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 13:33:49 -0400
Received: by fg-out-1718.google.com with SMTP id l26so3637045fgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 10:33:48 -0700 (PDT)
Message-ID: <4bb235fb.0baa660a.5b56.ffffa9c2@mx.google.com>
Date: Tue, 30 Mar 2010 10:33:47 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: Another AR5008 hang
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ath9k@lists.ath9k.org
In-Reply-To: <4bb1f940.47c2f10a.3469.609b@mx.google.com>
References: <4bb0e2da.04c2f10a.32b2.11ae@mx.google.com>
	<1269928986.3927.5.camel@jlt3.sipsolutions.net>
	<4bb1f940.47c2f10a.3469.609b@mx.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 30 Mar 2010 06:14:40 -0700 (PDT), Ben Gamari <bgamari.foss@gmail.com> wrote:
> On Tue, 30 Mar 2010 08:03:06 +0200, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Mon, 2010-03-29 at 10:26 -0700, Ben Gamari wrote:
> > > New (2.6.33 and greater) kernels seem to result in a selective hang on my
> > > machine directly only seconds after association with an 802.11N access point
> > > (hosted with hostapd and another ar5008). I've included dmesg output for a
> > > failure event, including back traces of hung processes. What ath9k.debug flags
> > > would be most helpful for tracing this further?
> > 
> > None, I would think, this seems to be a lockup between
> > modprobe/stop_machine and some rtnl things, but I have no idea why that
> > would happen. Do you have lockdep enabled? And if you do, please disable
> > RCU lockdep as it typically gives you a warning and then turns off
> > lockdep...
> > 
> Thank you very much for your response. I do not currently have lockdep enabled,
> but I'm building a new kernel as we speak. Thanks again,
> 
Well, it will take me a bit longer than expected to get lockdep results on
2.6.34 due to a recent change[1] in how sysfs attributes are exposed to
lockdep. Hopefully this will be fixed soon.

That being said, after discovering this I went back and recompiled with
lockdep. Unfortunately, I'm now having trouble reproducing the issue on this
release. I still can with 2.6.34-rc1 though, so, again, hopefully soon I'll be
able to say where the deadlock occurs. I'll let you know as soon as I have
news. Thanks for your help,

- Ben

[1] http://lkml.org/lkml/2010/3/8/365
