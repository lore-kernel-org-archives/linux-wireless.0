Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50303 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab2DWGr5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 02:47:57 -0400
Message-ID: <1335163675.3928.1.camel@jlt3.sipsolutions.net> (sfid-20120423_084800_522009_51247678)
Subject: Re: carl9170 - monitor mode TP drop
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 23 Apr 2012 08:47:55 +0200
In-Reply-To: <CAFED-jkFtT2agUpymwWN-srTVH+wkh7bbkgkxQg9e4vy+q-Xvw@mail.gmail.com> (sfid-20120423_062709_111941_72F1C6FE)
References: <CAFED-j=fZjXVhLKe=eOHM-rhR7g1ZvHeSMm1jUA0bdJbk4_qWQ@mail.gmail.com>
	 <201204201959.56495.chunkeey@googlemail.com>
	 <CAFED-jkFtT2agUpymwWN-srTVH+wkh7bbkgkxQg9e4vy+q-Xvw@mail.gmail.com>
	 (sfid-20120423_062709_111941_72F1C6FE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-04-23 at 06:27 +0200, Janusz Dziedzic wrote:

> This is a scenario:
> AP <--> STA1 (channel 6)
> STA2 == carl_monitor (channel 6)
> 
> This is what I can see on STA1:
> # iperf -c 192.168.254.1 -t 100 -i 5
> ------------------------------------------------------------
> Client connecting to 192.168.254.1, TCP port 5001
> TCP window size:  512 KByte (default)
> ------------------------------------------------------------
> [  3] local 192.168.254.181 port 46048 connected with 192.168.254.1 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0- 5.0 sec  17.4 MBytes  29.2 Mbits/sec
> [  3]  5.0-10.0 sec  19.6 MBytes  32.9 Mbits/sec
> [  3] 10.0-15.0 sec  20.4 MBytes  34.2 Mbits/sec
> [  3] 15.0-20.0 sec  19.8 MBytes  33.1 Mbits/sec
> [  3] 20.0-25.0 sec  19.8 MBytes  33.1 Mbits/sec
> [  3] 25.0-30.0 sec  19.8 MBytes  33.1 Mbits/sec
> [  3] 30.0-35.0 sec  19.6 MBytes  32.9 Mbits/sec
> [  3] 35.0-40.0 sec  18.1 MBytes  30.4 Mbits/sec
> 
> =====> here I setup carl monitor on second PC, like this:
> =====> iw dev wlan0 set type monitor
> =====> iw dev wlan0 set freq 2437
> =====> ifconfig wlan0 up
> 
> [  3] 40.0-45.0 sec  2.38 MBytes  3.98 Mbits/sec
> [  3] 45.0-50.0 sec  2.50 MBytes  4.19 Mbits/sec
> [  3] 50.0-55.0 sec  3.00 MBytes  5.03 Mbits/sec
> 
> Seems I don't even need to start wireshark here ... and see this TP drop.

FWIW, I have observed this as well (in the past, my ar9170 devices all
died now)

johannes

