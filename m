Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:52845 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab1BIVve (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 16:51:34 -0500
Subject: Re: SSB AI support code
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: George Kashperko <george@znau.edu.ua>,
	linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTi=v9PM8pQ8qF1XpuMSYAy4=MAO2W8TQU+a3AGQn@mail.gmail.com> (sfid-20110209_223540_861508_FFFFFFFF9377054D)
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	 <AANLkTi=v9PM8pQ8qF1XpuMSYAy4=MAO2W8TQU+a3AGQn@mail.gmail.com>
	 (sfid-20110209_223540_861508_FFFFFFFF9377054D)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 22:51:26 +0100
Message-ID: <1297288286.9734.28.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-09 at 22:35 +0100, Rafał Miłecki wrote: 
> What about proposed solution?

Well, I'm not going to maintain it due to a lack of devices,
knowledge of the AI and a serious lack of additional time.

However, I'm certainly OK with you adopting maintainership
if people think that the code looks sane and should be merged.

One thing I really don't like is the name-confusion introduced
by this. We will have functions with the ssb_...() prefix
that don't necessarily operate on ssb devices, but on AI devices
instead, depending on the actual magic behind the scenes.
That's one of the major things I tried hard to avoid in the
SSB design from day 0 on.
It's what I hated most about Broadcom's SB implementation (there it
is pci_...() functions, which operate on PCI, SB or whatever else
depending on some serious magic).

So my proposal doesn't change: Create two separate busses (SSB and AI)
and port the device drivers to work on both. That also implies
decoupling the built-in SSB device drivers (CC, MIPS, EXTIF, PCICORE)
from the SSB implementation.
The code duplication will negligible.

-- 
Greetings Michael.

