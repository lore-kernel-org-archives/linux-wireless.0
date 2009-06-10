Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:49365 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZFJHOB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 03:14:01 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Marcel Holtmann <marcel@holtmann.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090610020522.GD593@khazad-dum.debian.net>
References: <1243929706.20064.7.camel@johannes.local>
	 <1243930703.3192.59.camel@localhost.localdomain>
	 <20090603040315.GA10464@khazad-dum.debian.net>
	 <1244008652.4145.7.camel@localhost.localdomain>
	 <20090603213340.GB22809@khazad-dum.debian.net>
	 <1244088806.4145.24.camel@localhost.localdomain>
	 <9b2b86520906070538s7def28f0nb269914e03207228@mail.gmail.com>
	 <1244389617.23850.102.camel@localhost.localdomain>
	 <4A2BE520.6080207@tuffmail.co.uk>
	 <1244392536.23850.109.camel@localhost.localdomain>
	 <20090610020522.GD593@khazad-dum.debian.net>
Content-Type: text/plain
Date: Wed, 10 Jun 2009 09:13:57 +0200
Message-Id: <1244618037.3068.29.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henrique,

> > > I don't think we should expect userspace to know whether or not a device
> > > has a persistent state.  Yes, it _could_ maintain whitelists, but why
> > > should it have to if the driver already knows?
> > 
> > If you want that, then the best approach seems an extra sysfs attribute
> > for this. It is not intrusive on the event API and lets udev etc. have
> > these information, too.
> 
> I have no problems with either approach.  As long as the information of
> which devices have restored their initial state from NVS is available to
> userspace, it is enough.

just to get the semantic right here. We are not telling userspace if a
state has been restored or not. We are telling userspace that this
specific RFKILL switch is capable of storing something in a persistent
state over boot. There is a difference here.

If a RFKILL driver claims it is capable of persistent storage then it
better work or it should not claims it. Either it does it all the time
or doesn't do it at all. Otherwise we end up in policy again and that is
not the job of the kernel.

> Do note that this information also needs to be available for resume (state
> should be checkpointed to NVS on sleep, and restored from NVS on resume.  I
> believe tpacpi does this, but if it doesn't, I will fix it eventually).

Correct. That is the job of the driver. If it is broken, that needs
fixing.

Regards

Marcel


