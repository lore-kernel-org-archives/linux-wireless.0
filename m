Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:47685 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752054AbeEOHmh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 03:42:37 -0400
Date: Tue, 15 May 2018 09:42:25 +0200
From: =?UTF-8?B?TXlsw6huZQ==?= Josserand <mylene.josserand@bootlin.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: rtl8188eu: link is not ready error on lm816
Message-ID: <20180515094225.3f24e2ff@dell-desktop.home> (sfid-20180515_094242_214072_D83903DB)
In-Reply-To: <20180514085521.1529d00b@dell-desktop.home>
References: <20180504212057.2edaa658@dell-desktop.home>
        <f40ea748-d53f-9cd5-18f9-e713c86865bb@lwfinger.net>
        <20180514085521.1529d00b@dell-desktop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

On Mon, 14 May 2018 08:55:21 +0200
Mylène Josserand <mylene.josserand@bootlin.com> wrote:

> Hello Larry,
> 
> Sorry about the delay, I was on holiday last week.
> 
> On Sat, 5 May 2018 16:11:13 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
> > On 05/04/2018 02:20 PM, Mylène Josserand wrote:  
> > > Hello everyone,
> > > 
> > > I am currently testing a USB Wifi dongle LM816 [1] on a custom
> > > platform based on an IMX6.
> > > 
> > > My configuration:
> > > 	kernel from mainline: v4.14
> > > 	driver: staging R8188EU
> > > 	firmware: rtl8188eu from linux-firmware, last commit
> > > 	a3a26af24e29c818ef9b5661856018e21a5c49fb
> > > 
> > > When I tried to set the wlan interface up, it says that "link is
> > > not ready" and that's all. Because of that, it fails to scan
> > > available networks.
> > > 
> > > Here are commands used and their output:
> > > 
> > > # dmesg
> > > [...]
> > > [   14.690152] r8188eu: module is from the staging directory, the
> > > quality is unknown, you have been warned.
> > > [   14.703105] Chip Version
> > > Info: CHIP_8188E_Normal_Chip_TSMC_D_CUT_1T1R_RomVer(0)
> > > [...]
> > > 
> > > # lsusb
> > > Bus 002 Device 004: ID 0bda:8179  <-- LM816
> > > Bus 002 Device 003: ID 0424:9e00
> > > Bus 002 Device 002: ID 0424:2517
> > > Bus 002 Device 001: ID 1d6b:0002
> > > Bus 001 Device 001: ID 1d6b:0002
> > > 
> > > # lsmod
> > > Module                  Size  Used by    Tainted: G
> > > dw_hdmi_ahb_audio      16384  0
> > > r8188eu               401408  0
> > > coda                   61440  0
> > > imx_vdoa               16384  1 coda
> > > v4l2_mem2mem           24576  1 coda
> > > videobuf2_vmalloc      16384  1 coda
> > > evbug                  16384  0
> > > 
> > > # ifconfig wlan0 up
> > > [  447.639524] MAC Address = 5c:f3:70:3d:5c:71
> > > [  447.653636] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> > > #
> > > #
> > > # iw wlan0 scan
> > > command failed: No such device (-19)
> > > 
> > > 
> > > Does anyone already have this issue with this dongle?
> > > If it is not the case, what is your setup? Which firmware? Which
> > > driver? Any help will be very appreciated.
> > > 
> > > Thanks in advance,
> > > Best regards,
> > > 
> > > [1]:
> > > https://www.lm-technologies.com/product/wifi-usb-nano-adapter-150mbps-lm816/    
> > 
> > I am running kernel 4.17.0-rc3 under openSUSE Tumbleweed KDE on a
> > Toshiba laptop, and controlling networks with NetworkManager.   
> 
> I am running a kernel v4.14.0. The last commit I have for this driver
> is:
> b24413180f56 'License cleanup: add SPDX GPL-2.0 license identifier to
> files with no license'.
> 
> There is many new commits on top of it. I will try to update the
> driver or my kernel to have the last version.
> 
> > When I plug my dongle in, 
> > the device connects automatically. The firmware I am using has the
> > following md5sum:
> > 
> > aaef52a47852e599cbff63a3e7f96a94  /lib/firmware/rtlwifi/rtl8188eufw.bin  
> 
> Okay, I have the same md5sum so we are using the same firmware:
> aaef52a47852e599cbff63a3e7f96a94  /lib/firmware/rtlwifi/rtl8188eufw.bin
> 
> > 
> > My dongle shows the following with lsusb:
> > ID 0bda:8179 Realtek Semiconductor Corp. RTL8188EUS 802.11n
> > Wireless Network Adapter  
> 
> Same here:
> ID 0bda:8179 Realtek Semiconductor Corp. RTL8188EUS 802.11n Wireless
> Network Adapter
> 
> > 
> > Mine shows as an A-cut:
> > Chip Version Info: CHIP_8188E_Normal_Chip_TSMC_A_CUT_1T1R_RomVer(0)
> > 
> > Yours is a D-cut, but I would not expect any difference from that.
> > The only place that information is used is in the log entry shown
> > above.
> > 
> > If you want to try a different driver, there is one at
> > http://github.com/lwfinger/rtl8188eu.git
> > 
> > Larry
> > 
> >   
> 
> I will try to update my kernel and I will let you know if it is now
> working (or not).
> 
> Anyway, thanks for your help!
> 
> Best regards,
> 

I tested it and it was still not working but after searching on the
net, I found other commands to scan for networks.

Instead of using:

# iw wlan0 scan
command failed: No such device (-19)

I used:

# iwlist wlan0 scan

And it is able to scan available networks (even with the 4.14.0 kernel)

