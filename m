Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bandspeed.com ([24.227.171.243]:2542 "EHLO
	mars.bandspeed.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753336AbYJIPlK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 11:41:10 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: HT capabilities IE
Date: Thu, 9 Oct 2008 10:41:04 -0500
Message-ID: <6EACAD9615B47B42A780C005414307E1014956CE@mars.bandspeed.com> (sfid-20081009_174114_846197_4BF5C52E)
In-Reply-To: <1223546085.22490.29.camel@johannes.berg>
References: <1223460098.3618.53.camel@johannes.berg> <6EACAD9615B47B42A780C005414307E1014956B2@mars.bandspeed.com> <1223546085.22490.29.camel@johannes.berg>
From: "Nils Bagge" <nbagge@bandspeed.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Right, but if you enter dynamic SM PS then it doesn't matter much
> anyway, does it? I mean, there's no protection requirement in that
> case, is there? Or am I reading it wrong? I _think_ I will handle the
> SM PS change in mac80211, but I'm not entirely sure right now.
> 
> Johannes


Well, upon a more careful reading of 11.2.3, the second paragraph would
seem to indicate that some kind of protection/wake-up is required prior
to a multi-spatial stream transmission, if the receiver is in dynamic SM
power save mode. The 'protection' frame that is received, is received by
a single RX chain. It is suggested to use an RTS/CTS. The other RX
chains are powered-on after the RTS is received. 

You could use an RTS/CTS, as suggested. I suspect there are more
efficient ways to kickoff the TXOP, and the 4th paragraph suggests that
any frame with matching RA will wake up all the RX chains for the
duration of the TXOP. That is probably the way to go, assuming you can.

If the STA is in static power save, it simply cannot receive 2+ spatial
stream MCS's, until it exits that mode.

So, I guess, yes, it does matter after all. 


Nils
