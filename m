Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from col0-omc2-s11.col0.hotmail.com ([65.55.34.85]:45001 "EHLO
	col0-omc2-s11.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755553AbZCPM3B convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 08:29:01 -0400
Message-ID: <COL113-W348B209977311F6BB460ADCB9B0@phx.gbl> (sfid-20090316_132906_184685_83CB7DBB)
From: Adrian Bassett <adrian.bassett@hotmail.co.uk>
To: <linux-wireless@vger.kernel.org>
Subject: rtl8180 Bit Rate regression in 2.6.29
Date: Mon, 16 Mar 2009 12:22:50 +0000
Content-Type: text/plain; charset=Windows-1252
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



(I'm not currently subscribed so please Cc: in any response ...)

Using PCI device 1799:700f and the rtl8180 kernel wireless driver.

With the vanilla 2.6.29-rc releases (rc8 most recently but also with pr=
edecessors) I've noticed that the Bit Rate of my wireless device appear=
s to be more or less fixed at 1 Mb/s.  Occasionally, iwconfig reports h=
igher values but, as the stats below show, no attempts are successful a=
t higher Bit Rates with this kernel version.

With the 2.6.28 series, however, the Bit Rate will vary in the normal w=
ay, with the majority of the network activity happening at the higher e=
nd, if not the highest(54 Mb /s) point, of the range supported by this =
device.

This is using the minstrel rate control mechanism.

2.6.29 stats:

14:44:02 up  4:10,  2 users,  load average: 0.12, 0.11, 0.06

Stats from /sys/kernel/debug/ieee80211/phy0/stations/xx:xx:xx:xx:xx:xx/=
rc_stats

rate     throughput  ewma prob   this prob  this succ/attempt   success=
    attempts
TtP  1         0.9      103.7      100.0          4(  4)      10040    =
    9806
     2         0.0        0.0        0.0          0(  0)          0    =
      46
     5.5       0.0        0.0        0.0          0(  0)          0    =
      47
    11         0.0        0.0        0.0          0(  0)          0    =
      48
     6         0.0        0.0        0.0          0(  0)          0    =
      47
     9         0.0        0.0        0.0          0(  0)          0    =
      48
    12         0.0        0.0        0.0          0(  0)          0    =
      45
    18         0.0        0.0        0.0          0(  0)          0    =
      46
    24         0.0        0.0        0.0          0(  0)          0    =
      46
    36         0.0        0.0        0.0          0(  0)          0    =
      47
    48         0.0        0.0        0.0          0(  0)          0    =
      48
    54         0.0        0.0        0.0          0(  0)          0    =
      58

Total packet count::    ideal 9399      lookaround 494



2.6.28.7 stats:

19:17:12 up  4:31,  2 users,  load average: 0.32, 0.31, 0.12

Stats from /sys/kernel/debug/ieee80211/phy0/stations/xx:xx:xx:xx:xx:xx/=
rc_stats

rate     throughput  ewma prob   this prob  this succ/attempt   success=
    attempts
  P  1         0.9       99.9      100.0          0(  0)        284    =
     284
     2         1.9       99.9      100.0          0(  0)         78    =
      78
     5.5       5.0       99.9      100.0          0(  0)        152    =
     152
    11         9.5       99.9      100.0          0(  0)         78    =
      78
     6         4.2       74.4        0.0          0(  0)         75    =
      84
     9         8.4       99.9      100.0          0(  0)         78    =
      78
    12        11.0       99.9      100.0          0(  0)         78    =
      78
    18        16.2       99.9      100.0          0(  0)         78    =
      79
    24        21.2       99.9      100.0          0(  0)         78    =
      80
T   36         7.0       99.8      100.0          0(  0)       1454    =
    1486
 t  48         5.6       74.0       44.4          4(  9)       8835    =
   10282
    54         2.5       59.6       20.0          0(  0)       6128    =
    7723

Total packet count::    ideal 6802      lookaround 357


Hope this report is useful.  If it would help I could test any patches =
that might be produced.

regards and thanks,

Adrian Bassett








_________________________________________________________________
View your Twitter and Flickr updates from one place =96 Learn more!
http://clk.atdmt.com/UKM/go/137984870/direct/01/--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