I noticed that I got a warning about a recursive locking:

      # iwlist wlan0 scan
      [   87.149647]
      [   87.151176] ============================================
      [   87.156506] WARNING: possible recursive locking detected
      [   87.161843] 4.14.0 #1 Tainted: G         C
      [   87.166390] --------------------------------------------
      [   87.171721] RTW_CMD_THREAD/278 is trying to acquire lock:
      [   87.177136]  (&(&pqueue->lock)->rlock){+.-.}, at: [<bf0438f8>] _rtw_alloc_network+0x1c/0xc8 [r8188eu]
      [   87.186763]
      [   87.186763] but task is already holding lock:
      [   87.192615]  (&(&pqueue->lock)->rlock){+.-.}, at: [<bf043f98>] rtw_update_scanned_network+0x20/0x240 [r8188eu]
      [   87.202970]
      [   87.202970] other info that might help us debug this:
      [   87.209517]  Possible unsafe locking scenario:
      [   87.209517]
      [   87.215454]        CPU0
      [   87.217915]        ----
      [   87.220376]   lock(&(&pqueue->lock)->rlock);
      [   87.224677]   lock(&(&pqueue->lock)->rlock);
      [   87.228979]
      [   87.228979]  *** DEADLOCK ***
      [   87.228979]
      [   87.234919]  May be due to missing lock nesting notation
      [   87.234919]
      [   87.241731] 2 locks held by RTW_CMD_THREAD/278:
      [   87.246277]  #0:  (&(&(pmlmepriv->lock))->rlock){+...}, at: [<bf044288>] rtw_survey_event_callback+0x84/0x1cc [r8188eu]
      [   87.257417]  #1:  (&(&pqueue->lock)->rlock){+.-.}, at: [<bf043f98>] rtw_update_scanned_network+0x20/0x240 [r8188eu]
      [   87.268206]
      [   87.268206] stack backtrace:
      [   87.272593] CPU: 2 PID: 278 Comm: RTW_CMD_THREAD Tainted: G         C      4.14.0 #1
      [   87.280354] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
      [   87.286896] Backtrace:
      [   87.289390] [<c010c820>] (dump_backtrace) from [<c010caf0>] (show_stack+0x18/0x1c)
      [   87.296986]  r7:00000000 r6:600e0093 r5:00000000 r4:c0e771e0
      [   87.302678] [<c010cad8>] (show_stack) from [<c09cf8b8>] (dump_stack+0xb4/0xe8)
      [   87.309937] [<c09cf804>] (dump_stack) from [<c0170378>] (__lock_acquire+0x898/0x1968)
      [   87.317796]  r9:c12f1bd8 r8:00000000 r7:c1585410 r6:c15d8958 r5:ecf61ea0 r4:c12f1bd8
      [   87.325568] [<c016fae0>] (__lock_acquire) from [<c0171bf8>] (lock_acquire+0x70/0x90)
      [   87.333338]  r10:bf08a71c r9:f13a9064 r8:00000001 r7:00000001 r6:600e0013 r5:00000000
      [   87.341185]  r4:ffffe000
      [   87.343754] [<c0171b88>] (lock_acquire) from [<c09ebb8c>] (_raw_spin_lock_bh+0x4c/0x5c)
      [   87.351784]  r8:f13a9000 r7:f13a905c r6:eceffc08 r5:bf0438f8 r4:f13a903c
      [   87.358816] [<c09ebb40>] (_raw_spin_lock_bh) from [<bf0438f8>] (_rtw_alloc_network+0x1c/0xc8 [r8188eu])
      [   87.368234]  r5:f13a903c r4:f13a9004
      [   87.372418] [<bf0438dc>] (_rtw_alloc_network [r8188eu]) from [<bf044060>] (rtw_update_scanned_network+0xe8/0x240 [r8188eu])
      [   87.383573]  r5:00000000 r4:f13a905c
      [   87.387765] [<bf043f78>] (rtw_update_scanned_network [r8188eu]) from [<bf044304>] (rtw_survey_event_callback+0x100/0x1cc [r8188eu])
      [   87.399623]  r10:bf08a71c r9:f13aa378 r8:bf03b434 r7:f13a9004 r6:f13a9000 r5:00000800
      [   87.407473]  r4:eceffc08 r3:00000043
      [   87.411660] [<bf044204>] (rtw_survey_event_callback [r8188eu]) from [<bf04f63c>] (mlme_evt_hdl+0x64/0xf0 [r8188eu])
      [   87.422127]  r9:f13aa378 r8:bf03b434 r7:ecf36000 r6:00000000 r5:f13ac000 r4:00000008
      [   87.430476] [<bf04f5d8>] (mlme_evt_hdl [r8188eu]) from [<bf03ba8c>] (rtw_cmd_thread+0x110/0x2bc [r8188eu])
      [   87.440158]  r7:ecf36000 r6:f13aa3d0 r5:f13ac000 r4:eca20ec0
      [   87.446140] [<bf03b97c>] (rtw_cmd_thread [r8188eu]) from [<c0147914>] (kthread+0x120/0x160)
      [   87.454522]  r10:ece13d34 r9:ecc793b8 r8:f13a9000 r7:ecf36000 r6:eca20800 r5:00000000
      [   87.462370]  r4:ecc79380
      [   87.464943] [<c01477f4>] (kthread) from [<c0107f68>] (ret_from_fork+0x14/0x2c)
      [   87.472192]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c01477f4
      [   87.480039]  r4:eca20800

Otherwise, it works correctly using "iwlist" and not "iw".
I have seen that "iwlist/iwconfig" are now replaced by "iw", right?

Do you think it would be difficult to update the driver to make it work
with "iw"? If you think it is possible (and not so complicated for a
person that never looked at a wifi driver), we will be pleased to have a
look and contribute to this driver.

Thank you in advance,

Best regards,

-- 
Mylène Josserand, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
http://bootlin.com
