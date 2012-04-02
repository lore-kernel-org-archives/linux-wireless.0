Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.watchguard.com ([206.191.171.101]:21935 "EHLO
	watchguard.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750992Ab2DBV6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 17:58:17 -0400
From: Bryan Phillippe <Bryan.Phillippe@watchguard.com>
To: Ben Greear <greearb@candelatech.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: bss_info_change_notify warning (hacked 3.3.0-rc5+)
Date: Mon, 2 Apr 2012 21:58:16 +0000
Message-ID: <82DC76E2-7235-4EF5-BB23-CDFC4B61CBA8@watchguard.com> (sfid-20120402_235821_002212_42290C6E)
References: <4F57B7E6.1050103@candelatech.com>
 <D6CE340A-7CE4-42DA-B1C3-4137C1D13BFF@watchguard.com>
 <4F735EF5.3010708@candelatech.com>
In-Reply-To: <4F735EF5.3010708@candelatech.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mar 28, 2012, at 11:56 AM, Ben Greear wrote:

> On 03/07/2012 11:45 AM, Bryan Phillippe wrote:
>> 
>> Yes, it's a known problem.  It's very reproducible for me on a non-hacked 3.3-rc1 as well: changing from AP to client mode, or setting up multiple APs, or changing from 2.4Ghz to 5Ghz all seem to trigger this warning with various stack traces.
> 
> I'm still seeing this and related warnings on 3.3.0.  At least some
> of them comes from calls the 'hostapd' process makes (I printed
> current->comm in the warning).
> 
> I am not having luck writing a simple script that reproduce this,
> but my application that creates a VAP and bunch of virtual station
> hits it every time on startup.
> 
> Bryan:  Do you have a simple script that reproduces this problem?

Hi Ben.  I apologize for the delay in responding; I was out of town
for a week.  No, I do not.  Which is frustrating, because it was
happening pretty reliably for me before, but it's much more
difficult to force to happen now.  In the past, it was switching
back and forth between AP and client mode (kill hostapd, start
wpa_supplicant, for example).  Or restarting hostapd frequently
in different radio modes.

> Johannes:  Any ideas on likely causes of this problem?  Might help
> me zero in on the problem quicker...

If I've been following the thread accurately, it looks like some
headway has been made on this and some fixes checked in?  I'd like
to retest, if that is the case.  I'm using compat-wireless trees
downloaded as tarballs - do you have a version you recommend I test
with?

Thanks,
--
-bp


