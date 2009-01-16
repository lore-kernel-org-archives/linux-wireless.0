Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57964 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756576AbZAPVuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 16:50:44 -0500
Date: Fri, 16 Jan 2009 19:50:40 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Werner Almesberger <werner@openmoko.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rfkill: life after driver death
Message-ID: <20090116215040.GF5719@khazad-dum.debian.net> (sfid-20090116_225048_786985_EAD34CAF)
References: <20090116195247.GC13290@almesberger.net> <20090116202759.GD5719@khazad-dum.debian.net> <20090116205905.GR13288@almesberger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090116205905.GR13288@almesberger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 16 Jan 2009, Werner Almesberger wrote:
> But then we're a few sysfs interfaces short. Is there any specific
> reason why there is a control for setting the global default state
> (/sys/module/rfkill/parameters) but there are no controls for:
> 
> - setting the default state by type,
> - setting the current state by type, and
> - setting the current state ?

Yeah, they are sitting in my queue, but I dislike them so much I always find
a reason not to post them and do something else in thinkpad-acpi, instead...

I will see if I can bring myself to post them during the weekend.

Anyway, right now access to those is only possible through rfkill-input and
input-events (for those types that HAVE an input event related to them...).

> > But there are other questions: why?  You *NEED* somewhere to attach the
> > rfkill kobjects to, and that somewhere can't very well be a device that is
> > getting hotunplugged, as it will disappear.  So, you will need something
> > like the platform device you used, anyway...
> 
> In my scenario, a driver calling rfkill_detach would say "I might be
> back".
> 
> But I think I like the idea of making the per-type controls more
> powerful.

Then, it is best that we stick with what already is there (the per-type
control).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
