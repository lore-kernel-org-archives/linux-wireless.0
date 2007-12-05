Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eth6155.nsw.adsl.internode.on.net ([59.167.247.10]:58212 "EHLO
	sac.g2microsystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751684AbXLEXoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 18:44:08 -0500
Message-ID: <4757336F.7050301@hotmail.com> (sfid-20071205_234412_205298_04916F1D)
Date: Thu, 06 Dec 2007 10:25:35 +1100
From: Shaddy Baddah <shaddy_baddah@hotmail.com>
MIME-Version: 1.0
To: jt@hpl.hp.com
CC: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	David Miller <davem@davemloft.net>
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
References: <4740DF47.4040206@hotmail.com> <20071119.002755.77617097.davem@davemloft.net> <1195484582.8642.18.camel@johannes.berg> <20071119180423.GA19250@bougret.hpl.hp.com> <47443035.1070702@hotmail.com> <20071121184459.GA17199@bougret.hpl.hp.com> <474F86AD.4040403@hotmail.com> <20071130202115.GA32444@bougret.hpl.hp.com> <20071204000138.GA1363@bougret.hpl.hp.com> <4756AABC.3000204@hotmail.com> <20071205215600.GA28349@bougret.hpl.hp.com>
In-Reply-To: <20071205215600.GA28349@bougret.hpl.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jean,

Jean Tourrilhes wrote:
> 	Personally, I was under the impression that in userspace libc
> trap unaligned access and make them work. I mean, this code was tested
> on other 64/32 bit platforms (PPC, AMD-64, PS3) and was working there,
> so this seems to be specific to your platform.

Sure. The platform is a Sun Ultra 10, running Debian Lenny:

Linux trad 2.6.22 #2 Fri Nov 30 13:47:43 EST 2007 sparc64 GNU/Linux

(just noticed that the clock is wrong. I'll sort that out later).

> 	In any case, I've modified my code to use a memcpy() instead
> of direct memory access. I'm not 100% sure it will fix it because many
> time memcpy() is optimised away to a direct memory access.
> 
> 	So, you'll find attached a new version of Wireless Tools. Just
> tell me if it work. You can remove the debugging output by commenting
> out the "#define DEBUG" lines (grep for it).

Yes, that has fixed it. Thank you very much.

Regards,
Shaddy

