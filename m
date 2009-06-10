Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41109 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753832AbZFJCFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 22:05:22 -0400
Date: Tue, 9 Jun 2009 23:05:22 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
Message-ID: <20090610020522.GD593@khazad-dum.debian.net>
References: <1243929706.20064.7.camel@johannes.local> <1243930703.3192.59.camel@localhost.localdomain> <20090603040315.GA10464@khazad-dum.debian.net> <1244008652.4145.7.camel@localhost.localdomain> <20090603213340.GB22809@khazad-dum.debian.net> <1244088806.4145.24.camel@localhost.localdomain> <9b2b86520906070538s7def28f0nb269914e03207228@mail.gmail.com> <1244389617.23850.102.camel@localhost.localdomain> <4A2BE520.6080207@tuffmail.co.uk> <1244392536.23850.109.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1244392536.23850.109.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 07 Jun 2009, Marcel Holtmann wrote:
> > I don't think we should expect userspace to know whether or not a device
> > has a persistent state.  Yes, it _could_ maintain whitelists, but why
> > should it have to if the driver already knows?
> 
> If you want that, then the best approach seems an extra sysfs attribute
> for this. It is not intrusive on the event API and lets udev etc. have
> these information, too.

I have no problems with either approach.  As long as the information of
which devices have restored their initial state from NVS is available to
userspace, it is enough.

Do note that this information also needs to be available for resume (state
should be checkpointed to NVS on sleep, and restored from NVS on resume.  I
believe tpacpi does this, but if it doesn't, I will fix it eventually).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
