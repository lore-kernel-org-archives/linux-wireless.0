Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s37.bay0.hotmail.com ([65.54.246.237]:62155 "EHLO
	bay0-omc3-s37.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763540AbYCTBLC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 21:11:02 -0400
Message-ID: <BAY101-W2F265A1ACEEAD6E11D953C8000@phx.gbl> (sfid-20080320_011109_826246_EC8219A9)
From: Adam Turk <bofh1234@hotmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: 2.6.25-rc6, rausb0 or wlan0 or both???
Date: Wed, 19 Mar 2008 21:11:01 -0400
Content-Type: text/plain; charset=iso-8859-1
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello,

I am trying to teach my students why WEP is not to be used any more.  U=
sing the BackTrack 3 beta, a 2.6.22 kernel, and a non mainline driver f=
or my ralink wireless card everything worked great.  When my wireless c=
ard was supported in mainline 2.6.24 I gave it a try and found support =
was pretty bad, but the authors knew it and were working on it.  I am n=
ow trying 2.6.25-rc6 to see if thing improved and I am sorry to say the=
y haven't.  I use the following commands (these commands work in 2.6.22=
) to get things started:
# airmon-ng stop rausb0
# ifconfig rausb0 down
# macchanger --mac 00:11:22:33:44:55 rausb0
# airmon-ng start rausb0
# aireplay-ng -9 rausb0

In 2.6.25-rc6 the name changed to wlan0 and I do:
# airmon-ng stop wlan0
# ifconfig wlan0 down
# macchanger --mac 00:11:22:33:44:55 wlan0
# airmon-ng start wlan0

When I do the airmon-ng start wlan0 I get the following error message:
Interface       Chipset         Driver
wlan0           Ralink 2573 USB rt73usb - [phy0]

ERROR: Neither the sysfs interface links nor the iw command is availabl=
e.
Please download and install iw from http://git.sipsolutions.net/iw.git

If I do a airmon-ng start rausb0 I don't get the error, but the packet =
injection test doesn't succeed.  I am using aircrack beta 2 version 100=
7

Can this please get fixed for 2.6.25?

Thanks,

_________________________________________________________________
Need to know the score, the latest news, or you need your Hotmail=AE-ge=
t your "fix".
http://www.msnmobilefix.com/Default.aspx--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
