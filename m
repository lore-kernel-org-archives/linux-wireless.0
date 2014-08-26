Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:63830 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939AbaHZBIP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2014 21:08:15 -0400
Received: by mail-ie0-f172.google.com with SMTP id lx4so10725469iec.31
        for <linux-wireless@vger.kernel.org>; Mon, 25 Aug 2014 18:08:14 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 25 Aug 2014 18:08:14 -0700
Message-ID: <CALoNvyuUxX7Wv+nRnPDW_PdO3BsJbTfrF-MU7uoNuUbAXrbZnA@mail.gmail.com> (sfid-20140826_030822_443070_6AFA23A4)
Subject: rtl8192su driver compatibility with a rtl8188su device
From: David Madsen <david.madsen@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

I came across the in-development rtl8192su source tree on github while
looking for a driver for a small Trendnet 802.11bgn device I have.
The chipset in use is an rtl8188su with usbid 0bda:8171.  I was able
to compile and load the driver against a standard 3.16.1 kernel with
what looks to be a reasonably accurate capability listing for the
wireless phy along with a standard dev instance.

Whenever I attempt to enable the dev interface with an 'ifconfig wlan0
up' I get an error back indicating no such device (it does pause for a
second or two however before the error returns).  I enabled the
RT_TRACE messages in the module compile as well as setting the debug
module parameter to 5 to enable all the tracing and it looks like
there are some problems happening when the driver attempts to load the
firmware into the device.

The firmware is found correctly (I created a link from the
rtl8712u.bin to rtl8192sufw.bin).  This firmware is identical to the
rtl8712u-oldest-but-good.bin firmware located in the git tree.  Here's
a snippet of what looks to be start of the troubles during the module
initialization.

Aug 24 19:43:02 [kernel] rtl8192s_common: Chip version 0x3
Aug 24 19:43:02 [kernel] rtl_usb: rx_max_size 9100, rx_urb_num 8, in_ep 3
Aug 24 19:43:02 [kernel] rtl8192su: Power Save off (module option)
Aug 24 19:43:02 [kernel] rtl8192su: FW Power Save off (module option)
Aug 24 19:43:02 [kernel] rtl8192su: Driver for Realtek RTL8192SU/RTL8191SU
Aug 24 19:43:02 [kernel] Loading firmware rtlwifi/rtl8192sufw.bin
Aug 24 19:43:02 [kernel] usbcore: registered new interface driver rtl8192su
Aug 24 19:43:02 [kernel] rtl8192su:rtl92su_fw_cb():<0-0> Firmware
callback routine entered!
Aug 24 19:43:02 [kernel] rtlwifi:rtl_reg_notifier():<0-0>
Aug 24 19:43:02 [kernel] ieee80211 phy0: Selected rate control
algorithm 'rtl_rc'
Aug 24 19:43:33 [kernel]
rtl8192su:_rtl92su_macconfig_before_fwdownload():<0-0> Polling
TXDMA_INIT_VALUE timeout!! Current TCR(0x0)
Aug 24 19:43:33 [kernel] rtl8192s_common:rtl92s_download_fw():<0-0>
signature:8712, version:11ec, size:30, imemsize:e808, sram size:f550
Aug 24 19:43:33 [kernel]
rtl8192s_common:_rtl92s_firmware_checkready():<0-0> LoadStaus(1)
Aug 24 19:43:33 [kernel]
rtl8192s_common:_rtl92s_firmware_checkready():<0-0>
FW_STATUS_LOAD_IMEM FAIL CPU, Status=0
Aug 24 19:43:33 [kernel]
rtl8192s_common:_rtl92s_firmware_checkready():<0-0> loadfw_status(1),
rtstatus(1)
Aug 24 19:43:33 [kernel]
rtl8192s_common:_rtl92s_firmware_checkready():<0-0> LoadStaus(2)
Aug 24 19:43:34 [kernel]
rtl8192s_common:_rtl92s_firmware_checkready():<0-0>
FW_STATUS_LOAD_EMEM FAIL CPU, Status=0
Aug 24 19:43:34 [kernel]
rtl8192s_common:_rtl92s_firmware_checkready():<0-0> loadfw_status(2),
rtstatus(1)
Aug 24 19:43:34 [kernel]
rtl8192s_common:_rtl92s_firmware_checkready():<0-0> LoadStaus(3)
Aug 24 19:43:34 [kernel]
rtl8192s_common:_rtl92s_firmware_checkready():<0-0> Polling DMEM code
done fail ! cpustatus(0x0)
Aug 24 19:43:34 [kernel]
rtl8192s_common:_rtl92s_firmware_checkready():<0-0> loadfw_status(3),
rtstatus(1)
Aug 24 19:43:34 [kernel]
rtl8192su:_rtl92su_macconfig_after_fwdownload():<0-0> OK

...

The trace then goes on to do a bunch of register writes to continue
initializing the device and then ends as follows:

...

Aug 24 19:43:34 [kernel] rtl8192s_common:rtl92s_phy_set_bb_reg():<0-0>
regaddr(0xc78), bitmask(0xffffffff), data(0x721f001e)
Aug 24 19:43:34 [kernel]
rtl8192s_common:rtl92s_phy_query_bb_reg():<0-0> BBR MASK=0x200
Addr[0x824]=0x0
Aug 24 19:43:34 [kernel]
rtl8192s_common:rtl92s_phy_query_bb_reg():<0-0> BBR MASK=0xf
Addr[0x804]=0x0
Aug 24 19:43:34 [kernel]
rtl8192s_common:rtl92s_phy_query_bb_reg():<0-0> BBR MASK=0xf
Addr[0xc04]=0x0
Aug 24 19:43:34 [kernel] rtl8192s_common:rtl92s_phy_bb_config():<0-0>
RF_Type(0) does not match RF_Num(0)!!
Aug 24 19:43:34 [kernel] rtl8192s_common:rtl92s_phy_bb_config():<0-0>
path1 0x0, path2 0x0, pathmap 0x0
Aug 24 19:43:34 [kernel] rtl8192su:rtl92su_hw_init():<0-0> BB Config failed


It appears that the firmware writes into the device are timing out or
failing in some fashion which leaves the device uninitialized, and
eventually returns the error.  Is the rtl8188su expected to work with
the driver currently or is support there still a work in progress?

I was able to use the existing rtl8712 driver from the staging tree to
get the device working, but it uses the old wireless extensions and
doesn't appear to support a monitor mode, which was the initial goal
of getting this device working.

In summary I've got a few questions.  Is this chipset expected to be
functional with the driver at this time?  If so, is there anything I
can do/provide to debug further?   If not I would be interested in
helping out with porting/testing/debugging to aid in getting the
chipset functional.  Lastly, is monitor mode expected to work with the
driver/chipset or are there lower layer filters in place that would
keep the driver and upper layers from seeing all the frames from the
phy?

--
David Madsen
