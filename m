Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:45772 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbYFHUQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 16:16:14 -0400
Date: Sun, 8 Jun 2008 21:16:03 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Dan Williams <dcbw@redhat.com>, Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 01/12] rfkill: clarify meaning of rfkill states
Message-ID: <20080608201603.GA25453@srcf.ucam.org> (sfid-20080608_221617_736243_024FA366)
References: <1212611246.4018.12.camel@localhost.localdomain> <1ba2fa240806041607j10841ac0qb11fe0d0b27953d8@mail.gmail.com> <20080605003808.GA16599@khazad-dum.debian.net> <1212667955.25730.29.camel@localhost.localdomain> <20080605130323.GB3413@khazad-dum.debian.net> <1212677207.28545.56.camel@localhost.localdomain> <1212696826.13915.1256967905@webmail.messagingengine.com> <1212722763.1026.17.camel@localhost.localdomain> <1212758662.26514.5.camel@localhost.localdomain> <20080606141419.GA3444@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080606141419.GA3444@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 06, 2008 at 11:14:19AM -0300, Henrique de Moraes Holschuh wrote:

> 1. Every transmitter shall have ONE, and just ONE (not zero, not two,
> not more) rfkill class attached.  For those transmitters lacking support
> in hardware to make it block, the drivers shall quiesce them and avoid
> doing anything to cause transmissions, or even use bus tricks to power
> the device down (i.e. the driver will emulate a switch capable of doing
> the blocking).

How do we enforce this? iwl4965 provides an rfkill device, but hp-wmi 
will also provide one for the wifi. If I swap out the wireless card for 
something else, I may lose the card-specific rfkill device.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
