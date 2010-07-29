Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10439 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034Ab0G2U4k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 16:56:40 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 29 Jul 2010 13:56:40 -0700
Date: Thu, 29 Jul 2010 13:56:37 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: "Simsek, Burak" <burak.simsek@fokus.fraunhofer.de>,
	David Quan <David.Quan@Atheros.com>,
	Amod Bodas <Amod.Bodas@Atheros.com>,
	Stephen Chen <Stephen.Chen@Atheros.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH 4/5] mac80211: add WoW support
Message-ID: <20100729205637.GH4925@tux>
References: <804B13F8F3D94A4AB18B9B01ACB68FA1037B5158@EXCHSRV.fokus.fraunhofer.de>
 <20100727172020.GE8293@tux>
 <804B13F8F3D94A4AB18B9B01ACB68FA1037B526B@EXCHSRV.fokus.fraunhofer.de>
 <20100729153117.GB4925@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20100729153117.GB4925@tux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 29, 2010 at 08:31:17AM -0700, Luis Rodriguez wrote:
> On Thu, Jul 29, 2010 at 06:31:02AM -0700, Simsek, Burak wrote:
> > Hi Luis,
> > 
> > we tried your patches on the old version as described in your patch file. 
> > 
> > As you wrote the first issue was about the getting the right hardware. We
> > first wanted to use RS71-USB from ubiquity and it has AR9280. However, we
> > then realized that the implementation was for pci. We had assumed that RS71
> > would use ath9k but it used AR9170 driver. First question: do you think that
> > we can do similar patch for usb without much effort?
> 
> Well, ar9170 uses Atheros radios but uses an old Zydas MAC so the programming
> would be different and I am not sure if ar9170 ever supported WoW. Stephen
> and Christian would know best at this point, whom I have CC'd.

I checked and ar9170 does not support WoW in hardware but since the firmware is
open (GPLv2) a WoW solution might be possible through software. You'd just have
to implement it. May want to look at carl9170.

  Luis
