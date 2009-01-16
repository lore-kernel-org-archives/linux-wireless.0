Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39264 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756048AbZAPU2G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 15:28:06 -0500
Date: Fri, 16 Jan 2009 18:27:59 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Werner Almesberger <werner@openmoko.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rfkill: life after driver death
Message-ID: <20090116202759.GD5719@khazad-dum.debian.net> (sfid-20090116_212815_267817_C1F4DA2C)
References: <20090116195247.GC13290@almesberger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090116195247.GC13290@almesberger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 16 Jan 2009, Werner Almesberger wrote:
> Since rfkill is supposed to restore the previous state on resume, I
> let a platform driver "own" the rfkill device instead, with a private
> interface between the AR6k driver and this platform driver to perform
> the actual blocking/unblocking and also to tell the AR6k driver
> whether it is allowed to activate the SDIO function or not on resume.

This is the way to do it, yes.  In fact, that's how most (all?) Bluetooth
and WWAN rfkilling is done...

> Furthermore, it's not only suspend/resume that makes the driver
> disappear, but user space may also do other things that cause it to
> be removed, e.g., unbind through sysfs or module removal.

Indeed.

> My present hac^H^H^Hsolution:
> 
> This approach works quite satisfyingly, except that the private
> interface between driver and platform isn't nice. I could apply some
> window dressing to make it look a bit nicer, but I think this is
> something that would better be handled by the general rfkill
> infrastructure.
> 
> What the interface does is to track rfkill changes while the driver
> is absent, and notify the driver in a race-free way of the rfkill
> state at the time of driver initialization. The initialization of
> the driver looks as follows:

It sort of already does that.  Look at the rfkill core, it tracks the
"desired rfkill state" of each device *TYPE*, and when you register a new
rfkill switch, it calls rfkill_toggle_radio() on it to match the "desired
rfkill state" for that type.

> Proposed generalization:
> 
> Since there are plenty of other hotpluggable devices around, I think
> persistent state would generally be desirable for rfkill. Maybe
> something along the lines of allowing a driver to detach its rfkill
> device and to let a later instance to re-attach to it. Example:

You want the rfkill core to track per-device-instance rfkill states, or
would the per-type tracking it does already be enough?

But there are other questions: why?  You *NEED* somewhere to attach the
rfkill kobjects to, and that somewhere can't very well be a device that is
getting hotunplugged, as it will disappear.  So, you will need something
like the platform device you used, anyway...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
