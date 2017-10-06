Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:52202 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750967AbdJFLQT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2017 07:16:19 -0400
Received: by mail-wm0-f42.google.com with SMTP id f4so7281411wme.0
        for <linux-wireless@vger.kernel.org>; Fri, 06 Oct 2017 04:16:18 -0700 (PDT)
Date: Fri, 6 Oct 2017 13:16:13 +0200
From: Gary Bisson <gary.bisson@boundarydevices.com>
To: Alagu Sankar <alagusankar@silex-india.com>
Cc: silexcommon@gmail.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, erik.stromdahl@gmail.com
Subject: Re: [PATCH 00/11] SDIO support for ath10k
Message-ID: <20171006111613.ulatu65gvmgrr2ie@t450s.lan> (sfid-20171006_131623_648161_5FDC9633)
References: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
 <20171005151205.cymirl4wikuw4f7q@t450s.lan>
 <59D66ACA.60801@silex-india.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <59D66ACA.60801@silex-india.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alagu,

On Thu, Oct 05, 2017 at 10:54:26PM +0530, Alagu Sankar wrote:
> Hi Gary,
> 
> On 05-10-2017 20:42, Gary Bisson wrote:
> > Hi Alagu,
> > 
> > First of all, thank you for sharing your patches, this will be a very
> > nice improvement to have SDIO QCA9377 working with ath10k.
> > 
> > I've tried your series with Nitrogen7 [1] platform which is supported in
> > mainline already. It uses BD-SDMAC [2] which uses the same module as the
> > SX-SDMAC.
> > 
> > Below are some questions/remarks I have after the testing.
> > 
> > On Sat, Sep 30, 2017 at 11:07:37PM +0530, silexcommon at gmail.com wrote:
> > > From: Alagu Sankar <alagusankar at silex-india.com>
> > > 
> > > This patchset, generated against master-pending branch, enables a fully
> > > functional SDIO interface driver for ath10k.  Patches have been verified on
> > > QCA9377-3 WB396 and Silex's SX-SDCAC reference cards with Station, Access Point
> > > and P2P modes.
> > > 
> > > The driver is verified with the firmware WLAN.TF.1.1.1-00061-QCATFSWPZ-1
> > Quick question on the firmware, is it the one from Kalle's repository?[3]
> > 
> > If so, where does this firmware comes from? Is 00061 the firmware
> > version? So far I've only seen up to v0.0.0.60, see qcacld-2.0 output:
> > Host SW:4.5.20.037, FW:0.0.0.60, HW:QCA9377_REV1_1
> Yes, it is from
> https://github.com/kvalo/ath10k-firmware/tree/master/QCA9377/hw1.0/untested.
> I have also used custom firmware from QCA/Silex as used in qcacld-2.0 driver
> without any issue. You need to use the firmware merger tool from
> https://github.com/erstrom/linux-ath/wiki/Firmware to combine the
> qwlan30.bin and otp30.bin to generate the firmware-sdio.bin.

Good to know, thanks. Maybe Kalle can tell us more about the firmware
itself, what's the difference between the version 0.0.0.60 and 0.0.0.61?

> > > with the board data from respective SDIO card vendors.
> > About the board-sdio.bin, is it just a copy of your bdwlan30.bin?
> Yes board-sdio.bin is a copy of bdwlan30.bin

Thanks for confirming it.

> > > Receive performance
> > > matches the QCA reference driver when used with SDIO3.0 enabled platforms.
> > > iperf tests indicate a downlink UDP of 275Mbit/s and TCP of 150Mbit/s
> > Nice performances. Unfortunately I don't get better than 30Mbits/s in TX
> > and 50Mbits/s in RX:
> > # iperf -c 192.168.1.1
> > ------------------------------------------------------------
> > Client connecting to 192.168.1.1, TCP port 5001
> > TCP window size: 43.8 KByte (default)
> > ------------------------------------------------------------
> > [  3] local 192.168.1.115 port 41354 connected with 192.168.1.1 port
> > 5001
> > [ ID] Interval       Transfer     Bandwidth
> > [  3]  0.0-10.0 sec  34.9 MBytes  29.2 Mbits/sec
> > # iperf -s
> > ------------------------------------------------------------
> > Server listening on TCP port 5001
> > TCP window size: 85.3 KByte (default)
> > ------------------------------------------------------------
> > [  4] local 192.168.1.115 port 5001 connected with 192.168.1.1 port
> > 50646
> > [ ID] Interval       Transfer     Bandwidth
> > [  4]  0.0-10.0 sec  63.1 MBytes  52.7 Mbits/sec
> > 
> > Do you have any idea why? Note that qcacld-2.0 driver on that same
> > platform (same OS) gives the performances you advertize (150Mbits/s).
> For some reason, if I use the imx_v6_v7_defconfig as is, performance is very
> poor. In fact, the firmware download itself will take about 6 seconds. This
> can also be seen when you up/down the wlan0 interface. For the i.MX6 SoloX
> board, I used the configuration of 4.1.15 as provided by the BSP from
> NXP/Freescale.

