Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37319 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbZEaVTj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 17:19:39 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Dan Williams <dcbw@redhat.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	alan-jenkins@tuffmail.co.uk,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1243796628.6570.37.camel@localhost.localdomain>
References: <1243524688.10632.0.camel@johannes.local>
	 <9b2b86520905310651g41babab2hb05729b0699dd81f@mail.gmail.com>
	 <1243778069.5299.0.camel@johannes.local>
	 <1243796628.6570.37.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 31 May 2009 17:19:04 -0400
Message-Id: <1243804744.4714.23.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-05-31 at 21:03 +0200, Marcel Holtmann wrote:
> Hi Johannes,
> 
> > > How should userspace test CONFIG_RFKILL_INPUT to determine whether
> > > it's safe to start the daemon?  With the old core, debian-eeepc
> > > scripts check if the module rfkill-input exists (which should work
> > > even if it's built in).  If it exists, the scripts don't perform any
> > > rfkill actions.  (Yeah, according to the doc this is not allowed
> > > because the scripts don't use "claim", but you can see how it's
> > > useful).
> > > 
> > > The new rfkill-input isn't a module, so I'm not sure how your daemon
> > > would test for it.
> > 
> > Maybe we should add an ioctl that disables rfkill-input if present.
> 
> I am against it. Can we just add a module parameter that allows us to
> disable it. I am against cluttering a new interface with legacy stuff
> since we are removing rfkill-input and replacing it by rfkilld anyway in
> a near future (meaning when I am back from vacation).

Module parameter to what?  Module parameters are almost always the wrong
thing to do.  Or, just don't built rfkill_input it into your kernel

Dan


