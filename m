Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:55292 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884Ab1I2V4m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 17:56:42 -0400
Date: Thu, 29 Sep 2011 18:56:36 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Andrew V. Stepanov" <stanv@altlinux.org>, davem@davemloft.net,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] rfkill: add module option to become inactive.
Message-ID: <20110929215636.GA21490@khazad-dum.debian.net> (sfid-20110929_235646_081766_9D255A7C)
References: <1317119624-2974-1-git-send-email-stanv@altlinux.org>
 <1317109617.4082.0.camel@jlt3.sipsolutions.net>
 <CAN8FffqH=x+qWnz=YJzatbW-b3aOgoivazH6Nb5SpsGt4Q6hGg@mail.gmail.com>
 <1317110884.4082.5.camel@jlt3.sipsolutions.net>
 <CAN8FffqjeurgAvVHtMExgeAyBHRWznYBz2c043jcZgOmqw6TVg@mail.gmail.com>
 <1317113699.4082.7.camel@jlt3.sipsolutions.net>
 <CAN8FffrZuGu63oL7ZL8EjjdNqBaPDU6KHuatwrbNB0SjffvaTg@mail.gmail.com>
 <1317121681.4082.8.camel@jlt3.sipsolutions.net>
 <CAN8FffrnCt6TL-dWBJtnOpk=oELRXhnU0ksHntFWfbPo5mgWaA@mail.gmail.com>
 <1317124813.4082.29.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1317124813.4082.29.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 27 Sep 2011, Johannes Berg wrote:
> > This patch give ability disable rfkill sub-system by means to pass
> > special module parameter.
> 
> Because the platform driver is doing the wrong thing.

Hmm?  Is it?

> > Example from real life. Some company want to make inactive rfkill
> > SW+HW buttons on some company notebooks.
> > For this, you advise to recompile kernel.
> 
> No, you need to fix the thinkpad driver.

Eh, I can certainly blacklist platform rfkill support for the x201i on the
grounds that it is a piece of crap, since a hardware button that does it in
software is clearly el-cheap-o land that does not belong to something that
dares call itself a ThinkPad X-series.  But I am not sure this is the best
way to go about it.  It will cause that switch to become useless, for one.

I can map it to a soft rfkill button, which seems to be more in line with
the real truth behind it.  But this is very weird, the EC used to even kick
bluetooth out of the USB bus when that switch was enabled...

dmidecode dump, please.  And I'd really appreciate a _full_ report of the
issue and behaviour of the rfkill hw button on the x201i, please send it to
ibm-acpi-devel@lists.sourceforge.net, and we can take the thread there.

I'd ask it to be done through bugzilla.kernel.org, but that's still down.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
