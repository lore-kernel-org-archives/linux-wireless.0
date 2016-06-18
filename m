Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58640 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbcFRP7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2016 11:59:49 -0400
Date: Sat, 18 Jun 2016 17:59:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
	patrikbachan@gmail.com, serge@hallyn.com,
	linux-wireless@vger.kernel.org
Subject: N900, wl1251: wifi is now slow, even with powersave off
Message-ID: <20160618155946.GA16792@amd> (sfid-20160618_180015_453046_4D7820E2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

Ping to N900:

64 bytes from maemo (10.0.0.8): icmp_seq=187 ttl=64 time=124 ms
64 bytes from maemo (10.0.0.8): icmp_seq=188 ttl=64 time=131 ms
64 bytes from maemo (10.0.0.8): icmp_seq=189 ttl=64 time=66.7 ms
^C
--- maemo ping statistics ---
189 packets transmitted, 189 received, 0% packet loss, time 188742ms
rtt min/avg/max/mdev = 4.382/101.866/453.145/42.395 ms
root@duo:/data/pavel#

Now on n900:

pavel@n900:/my/tui/ofone$ sudo iw dev wlan0 set power_save off
pavel@n900:/my/tui/ofone$

That should bring ping back to < 2 msec range, but nothing changes:

root@duo:/data/pavel# ping maemo
PING maemo (10.0.0.8) 56(84) bytes of data.
64 bytes from maemo (10.0.0.8): icmp_seq=1 ttl=64 time=78.5 ms
64 bytes from maemo (10.0.0.8): icmp_seq=2 ttl=64 time=101 ms
64 bytes from maemo (10.0.0.8): icmp_seq=3 ttl=64 time=18.2 ms
64 bytes from maemo (10.0.0.8): icmp_seq=4 ttl=64 time=37.5 ms
64 bytes from maemo (10.0.0.8): icmp_seq=5 ttl=64 time=58.2 ms
64 bytes from maemo (10.0.0.8): icmp_seq=6 ttl=64 time=77.6 ms
64 bytes from maemo (10.0.0.8): icmp_seq=7 ttl=64 time=98.3 ms
64 bytes from maemo (10.0.0.8): icmp_seq=8 ttl=64 time=118 ms
64 bytes from maemo (10.0.0.8): icmp_seq=9 ttl=64 time=35.8 ms
64 bytes from maemo (10.0.0.8): icmp_seq=10 ttl=64 time=55.7 ms
^C
--- maemo ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9034ms
rtt min/avg/max/mdev = 18.298/68.025/118.223/30.756 ms
root@duo:/data/pavel#

Any ideas what is going on there?

Best regards,
									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
