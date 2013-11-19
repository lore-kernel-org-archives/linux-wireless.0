Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:52138 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab3KSST6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 13:19:58 -0500
Received: by mail-ie0-f177.google.com with SMTP id tp5so4536656ieb.36
        for <linux-wireless@vger.kernel.org>; Tue, 19 Nov 2013 10:19:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAM9fjH5vXGOsoQaJrU_Ezx9L0iHYYAqD=jMB050-=uwnPMVLMw@mail.gmail.com>
References: <CAM9fjH52HZ=quNrzTeqkzNuCQTSxMs5DmAJAk+2Xnv+2m2aPZQ@mail.gmail.com>
	<CAM9fjH5vXGOsoQaJrU_Ezx9L0iHYYAqD=jMB050-=uwnPMVLMw@mail.gmail.com>
Date: Tue, 19 Nov 2013 10:19:58 -0800
Message-ID: <CAM9fjH4CzsCMbAyJ8qucUc1+fFFMeSA87JWWPiqD7L6-1Cg7aw@mail.gmail.com> (sfid-20131119_192002_613508_F243FA16)
Subject: Re: WL1271 + recent compat/backports + calibrator?
From: Kyle Manna <2bluesc@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I succeed in resolving this issue and figured I'd share my findings to
help others.

There are some bugs in the calibrator when used against more recent
versions of the wl12xx driver.  It appears that loading the wl12xx
module brought the interface "up" in the past and doesn't anymore
before setting the PLT power_mode to on.  The result would be some
error about inability to set power mode. Running a manual calibration
with properly bringing the interface up followed by setting the PLT
power_mode fixed this.

Another issue was with Bluetooth subsystem interrupting calibration
with the non-obvious "radio status (-36)" calibration failure.  If I
explicitly disable bluetooth (using the BT_EN GPIO which I've
implemented via rfkill) calibration succeeds. The check of the radio
status was added in more recent wl12xx kernels and may have been
causing un-detected problems in earlier releases.

In a nutshell the wl12xx calibration procedure works fine on an 3.0.x
kernel + backports-3.12.1 and I'm happy.

Approximate calibration procedure for me:

rmmod wl12xx
calibrator set ref_nvs /data/TQS_S_2.6_WG7310_WG7311_NLCP.INI
/etc/firmware/ti-connectivity/wl1271-nvs.bin
calibrator set nvs_mac /etc/firmware/ti-connectivity/wl1271-nvs.bin
aa:bb:cc::dd:ee::ff
insmod /system/lib/modules/wl12xx.ko
sleep 1

# Bluetooth/hci interfers with calibration with radio_status=-36 or
radio_status=-45
# stop hciattach
echo 1 > /sys/class/rfkill/rfkill0/soft
ip link set wlan0 down # Needs to be down for power_mode on to work
calibrator dev wlan0 plt power_mode on
calibrator dev wlan0 plt tune_channel 0 7
calibrator dev wlan0 plt nvs_ver 0403
calibrator dev wlan0 plt tx_bip 1 0 0 0 0 0 0 0
/factory/firmware/ti-connectivity/wl1271-nvs.bin
calibrator dev wlan0 plt power_mode off

- Kyle

On Wed, Nov 13, 2013 at 4:38 PM, Kyle Manna <2bluesc@gmail.com> wrote:
>
> It's also worth noting that the old OpenLink tag "ol_R5.SP4.01" does
> succeed with calibration:
>
> # ./calibrator plt autocalibrate wlan0
> /system/lib/modules/wl12xx_sdio.ko
> /data/TQS_S_2.6_WG7310_WG7311_NLCP.INI
> /factory/firmware/ti-connectivity/wl1271-nvs.bin 00:00:00:00:00:00
>
> Using nvs version 2.1
> Calibrate /factory/firmware/ti-connectivity/wl1271-nvs.bin
> Writing calibration data to /factory/firmware/ti-connectivity/wl1271-nvs.bin
> Writing mac address 00:00:00:00:00:00 to file
> /factory/firmware/ti-connectivity/wl1271-nvs.bin
> Calibration done. FEM1 has 1 bands. AutoFEM is off. Resulting nvs is
> /factory/firmware/ti-connectivity/wl1271-nvs.bin
>
>
>
> Base tree version: ol_R5.SP4.01-2-g1aa2c8e
> compat-wireless release: ol_R5.SP6.01
>
>
> - Kyle
>
>
> On Wed, Nov 13, 2013 at 4:08 PM, Kyle Manna <2bluesc@gmail.com> wrote:
> > Hi all,
> >
> > I'm running a WL1271L (on Android + v3.0 kernel) and am trying to find
> > an up to date compat/backports package (want upstream bug fixes +
> > bluetooth stack with better BLE support) + the ability to properly
> > calibrate the chip.
> >
> > I'm able to use newer wlcore architecture + a number of patches to
> > bridge the platform configuration gaps and am getting the code
> > fromgithub.com/TI-OpenLink/{compat,compat-wireless,wl18xx} on the
> > ol_r8.a7.02 tag, BLE works, WiFi works (using 6.3.10.0.133 firmware),
> > however the calibrator (v0.73) reports:
> >
> > root@android:/data # ip link set wlan0 down
> > root@android:/data # ./calibrator dev wlan0 plt power_mode off
> > 240|root@android:/data # ./calibrator plt calibrate
> > Unknown arch. Not setting nvs ver 2.1Calibrate ./new-nvs.bin
> > Fail to calibrate ith radio status (-36)
> >
> > I'm able to enter PLT mode without issue, kernel message buffer:
> >
> > [ 3276.057434] wlcore: power up
> > [ 3276.528961] wlcore: firmware booted in PLT mode PLT_ON (PLT 6.3.10.0.133)
> >
> > Ideally I'd like to just use the upstream backports drivers from
> > backports.wiki.kernel.org and avoid the TI repos as they seem rather
> > turbulent.  I've succeeded in getting v3.12.1
> > (www.kernel.org/pub/linux/kernel/projects/backports/stable/v3.12/backports-3.12-1.tar.bz2)
> >  which does approximately the same thing:
> >
> > root@android:/data # ./calibrator plt calibrate
> > Unknown arch. Not setting nvs ver 2.1Calibrate ./new-nvs.bin
> > Writing calibration data to ./new-nvs.bin
> > File ./new-nvs.bin not exists
> > Fail to prepare calibrated NVS file
> >
> > root@android:/data # dmesg | tail
> > [  292.573638] wlcore: power up
> > [  293.024566] wlcore: firmware booted in PLT mode PLT_ON (PLT 6.3.10.0.133)
> > [  293.074676] wlcore: testmode cmd: radio status=0
> > [  293.075103] wlcore: power down
> >
> >
> > This leads me to some questions:
> >
> > 1) My understanding is that calibration tunes only the power
> > amplifiers, does anyone know how big of an effect this has?  Is
> > figuring out the calibration worth spending time on it?
> > 2) Has the firmware changed to potentially auto-calibrate as the new
> > wl18xx/WiLink8 devices do?  I can't find any real changelogs on the
> > firmware that gets loaded.
> > 3) Any other advice before I jump in to debugging the netlink +
> > calibration procedure?
> >
> > Thanks,
> > - Kyle
