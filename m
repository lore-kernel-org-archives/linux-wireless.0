Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:55220 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbZFAHTU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 03:19:20 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Marcel Holtmann <marcel@holtmann.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	alan-jenkins@tuffmail.co.uk,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1243804744.4714.23.camel@localhost.localdomain>
References: <1243524688.10632.0.camel@johannes.local>
	 <9b2b86520905310651g41babab2hb05729b0699dd81f@mail.gmail.com>
	 <1243778069.5299.0.camel@johannes.local>
	 <1243796628.6570.37.camel@localhost.localdomain>
	 <1243804744.4714.23.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 09:18:58 +0200
Message-Id: <1243840738.3015.7.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> > > > How should userspace test CONFIG_RFKILL_INPUT to determine whether
> > > > it's safe to start the daemon?  With the old core, debian-eeepc
> > > > scripts check if the module rfkill-input exists (which should work
> > > > even if it's built in).  If it exists, the scripts don't perform any
> > > > rfkill actions.  (Yeah, according to the doc this is not allowed
> > > > because the scripts don't use "claim", but you can see how it's
> > > > useful).
> > > > 
> > > > The new rfkill-input isn't a module, so I'm not sure how your daemon
> > > > would test for it.
> > > 
> > > Maybe we should add an ioctl that disables rfkill-input if present.
> > 
> > I am against it. Can we just add a module parameter that allows us to
> > disable it. I am against cluttering a new interface with legacy stuff
> > since we are removing rfkill-input and replacing it by rfkilld anyway in
> > a near future (meaning when I am back from vacation).
> 
> Module parameter to what?  Module parameters are almost always the wrong
> thing to do.  Or, just don't built rfkill_input it into your kernel

we will make rfkill-input go away. This is just for the interim to
detect if rfkill-input is supported by the kernel or not. And it allows
to compile it into the kernel and disable it via modprobe.conf.

Regards

Marcel


