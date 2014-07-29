Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.natecarlson.com ([74.117.236.15]:53027 "EHLO
	plesk.technicality.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751321AbaG2PGn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2014 11:06:43 -0400
Date: Tue, 29 Jul 2014 09:56:46 -0500 (CDT)
From: Nate Carlson <linux-wireless@natecarlson.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Borislav Boev <borislavboev@hotmail.com>
Subject: Re: Poor wifi performance on Intel 7260 Dual-Band AC Wifi card
In-Reply-To: <53D7AEF5.5040907@lwfinger.net>
Message-ID: <alpine.DEB.2.02.1407290946100.1431@admin.chi.technicality.org> (sfid-20140729_170646_576086_C84A54AE)
References: <BAY178-W38CA42DFDD4031D453FB48CFF80@phx.gbl> <53D7AEF5.5040907@lwfinger.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 29 Jul 2014, Larry Finger wrote:
> You should try the experimental firmware file from
> https://git.kernel.org/cgit/linux/kernel/git/egrumbach/linux-firmware.git/plain/iwlwifi-7260-9.ucode?h=Core6.
>
> I am currently testing it and getting throughput of 60 Mbps on the 2.4 GHz band,
> and 90 Mbps at 5 GHz.

For what it's worth - on both this experimental firmware and previous 
revisions, I can do > 200Mbps to the public internet (on my office 
internet connection), with 13 other users currently on the same AP as me 
(the APs are Cisco 3702i's managed by a Cisco 2504.) This is (obviously) 
on the 5ghz band, with VHT enabled. I've had issues with occasional 
'dropouts' with this card, where traffic will randomly stop passing and/or 
ping times will jump to > 10s; sometimes it clears up on its own, 
somethings I have to re-associate to the AP to get it to stop. I'm hoping 
the new firmware and/or the newest Cisco WLC build fixes it; testing now.

Borislav - you didn't mention what firmware revision you are running; if 
you aren't on one of the -9 builds, I'd highly recommend moving to it.

I do have the following set in 
/etc/modprobe.d/iwlwifi-disable-powersave.conf:
"options iwlwifi power_save=0 bt_coex_active=0"

Once I move to 3.16, I'll probably try turning both of those features back 
on, and see what happens.

Here's a speedtest result; I've gotten better, but this is representative 
of my average speeds:
http://www.speedtest.net/my-result/3655207245

In any case - this card _is_ capable of decent speeds for sure!

-Nate
