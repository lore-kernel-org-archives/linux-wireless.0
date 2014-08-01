Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f63.google.com ([209.85.213.63]:54319 "EHLO
	mail-yh0-f63.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbaHAIWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2014 04:22:55 -0400
Received: by mail-yh0-f63.google.com with SMTP id b6so865242yha.18
        for <linux-wireless@vger.kernel.org>; Fri, 01 Aug 2014 01:22:54 -0700 (PDT)
Date: Fri, 1 Aug 2014 00:36:46 -0700 (PDT)
From: whereissteven@gmail.com
To: linux-sunxi@googlegroups.com
Cc: julian.calaby@gmail.com, linux-wireless@vger.kernel.org,
	linux@rempel-privat.de
Message-Id: <dd1eacd8-7b53-4be9-bdc8-e0fcc7c7f4bb@googlegroups.com> (sfid-20140801_102302_015646_14833A28)
In-Reply-To: <53DB35DC.6080000@rempel-privat.de>
References: <abdf4435-03e3-4ebe-93b2-694d7df9d7cd@googlegroups.com> <ba1f0077-55e0-4e9b-b06e-75c6b9e2ea08@googlegroups.com> <8d579ffa-80e9-470e-9c29-ecb3c4b67c15@googlegroups.com> <9652a9a0-f205-4d03-8a69-4f7eb95963da@googlegroups.com> <CAGRGNgXyD_y9AMWpKHq-=cq7Fnda6cVoCWHybbgvRHRKbdLhRQ@mail.gmail.com> <53DA5F11.4040306@gmail.com> <CAGRGNgV=698Dab9AnpqBf1B67tew5kOteRnLvA7cm=YXSXYjcw@mail.gmail.com>
 <53DB35DC.6080000@rempel-privat.de>
Subject: [SOLVED]Re: [linux-sunxi] Re: A20 + AR9271 wifi problem
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_45_150724646.1406878606880"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_45_150724646.1406878606880
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello all,

On Friday, August 1, 2014 8:47:54 AM UTC+2, Oleksij Rempel wrote:
> Am 01.08.2014 um 02:13 schrieb Julian Calaby:
> 
> > Hi Steven,
> 
> > 
> 
> > I'm CCing Linux-wireless as they might be able to help and I'm running
> 
> > out of ideas =)
> 
> > 
> 
> > On Fri, Aug 1, 2014 at 1:21 AM, Steven <whereissteven@gmail.com> wrote:
> 
> >> Julian,
> 
> >>
> 
> >>
> 
> >> On 07/31/2014 02:28 PM, Julian Calaby wrote:
> 
> >>> Hi Steven,
> 
> >>>
> 
> >>> On Thu, Jul 31, 2014 at 8:47 PM,  <whereissteven@gmail.com> wrote:
> 
> >>>> Hello Tim,
> 
> >>>>
> 
> >>>> Thanks for your advice and sorry for delay. For now I'm trying to find out how do I know if kernel was compiled with this config.
> 
> >>>>
> 
> >>>> All I can see is :
> 
> >>>>
> 
> >>>> root@a20-OLinuXino:~# find / -iname "*cfg80211*"
> 
> >>>> /sys/module/cfg80211
> 
> >>>> /sys/module/cfg80211/parameters/cfg80211_disable_40mhz_24ghz
> 
> >>>>
> 
> >>>> root@a20-OLinuXino:~# find / -iname "*ath9k*"
> 
> >>>> /sys/bus/usb/drivers/ath9k_htc
> 
> >>>> /sys/devices/platform/sw-ehci.1/usb2/2-1/2-1:1.0/leds/ath9k_htc-phy1
> 
> >>>> /sys/class/leds/ath9k_htc-phy1
> 
> >>>> /sys/module/ath/holders/ath9k_common
> 
> >>>> /sys/module/ath/holders/ath9k_htc
> 
> >>>> /sys/module/ath/holders/ath9k_hw
> 
> >>>> /sys/module/ath9k_common
> 
> >>>> /sys/module/ath9k_common/holders/ath9k_htc
> 
> >>>> /sys/module/mac80211/holders/ath9k_htc
> 
> >>>> /sys/module/ath9k_htc
> 
> >>>> /sys/module/ath9k_htc/drivers/usb:ath9k_htc
> 
> >>>> /sys/module/ath9k_hw
> 
> >>>> /sys/module/ath9k_hw/holders/ath9k_common
> 
> >>>> /sys/module/ath9k_hw/holders/ath9k_htc
> 
> >>>> /lib/modules/3.4.67+/kernel/drivers/net/wireless/ath/ath9k
> 
> >>>> /lib/modules/3.4.67+/kernel/drivers/net/wireless/ath/ath9k/ath9k_common.ko
> 
> >>>> /lib/modules/3.4.67+/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
> 
> >>>> /lib/modules/3.4.67+/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
> 
> >>>> /lib/modules/3.4.67+/kernel/drivers/net/wireless/ath/ath9k/ath9k_hw.ko
> 
> >>>>
> 
> >>>>
> 
> >>>> So I guess cfg80211 is supposed to be present in my /lib/modules directory.
> 
> >>> You wouldn't have the /sys/module cfg80211 entries if it wasn't
> 
> >>> present - ath9k_htc simply won't work without it. I'm guessing it's
> 
> >>> built in.
> 
> >>>
> 
> >>> I suspect it's something else.
> 
> >>>
> 
> >>> Do other devices work on that USB port? What happens if you plug it in
> 
> >>> after it's booted?
> 
> >>>
> 
> >>> Also, you should be using the iw command ("iw dev wlan9 scan") not
> 
> >>> iwlist. Make sure you have the "iw" package installed.
> 
> >>>
> 
> >>> Finally, scanning doesn't always work first time (i.e. the device is
> 
> >>> busy doing something else) and it doesn't work before you configure it
> 
> >>> up ("ifconfig wlan9 up") so try it a couple of times before calling it
> 
> >>> completely broken.
> 
> >>>
> 
> >>> Thanks,
> 
> >>>
> 
> >>
> 
> >> I use as well a RT5370 based wifi card and external USB HDD without any
> 
> >> issue.
> 
> >> I played around plugging and unplugging the device, but ifconfig ends up
> 
> >> freezing. I attached dmesg output with probably interesting information,
> 
> >> timeouts everywhere.
> 
> >>
> 
> >> After a reboot, if I plug the device, it gets correctly detected, and I
> 
> >> can bring it up, then I tried :
> 
> >>
> 
> >> root@a20-OLinuXino:~# iw dev wlan9 scan
> 
> >> command failed: Network is down (-100)
> 
> >> root@a20-OLinuXino:~# ifconfig wlan9 up
> 
> >> root@a20-OLinuXino:~# iw dev wlan9 scan
> 
> >> scan aborted!
> 
> >> root@a20-OLinuXino:~# ifconfig wlan9 up
> 
> >> root@a20-OLinuXino:~# iw dev wlan9 scan
> 
> >> ^C
> 
> >> root@a20-OLinuXino:~# iw dev wlan9 scan
> 
> >> command failed: Device or resource busy (-16)
> 
> >> root@a20-OLinuXino:~# iw dev wlan9 scan
> 
> >> command failed: Device or resource busy (-16)
> 
> >> root@a20-OLinuXino:~# iw dev wlan9 scan
> 
> >> command failed: Device or resource busy (-16)
> 
> >>
> 
> >>
> 
> >> When "scan aborted!" appears, dmesg shows at the same time :
> 
> >>
> 
> >> Jul 31 14:58:54 a20-OLinuXino kernel: [  152.493643] ehci_irq: port
> 
> >> change detect
> 
> >> Jul 31 14:58:54 a20-OLinuXino kernel: [  152.503192] hub 2-0:1.0: port 1
> 
> >> disabled by hub (EMI?), re-enabling...
> 
> >> Jul 31 14:58:54 a20-OLinuXino kernel: [  152.513886] usb 2-1: USB
> 
> >> disconnect, device number 2
> 
> >> Jul 31 14:58:56 a20-OLinuXino kernel: [  154.386911] ath: phy0: Chip
> 
> >> reset failed
> 
> >> Jul 31 14:58:56 a20-OLinuXino kernel: [  154.396668] ath: phy0: Unable
> 
> >> to reset channel (2412 Mhz) reset status -22
> 
> >> Jul 31 14:58:56 a20-OLinuXino kernel: [  154.412196] ath: phy0: Unable
> 
> >> to set channel
> 
> >> Jul 31 14:58:56 a20-OLinuXino kernel: [  154.532207] ath: phy0: Chip
> 
> >> reset failed
> 
> >> Jul 31 14:58:56 a20-OLinuXino kernel: [  154.542586] ath: phy0: Unable
> 
> >> to reset hardware; reset status -22 (freq 2422 MHz)
> 
> >> Jul 31 14:58:56 a20-OLinuXino kernel: [  154.671860] ath: phy0: Failed
> 
> >> to wakeup in 500us
> 
> >> Jul 31 14:58:56 a20-OLinuXino kernel: [  154.697274] ath: phy0: Failed
> 
> >> to wakeup in 500us
> 
> >> Jul 31 14:58:57 a20-OLinuXino kernel: [  154.721561] ath: phy0: Failed
> 
> >> to wakeup in 500us
> 
> >> Jul 31 14:58:57 a20-OLinuXino kernel: [  154.993220] usb 2-1: ath9k_htc:
> 
> >> USB layer deinitialized
> 
> >> Jul 31 14:58:57 a20-OLinuXino kernel: [  155.278312] usb 2-1: new
> 
> >> high-speed USB device number 3 using sw-ehci
> 
> >> Jul 31 14:58:57 a20-OLinuXino kernel: [  155.460699] usb 2-1: ath9k_htc:
> 
> >> Firmware htc_9271.fw requested
> 
> >> Jul 31 14:58:58 a20-OLinuXino kernel: [  155.782216] usb 2-1: ath9k_htc:
> 
> >> Transferred FW: htc_9271.fw, size: 51008
> 
> >> Jul 31 14:58:58 a20-OLinuXino kernel: [  156.032307] ath9k_htc 2-1:1.0:
> 
> >> ath9k_htc: HTC initialized with 33 credits
> 
> >> Jul 31 14:58:58 a20-OLinuXino kernel: [  156.262060] ath9k_htc 2-1:1.0:
> 
> >> ath9k_htc: FW Version: 1.4
> 
> >> Jul 31 14:58:58 a20-OLinuXino kernel: [  156.270467] ath: EEPROM
> 
> >> regdomain: 0x833a
> 
> >> Jul 31 14:58:58 a20-OLinuXino kernel: [  156.279670] ath: EEPROM
> 
> >> indicates we should expect a country code
> 
> >> Jul 31 14:58:58 a20-OLinuXino kernel: [  156.290086] ath: doing EEPROM
> 
> >> country->regdmn map search
> 
> >> Jul 31 14:58:58 a20-OLinuXino kernel: [  156.299279] ath: country maps
> 
> >> to regdmn code: 0x37
> 
> >> Jul 31 14:58:58 a20-OLinuXino kernel: [  156.307499] ath: Country alpha2
> 
> >> being used: GB
> 
> >> Jul 31 14:58:58 a20-OLinuXino kernel: [  156.314466] ath: Regpair used: 0x37
> 
> >> Jul 31 14:58:58 a20-OLinuXino kernel: [  156.337430] ieee80211 phy1:
> 
> >> Atheros AR9271 Rev:1
> 
> >> Jul 31 14:58:58 a20-OLinuXino kernel: [  156.352292] Registered led
> 
> >> device: ath9k_htc-phy1
> 
> >> Jul 31 14:59:11 a20-OLinuXino kernel: [  169.356075]
> 
> >> ADDRCONF(NETDEV_UP): wlan9: link is not ready
> 
> >>
> 
> >>
> 
> >> At this point all network commands are locked. Unplugging et replugging
> 
> >> won't change anything. Even rebooting seems to hang, unfortunately I
> 
> >> don't have a screen to follow what's going on.
> 
> >>
> 
> >> Thanks for the advice about iwlist, indeed "iw dev" gave me a good scan,
> 
> >> once. Actually I didn't manage to make it work again.
> 
> > 
> 
> > This really looks like a hardware issue. Maybe your ath9k_htc device
> 
> > is particularly sensitive to power supply noise or something like
> 
> > that. Have you tried a different power supply or connecting it through
> 
> > a powered hub?
> 
> 
> 
> That can be an issue. After firmware is loaded power consumption goes
> 
> from 30mA to 100-200mA. If it won't get enough power, then it will get
> 
> strange issues. Second problem is noise on data or power lines. It
> 
> depend on circuit design, cable and so on. Some users reported similar
> 
> issues which was fixed after cable change.
> 
> 
> 
> > I really wish I could help out more with this =)
> 
> > 
> 
> > I'd be surprised if it's a software issue, but if you're compiling
> 
> > your own kernels, it might be worth checking out the Linux Backports
> 
> > project:
> 
> > 
> 
> > https://backports.wiki.kernel.org/index.php/Main_Page
> 
> > 
> 
> > Which is essentially the latest kernel's WiFi drivers and stuff
> 
> > repackaged so it can be compiled with older kernels.
> 
> 
> 
> Yea... i will not continue this discussion untill you get updated driver.
> 
> 
> 
> -- 
> 
> Regards,
> 
> Oleksij

I already am on the latest firmware. But, we can stop all this. Self-powered hub did the trick! The funny thing is that I already tried with the hub and as far as I remember didn't change much. 
Anyway, thank you very much for your time and your sharp eye Julian. Indeed this was hardware related. 

Thank you all,
Steven

------=_Part_45_150724646.1406878606880--
