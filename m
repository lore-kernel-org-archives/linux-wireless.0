Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61512 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab2A2Djw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 22:39:52 -0500
Received: by yenm6 with SMTP id m6so1358578yen.19
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jan 2012 19:39:51 -0800 (PST)
Message-ID: <4F24BF84.1020209@lwfinger.net> (sfid-20120129_043956_251185_D102441D)
Date: Sat, 28 Jan 2012 21:39:48 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: Drivers that use synchronous firmware loading
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To all wireless developers:

As you may have noticed, the udev layer is being changed. One of the side 
effects is that the kernel may timeout when a driver uses synchronous firmware 
loading. My rtlwifi drivers were affected, and a kernel bugzilla has been logged 
against rtl8192se. I suggest that the maintainers should be proactive, and 
convert to asynchronous loading as soon as possible.

In wireless-testing, the files listed below contain calls to read_firmware() 
rather than read_firmware_nowait():

drivers/net/wireless/at76c50x-usb.c
drivers/net/wireless/ath/ath6kl/init.c
drivers/net/wireless/ath/ath9k/hif_usb.c
drivers/net/wireless/atmel.c
drivers/net/wireless/b43/main.c
drivers/net/wireless/b43legacy/main.c
drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
drivers/net/wireless/ipw2x00/ipw2100.c
drivers/net/wireless/iwlegacy/3945-mac.c
drivers/net/wireless/iwlegacy/4965-mac.c
drivers/net/wireless/iwlwifi/iwl-agn.c
drivers/net/wireless/libertas/main.c
drivers/net/wireless/libertas/if_usb.c
drivers/net/wireless/libertas_tf/if_usb.c
drivers/net/wireless/mwifiex/main.c
drivers/net/wireless/mwl8k.c
drivers/net/wireless/orinoco/fw.c
drivers/net/wireless/orinoco/orinoco_usb.c
drivers/net/wireless/p54/p54spi.c
drivers/net/wireless/p54/p54usb.c
drivers/net/wireless/p54/p54pci.c
drivers/net/wireless/prism54/islpci_dev.c
drivers/net/wireless/rt2x00/rt2x00firmware.c
drivers/net/wireless/wl1251/main.c
drivers/net/wireless/zd1201.c
drivers/net/wireless/zd1211rw/zd_usb.c

Some of the drivers above may be exempt as their firmware is built into the 
kernel. I did not check for that case.

When your driver loads only a single firmware file, the procedure is relatively 
easy. I copied the flow used in iwlagn. In the firmware callback routine, the 
kernel has loaded a copy of the firmware file. All you need to do is copy that 
info into the driver's cached version of the firmware and free the kernel's 
copy. Once the firmware is loaded, then start mac80211 with the 
ieee80211_register_hw() call.

One additional step is to create a completion queue entry, that is initialized 
in the probe routine. Once the firmware callback routine is entered, then you 
call the complete() routine for that queue, and check for completion before the 
driver is unloaded. This way, the case where the driver is unloaded while a 
callback is pending is prevented.

I am currently working on b43legacy, which loads 4 different firmware files. 
Using only a single callback routine is proving to be a little difficult, but I 
hope to find a way to handle this case as well. Once I have b43legacy solved, 
b43 will be easy.

Thanks,

Larry
