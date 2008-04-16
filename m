Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.226]:58178 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbYDPC1h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 22:27:37 -0400
Received: by wx-out-0506.google.com with SMTP id h31so1715713wxd.4
        for <linux-wireless@vger.kernel.org>; Tue, 15 Apr 2008 19:27:36 -0700 (PDT)
Message-ID: <48056406.2060502@gmail.com> (sfid-20080416_032830_266075_01ED93C4)
Date: Tue, 15 Apr 2008 22:27:18 -0400
From: Miles Lane <miles.lane@gmail.com>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: 2.6.25-rc9 -- bcm4306 performance is in the toilet
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have a bcm4306 card in my desktop machine.  I am running a build of 2=
=2E6.25-rc9.  I have tried fiddling with the network build options and =
no matter what I select, my network performance is absolutely terrible =
(between 0 - 24KBps).  Connections take around 10-20 seconds to establi=
sh.  I have a cable modem, and usually see nearly instantaneous connect=
ions and between 65-600KBps throughput.  I just tried downloading somet=
hing and am seeing this:  223B/s.  Everything is intermittent and and o=
ften times out.

I am attempting to collect a log for you to analyze.  However, I am run=
ning into some snags.
1)  The latest firmware, which is called for in the latest kernel code,=
 won't work with my Ubuntu 8.10 kernel (2.6.24-16-386).  I got the late=
st iw git code downloaded, but it won't build for me:

# make
 CC   interface.o
interface.c: In function =91get_if_type=92:
interface.c:50: error: =91NL80211_IFTYPE_MESH_POINT=92 undeclared (firs=
t use in this function)
interface.c:50: error: (Each undeclared identifier is reported only onc=
e
interface.c:50: error: for each function it appears in.)
interface.c: In function =91handle_interface_add=92:
interface.c:121: error: =91NL80211_ATTR_MESH_ID=92 undeclared (first us=
e in this function)
make: *** [interface.o] Error 1

I built with a bunch of network and wireless debugging options enabled =
and am seeing this is my kernel log:

