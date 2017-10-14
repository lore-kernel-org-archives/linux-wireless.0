Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:58942 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752705AbdJNLaD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 14 Oct 2017 07:30:03 -0400
Date: Sat, 14 Oct 2017 12:29:53 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Altshul, Maxim" <maxim.altshul@ti.com>,
        "Narang, Saurabh" <saurabhnarang@ti.com>
Subject: Re: [EXTERNAL] wl1837: poor performance?
Message-ID: <20171014112953.GA17245@n2100.armlinux.org.uk> (sfid-20171014_133010_501783_1D2D0DBD)
References: <20171012230845.GA29517@n2100.armlinux.org.uk>
 <kxtrhma14knf9mq4u3dw8875.1507880614445@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <kxtrhma14knf9mq4u3dw8875.1507880614445@email.android.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 13, 2017 at 07:43:37AM +0000, Reizer, Eyal wrote:
> Sorry for top posting.
> Signal level on wlan0 seems low (-79 dbm) are you sure there are antennas
> connected?

Thanks for the reply.

In development environments, it's common to have the AP and station
nearby, which will give good signal.  Out of the development
environment, the AP and station may be separated by several 10s of ft
and objects in the way.  That's the case here, so about -80dBm is to
be expected.

As I mentioned, there's two stations each with different chipsets, both
with the same signal level being reported, both at a similar distance 
from the AP, but one performs way better than the other.  I've found
the reason for this (see below.)

I should also mention that this is installed remotely, and I'm debugging
it over the 'net, involving this very Wi-Fi connection.

The radio environment is not excessively populated - both systems are
within a tower with >2ft thick stone and lime mortar walls which radio
has difficulty penetrating, which is itself in a park with very few
other buildings around.  I'm using the 2.4G channel 8, I've seen some
other APs on channel 1 when outside but almost never inside the tower.

nmcli (used to?) occasionally reports that the wl1837 can see another
AP ("CARWIFI") on channel 1, but that's rare - I suspect it requires
someone to park their car in direct line of literal sight through a
tower window from the machine.  I suspect NM noticed that before I
configured the BSSID of the associated AP as I haven't recently
noticed NM reporting any other networks.  Could also be that non-wifi
enabled cars are parked in those spaces!

> In addition what type of module is used here?

It's a WL1837 integrated onto SolidRun's iMX6 microsom.  I'm not sure
what other information in terms of "module" you're asking for.

> Di you use the configure_device.sh scripts as documented in the
> "wlconf" manual?

No, because quite honestly the wilink tooling is something of a mess
in terms of trying to find the right tooling.  This is what I ended
up doing:

1. cloning git://github.com/TI-OpenLink/18xx-ti-utils
2. taking the wl18xx driver default configuration (from debugfs).
3. taking the ti wilink driver conf.h files.
4. massaging the conf.h files into a form that wlconf can read
5. generating a new struct.bin
6. changing:
   wl18xx.phy.number_of_assembled_ant2_4 = 0x01
   wl18xx.phy.number_of_assembled_ant5 = 0x00

since this variant of the microsom I have only populates one antenna.
(The layout allows for the design to be extended to a second antenna.)

