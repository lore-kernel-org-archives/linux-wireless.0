Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 213-239-195-126.clients.your-server.de ([213.239.195.126]:57997
	"EHLO bercruz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZA0JLc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 04:11:32 -0500
Received: from [192.168.2.199] (dslb-088-074-056-210.pools.arcor-ip.net [88.74.56.210])
	by bercruz.com (Postfix) with ESMTP id 6A5591FA4044
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2009 09:51:11 +0100 (CET)
Message-ID: <497ECAFE.8030900@bercruz.com> (sfid-20090127_101138_052861_7B39BB5F)
Date: Tue, 27 Jan 2009 09:51:10 +0100
From: Thorsten Maus <maus@bercruz.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Problems with latest driver and iwl4965
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


My environment:

Ubuntu 08.10
uname -a: Linux dell5400 2.6.27-9-generic #1 SMP Thu Nov 20 21:57:00 UTC
2008 i686 GNU/Linu

wifie:
ls -la  compat-wireless-2009-01-19 -> latest driver

dmesg | grep iwl
 dmesg | grep iwl
[   12.148010] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux,
1.3.27ks
[   12.148012] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[   12.148068] iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) ->
IRQ 17
[   12.148076] iwlagn 0000:0c:00.0: setting latency timer to 64
[   12.148093] iwlagn: Detected Intel Wireless WiFi Link 5300AGN REV=0x24
[   12.177631] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
[   12.233747] iwlagn 0000:0c:00.0: PCI INT A disabled
[   12.234132] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   33.849292] iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) ->
IRQ 17
[   33.849370] iwlagn 0000:0c:00.0: restoring config space at offset 0x1
(was 0x100102, writing 0x100106)
[   33.849542] firmware: requesting iwlwifi-5000-1-lbm.ucode
[   36.301423] Registered led device: iwl-phy0:radio
[   36.302226] Registered led device: iwl-phy0:assoc
[   36.302629] Registered led device: iwl-phy0:RX
[   36.303297] Registered led device: iwl-phy0:TX


dmesg | grep Intel
 dmesg | grep Intel
[    0.342534] CPU0: Intel(R) Core(TM)2 Duo CPU     P9500  @ 2.53GHz
stepping 06
[    0.428944] CPU1: Intel(R) Core(TM)2 Duo CPU     P9500  @ 2.53GHz
stepping 06
[   10.971737] agpgart-intel 0000:00:00.0: Intel Mobile Intel? GM45
Express Chipset
[   11.686362] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low)
-> IRQ 21
[   11.686379] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   12.148010] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux,
1.3.27ks
[   12.148012] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[   12.148093] iwlagn: Detected Intel Wireless WiFi Link 5300AGN REV=0x24

lsmod | grep iwl
 lsmod | grep iwl
iwlagn                 99844  0
iwlcore                92672  1 iwlagn
rfkill                 17176  2 iwlcore
led_class              12164  1 iwlcore
lbm_cw_mac80211       210728  2 iwlagn,iwlcore
lbm_cw_cfg80211        39696  3 iwlagn,iwlcore,lbm_cw_mac80211

The problems ONLY occur on this kernel version using the latest driver
as mentioned earlier.
A former kernel (2.6.19) as well as the alternative windows installation
do not show any uncommon behavior.


Problem description:
Directly after starting the device, the internet connection is stable.
>From time to time however the connection for at least the http based
protocol as well as the protocol used for mail stops working.
None of the available log-files produce any additional output during
off-time.


A wget request like the following produces:
tmaus@dell5400:~$ wget yahoo.com
--2009-01-27 09:42:47--  http://yahoo.com/
Resolving yahoo.com... 68.180.206.184, 206.190.60.37
Connecting to yahoo.com|68.180.206.184|:80... connected.
HTTP request sent, awaiting response... 301 Moved Permanently
Location: http://www.yahoo.com/ [following]
--2009-01-27 09:42:47--  http://www.yahoo.com/
Resolving www.yahoo.com... 87.248.113.14
Connecting to www.yahoo.com|87.248.113.14|:80... connected.
HTTP request sent, awaiting response...

where at the same time a ping request produces:
tmaus@dell5400:~$ ping yahoo.com
PING yahoo.com (68.180.206.184) 56(84) bytes of data.
64 bytes from w2.rc.vip.sp1.yahoo.com (68.180.206.184): icmp_seq=1
ttl=49 time=191 ms
64 bytes from w2.rc.vip.sp1.yahoo.com (68.180.206.184): icmp_seq=2
ttl=49 time=189 ms
64 bytes from w2.rc.vip.sp1.yahoo.com (68.180.206.184): icmp_seq=3
ttl=49 time=190 ms


My instant messaging clients do work properly all the time without
exception.

>From my point of view, this must be a bug within the latest driver ...
but as my knowledge on this topic is not deep, I kindly ask you to have
a look at my mail and to respond to me ..

thanks in advance and greetings from berlin

thorsten maus

