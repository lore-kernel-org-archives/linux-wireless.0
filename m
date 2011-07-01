Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59157 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab1GAOBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 10:01:20 -0400
Received: by wwe5 with SMTP id 5so3268848wwe.1
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jul 2011 07:01:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110701133553.GA7125@alittletooquiet.net>
References: <20110701133553.GA7125@alittletooquiet.net>
Date: Fri, 1 Jul 2011 19:31:18 +0530
Message-ID: <BANLkTikByepHZoEE2b65CrgUmpBmcxiTgw@mail.gmail.com> (sfid-20110701_160123_573006_15CFDEEA)
Subject: Re: ath9k_htc fails to initialize TL-WN721N with compat-wireless 3.0-rc4-1
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Forest Bond <forest@alittletooquiet.net>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 1, 2011 at 7:05 PM, Forest Bond <forest@alittletooquiet.net> wrote:
> Hi,
>
> I am running compat-wireless 3.0-rc4-1 on an Ubuntu 8.04 (Hardy) system with
> Ubuntu kernel version 2.6.24-21-generic.  Yes, I know this kernel version is
> ancient, but that's what c-w is for, right? ;)
>
> First, I should mention that had to apply this patch for c-w to build:
>
>  http://permalink.gmane.org/gmane.linux.kernel.wireless.general/72402
>
> I also ran into problems because the c-w Makefile installs the udev
> compat_firmware rules file into /lib/udev/rules.d, which is not a supported
> location on Hardy.  Moving the rules file to /etc/udev/rules.d solved that.
>
> Now the module loads fine and appears to load the firmware correctly, but the
> interface never comes up.  Here's what happens when I insert the device:
>
> [  206.270348] usb 5-7: new high speed USB device using ehci_hcd and address 5
> [  206.422393] usb 5-7: configuration #1 chosen from 1 choice
> [  206.657723] Compat-wireless backport release: compat-wireless-v3.0-rc4-1
> [  206.657732] Backport based on linux-2.6-allstable.git v3.0-rc4
> [  206.864667] Calling CRDA to update world regulatory domain
> [  207.714633] usb 5-7: ath9k_htc: Transferred FW: htc_9271.fw, size: 51288
> [  207.861037] ath9k_htc 5-7:1.0: ath9k_htc: HTC initialized with 33 credits
>
> At this point the interface is not visible in the output of ifconfig.  Something
> has gone wrong with USB, because lsusb hangs until I unplug the device, at which
> point I see the following in dmesg:
>
> [  225.464212] usb 5-7: USB disconnect, address 5
> [  225.592282] ath: Reading Magic # failed
> [  225.592310] ath: no band has been marked as supported in EEPROM
> [  225.592315] ath: Unable to initialize hardware; initialization status: -22
> [  225.592321] ath: Unable to initialize hardware; initialization status: -22
> [  225.592336] Failed to initialize the device
> [  225.592400] ath9k_htc: probe of 5-7:1.0 failed with error -22
> [  225.712249] usbcore: registered new interface driver ath9k_htc

something wrong in reading EEPROM, please post the kernel log for
sudo modprobe ath9k_htc debug debug=0x404

make sure to enable CONFIG_ATH_DEBUG and ATH9K_HTC_DEBUGFS
http://wireless.kernel.org/en/users/Drivers/ath9k/debug

was this previously working?

>
> There are several variations on this depending on how long I leave the device
> plugged in.  Eventually lsusb runs fine in some cases, and I have seen the
> interface come up once, but I did not test functionality and I haven't been able
> to easily repeat that scenario.
>
> What can I do to debug?
>
> Thanks,
> Forest
> --
> Forest Bond
> http://www.alittletooquiet.net
> http://www.rapidrollout.com
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iEYEARECAAYFAk4NzTkACgkQRO4fQQdv5Ay4aACbBkvIjx+4PB5TlADJlcGMGcGe
> TYwAnjiVA65h6MubxeVc7i7bN8QlzoRM
> =Vo6s
> -----END PGP SIGNATURE-----
>
>



-- 
shafi
