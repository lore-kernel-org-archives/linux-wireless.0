Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:56505 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750996Ab2A3HBu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 02:01:50 -0500
Received: by lahi5 with SMTP id i5so1487259lah.4
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jan 2012 23:01:38 -0800 (PST)
Subject: Re: Drivers that use synchronous firmware loading
From: Luciano Coelho <coelho@ti.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kvalo@adurom.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4F25894C.9080206@lwfinger.net>
References: <4F24BF84.1020209@lwfinger.net>
	 <87mx96csyd.fsf@purkki.adurom.net>  <4F25894C.9080206@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Jan 2012 09:01:34 +0200
Message-ID: <1327906894.3626.30.camel@cumari> (sfid-20120130_080154_426223_D1E9B18B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-01-29 at 12:00 -0600, Larry Finger wrote: 
> On 01/29/2012 11:35 AM, Kalle Valo wrote:
> > Larry Finger<Larry.Finger@lwfinger.net>  writes:
> >
> >> To all wireless developers:
> >>
> >> As you may have noticed, the udev layer is being changed. One of the
> >> side effects is that the kernel may timeout when a driver uses
> >> synchronous firmware loading. My rtlwifi drivers were affected, and a
> >> kernel bugzilla has been logged against rtl8192se. I suggest that the
> >> maintainers should be proactive, and convert to asynchronous loading
> >> as soon as possible.
> >
> > Thanks for the summary, this was really useful.
> >
> >> In wireless-testing, the files listed below contain calls to
> >> read_firmware() rather than read_firmware_nowait():
> >>
> >> drivers/net/wireless/at76c50x-usb.c
> >> drivers/net/wireless/ath/ath6kl/init.c
> >> drivers/net/wireless/ath/ath9k/hif_usb.c
> >> drivers/net/wireless/atmel.c
> >> drivers/net/wireless/b43/main.c
> >> drivers/net/wireless/b43legacy/main.c
> >> drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> >> drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
> >> drivers/net/wireless/ipw2x00/ipw2100.c
> >> drivers/net/wireless/iwlegacy/3945-mac.c
> >> drivers/net/wireless/iwlegacy/4965-mac.c
> >> drivers/net/wireless/iwlwifi/iwl-agn.c
> >> drivers/net/wireless/libertas/main.c
> >> drivers/net/wireless/libertas/if_usb.c
> >> drivers/net/wireless/libertas_tf/if_usb.c
> >> drivers/net/wireless/mwifiex/main.c
> >> drivers/net/wireless/mwl8k.c
> >> drivers/net/wireless/orinoco/fw.c
> >> drivers/net/wireless/orinoco/orinoco_usb.c
> >> drivers/net/wireless/p54/p54spi.c
> >> drivers/net/wireless/p54/p54usb.c
> >> drivers/net/wireless/p54/p54pci.c
> >> drivers/net/wireless/prism54/islpci_dev.c
> >> drivers/net/wireless/rt2x00/rt2x00firmware.c
> >> drivers/net/wireless/wl1251/main.c
> >> drivers/net/wireless/zd1201.c
> >> drivers/net/wireless/zd1211rw/zd_usb.c
> >>
> >> Some of the drivers above may be exempt as their firmware is built
> >> into the kernel. I did not check for that case.
> >
> > But isn't the issue only when a firmware is requested synchronously
> > during module init? For example, IIRC wl1251 loads the module during
> > hw start and that should be safe, even when making a synchronous call.
> > Or did I misunderstood something?
> 
> As I understand the situation, if userland is running when the firmware is 
> requested synchronously, then the request should be OK. Certainly, when firmware 
> loading is triggered from the probe routine, it will cause trouble.
> 
> I was just contacted this morning about problems with r8712u on Arch Linux. 
> Another driver for me to fix.

I echo Kalle's thanks for this summary.

As Kalle said, I think wl1251 is fine.  It doesn't request any firmware
during the probe path, only when the interface is brought up.

In wl12xx, though, we have a problem.  We request the *firmware* also
when the interface is brought up, but we get the "NVS file" (which
contains the MAC address) during probe.  That must be fixed and is in my
TODO list.

-- 
Cheers,
Luca.

