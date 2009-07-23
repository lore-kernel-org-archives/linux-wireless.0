Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:47641 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661AbZGWV1h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 17:27:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: Generic events for wake up from S1-S4
Date: Thu, 23 Jul 2009 23:27:59 +0200
Cc: Pavel Machek <pavel@ucw.cz>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-kernel@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Stephen Chen <Stephen.Chen@atheros.com>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	pm list <linux-pm@lists.linux-foundation.org>
References: <43e72e890907150851m69cd2de6lfb71596fbfac30e6@mail.gmail.com> <20090723195114.GR28158@elf.ucw.cz> <20090723201050.GD19369@khazad-dum.debian.net>
In-Reply-To: <20090723201050.GD19369@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907232328.03566.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 23 July 2009, Henrique de Moraes Holschuh wrote:
> On Thu, 23 Jul 2009, Pavel Machek wrote:
> > On Thu 2009-07-23 16:45:22, Henrique de Moraes Holschuh wrote:
> > > On Thu, 23 Jul 2009, Pavel Machek wrote:
> > > > > > Note that the "why" is unreliable by design. Network driver will
> > > > > > ignore WoL during run-time, right?
> > > > > 
> > > > > "Why" is unrealible?  I don't follow your reasoning.  It should be as
> > > > > reliable as "who"...
> > > > 
> > > > See above. The wakeup events race with each other.
> > > 
> > > We deliver them all.  It is that simple.  The rest is up to userspace.
> > 
> > Ok, but then we should not be talking about wake up events,
> > but... events.
> > 
> > Like "lid opened", "wake packet came", ... . And deliver them even
> > when they happen during run-time. That's okay with me.
> 
> Well, we *already* deliver "lid opened" when the lid is opened, regardless
> of it waking up the computer or not.  But we are missing a way to deliver
> other classes of wakeup events.
> 
> I know of at least these (incomplete list):
> 
> 1. network-initiated wakeup
>    a. wired
>    b. wireless
>    c. long-range wireless
> 
> 2. platform health/condition alarms
>    a. battery alarm (two levels, warning and emergency)
>    b. thermal alarm (two levels, warning and emergency)
>    (we need these as generic alarms, not just reason-for-wakeup)
> 
> 3. device (or device tree) hotplug/hotunplug
>    a. hotunplug request or notification
>       (we deliver the request/notification, but we don't know we should
>       go back to sleep, so all we are missing is the reason-for-wakeup
>       event)
> 
> 4. management
>    a. wake-up/power on clock
>    b. remote management command (IMPI, etc)
>    c. intrusion alarm
>    d. theft alarm
> 
> None of those have a standard interface to notify userspace of the reason of
> the wake up AFAIK.  Many of these want a generic event interface to be
> delivered not just as reason-for-wakeup, but also as runtime events.
> 
> And I guess we should also tell userspace what state we are waking up from
> (S5 clean state, S5/S4 hibernation, S3), sometimes it matters.

Agreed, and same for the above.

So, what in your opinion would be the best way to expose this information?

Rafael
