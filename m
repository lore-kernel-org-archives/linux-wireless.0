Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48519 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052AbZELR6s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 13:58:48 -0400
Subject: Re: [RFT v9] rfkill: rewrite
From: Dan Williams <dcbw@redhat.com>
To: Will Keaney <keaneyw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A09B130.9000106@gmail.com>
References: <1242030669.6930.10.camel@johannes.local>
	 <4A09B130.9000106@gmail.com>
Content-Type: text/plain
Date: Tue, 12 May 2009 13:59:39 -0400
Message-Id: <1242151180.3203.19.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-05-12 at 13:26 -0400, Will Keaney wrote:
> Johannes Berg wrote:
> > This patch completely rewrites the rfkill core to address
> > the following deficiencies:
> >
> >  * all rfkill drivers need to implement polling where necessary
> >    rather than having one central implementation
> >
> >  * updating the rfkill state cannot be done from arbitrary
> >    contexts, forcing drivers to use schedule_work and requiring
> >    lots of code
> >
> >  * rfkill drivers need to keep track of soft/hard blocked
> >    internally -- the core should do this
> >
> >  * the rfkill API has many unexpected quirks, for example being
> >    asymmetric wrt. alloc/free and register/unregister
> >
> >  * rfkill can call back into a driver from within a function the
> >    driver called -- this is prone to deadlocks and generally
> >    should be avoided
> >
> >  * rfkill-input pointlessly is a separate module
> >   
> Please leave rfkill-input available as a module, at least until the bug
> I reported in my previous e-mail 'Soft Lockup With rfkill_input and
> thinkpad_acpi' is resolved.  Otherwise it will render Thinkpads, and
> possibly other systems, unusable with rfkill enabled.

The problem gets fixed where the problem is at...  if the actual root
cause is in the rfkill rewrite, then maybe Johannes should take a look.
If the actual root cause is a bug in thinkpad-acpi, then it shouldn't
block the rfkill rewrite, but should be fixed in thinkpad-acpi.

Dan

