Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41236 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753595AbYFLSDM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 14:03:12 -0400
Message-Id: <1213293791.31864.1258155401@webmail.messagingengine.com> (sfid-20080612_200316_062048_5221417D)
From: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: "Matthew Garrett" <mjg@redhat.com>,
	"Dan Williams" <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, "Dmitry Torokhov" <dtor@mail.ru>
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
References: <1ba2fa240806041607j10841ac0qb11fe0d0b27953d8@mail.gmail.com>
 <1212667955.25730.29.camel@localhost.localdomain>
 <20080605130323.GB3413@khazad-dum.debian.net>
 <1212677207.28545.56.camel@localhost.localdomain>
 <1212696826.13915.1256967905@webmail.messagingengine.com>
 <1212722763.1026.17.camel@localhost.localdomain>
 <1212758662.26514.5.camel@localhost.localdomain>
 <20080606141419.GA3444@khazad-dum.debian.net>
 <20080608201603.GA25453@srcf.ucam.org>
 <20080610041136.GA20310@khazad-dum.debian.net>
 <1ba2fa240806111010r54772177r9b274590f8fa89d8@mail.gmail.com>
Subject: Re: [PATCH 01/12] rfkill: clarify meaning of rfkill states
In-Reply-To: <1ba2fa240806111010r54772177r9b274590f8fa89d8@mail.gmail.com>
Date: Thu, 12 Jun 2008 15:03:11 -0300
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 11 Jun 2008 20:10:53 +0300, "Tomas Winkler" <tomasw@gmail.com> said:
> Not that I cannot read the code, but what this rkill class actually
> should do according your vision?

It is not a vision.  I am working with what we currently have, and fixing it.
It looks like a bit more than a simple code fix, because of the extremely
sorry state the documentation for rfkill was (i.e. it was on par with what
we have for most of the stuff in the kernel), and the fact that almost nobody
really knew how to use rfkill properly given its current limitations
(especially the ones existing before my patchset), so you couldn't even find
good examples to follow.

And there is a lesson here: NOTHING that involves the input layer should
ever be merged without a damn complete usage guide to go with it :-)

There is no re-designing going on.  That could be done later, I suppose,
but it is not what I am doing.  At most, I am adding a feature here or there.
The documentation effort is bringing to light a lot of misconceptions about
rfkill and how to use it (and also a lot of its current limitations), and
I will address some of these limitations since I am already knee-deep into
rfkill right now anyway.

> Does it implement radio-state state machine....notification hub for
> rfkill switches ...

rfkill class: Interface between softswitch and wireless device drivers with
the rfkill subsystem.  This INCLUDES sysfs and uevents, so it also includes
part of the rfkill subsystem interface to userspace.

But the rfkill class it is NOT the whole rfkill subsystem, at all.  It is only
ONE of the interfaces to the rfkill subsystem.  There are at least two others:
whatever is provided by rfkill-input (which includes processing of input layer
events), and whatever is provided by rfkill.h that you can call directly.

So, let me repeat it: the rfkill class is just a SUBSET of the rfkill subsystem.

> > An example:
> >
> > ipw4965 probably has two rfkill controls in itself (an input pin for a
> > hardkill line, and an R/W IO register to help its driver (ilw4965) implement
> > a rfkill softswitch).  Those TWO rfkill inputs are to be combined into just
> > ONE rfkill class which will be attached to the Linux device provided by
> > ilw4965.  This is the end of the story from the PoC of the ilw4965 module.
> 
> iwl4965 has actually one more rf kill switch. It switches itself off
> if it goes over critical temperature.
> For NIC it looks like temporal rfkill.

We would just consider that something that looks like another hardkill input line,
and be done with it.  When you synthesize the rfkill state for ipw4965, you'd use
its thermal shutdown status, its hw-rfkill-line input pin status, and its
softswitch status (the only one you can control).  Everything outside of iwl4965
would still just see a single rfkill status, it doesn't matter how many internal
components contributed to that status.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

