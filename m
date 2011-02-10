Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:45752 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab1BJSL1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 13:11:27 -0500
Subject: Re: SSB AI support code ([RFC] v2)
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: George Kashperko <george@znau.edu.ua>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297359641.15805.38.camel@dev.znau.edu.ua> (sfid-20110210_184827_887841_41FA745D)
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	 <AANLkTi=v9PM8pQ8qF1XpuMSYAy4=MAO2W8TQU+a3AGQn@mail.gmail.com>
	 <1297288286.9734.28.camel@maggie>
	 <AANLkTimS7Q5Du5_r3dZbF1gfpDofjL3Vm-AdEZP=zDQd@mail.gmail.com>
	 <4D5320AA.5020405@lwfinger.net> <1297315457.12795.40.camel@dev.znau.edu.ua>
	 (sfid-20110210_063153_817778_FFFFFFFFF46A15B5)  <1297333256.30218.10.camel@maggie>
	 <1297359641.15805.38.camel@dev.znau.edu.ua>
	 (sfid-20110210_184827_887841_41FA745D)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 19:11:21 +0100
Message-ID: <1297361481.30218.31.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-02-10 at 19:40 +0200, George Kashperko wrote: 
> Under "plain SSB" I mean SSB AI/SB bus interconnected with

A plain SSB bus is a plain SSB bus. Not AI, not PCI-SSB. It's plain SSB.
And that's exactly the kind of horrible confusion I am trying
to avoid. It would be completely avoided if SSB and AI bus
implementations were separated. You could _still_ implement a thin
abstraction layer on top of that to avoid if(ssb) ... else ...
code in drivers. Let's call it "hndbackplane" or something like that.

void hndbackplane_device_enable(struct dev)
{
if (device_is_ssb)
ssb_device_enable()
else
ai_device_enable()
}

And I want to say it once again: The code you added does only work
on embedded. If PCI support is to be added, the PCI-host code will
have to be changed, too. (Currently it will crash with NULL pointer
derefs on the ops)

You're actually abusing the ops structure. The ops structure is meant
to abstract the SSB backplane from its host bus. It is _not_ meant
to abstract the SSB backplane itself. Your patches mix that up. It's
an abstraction layer violation, which my proposal avoids completely.

In case I didn't say it clear enough in the past: Having SSB and AI
being separate busses does _not_ mean that they cannot share some
code. So the duplication of code is not an issue.

> system without intermediate PCI/SDIO/PCMCIA/etc bus - therefore no core
> switching required and whole mmio addrspace for all the cores can be
> accessed simultaneously. At least it looks as such for me from GPL'ed
> sourcecodes from Broadcom. Unfortunately have no other better source of
> knowledge of how is it working rather than these sources

It's pretty well understood how it works. Just read the documentation.
That is the PDF I provided and the b43 documentation wiki.

-- 
Greetings Michael.

