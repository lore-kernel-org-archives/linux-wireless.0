Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:59024 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757969Ab0EVTNv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 May 2010 15:13:51 -0400
Message-ID: <4BF82CEE.8020502@dlasys.net>
Date: Sat, 22 May 2010 15:13:50 -0400
From: "David H. Lynch Jr." <dhlii@dlasys.net>
Reply-To: dhlii@dlasys.net
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: carl9170 1.0.9
References: <4BDC001F.9050202@dlasys.net> <4BDD2E05.40203@free.fr> <4BDD5EB3.7020802@dlasys.net> <201005021452.01101.chunkeey@googlemail.com>
In-Reply-To: <201005021452.01101.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	
some items I have found while making my changes to the code.


	In firmware_source/carlfw/src/wlan.c you have aloop to read the TSF 
timer to make sure there is no roll over. According to the docs I have 
when TSF_LOW is read, TSF_HI is automatically concurrently copied to a 
temp register so that an immediate read of TSF_HI will get the value 
that was present when TSF_LO was read.

	Presuming the docs are correct - and this feature is common in 
multi-word timers you should be able to save some code.
	Also with some complex casting or another pointer you can read directly 
to your destination and save a memcpy()

	I beleive the timer_init() routine in carlfw/src/timer.c can not be 
called for more than one timer. Any subsequent call will clear the 
interrupt and mode bits for the previous timer.

	I have not completely tracked these down, but the new config system 
must be missing some dependencies, because I can configure and build 
firmware that will not load.
	In carlfw/src/cmd.c the CARL9170_CMD_PSM case needs ifdef'd with 
CONFIG_CARL9170FW_PSM or it will not build with PSM disabled.



-- 
Dave Lynch 					  	    DLA Systems
Software Development:  				         Embedded Linux
717.587.7774 	       dhlii@dlasys.net 	  http://www.dlasys.net
Over 25 years' experience in platforms, languages, and technologies 
toonumerous to list.

"Any intelligent fool can make things bigger and more complex... It 
takes a touch of genius - and a lot of courage to move in the opposite 
direction."
Albert Einstein

