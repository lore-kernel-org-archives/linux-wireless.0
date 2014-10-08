Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbaJHRyi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 13:54:38 -0400
Message-ID: <1412790745.13755.15.camel@dcbw.local> (sfid-20141008_195441_917525_EB634602)
Subject: Re: wl1271 driver on Linux 3.10 for SabreSD
From: Dan Williams <dcbw@redhat.com>
To: CHAUMETTE Hubert <hchaumette@adeneo-embedded.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 08 Oct 2014 12:52:25 -0500
In-Reply-To: <51562649.4716655.1412775436836.JavaMail.zimbra@adeneo-embedded.com>
References: <51562649.4716655.1412775436836.JavaMail.zimbra@adeneo-embedded.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-10-08 at 15:37 +0200, CHAUMETTE Hubert wrote:
> Hi all,
> 
> I need to activate the wl12xx driver (from drivers/net/wireless/ti/) on a (Android) Linux 3.10.31 kernel on an i.MX6Q SabreSD board. The wl1271 is to communicate with the board through an SDIO interface (SD2 on the board).
> 
> I have built the driver modules (cfg80211 and mac80211; wlcore, wlcore_sdio and wl12xx), and insmod'ed them. They are listed by lsmod :
> wlcore_sdio 3820 0 - Live 0x00000000
> wl12xx 51103 0 - Live 0x00000000
> wlcore 161008 1 wl12xx, Live 0x00000000
> mac80211 253798 2 wl12xx,wlcore, Live 0x00000000
> cfg80211 201451 2 wlcore,mac80211, Live 0x00000000
> 
> dmesg shows only a message from cfg80211 (no errors for other modules, when insmod'ed in the right order) :
> cfg80211: Calling CRDA to update world regulatory domain

Does the SDHCI driver recognize the device?  You should see something
like this in 'dmesg':

[78504.888006] sdhci-pci 0000:44:06.1: Will use DMA mode even though HW
doesn't fully claim to support it.
[78536.520725] mmc0: new SDIO card at address 0001
[78536.540309] libertas_sdio: Libertas SDIO driver
[78536.540313] libertas_sdio: Copyright Pierre Ossman

If you don't see "mmc0: new SDIO card..." somewhere, then the wl1271
driver isn't even involved and you need to find out why the SD/MMC layer
can't even see the card.

Once you've got it to the point of the SD/MMC stack finding the driver,
find out the VID/PID of the card (it'll be somewhere
in /sys/bus/sdio/devices/), and make sure that matches what's in the
wl1271 SDIO driver (VID 0x0097 PID 0x4076).  If your device doesn't
match that, add it to wlcore/sdio.c's wl1271_devices array.

Dan

> 1) Can I use /sys/modules/{wlcore,wlcore_sdio,wl12xx}/ to test it ?
> 2) The board uses the device tree to enumerate platform devices. To correctly activate the driver, do I need to add it to the board DT (and a binding to the driver) ?
> 3) The driver is supposed to use a firmware (according to http://wireless.kernel.org/en/users/Drivers/wl12xx), how do I know whether it found it (no kernel log message) (I've put the firmware in /system/etc/firmware/) ?
> 
> Thanks in advance.
> Regards,
> 
> Hubert
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


