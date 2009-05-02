Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 42.248.sfcn.org ([160.7.248.42]:46002 "HELO mail.mypals.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753485AbZEBSSY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2009 14:18:24 -0400
From: Alf <alf@mypals.org>
To: linux-wireless@vger.kernel.org
Subject: ath5k in 2.6.29.1 won't associate with AP
Date: Sat, 2 May 2009 12:18:23 -0600
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200905021218.23747.alf@mypals.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Earlier I posted problems with the adm8211 driver detecting any wireless 
networks and associating with an AP.  I switched cards to an ath5k-based 
card and some problems improved, but the problem associating is still there.

It seems I am able to associate with an AP (not just my AP) sporadically.  
It seems that when it works, it works reliably, but that's only 10% of the 
time, if that.  I have turned on debugging on ath5 and on mac80211 but the 
debug messages don't offer anything useful.  The only thing I get is this:

May  2 12:08:20 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 1
May  2 12:08:20 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 2
May  2 12:08:20 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 3
May  2 12:08:20 wlan0: direct probe to AP 00:30:bd:60:d3:44 timed out
May  2 12:08:28 wlan0 direct probe responded
May  2 12:08:28 wlan0: authenticate with AP 00:30:bd:60:d3:44
May  2 12:08:28 wlan0: authenticate with AP 00:30:bd:60:d3:44
May  2 12:08:28 wlan0: authenticate with AP 00:30:bd:60:d3:44
May  2 12:08:28 wlan0: authentication with AP 00:30:bd:60:d3:44 timed out

I know the WEP key is fine, I know all my hardware is working properly.  
Other devices on my wireless network work well and associate without any 
troubles, probably because none of them use the ath5k driver.  Another 
interesting thing is the contents of /sys/class/net/wlan0/wireless:

beacon:0
crypt:0
fragment:0
level:0
link:0
misc:0
noise:0
nwid:0
retries:0
status:0x0

I haven't tried the wireless-testing tree because it causes problems with X 
on my system.  Even if it were to work, I don't want to go through 200 
patches to find the one that works only to find it requires another 20 just 
to apply it. :-)

I'm really anxious to get this up and running.  I'd be happy to send my 
kernel config, the output of lspci or any log in my system.  If you send me 
a patch, I'll apply it and return any information you want on it.

Google reports several people with these types of problems, but I can't find 
any solutions.  It would be great if someone with experience with that 
driver could take the lead and help me resolve it.  Again, ask anything and 
I'll do it, even using the wireless-testing tree as long as I can have a 
patch for the stable kernel.

Thanks in advance.

-- 
Alf
@