I've since found the _right_ repository for the tooling
(git://git.ti.com/wilink8-wlan/18xx-ti-utils.git), and compared the
resulting files, and confirmed that my new struct.bin is identical to
the one in the right repository.

There are some differences between the two files (- = mine,
+ = configure_device.sh generated):

-core.sg.params = 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x000000aa, 0x00000032, 0x00000000, 0x00000000, 0x00000000, 0x000000c8, 0x00000000, 0x00000000, 0x00000000, 0x00000001, 0x00000000, 0x0000003c, 0x00000000, 0x000004b0, 0x00000000, 0x00000001, 0x00000003, 0x00000006, 0x00000000, 0x00000000, 0x00000002, 0x00000000, 0x00000000, 0x00000003, 0x00000000, 0x00000002, 0x0000001e, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
+core.sg.params = 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x0000000f, 0x0000001b, 0x00000011, 0x000000aa, 0x00000032, 0x00000064, 0x00000320, 0x000000c8, 0x000000c8, 0x00000000, 0x00000000, 0x00000000, 0x00000001, 0x00000000, 0x0000003c, 0x00001388, 0x000004b0, 0x000003e8, 0x00000001, 0x00000003, 0x00000006, 0x0000000a, 0x0000000a, 0x00000002, 0x00000005, 0x0000001e, 0x00000003, 0x0000000a, 0x00000002, 0x00000000, 0x00000019, 0x00000019, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
-core.conn.dynamic_ps_timeout = 0x05dc
+core.conn.dynamic_ps_timeout = 0x0096
-core.sched_scan.num_short_intervals = 0x0e
+core.sched_scan.num_short_intervals = 0x0d
-core.fwlog.mem_blocks = 0x00
+core.fwlog.mem_blocks = 0x02
-wl18xx.ap_sleep.max_stations_thresh = 0x00
-wl18xx.ap_sleep.idle_conn_thresh = 0x00
+wl18xx.ap_sleep.max_stations_thresh = 0x04
+wl18xx.ap_sleep.idle_conn_thresh = 0x08

The core.sg.param differences in an easier to read format are:
     mine      configure_device.sh
[23] 0x00000000 => 0x0000000f   WL18XX_CONF_SG_PARAM_23
[24] 0x00000000 => 0x0000001b   WL18XX_CONF_SG_PARAM_24
[25] 0x00000000 => 0x00000011   WL18XX_CONF_SG_PARAM_25
[28] 0x00000000 => 0x00000064   WL18XX_CONF_SG_PARAM_28
[29] 0x00000000 => 0x00000320   WL18XX_CONF_SG_PARAM_29
[30] 0x00000000 => 0x000000c8   WL18XX_CONF_SG_PARAM_30
[38] 0x00000000 => 0x00001388   WL18XX_CONF_SG_PARAM_38
[40] 0x00000000 => 0x000003e8   WL18XX_CONF_SG_UNUSED
[44] 0x00000000 => 0x0000000a   WL18XX_CONF_SG_PARAM_44
[45] 0x00000000 => 0x0000000a   WL18XX_CONF_SG_PARAM_45
[47] 0x00000000 => 0x00000005   WL18XX_CONF_SG_GEMINI_PARAM_47
[48] 0x00000000 => 0x0000001e   WL18XX_CONF_SG_STA_CONNECTION_PROTECTION_TIME
[50] 0x00000000 => 0x0000000a   WL18XX_CONF_SG_PARAM_50
[52] 0x0000001e => 0x00000000   WL18XX_CONF_SG_AP_CONNECTION_PROTECTION_TIME
[53] 0x00000000 => 0x00000019   WL18XX_CONF_SG_PARAM_53
[54] 0x00000000 => 0x00000019   WL18XX_CONF_SG_PARAM_54

In any case, I eventually tracked down the reason for the 10ms pings - it
seems the iMX6 host SDHCI aggressively enters PM, with the autosuspend
delay is set to 50ms.  Disabling runtime PM on the host results in ping
times around what I would expect - between 2 to 4ms.

> In addition, for the recovery. Are you using latest firmware (8.9.0.0.70)?

I'm using 8.9.0.0.75, which seems to be the latest as of 19th June,
which came from https://git.ti.com/wilink8-wlan/wl18xx_fw

The recovery doesn't seem to be a regular thing - I've only seen it
once so far, and it was non-fatal.


However, I have one lingering difference between the wl1837 and rtl8192eu
stations.  If I set both up identically - with a BSS MAC address, thus
telling them that they should only associate with an AP with that MAC,
I find that rtl8192eu doesn't go off-channel to scan for APs, and has
pretty a stable ping RTT.

However, the wl1837 seems to end up with a ping RTT of about 110ms every
32s or so.  I tried increasing "core.sched_scan.long_interval" in the
conf file to 40000, and this seemed to increase this to about once every
50s.

I've tried disabling the scheduled scan code in the wl18xx driver, but
that doesn't seem to have made a difference.  I've also tried telling
wpa_supplicant not to scan (wpa_cli set pon) but that also doesn't seem
to make a difference.  I don't think it's NetworkManager triggering the
scans, as both the wl1837 and rtl8192eu are setup identically, and
stracing NM only shows it polling for the signal level/bit rate etc -
and from what I read, configuring the connection with a BSSID stops
NM scanning for roaming.

It doesn't seem to be causing a problem, but it would be nice to get
rid of the additional latency if possible.  Obviously, it does need
to scan initially, so NM/wpa_supplicant can associate with the AP.

With "core.sched_scan.long_interval" set back to 30000, and the
scheduled scan code in the wl18xx driver disabled, I'm seeing:

64 bytes from 192.168.250.1: icmp_seq=25 ttl=64 time=2.68 ms
64 bytes from 192.168.250.1: icmp_seq=26 ttl=64 time=114 ms
64 bytes from 192.168.250.1: icmp_seq=27 ttl=64 time=3.58 ms
...
64 bytes from 192.168.250.1: icmp_seq=65 ttl=64 time=2.58 ms
64 bytes from 192.168.250.1: icmp_seq=66 ttl=64 time=107 ms
64 bytes from 192.168.250.1: icmp_seq=67 ttl=64 time=2.71 ms
...
64 bytes from 192.168.250.1: icmp_seq=105 ttl=64 time=3.04 ms
64 bytes from 192.168.250.1: icmp_seq=106 ttl=64 time=110 ms
64 bytes from 192.168.250.1: icmp_seq=107 ttl=64 time=3.42 ms
...
64 bytes from 192.168.250.1: icmp_seq=145 ttl=64 time=3.18 ms
64 bytes from 192.168.250.1: icmp_seq=146 ttl=64 time=109 ms
64 bytes from 192.168.250.1: icmp_seq=147 ttl=64 time=3.27 ms

Any ideas?

Thanks.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
