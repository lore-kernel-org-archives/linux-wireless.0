Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:60582 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752270AbZCPOkV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 10:40:21 -0400
Message-ID: <49BE64CF.8020407@lwfinger.net> (sfid-20090316_154024_719314_A3151F07)
Date: Mon, 16 Mar 2009 09:40:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Adrian Bassett <adrian.bassett@hotmail.co.uk>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8180 Bit Rate regression in 2.6.29
References: <COL113-W348B209977311F6BB460ADCB9B0@phx.gbl>
In-Reply-To: <COL113-W348B209977311F6BB460ADCB9B0@phx.gbl>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian Bassett wrote:
> 
> (I'm not currently subscribed so please Cc: in any response ...)
> 
> Using PCI device 1799:700f and the rtl8180 kernel wireless driver.
> 
> With the vanilla 2.6.29-rc releases (rc8 most recently but also with predecessors) I've noticed that the Bit Rate of my wireless device appears to be more or less fixed at 1 Mb/s.  Occasionally, iwconfig reports higher values but, as the stats below show, no attempts are successful at higher Bit Rates with this kernel version.
> 
> With the 2.6.28 series, however, the Bit Rate will vary in the normal way, with the majority of the network activity happening at the higher end, if not the highest(54 Mb /s) point, of the range supported by this device.

It would be immensely helpful if you, or someone else with this hardware and the
problem, could use git to download the mainline tree and find the bad commit
using bisection. In a review of the commit log, I found only one change in the
rtl8180 code in the 2.6.28 to 2.6.29-rcX range, and without it the rtl8180 would
not work at all. As a result, I cannot suggest a trial patch.

My system says that there are 6172 commits between 2.6.29-rc8 and 2.6.28, thus
it will take roughly 13 kernel builds to bisect the problem.

Larry