Do you mean that you've used 4.1.15 kernel or just the 4.1.15
configuration on latest 4.14?

> This improved the performance quite a bit. I haven't had a
> chance to spend time on this to figure out the difference and reason.
> Another difference is that the default device tree for SoloX did not have
> the correct settings to support SDIO3.x.  Had to modify them, but did not
> include the device tree patches here as it is not meant for this group.

Doh! That's why I don't get better performances, my platform limits the
SDIO bus to 50MHz right now.

Unfortunately SDIO3.0 doesn't seem stable on i.MX7, it is missing a few
patches, I'll start a thread with Shawn/Fabio about it.

> > > This patchset differs from the previous high latency patches, specific to SDIO.
> > > HI_ACS_FLAGS_SDIO_REDUCE_TX_COMPL_SET is enabled for HI_ACS. This instructs the
> > > firmware to use HTT_T2H_MSG_TYPE_TX_COMPL_IND for outgoing packets. Without
> > > this flag, the management frames are not sent out by the firmware. Possibility
> > > of management frames being sent via WMI and data frames through the reduced Tx
> > > completion needs to be probed further.
> > > 
> > > Further improvements can be done on the transmit path by implementing packet
> > > bundle. Scatter Gather is another area of improvement for both Transmit and
> > > Receive, but may not work on all platforms
> > > 
> > > Known issues: Surprise removal of the card, when the device is in connected
> > > state, delays sdio function remove due to delayed WMI command failures.
> > > Existing ath10k framework can not differentiate between a kernel module
> > > removae and the surprise removal of teh card.
> > Here are some questions:
> > - Is it normal to see a warning about board-2.bin, shouldn't it look for
> >    board-sdio.bin only?
> > [   14.696704] ath10k_sdio mmc1:0001:1: Direct firmware load for
> > ath10k/QCA9377/hw1.0/board-2.bin failed with error -2
> This was only noticed in the latest update. Like the different firmware
> versions, the driver also looks for the board-2.bin now. I have only tested
> with the board-sdio.bin

Good, thanks.

> > - Did you have pre-cal and/or cal binaries for your testing?
> > [   14.067159] ath10k_sdio mmc1:0001:1: Direct firmware load for
> > ath10k/pre-cal-sdio-mmc1:0001:1.bin failed with error -2
> > [   14.149257] ath10k_sdio mmc1:0001:1: Direct firmware load for
> > ath10k/cal-sdio-mmc1:0001:1.bin failed with error -2
> No. I did not use the pre-cal and cal binaries.
> > Also noticed that the "tx bitrate" output of 'iw link' is wrong in my
> > case:
> > # iw wlan0 link
> > Connected to 00:00:00:00:00:b0 (on wlan0)
> > 	SSID: TPLINK_AC_5G
> > 	freq: 5180
> > 	RX: 72072365 bytes (67934 packets)
> > 	TX: 79084128 bytes (73649 packets)
> > 	signal: -35 dBm
> > 	tx bitrate: 6.0 MBit/s
> > 
> > 	bss flags:	short-slot-time
> > 	dtim period:	2
> > 	beacon int:	100
> > 
> > When connecting using qcacld driver it shows 433MBit/s as expected. Is
> > it working properly in your case?
> Tx rate is not updated properly.  I will include it in the list of known
> issues.

I'll try to see if it is complex to fix, I had a similar issue on qcacld
which was straightforward to fix.

Regards,
Gary
