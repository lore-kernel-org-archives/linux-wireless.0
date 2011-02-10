Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:54641 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756844Ab1BJUAe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 15:00:34 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000020458.msg
	for <linux-wireless@vger.kernel.org>; Thu, 10 Feb 2011 21:59:55 +0200
Subject: Re: SSB AI support code ([RFC] v2)
From: George Kashperko <george@znau.edu.ua>
To: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297363781.30218.37.camel@maggie>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	 <AANLkTi=v9PM8pQ8qF1XpuMSYAy4=MAO2W8TQU+a3AGQn@mail.gmail.com>
	 <1297288286.9734.28.camel@maggie>
	 <AANLkTimS7Q5Du5_r3dZbF1gfpDofjL3Vm-AdEZP=zDQd@mail.gmail.com>
	 <4D5320AA.5020405@lwfinger.net> <1297315457.12795.40.camel@dev.znau.edu.ua>
	 (sfid-20110210_063153_817778_FFFFFFFFF46A15B5)  <1297333256.30218.10.camel@maggie>
	 <1297359641.15805.38.camel@dev.znau.edu.ua>
	 (sfid-20110210_184827_887841_41FA745D)  <1297361481.30218.31.camel@maggie>
	 <1297362251.15805.51.camel@dev.znau.edu.ua>
	 (sfid-20110210_193159_907950_6C4B7BA8)  <1297363781.30218.37.camel@maggie>
Content-Type: text/plain
Date: Thu, 10 Feb 2011 21:52:36 +0200
Message-Id: <1297367556.15805.79.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arrgh.... Tired to hell but can't sleep...
So im back ! ;)

> On Thu, 2011-02-10 at 20:24 +0200, George Kashperko wrote: 
> > > code in drivers. Let's call it "hndbackplane" or something like that.
> > hndbackplane... nevah!!1 :p Since some time I started hating hnd abbreviation dunno why.
> 
> Well, it's just a name I made up right now.
> It obviously is not a good one. ;)
> It was just my way to explain the idea of a thin layer between
> SSB (or AI) and drivers. That thin layer can be a mostly-inline function
> layer with if()..else or a function table layer.
Yes, I got your idea. But to be honest the more I think about actual
implementation the more I beleive mine initial proposal is less
intrusive one but might need to be redesigned slightly to avoid
confusion with original SSB and guarantee proper support with hosted AI
later on.
Anyway as I've already said I'm going to take a break for few days to
plan things with separate bus driver. Its not like I gave up and will
start on bus code right away. Just want to see the whole picture. As
soon as I finish with my paintings and if only I see at least 1ne more
advantage for separate bus driver rather than ssb+ai driver I will start
with this way ofcourse.
But yet again not like im scared of amount of if/else stuff this will
introduce (most of it could be hidden with proper inliners anyway). Just
looks like AI bus driver is either to replicate the whole ssb_bus struct
layout or whole ssb-based code subset with device drivers as well will
be flooded with those if/else or inline ssb_gimme_bus(). Replicating (or
including in first place) the whole ssb_bus makes me think AI is much
more SSB than just AI, while all those if/else even inlined look for me
less desirable and clean than ssb_core_(ctl|state)_flags. Wrapping
required ssb codebase with some bcmai_zzz() will require ssb_bus struct
replication yet again. There might be some other way I dont see atm,
hopefully I will after get some rest.

> > Any chance someone can share alike .pdf for AI socs ?
> 
> I think that's pretty much the only one available.
> Broadcom doesn't really distribute docs on HND, but only code.
Maybe some kind Broadcom guy could comment on this ? -.-
Might not, but I was to try anyway.

> > Also would be much
> > appreciated if you could help me with finding out non-embedded bcm
> > ai-based hw part-numbers.
> 
> I have no idea. You could probably look at brcm80211 for starters?
> 
Already done with that, unfortunately PCI_VENDOR_ID_BROADCOM with
dev_ids 0x4357/0x4353/0x4727 gives me no clue if they are SB or AI
based. Must back again dig deep into bcm80211 but I'm already tired to
hell with all those sih, sii and osh stuff :/

Have nice day,
George


