Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43392 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759787AbZE0OAW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 10:00:22 -0400
Date: Wed, 27 May 2009 11:00:21 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Will Keaney <keaneyw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v11] rfkill: rewrite
Message-ID: <20090527140020.GA14440@khazad-dum.debian.net>
References: <1242942720.4212.19.camel@johannes.local> <1243068246.4606.45.camel@johannes.local> <4A1BDE51.7020009@gmail.com> <20090526131533.GA3932@tuxdriver.com> <20090527025516.GC22235@khazad-dum.debian.net> <1243405682.26933.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1243405682.26933.0.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 27 May 2009, Johannes Berg wrote:
> On Tue, 2009-05-26 at 23:55 -0300, Henrique de Moraes Holschuh wrote:
> > As long as the missing userspace control functionality (the lack of which is
> > a _serious_ regression for platform drivers) is added before 2.6.31 ships, I
> > have no complains.
> > 
> > Userspace must be able to change the (soft) state using sysfs.  This is
> > not an optional part of rfkill :-)
> 
> I'm sorry, but you're wrong. Before I removed it, almost all drivers
> disabled that functionality. We do want to add it back, but certainly
> not with the mostly braindead interface it used to have.

Well, thinkpad-acpi has users of that functionality, and not just that, it
is in the middle of a two year effort to deprecate the thinkpad-acpi
specific driver attributes and switch to just rfkill.   This effort will be
destroyed if a kernel releases without support to writes to the "state"
attribute.

I need that userspace interface (writes to the state attribute) in place and
working.  It _is_ a big regression for thinkpad-acpi to have it return
-EOPNOTSUPP.

Also, regardless of the "claim" attribute (and the related
user_claim_unsupported nonsense), the old core would allow the user to
change the soft state using sysfs, so I really don't understand what you
mean when you say "almost all drivers disabled that functionality", you
can't disable writes to the "state" attribute in the old core from what I
can see.  Please correct me if I am wrong on this.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