[ 1959.456654] phy0: TX to low-level driver (len=3D68) FC=3D0x4108 DUR=3D=
0x00da A1=3D00:1b:2f:0e:ed:ba A2=3D00:0c:e5:53:2c:3e A3=3D00:1b:2f:0e:e=
d:ba
[ 1959.816931] phy0: TX to low-level driver (len=3D104) FC=3D0x4108 DUR=
=3D0x00da A1=3D00:1b:2f:0e:ed:ba A2=3D00:0c:e5:53:2c:3e A3=3D00:1b:2f:0=
e:ed:ba
[ 1960.485441] phy0: TX to low-level driver (len=3D68) FC=3D0x4108 DUR=3D=
0x00da A1=3D00:1b:2f:0e:ed:ba A2=3D00:0c:e5:53:2c:3e A3=3D00:1b:2f:0e:e=
d:ba
[ 1962.493413] phy0: TX to low-level driver (len=3D295) FC=3D0x4108 DUR=
=3D0x00da A1=3D00:1b:2f:0e:ed:ba A2=3D00:0c:e5:53:2c:3e A3=3D00:1b:2f:0=
e:ed:ba
[ 1962.591237] phy0: TX to low-level driver (len=3D112) FC=3D0x4108 DUR=
=3D0x00da A1=3D00:1b:2f:0e:ed:ba A2=3D00:0c:e5:53:2c:3e A3=3D00:1b:2f:0=
e:ed:ba
[ 1962.591824] phy0: TX to low-level driver (len=3D112) FC=3D0x4108 DUR=
=3D0x00da A1=3D00:1b:2f:0e:ed:ba A2=3D00:0c:e5:53:2c:3e A3=3D00:1b:2f:0=
e:ed:ba
[ 1963.590056] phy0: TX to low-level driver (len=3D51) FC=3D0x0040 DUR=3D=
0x00da A1=3D00:1b:2f:0e:ed:ba A2=3D00:0c:e5:53:2c:3e A3=3D00:1b:2f:0e:e=
d:ba
[ 1963.696498] printk: 6 messages suppressed.
[ 1963.696498] eth2: RX non-WEP frame, but expected encryption
[ 1968.081760] phy0: TX to low-level driver (len=3D285) FC=3D0x4108 DUR=
=3D0x00da A1=3D00:1b:2f:0e:ed:ba A2=3D00:0c:e5:53:2c:3e A3=3D00:1b:2f:0=
e:ed:ba
[ 1968.794538] phy0: TX to low-level driver (len=3D104) FC=3D0x4108 DUR=
=3D0x00da A1=3D00:1b:2f:0e:ed:ba A2=3D00:0c:e5:53:2c:3e A3=3D00:1b:2f:0=
e:ed:ba
[ 1969.334759] printk: 6 messages suppressed.
[ 1969.334759] eth2: RX non-WEP frame, but expected encryption
[ 1971.427823] phy0: TX to low-level driver (len=3D92) FC=3D0x4108 DUR=3D=
0x00da A1=3D00:1b:2f:0e:ed:ba A2=3D00:0c:e5:53:2c:3e A3=3D00:1b:2f:0e:e=
d:ba
[ 1977.083672] printk: 3 messages suppressed.
[ 1977.083672] eth2: RX non-WEP frame, but expected encryption
[ 1977.168797] phy0: TX to low-level driver (len=3D92) FC=3D0x4108 DUR=3D=
0x00da A1=3D00:1b:2f:0e:ed:ba A2=3D00:0c:e5:53:2c:3e A3=3D00:1b:2f:0e:e=
d:ba
[ 1977.747613] phy0: TX to low-level driver (len=3D112) FC=3D0x4108 DUR=
=3D0x00da A1=3D00:1b:2f:0e:ed:ba A2=3D00:0c:e5:53:2c:3e A3=3D00:1b:2f:0=
e:ed:ba
[ 1977.830750] phy0: TX to low-level driver (len=3D92) FC=3D0x4108 DUR=3D=
0x00da A1=3D00:1b:2f:0e:ed:ba A2=3D00:0c:e5:53:2c:3e A3=3D00:1b:2f:0e:e=
d:ba
[ 1977.830936] phy0: TX to low-level driver (len=3D92) FC=3D0x4108 DUR=3D=
0x00da A1=3D00:1b:2f:0e:ed:ba A2=3D00:0c:e5:53:2c:3e A3=3D00:1b:2f:0e:e=
d:ba
[ 1979.361252] HW CONFIG: channel=3D1 freq=3D2412 phymode=3D2
[ 1979.396044] phy0: TX to low-level driver (len=3D42) FC=3D0x0040 DUR=3D=
0x0000 A1=3Dff:ff:ff:ff:ff:ff A2=3D00:0c:e5:53:2c:3e A3=3Dff:ff:ff:ff:f=
f:ff
[ 1979.424945] HW CONFIG: channel=3D2 freq=3D2417 phymode=3D2
[ 1979.470621] phy0: TX to low-level driver (len=3D42) FC=3D0x0040 DUR=3D=
0x0000 A1=3Dff:ff:ff:ff:ff:ff A2=3D00:0c:e5:53:2c:3e A3=3Dff:ff:ff:ff:f=
f:ff
[ 1979.491637] HW CONFIG: channel=3D3 freq=3D2422 phymode=3D2
[ 1979.534201] phy0: TX to low-level driver (len=3D42) FC=3D0x0040 DUR=3D=
0x0000 A1=3Dff:ff:ff:ff:ff:ff A2=3D00:0c:e5:53:2c:3e A3=3Dff:ff:ff:ff:f=
f:ff
[ 1979.562325] HW CONFIG: channel=3D4 freq=3D2427 phymode=3D2
[ 1979.607111] phy0: TX to low-level driver (len=3D42) FC=3D0x0040 DUR=3D=
0x0000 A1=3Dff:ff:ff:ff:ff:ff A2=3D00:0c:e5:53:2c:3e A3=3Dff:ff:ff:ff:f=
f:ff
[ 1979.637328] HW CONFIG: channel=3D5 freq=3D2432 phymode=3D2
[ 1979.684702] phy0: TX to low-level driver (len=3D42) FC=3D0x0040 DUR=3D=
0x0000 A1=3Dff:ff:ff:ff:ff:ff A2=3D00:0c:e5:53:2c:3e A3=3Dff:ff:ff:ff:f=
f:ff
[ 1979.713532] HW CONFIG: channel=3D6 freq=3D2437 phymode=3D2
[ 1979.758496] phy0: TX to low-level driver (len=3D42) FC=3D0x0040 DUR=3D=
0x0000 A1=3Dff:ff:ff:ff:ff:ff A2=3D00:0c:e5:53:2c:3e A3=3Dff:ff:ff:ff:f=
f:ff
[ 1979.787576] HW CONFIG: channel=3D7 freq=3D2442 phymode=3D2
[ 1979.836341] phy0: TX to low-level driver (len=3D42) FC=3D0x0040 DUR=3D=
0x0000 A1=3Dff:ff:ff:ff:ff:ff A2=3D00:0c:e5:53:2c:3e A3=3Dff:ff:ff:ff:f=
f:ff
[ 1979.865464] HW CONFIG: channel=3D8 freq=3D2447 phymode=3D2
[ 1979.911072] phy0: TX to low-level driver (len=3D42) FC=3D0x0040 DUR=3D=
0x0000 A1=3Dff:ff:ff:ff:ff:ff A2=3D00:0c:e5:53:2c:3e A3=3Dff:ff:ff:ff:f=
f:ff
[ 1979.942569] HW CONFIG: channel=3D9 freq=3D2452 phymode=3D2
[ 1979.991364] phy0: TX to low-level driver (len=3D42) FC=3D0x0040 DUR=3D=
0x0000 A1=3Dff:ff:ff:ff:ff:ff A2=3D00:0c:e5:53:2c:3e A3=3Dff:ff:ff:ff:f=
f:ff
[ 1980.016228] HW CONFIG: channel=3D10 freq=3D2457 phymode=3D2
[ 1980.058783] phy0: TX to low-level driver (len=3D42) FC=3D0x0040 DUR=3D=
0x0000 A1=3Dff:ff:ff:ff:ff:ff A2=3D00:0c:e5:53:2c:3e A3=3Dff:ff:ff:ff:f=
f:ff
[ 1980.087823] HW CONFIG: channel=3D11 freq=3D2462 phymode=3D2
[ 1980.131718] phy0: TX to low-level driver (len=3D42) FC=3D0x0040 DUR=3D=
0x0000 A1=3Dff:ff:ff:ff:ff:ff A2=3D00:0c:e5:53:2c:3e A3=3Dff:ff:ff:ff:f=
f:ff
[ 1980.163187] HW CONFIG: channel=3D1 freq=3D2412 phymode=3D2
[ 1980.175182] phy0: TX to low-level driver (len=3D24) FC=3D0x0148 DUR=3D=
0x00da A1=3D00:1b:2f:0e:ed:ba A2=3D00:0c:e5:53:2c:3e A3=3D00:1b:2f:0e:e=
d:ba
[ 1980.838943] printk: 2 messages suppressed.
[ 1980.838943] eth2: RX non-WEP frame, but expected encryption
[ 1984.941340] printk: 3 messages suppressed.
[ 1984.941355] eth2: RX non-WEP frame, but expected encryption
[ 1986.486071] phy0: TX to low-level driver (len=3D104) FC=3D0x4108 DUR=
=3D0x00da A1=3D00:1b:2f:0e:ed:ba A2=3D00:0c:e5:53:2c:3e A3=3D00:1b:2f:0=
e:ed:ba
[ 1990.238587] printk: 7 messages suppressed.
[ 1990.238587] eth2: RX non-WEP frame, but expected encryption
[ 1994.877568] phy0: TX to low-level driver (len=3D92) FC=3D0x4108 DUR=3D=
0x00da A1=3D00:1b:2f:0e:ed:ba A2=3D00:0c:e5:53:2c:3e A3=3D00:1b:2f:0e:e=
d:ba
[ 1994.879422] phy0: TX to low-level driver (len=3D104) FC=3D0x4108 DUR=
=3D0x00da A1=3D00:1b:2f:0e:ed:ba A2=3D00:0c:e5:53:2c:3e A3=3D00:1b:2f:0=
e:ed:ba
[ 1994.881046] phy0: TX to low-level driver (len=3D92) FC=3D0x4108 DUR=3D=
0x00da A1=3D00:1b:2f:0e:ed:ba A2=3D00:0c:e5:53:2c:3e A3=3D00:1b:2f:0e:e=
d:ba
[ 1994.884351] phy0: TX to low-level driver (len=3D92) FC=3D0x4108 DUR=3D=
0x00da A1=3D00:1b:2f:0e:ed:ba A2=3D00:0c:e5:53:2c:3e A3=3D00:1b:2f:0e:e=
d:ba
[ 1995.065572] phy0: TX to low-level driver (len=3D80) FC=3D0x4108 DUR=3D=
0x00da A1=3D00:1b:2f:0e:ed:ba A2=3D00:0c:e5:53:2c:3e A3=3D00:1b:2f:0e:e=
d:ba
[ 1995.065572] phy0: TX to low-level driver (len=3D80) FC=3D0x4108 DUR=3D=
0x00da A1=3D00:1b:2f:0e:ed:ba A2=3D00:0c:e5:53:2c:3e A3=3D00:1b:2f:0e:e=
d:ba
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
