Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:49774 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751380AbdJEPMN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Oct 2017 11:12:13 -0400
Received: by mail-wm0-f53.google.com with SMTP id b189so2740570wmd.4
        for <linux-wireless@vger.kernel.org>; Thu, 05 Oct 2017 08:12:12 -0700 (PDT)
Date: Thu, 5 Oct 2017 17:12:05 +0200
From: Gary Bisson <gary.bisson@boundarydevices.com>
To: silexcommon@gmail.com
Cc: ath10k@lists.infradead.org, alagusankar@silex-india.com,
        linux-wireless@vger.kernel.org, erik.stromdahl@gmail.com
Subject: Re: [PATCH 00/11] SDIO support for ath10k
Message-ID: <20171005151205.cymirl4wikuw4f7q@t450s.lan> (sfid-20171005_171235_056797_C4503C3F)
References: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alagu,

First of all, thank you for sharing your patches, this will be a very
nice improvement to have SDIO QCA9377 working with ath10k.

I've tried your series with Nitrogen7 [1] platform which is supported in
mainline already. It uses BD-SDMAC [2] which uses the same module as the
SX-SDMAC.

Below are some questions/remarks I have after the testing.

On Sat, Sep 30, 2017 at 11:07:37PM +0530, silexcommon at gmail.com wrote:
> From: Alagu Sankar <alagusankar at silex-india.com>
> 
> This patchset, generated against master-pending branch, enables a fully
> functional SDIO interface driver for ath10k.  Patches have been verified on
> QCA9377-3 WB396 and Silex's SX-SDCAC reference cards with Station, Access Point
> and P2P modes.
> 
> The driver is verified with the firmware WLAN.TF.1.1.1-00061-QCATFSWPZ-1

Quick question on the firmware, is it the one from Kalle's repository?[3]

If so, where does this firmware comes from? Is 00061 the firmware
version? So far I've only seen up to v0.0.0.60, see qcacld-2.0 output:
Host SW:4.5.20.037, FW:0.0.0.60, HW:QCA9377_REV1_1

> with the board data from respective SDIO card vendors.

About the board-sdio.bin, is it just a copy of your bdwlan30.bin?

> Receive performance
> matches the QCA reference driver when used with SDIO3.0 enabled platforms.
> iperf tests indicate a downlink UDP of 275Mbit/s and TCP of 150Mbit/s

Nice performances. Unfortunately I don't get better than 30Mbits/s in TX
and 50Mbits/s in RX:
# iperf -c 192.168.1.1    
------------------------------------------------------------
Client connecting to 192.168.1.1, TCP port 5001
TCP window size: 43.8 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.115 port 41354 connected with 192.168.1.1 port
5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  34.9 MBytes  29.2 Mbits/sec
# iperf -s
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.1.115 port 5001 connected with 192.168.1.1 port
50646
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-10.0 sec  63.1 MBytes  52.7 Mbits/sec

Do you have any idea why? Note that qcacld-2.0 driver on that same
platform (same OS) gives the performances you advertize (150Mbits/s).

> This patchset differs from the previous high latency patches, specific to SDIO.
> HI_ACS_FLAGS_SDIO_REDUCE_TX_COMPL_SET is enabled for HI_ACS. This instructs the
> firmware to use HTT_T2H_MSG_TYPE_TX_COMPL_IND for outgoing packets. Without
> this flag, the management frames are not sent out by the firmware. Possibility
> of management frames being sent via WMI and data frames through the reduced Tx
> completion needs to be probed further.
> 
> Further improvements can be done on the transmit path by implementing packet
> bundle. Scatter Gather is another area of improvement for both Transmit and
> Receive, but may not work on all platforms
> 
> Known issues: Surprise removal of the card, when the device is in connected
> state, delays sdio function remove due to delayed WMI command failures.
> Existing ath10k framework can not differentiate between a kernel module
> removae and the surprise removal of teh card.

Here are some questions:
- Is it normal to see a warning about board-2.bin, shouldn't it look for
  board-sdio.bin only?
[   14.696704] ath10k_sdio mmc1:0001:1: Direct firmware load for
ath10k/QCA9377/hw1.0/board-2.bin failed with error -2

- Did you have pre-cal and/or cal binaries for your testing?
[   14.067159] ath10k_sdio mmc1:0001:1: Direct firmware load for
ath10k/pre-cal-sdio-mmc1:0001:1.bin failed with error -2
[   14.149257] ath10k_sdio mmc1:0001:1: Direct firmware load for
ath10k/cal-sdio-mmc1:0001:1.bin failed with error -2

Also noticed that the "tx bitrate" output of 'iw link' is wrong in my
case:
# iw wlan0 link
Connected to 00:00:00:00:00:b0 (on wlan0)
	SSID: TPLINK_AC_5G
	freq: 5180
	RX: 72072365 bytes (67934 packets)
	TX: 79084128 bytes (73649 packets)
	signal: -35 dBm
	tx bitrate: 6.0 MBit/s

	bss flags:	short-slot-time
	dtim period:	2
	beacon int:	100

When connecting using qcacld driver it shows 433MBit/s as expected. Is
it working properly in your case?

As a FYI, I've built Erik's tree[4] for this testing, should I use
another tree instead?

Let me know your thoughts.

Regards,
Gary

[1] https://boundarydevices.com/product/nitrogen7/
[2] https://boundarydevices.com/product/bd_sdmac_wifi/
[3] https://github.com/kvalo/ath10k-firmware/tree/master/QCA9377/hw1.0/untested
[4] https://github.com/erstrom/linux-ath
