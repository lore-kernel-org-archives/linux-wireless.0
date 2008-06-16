Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:25791 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbYFPGJF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 02:09:05 -0400
Received: by rv-out-0506.google.com with SMTP id k40so3410403rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 15 Jun 2008 23:09:05 -0700 (PDT)
Message-ID: <eaf2efa20806152309o342d0a0cs31e73dff3ba3d947@mail.gmail.com> (sfid-20080616_093322_686328_46EEF425)
Date: Mon, 16 Jun 2008 15:09:05 +0900
From: "Mark Roberts" <mroberts1839@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: Problem with master mode on BCM4318
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1213587639.2469.10.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <eaf2efa20806152024i510ea7auc9aba61b68598ec0@mail.gmail.com>
	 <1213587639.2469.10.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> You didn't write anything about the procedure you used to install the
> firmware, so it impossible for others to see what was wrong with it.
> Perhaps you should find where the original firmware is installed, move
> it away and make sure the new firmware appears there if you install it.

Thanks for your message and sorry to be inexact.

Following your suggestion, I've removed /lib/firmware/b43 and
/lib/firmware/b43legacy and reinstalled the firmware.

I am running 2.6.24-18-generic, so I have followed this procedure, as
described at http://www.linuxwireless.org/en/users/Drivers/b43 :

  wget http://bu3sch.de/b43/fwcutter/b43-fwcutter-011.tar.bz2
  tar xjf b43-fwcutter-011.tar.bz2
  cd b43-fwcutter-011
  make
  cd ..
  export FIRMWARE_INSTALL_DIR="/lib/firmware"
  wget http://downloads.openwrt.org/sources/broadcom-wl-4.80.53.0.tar.bz2
  tar xjf broadcom-wl-4.80.53.0.tar.bz2
  cd broadcom-wl-4.80.53.0/kmod
  sudo ../../b43-fwcutter-011/b43-fwcutter -w "$FIRMWARE_INSTALL_DIR" wl_apsta.o

After doing this, I checked /lib/firmware and found a new diectory
"b43" that contains the firmware, as expected.

Next, I did the following to build, install, and load the new wireless
module, as described at
http://www.linuxwireless.org/en/users/Download:

  wget http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2
  cd compat-wireless-2008-06-15
  make

During the make, I see the following warnings.

  /home/mroberts/Install/compat-wireless-2008-06-15/config.mk:48:
"WARNING: You are running a kernel >= 2.6.23, you should enable in it
CONFIG_NETDEVICES_MULTIQUEUE for 802.11[ne] support"

Next, I did the following to install the code:

  sudo make install

And I see the following messages, mixed in with a bunch of stuff from make:

  Module ath5k not detected -- this is fine
  Enabling ath_pci ...	[OK]	Module enabled:
  /lib/modules/2.6.24-18-generic/madwifi/ath_pci.ko
  Disabling b43 ...	[OK]	Module disabled:
  /lib/modules/2.6.24-18-generic/kernel/drivers/net/wireless/b43/b43.ko
  Disabling b43legacy ...	[OK]	Module disabled:
  /lib/modules/2.6.24-18-generic/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
  Enabling bcm43xx ...	[OK]	Module enabled:
  /lib/modules/2.6.24-18-generic/kernel/drivers/net/wireless/bcm43xx/bcm43xx.ko

  Your old wireless subsystem modules were left intact:

  [...]

  Note: madwifi detected, we're going to disable it. If you would like
to enable it later you can run:
    sudo athenable madwifi

  Running athenable ath5k...
  Disabling ath_pci ...	[OK]	Module disabled:
  /lib/modules/2.6.24-18-generic/madwifi/ath_pci.ko

Next, I did "sudo make load" and am told:

  [...]

  Disabling bcm43xx ...	[OK]	Module disabled:
  /lib/modules/2.6.24-18-generic/kernel/drivers/net/wireless/bcm43xx/bcm43xx.ko
  Enabling b43 ...	[OK]	Module renamed but another module file is
being preferred
  Renamed module:		/lib/modules/2.6.24-18-generic/kernel/drivers/net/wireless/b43/b43.ko
  Preferred module:	/lib/modules/2.6.24-18-generic/updates/drivers/net/wireless/b43/b43.ko
  Enabling b43legacy ...	[OK]	Module renamed but another module file
is being preferred
  Renamed module:		/lib/modules/2.6.24-18-generic/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
  Preferred module:	/lib/modules/2.6.24-18-generic/updates/drivers/net/wireless/b43legacy/b43legacy.ko
  b43 loaded successfully
  b43legacy loaded successfully

At this point, I try "sudo iwconfig wlan0 mode master" and I get the
same error as before:

  Error for wireless request "Set Mode" (8B06) :
    SET failed on device wlan0 ; Invalid argument.

If I try "dmesg", I get this:

  [14179.361761] ssb: Sonics Silicon Backplane found on PCI device 0000:04:05.0
  [14179.374306] b43-phy0: Broadcom 4318 WLAN found
  [14179.442440] phy0: Selected rate control algorithm 'pid'
  [14179.442955] Broadcom 43xx driver loaded [ Features: PMLR,
Firmware-ID: FW13 ]
  [14179.462153] Broadcom 43xx-legacy driver loaded [ Features: PID,
Firmware-ID: FW10 ]
  [14179.549440] input: b43-phy0 as /devices/virtual/input/input9
  [14179.809010] b43-phy0: Loading firmware version 351.126
(2006-07-29 05:54:02)
  [14179.809020] b43-phy0 warning: You are using an old firmware
image. Support for old firmware will be removed in July 2008.
  [14179.809025] b43-phy0 warning: You must go to
http://linuxwireless.org/en/users/Drivers/b43#devicefirmware and
download the latest firmware (version 4).
  [14179.926567] Registered led device: b43-phy0::tx
  [14179.926795] Registered led device: b43-phy0::rx
  [14179.926968] Registered led device: b43-phy0::radio
  [14179.974357] ADDRCONF(NETDEV_UP): wlan0: link is not ready
  [14180.759583] wlan0: Initial auth_alg=0
  [14180.759592] wlan0: authenticate with AP 00:11:24:07:bd:99
  [14180.761280] wlan0: RX authentication from 00:11:24:07:bd:99
(alg=0 transaction=2 status=0)
  [14180.761285] wlan0: authenticated
  [14180.761289] wlan0: associate with AP 00:11:24:07:bd:99
  [14180.763328] wlan0: RX AssocResp from 00:11:24:07:bd:99
(capab=0x11 status=0 aid=3)
  [14180.763334] wlan0: associated
  [14180.763350] wlan0: CTS protection enabled (BSSID=00:11:24:07:bd:99)
  [14180.764907] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
  [14191.736155] wlan0: no IPv6 routers present

Again, there is a complaint about the firmware, which I don't understand.

Now what?

M
