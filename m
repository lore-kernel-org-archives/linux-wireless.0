Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:51988 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267Ab0A1OHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2010 09:07:21 -0500
Received: by pxi12 with SMTP id 12so566833pxi.33
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jan 2010 06:07:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8bf247761001280439u59a9b6ch1128d42a83116594@mail.gmail.com>
References: <8bf247761001280439u59a9b6ch1128d42a83116594@mail.gmail.com>
Date: Thu, 28 Jan 2010 19:37:20 +0530
Message-ID: <8bf247761001280607i2b90f73j96e3afd02fb6da29@mail.gmail.com>
Subject: scan does not work
From: Sriram V <vshrirama@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

 Initially, i had posted this query on the libertas list - For some reason
 the query went in for moderation. Hence i post it here again.
 Sorry for the noise.


 I am using libertas 8686 sdio chip. I use linux kernel 2.6.29.
 The firmware gets downloaded. i see the interface, When i scan, The
scan always reports 0 APs.

 I have 3 working AP's on my network.

 This is the result of my libertas debug messages, I am not sure if
this is a RF issue/sdio issue.

  Please advice.
#ifconfig
eth0      Link encap:Ethernet  HWaddr 00:21:E8:D3:2C:95
        UP BROADCAST MULTICAST  MTU:1500  Metric:1
        RX packets:0 errors:0 dropped:0 overruns:0 frame:0
        TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
        collisions:0 txqueuelen:1000
        RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback
        inet addr:127.0.0.1  Mask:255.0.0.0
        UP LOOPBACK RUNNING  MTU:16436  Metric:1
        RX packets:0 errors:0 dropped:0 overruns:0 frame:0
        TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
        collisions:0 txqueuelen:0
        RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

# ./iwlist eth0 scan
eth0      No scan results

# ifconfig
eth0      Link encap:Ethernet  HWaddr 00:21:E8:D3:2C:95
        UP BROADCAST MULTICAST  MTU:1500  Metric:1
        RX packets:0 errors:0 dropped:0 overruns:0 frame:0
        TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
        collisions:0 txqueuelen:1000
        RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback
        inet addr:127.0.0.1  Mask:255.0.0.0
        UP LOOPBACK RUNNING  MTU:16436  Metric:1
        RX packets:0 errors:0 dropped:0 overruns:0 frame:0
        TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
        collisions:0 txqueuelen:0
        RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)


libertas debug prints:

libertas_sdio: Libertas SDIO driver
libertas_sdio: Copyright Pierre Ossman
libertas: 00:21:e8:d3:2c:95, fw 9.70.3p24, cap 0x00000303
libertas: unidentified region code; using the default (USA)
libertas main: region_cfp_table[i].region=16
eth0 (libertas_sdio): not using net_device_ops yet
libertas: PREP_CMD: command 0x00a3 failed: 2
libertas: PREP_CMD: command 0x00a3 failed: 2
libertas: eth0: Marvell WLAN 802.11 adapter
libertas host: PREP_CMD: command 0x0010
libertas host: QUEUE_CMD: inserted command 0x0010 into cmdpendingq
libertas host: PREP_CMD: command 0x0028
libertas host: QUEUE_CMD: inserted command 0x0028 into cmdpendingq
libertas host: EXEC_NEXT_CMD: sending command 0x0010
libertas cmd: DNLD_CMD: command 0x0010, seq 7, size 18
libertas cmd: CMD_RESP: response 0x8010, seq 7, size 18
libertas host: EXEC_NEXT_CMD: sending command 0x0028
libertas cmd: DNLD_CMD: command 0x0028, seq 8, size 12
libertas cmd: CMD_RESP: response 0x8028, seq 8, size 12
libertas host: PREP_CMD: command 0x0006
libertas host: QUEUE_CMD: inserted command 0x0006 into cmdpendingq
libertas host: EXEC_NEXT_CMD: sending command 0x0006
libertas cmd: DNLD_CMD: command 0x0006, seq 9, size 63
libertas cmd: CMD_RESP: response 0x8006, seq 9, size 11
libertas host: PREP_CMD: command 0x0006
libertas host: QUEUE_CMD: inserted command 0x0006 into cmdpendingq
libertas host: EXEC_NEXT_CMD: sending command 0x0006
libertas cmd: DNLD_CMD: command 0x0006, seq 10, size 63
libertas cmd: CMD_RESP: response 0x8006, seq 10, size 11
libertas host: PREP_CMD: command 0x0006
libertas host: QUEUE_CMD: inserted command 0x0006 into cmdpendingq
libertas host: EXEC_NEXT_CMD: sending command 0x0006
libertas cmd: DNLD_CMD: command 0x0006, seq 11, size 56
libertas cmd: CMD_RESP: response 0x8006, seq 11, size 11
libertas host: PREP_CMD: command 0x0006
libertas host: QUEUE_CMD: inserted command 0x0006 into cmdpendingq
libertas host: EXEC_NEXT_CMD: sending command 0x0006
libertas cmd: DNLD_CMD: command 0x0006, seq 12, size 63
libertas cmd: CMD_RESP: response 0x8006, seq 12, size 11
libertas host: PREP_CMD: command 0x0006
libertas host: QUEUE_CMD: inserted command 0x0006 into cmdpendingq
libertas host: EXEC_NEXT_CMD: sending command 0x0006
libertas cmd: DNLD_CMD: command 0x0006, seq 13, size 63
libertas cmd: CMD_RESP: response 0x8006, seq 13, size 11
libertas host: PREP_CMD: command 0x0006
libertas host: QUEUE_CMD: inserted command 0x0006 into cmdpendingq
libertas host: EXEC_NEXT_CMD: sending command 0x0006
libertas cmd: DNLD_CMD: command 0x0006, seq 14, size 56
libertas cmd: CMD_RESP: response 0x8006, seq 14, size 11





Regards,
sriram
