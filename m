Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:59481 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399Ab0LAV5R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 16:57:17 -0500
Subject: Re: RFC - removal of SPROM fallback
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	=?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4CF69ED1.1070406@lwfinger.net> (sfid-20101201_201546_954964_FFFFFFFFC298F049)
References: <4CF69ED1.1070406@lwfinger.net>
	 (sfid-20101201_201546_954964_FFFFFFFFC298F049)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 22:56:59 +0100
Message-ID: <1291240619.1960.3.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-01 at 13:15 -0600, Larry Finger wrote: 
> At one time, we thought that we had found BCM43xx devices with no SPROM. In the
> one case that I remember, it was because the SPROM had been relocated.
> 
> I now have the data from John's device that needs the revision fixup and I know
> what is wrong - it is rev 2 with corrupted CRC. The defaulting to rev 1 is
> getting almost everything wrong, including MAC address and vendor. My plan is to
> write a better fixup routine.
> 
> At the moment, we have some SPROM fallback code that has not been fully
> implemented, and is probably not needed. Are there any objections to stripping
> this code out of drivers/ssb/pci.c and drivers/ssb/sprom.c?

Yes. The code is needed for bcm63xx embedded devices. The code that uses
it currently is not in mainline, though. It can be found in the OpenWRT
repositories.

But I still think that the SPROM fallback mechanism should be replaced
by a "platform data" based mechanism, or similar. Just removing it
without replacement is not an option, because bcm63xx embedded really
does not have an SPROM.

The bcm63xx was the reason the fallback mechanism was implemented in
the first place. See git logs for more details.

-- 
Greetings Michael.

