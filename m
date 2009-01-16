Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.openmoko.org ([88.198.124.205]:48807 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764611AbZAPU7f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 15:59:35 -0500
Date: Fri, 16 Jan 2009 18:59:05 -0200
From: Werner Almesberger <werner@openmoko.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rfkill: life after driver death
Message-ID: <20090116205905.GR13288@almesberger.net> (sfid-20090116_215942_109272_52205409)
References: <20090116195247.GC13290@almesberger.net> <20090116202759.GD5719@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090116202759.GD5719@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henrique de Moraes Holschuh wrote:
> You want the rfkill core to track per-device-instance rfkill states, or
> would the per-type tracking it does already be enough?

This is a good question :-) As long as we're only concerned with making
sure no RF power goes into the air, even a global switch for all RF
devices may be sufficient.

There may also be cases where only certain bands or signal strenghts
are prohibited. E.g., BT may be tolerated while GSM isn't. The
current rfkill architecture covers this.

At the other end of the spectrum you have people who use rfkill as
a poor man's power management. These would definitely want a more
fine-grained control.

There may be more usage stories, with yet different requirements.

I think may uneasiness with the current situation comes mainly from
having an unreliable per-device rfkill control. You can switch it on
or off, but whether this setting lasts across suspend/resume depends
on the implementation. There's also a contradiction with rfkill.txt,
section 3.1, bullet 6: "During resume, rfkill will try to restore its
previous state."

But I think the per-type controls could in fact be good enough for
all practical purposes. In the worst case, a dedicated controller
could just turn everything off and activate things on a case-by-case
basis.

But then we're a few sysfs interfaces short. Is there any specific
reason why there is a control for setting the global default state
(/sys/module/rfkill/parameters) but there are no controls for:

- setting the default state by type,
- setting the current state by type, and
- setting the current state ?

> But there are other questions: why?  You *NEED* somewhere to attach the
> rfkill kobjects to, and that somewhere can't very well be a device that is
> getting hotunplugged, as it will disappear.  So, you will need something
> like the platform device you used, anyway...

In my scenario, a driver calling rfkill_detach would say "I might be
back".

But I think I like the idea of making the per-type controls more
powerful.

- Werner
