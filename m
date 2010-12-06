Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60492 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab0LFPdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 10:33:10 -0500
Received: by fxm20 with SMTP id 20so4292593fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 07:33:09 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Wade Fitzpatrick <wade.fitzpatrick@gmail.com>
Subject: Re: ar9170usb slow / poor performance
Date: Mon, 6 Dec 2010 16:32:52 +0100
Cc: linux-wireless@vger.kernel.org
References: <4CFCA416.1010505@gmail.com> <201012061414.27159.chunkeey@googlemail.com> <4CFCFD6A.8040700@gmail.com>
In-Reply-To: <4CFCFD6A.8040700@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201012061632.52375.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 06 December 2010 16:12:42 Wade Fitzpatrick wrote:
> Thanks for the response, Christian. Here is what I am seeing now, using 
> ar9170usb from compat-wireless (2010_12_02):
what happened to carl9170?

> usb 2-5: new high speed USB device using ehci_hcd and address 5
> usb 2-5: reset high speed USB device using ehci_hcd and address 5
> usbcore: registered new interface driver ar9170usb
> arusb_lnx: module is from the staging directory, the quality is unknown, 
> you have been warned.
> arusb - version 0.0.0.999
> usbcore: registered new interface driver Otus
kill otus. Unless you really want it to steal the device.

> ath: EEPROM regdomain: 0x0
> ath: EEPROM indicates default country code should be used
> ath: doing EEPROM country->regdmn map search
> ath: country maps to regdmn code: 0x3a
> ath: Country alpha2 being used: US
> ath: Regpair used: 0x3a
> ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
> Registered led device: ar9170-phy1::tx
> Registered led device: ar9170-phy1::assoc
> usb 2-5: Atheros AR9170 is registered as 'phy1'
> 
> # iw dev wlan0 link
> Connected to 00:22:3f:07:42:f3 (on wlan0)
>          SSID: waddles
>          freq: 2412
>          RX: 2627575 bytes (16028 packets)
>          TX: 127342 bytes (600 packets)
>          signal: -62 dBm
>          tx bitrate: 54.0 MBit/s
> # iw dev wlan1 link
> Connected to 00:22:3f:07:42:f3 (on wlan1)
>          SSID: waddles
>          freq: 2412
>          RX: 6208 bytes (43 packets)
>          TX: 522 bytes (5 packets)
>          signal: -61 dBm
>          tx bitrate: 6.5 MBit/s MCS 0
						^^ again MCS.
	Have you actually patched the driver?

> # iw event -f
> wlan1 (phy #1): deauth 00:22:3f:07:42:f3 -> 00:22:3f:8d:7b:05 reason 2: 
> Previous authentication no longer valid [frame: c0 00 40 01 00 22 3f 8d 
> 7b 05 00 22 3f 07 42 f3 00 22 3f 07 42 f3 70 00 02 00]
> wlan1 (phy #1): disconnected (by AP) reason: 2: Previous authentication 
> no longer valid
> [...]
> wlan1 (phy #1): deauth 00:22:3f:07:42:f3 -> 00:22:3f:8d:7b:05 reason 2: 
> Previous authentication no longer valid [frame: c0 00 40 01 00 22 3f 8d 
> 7b 05 00 22 3f 07 42 f3 00 22 3f 07 42 f3 70 00 02 00]
> wlan1 (phy #1): disconnected (by AP) reason: 2: Previous authentication 
> no longer valid
and? your ap (what is it btw?) has (silently) kicked you...
you would need to put one interface into monitor mode and
sniff what really happens.

> The wlan1 link is unusable. If I create a host route and ping the modem 
> over wlan1, all I get is 'Destination Host Unreachable' messages.
> 
> Note that wlan0 (the RTL8187) also has updated drivers but is stable 
> throughout this.
> 
> Any more suggestions?
again same as before, patch the driver (or migrate to carl9170).
If you are unfamiliar with the procedure you could also
reload mac80211.

modprobe mac80211 ieee80211_default_rc_algo=minstrel
(note, other drivers might depend on mac80211, you have to unload
them first.
	lsmod | grep ^mac80211

will tell you which).

Afterwards, verify that the system really loads the new module.
Or took the new default_rc settings(see
/sys/module/mac80211/parameters/ieee80211_default_rc_algo )

Regards,
	Chr
---
> >---
> > diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
> > index 32bf79e..cb2d1a7 100644
> > --- a/drivers/net/wireless/ath/ar9170/main.c
> > +++ b/drivers/net/wireless/ath/ar9170/main.c
> > @@ -145,7 +145,7 @@ static struct ieee80211_channel ar9170_5ghz_chantable[] = {
> >
> >   #define AR9170_HT_CAP							\
> >   {									\
> > -	.ht_supported	= true,						\
> > +	.ht_supported	= false,					\
> >   	.cap		= IEEE80211_HT_CAP_MAX_AMSDU |			\
> >   			  IEEE80211_HT_CAP_SUP_WIDTH_20_40 |		\
> >   			  IEEE80211_HT_CAP_SGI_40 |			\
> 
