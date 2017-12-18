Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35526 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935601AbdLRQUG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Dec 2017 11:20:06 -0500
Received: by mail-wm0-f67.google.com with SMTP id f9so30504806wmh.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 Dec 2017 08:20:05 -0800 (PST)
Date: Mon, 18 Dec 2017 17:19:58 +0100
From: Gary Bisson <gary.bisson@boundarydevices.com>
To: Alagu Sankar <alagusankar@silex-india.com>
Cc: silexcommon@gmail.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, erik.stromdahl@gmail.com
Subject: Re: [PATCH 00/11] SDIO support for ath10k
Message-ID: <20171218161958.yi5ldohhdf2hadfy@t450s.lan> (sfid-20171218_172042_279434_5F556374)
References: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
 <20171005151205.cymirl4wikuw4f7q@t450s.lan>
 <59D66ACA.60801@silex-india.com>
 <20171006111613.ulatu65gvmgrr2ie@t450s.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171006111613.ulatu65gvmgrr2ie@t450s.lan>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alagu,

On Fri, Oct 06, 2017 at 01:16:13PM +0200, Gary Bisson wrote:
> Hi Alagu,
> 
> On Thu, Oct 05, 2017 at 10:54:26PM +0530, Alagu Sankar wrote:
> > Hi Gary,
> > 
> > On 05-10-2017 20:42, Gary Bisson wrote:
> > > Hi Alagu,
> > > 
> > > First of all, thank you for sharing your patches, this will be a very
> > > nice improvement to have SDIO QCA9377 working with ath10k.
> > > 
> > > I've tried your series with Nitrogen7 [1] platform which is supported in
> > > mainline already. It uses BD-SDMAC [2] which uses the same module as the
> > > SX-SDMAC.
> > > 
> > > Below are some questions/remarks I have after the testing.
> > > 
> > > On Sat, Sep 30, 2017 at 11:07:37PM +0530, silexcommon at gmail.com wrote:
> > > > From: Alagu Sankar <alagusankar at silex-india.com>
> > > > 
> > > > This patchset, generated against master-pending branch, enables a fully
> > > > functional SDIO interface driver for ath10k.  Patches have been verified on
> > > > QCA9377-3 WB396 and Silex's SX-SDCAC reference cards with Station, Access Point
> > > > and P2P modes.
> > > > 
> > > > The driver is verified with the firmware WLAN.TF.1.1.1-00061-QCATFSWPZ-1
> > > Quick question on the firmware, is it the one from Kalle's repository?[3]
> > > 
> > > If so, where does this firmware comes from? Is 00061 the firmware
> > > version? So far I've only seen up to v0.0.0.60, see qcacld-2.0 output:
> > > Host SW:4.5.20.037, FW:0.0.0.60, HW:QCA9377_REV1_1
> > Yes, it is from
> > https://github.com/kvalo/ath10k-firmware/tree/master/QCA9377/hw1.0/untested.
> > I have also used custom firmware from QCA/Silex as used in qcacld-2.0 driver
> > without any issue. You need to use the firmware merger tool from
> > https://github.com/erstrom/linux-ath/wiki/Firmware to combine the
> > qwlan30.bin and otp30.bin to generate the firmware-sdio.bin.
> 
> Good to know, thanks. Maybe Kalle can tell us more about the firmware
> itself, what's the difference between the version 0.0.0.60 and 0.0.0.61?

Any update on this, is there a release notes for this 0.0.0.61 firmware?

> > > > with the board data from respective SDIO card vendors.
> > > About the board-sdio.bin, is it just a copy of your bdwlan30.bin?
> > Yes board-sdio.bin is a copy of bdwlan30.bin
> 
> Thanks for confirming it.
> 
> > > > Receive performance
> > > > matches the QCA reference driver when used with SDIO3.0 enabled platforms.
> > > > iperf tests indicate a downlink UDP of 275Mbit/s and TCP of 150Mbit/s
> > > Nice performances. Unfortunately I don't get better than 30Mbits/s in TX
> > > and 50Mbits/s in RX:
> > > # iperf -c 192.168.1.1
> > > ------------------------------------------------------------
> > > Client connecting to 192.168.1.1, TCP port 5001
> > > TCP window size: 43.8 KByte (default)
> > > ------------------------------------------------------------
> > > [  3] local 192.168.1.115 port 41354 connected with 192.168.1.1 port
> > > 5001
> > > [ ID] Interval       Transfer     Bandwidth
> > > [  3]  0.0-10.0 sec  34.9 MBytes  29.2 Mbits/sec
> > > # iperf -s
> > > ------------------------------------------------------------
> > > Server listening on TCP port 5001
> > > TCP window size: 85.3 KByte (default)
> > > ------------------------------------------------------------
> > > [  4] local 192.168.1.115 port 5001 connected with 192.168.1.1 port
> > > 50646
> > > [ ID] Interval       Transfer     Bandwidth
> > > [  4]  0.0-10.0 sec  63.1 MBytes  52.7 Mbits/sec
> > > 
> > > Do you have any idea why? Note that qcacld-2.0 driver on that same
> > > platform (same OS) gives the performances you advertize (150Mbits/s).
> > For some reason, if I use the imx_v6_v7_defconfig as is, performance is very
> > poor. In fact, the firmware download itself will take about 6 seconds. This
> > can also be seen when you up/down the wlan0 interface. For the i.MX6 SoloX
> > board, I used the configuration of 4.1.15 as provided by the BSP from
> > NXP/Freescale.
> 
> Do you mean that you've used 4.1.15 kernel or just the 4.1.15
> configuration on latest 4.14?

As a FYI, I've tried your ath10k patches (along with a few backported
patches from Erik) on the NXP-fork of 4.9 kernel [1].

I confirm that it provides pretty decent performances:
- ath10k: 110Mbit/s
- qcacld-2.0: 125Mbit/s

Here are some details about the setup:
- TPLink AC router
- Nitrogen7 (i.MX7) with BD-SDMAC
- Kernel 4.9.68 (NXP fork [1])
- FW 0.0.0.61 from ath10k-firmware repo

It is definitely a nice alternative to qcacld driver. When do you plan
on sending a v2 out?

Regards,
Gary

[1] https://github.com/boundarydevices/linux-imx6/commits/test-ath10k
