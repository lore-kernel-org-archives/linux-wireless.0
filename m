Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:57304 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162Ab2A2Rfn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jan 2012 12:35:43 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Drivers that use synchronous firmware loading
References: <4F24BF84.1020209@lwfinger.net>
Date: Sun, 29 Jan 2012 19:35:38 +0200
In-Reply-To: <4F24BF84.1020209@lwfinger.net> (Larry Finger's message of "Sat,
	28 Jan 2012 21:39:48 -0600")
Message-ID: <87mx96csyd.fsf@purkki.adurom.net> (sfid-20120129_183611_463706_0369F636)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> To all wireless developers:
>
> As you may have noticed, the udev layer is being changed. One of the
> side effects is that the kernel may timeout when a driver uses
> synchronous firmware loading. My rtlwifi drivers were affected, and a
> kernel bugzilla has been logged against rtl8192se. I suggest that the
> maintainers should be proactive, and convert to asynchronous loading
> as soon as possible.

Thanks for the summary, this was really useful.

> In wireless-testing, the files listed below contain calls to
> read_firmware() rather than read_firmware_nowait():
>
> drivers/net/wireless/at76c50x-usb.c
> drivers/net/wireless/ath/ath6kl/init.c
> drivers/net/wireless/ath/ath9k/hif_usb.c
> drivers/net/wireless/atmel.c
> drivers/net/wireless/b43/main.c
> drivers/net/wireless/b43legacy/main.c
> drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
> drivers/net/wireless/ipw2x00/ipw2100.c
> drivers/net/wireless/iwlegacy/3945-mac.c
> drivers/net/wireless/iwlegacy/4965-mac.c
> drivers/net/wireless/iwlwifi/iwl-agn.c
> drivers/net/wireless/libertas/main.c
> drivers/net/wireless/libertas/if_usb.c
> drivers/net/wireless/libertas_tf/if_usb.c
> drivers/net/wireless/mwifiex/main.c
> drivers/net/wireless/mwl8k.c
> drivers/net/wireless/orinoco/fw.c
> drivers/net/wireless/orinoco/orinoco_usb.c
> drivers/net/wireless/p54/p54spi.c
> drivers/net/wireless/p54/p54usb.c
> drivers/net/wireless/p54/p54pci.c
> drivers/net/wireless/prism54/islpci_dev.c
> drivers/net/wireless/rt2x00/rt2x00firmware.c
> drivers/net/wireless/wl1251/main.c
> drivers/net/wireless/zd1201.c
> drivers/net/wireless/zd1211rw/zd_usb.c
>
> Some of the drivers above may be exempt as their firmware is built
> into the kernel. I did not check for that case.

But isn't the issue only when a firmware is requested synchronously
during module init? For example, IIRC wl1251 loads the module during
hw start and that should be safe, even when making a synchronous call.
Or did I misunderstood something?

-- 
Kalle Valo
