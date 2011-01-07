Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.3eti.com ([65.220.88.141]:32157 "EHLO webmail.3eti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757Ab1AGR6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 12:58:17 -0500
From: Chaoxing Lin <CLin@3eti.com>
To: 'Ben Greear' <greearb@candelatech.com>
CC: "'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>
Subject: RE: hostapd hangs on quit, multi-BSSID scenario
Date: Fri, 7 Jan 2011 17:58:30 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D05715D9E@RockMX01.rock.corp>
References: <BD54DDEB2546894FAB0731EA7B0EDF8D05715D85@RockMX01.rock.corp>
 <4D275236.4040202@candelatech.com>
In-Reply-To: <4D275236.4040202@candelatech.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

1. I don't know how to use GDB. Consider me entry level developer.
2. It should not be related the change I made on ath9k. The reasons are
	a. My change is simple, linux/drivers/net/wireless/ath/ath9k/ath9k.h: change ATH_BCBUF from 4 to 12
	b. Without my change, driver accepts up to 3 extra BSSID. But hostapd still hangs on quit. Hostapd quits well if there only one extra BSSID.

This problem is 100% reproducible. I guess it would be quite easy for the original hostapd developer to fix it.


-----Original Message-----
From: Ben Greear [mailto:greearb@candelatech.com] 
Sent: Friday, January 07, 2011 12:50 PM
To: Chaoxing Lin
Cc: 'linux-wireless@vger.kernel.org'
Subject: Re: hostapd hangs on quit, multi-BSSID scenario

On 01/07/2011 09:44 AM, Chaoxing Lin wrote:
> Gentlemen,
>
>   When I run hostapd with 8+1 BSSID over one radio (ath9160), it runs well. All 9 BSS accepts clients.
> But when I "Ctrl + C" or "killall hostapd", hostapd daemon can NOT gracefully shut down. It hangs forever. I have to "Ctrl + C" again. Then it quits and print message like "
>
> I am running latest (as of 01/06/2011) hostapd, latest stable kernel (2.6.37) with one number change in ath9k to allow more than 12 virtual BSS over one radio.
>
> Below is my hostapd-conf and console screenshot. If someone can fix this bug, please help.

Maybe attach gdb to hostapd and see where it hangs?

Also, what change did you make to ath9k?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

