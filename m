Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from brent.tribalogic.net ([78.86.109.144]:40578 "EHLO
	summit.brent.tribalogic.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751837Ab1EIQhQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 12:37:16 -0400
Message-ID: <4DC8169C.3020601@colin.guthr.ie> (sfid-20110509_183720_581587_775DEF7D)
Date: Mon, 09 May 2011 17:30:20 +0100
From: Colin Guthrie <gmane@colin.guthr.ie>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	platform-driver-x86@vger.kernel.org
Subject: Re: [Regression] Problem with rfkill on 2.6.38
References: <ip6j66$o5f$1@dough.gmane.org>	 (sfid-20110426_170016_050429_A6E2C01A) <1304930195.3475.17.camel@jlt3.sipsolutions.net>
In-Reply-To: <1304930195.3475.17.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hiya,


No worries about the late reply... was running around for the last
couple weeks at various events so haven't had a chance to test any other
suggestions yet anyway.

'Twas brillig, and Johannes Berg at 09/05/11 09:36 did gyre and gimble:
>> > [root@jimmy ~]# rmmod dell_laptop
> I'm pretty sure this one's at fault, see below.

Looking at the only commit available for this module on this cycle I see:

http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.38.y.git;a=commit;h=a3d77411e8b2ad661958c1fbee65beb476ec6d70

dell-laptop: Toggle the unsupported hardware killswitch

It is found on Dell Inspiron 1018 that the firmware reports that the
hardware killswitch is not supported. This makes the rfkill key not
functional.

This patch forces the driver to toggle the firmware rfkill status in the
case that the hardware killswitch is indicated as unsupported by the
firmware.





This looks pretty suspicious to me (from the description) and sounds
like this could be an unintended consequence of the changes here.

I'll see if reverting this one fixes the issue. Thanks for the insights!

Col


-- 

Colin Guthrie
gmane(at)colin.guthr.ie
http://colin.guthr.ie/

Day Job:
  Tribalogic Limited [http://www.tribalogic.net/]
Open Source:
  Mageia Contributor [http://www.mageia.org/]
  PulseAudio Hacker [http://www.pulseaudio.org/]
  Trac Hacker [http://trac.edgewall.org/]
