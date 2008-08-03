Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52933 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017AbYHCD4H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 23:56:07 -0400
Date: Sun, 3 Aug 2008 00:55:59 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
Message-ID: <20080803035559.GB6053@khazad-dum.debian.net> (sfid-20080803_055611_001663_ED868DCF)
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <1217700664-20792-9-git-send-email-hmh@hmh.eng.br> <1217703723.8621.50.camel@johannes.berg> <20080802192704.GB24253@khazad-dum.debian.net> <1ba2fa240808021421h421fc362ib92660f7be4727f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240808021421h421fc362ib92660f7be4727f8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 03 Aug 2008, Tomas Winkler wrote:
> >> why does it interfere with suspend anyway?
> >
> > The class makes sure that all transmitters are blocked on suspend.  You'd
> > have to ask Ivo for the reason, but AFAIK, it is for both safety and to help
> > conserve power.
> 
> This one is also on my list to remove. Suspend/Hibernate Resume
> definitelly doesn't mean to rfkill radio on and off.. Driver should

I *certainly* don't want the chip active during S3 or S4 unless I want WoWL
active, so I do agree that just killing the radio is not enough.

> This only creates conflicts as both driver and rfkill system are
> trying to bring radio down

No conflicts.  The wireless driver gets the request to shut the radio down
BEFORE its suspend method is called (the class suspends first).  It will
also get the request to enable/disable (whatever state it was in before the
suspend) the radio AFTER its resume method is called (the class resumes
after).

> RFKILL  IMHO shell track rfkill switches states and not to invent

RFKILL is not about tracking, it is about *controlling*.

> them. If the radio was SW switched  off before NIC was suspend it
> shell be switched off also in resume. That's should be role of rfkill
> system, probably with some help from user space.

Without the patch, rfkill always disables radios on suspend.  If they were
enabled before the suspend, it will try to enable them on resume.  If they
were disabled before the suspend, it will try to disable them on resume.

That's well part of rfkill's role.  It might not be *needed* at all though,
and if it is not, it is best to stop doing it.  If it is needed just in a
few situations, we need to make it configurable (that's what my patch does).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
