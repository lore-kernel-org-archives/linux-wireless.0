Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34089 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaLPTrw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2014 14:47:52 -0500
Received: by mail-pa0-f48.google.com with SMTP id rd3so14696230pab.7
        for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2014 11:47:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <549089B9.6040300@lwfinger.net>
References: <CAD3NH5X-neqP-61kP=C2oNPPJTQNBkarae0rh93Hm4qzdpZRew@mail.gmail.com>
	<549089B9.6040300@lwfinger.net>
Date: Tue, 16 Dec 2014 20:47:51 +0100
Message-ID: <CAD3NH5VFrC-dhY33mXWOdxD5mwCPiFX4f68wr43hxvTcZygBDQ@mail.gmail.com> (sfid-20141216_204757_647465_FAC26B1C)
Subject: Re: mac80211 USB adapters with 5GHz support and SMA antenna
From: Dani Camps <danicamps81@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

Linux drivers for RTL8812AU can be downloaded from here:
http://www.edimax.com/edimax/download/download/data/edimax/global/download/for_home/wireless_adapters/wireless_adapters_ac600_dual-band/ew-7811usc

However, they are not compatible with mac80211, and in my case I need
that support.

Cheers

Daniel

On Tue, Dec 16, 2014 at 8:36 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 12/16/2014 01:09 PM, Dani Camps wrote:
>>
>> Dear all,
>>
>> I am looking for a Wi-Fi adapter with the following specs:
>>
>> a) Operates at 5GHz
>> b) Supports 802.11n and optionally 802.11ac
>> c) USB interface
>> d) SMA connector for external antenna(s)
>> e) It is supported by mac80211, and supports mesh mode
>>
>> I have done a survey and found only two devices that meet the previous
>> requirements, and they are only 802.11n. Most of the 802.11ac adapters
>> that I can find use the RT8812AU chipset, which as far as I know is
>> not supported by mac80211. Are there any plans to support this
>> chipset?
>>
>> I am pasting here a list of adapters, and I would appreciate if anyone
>> who has experimented with them could provide feedback on whether my
>> understanding is correct.
>>
>> Best Regards
>>
>> Daniel
>>
>> LIST OF ADAPTERS:
>> ================
>>
>> 1) ALFA AWUS051NH 2.4/ 5GHz Dual Band:
>>
>> link:
>> http://www.wifi-antennas.co.uk/alfa-awus051nh-2-4-5ghz-dual-band-300mbps-usb-wifi-dongle-with-rp-sma-antenna-4547.html
>> chipset: Ralink RT2870 A/B/G/N
>> mac80211 support: YES. rt2800usb.
>> http://wireless.kernel.org/en/users/Drivers/rt2800usb#external_links
>> mac80211s mesh support: YES. http://wireless.kernel.org/en/users/Drivers
>>
>> 2) Sveon SNT1022
>>
>> link:
>> http://sveon.com/tienda/adaptador-lan-wifi-usb-dual-band-doble-antena-rp-sma-snt1022/
>> chipset: Ralink 3572 A/B/G/N
>> mac80211 support: YES. rt2800usb.
>> http://wireless.kernel.org/en/users/Drivers/rt2800usb
>> mac80211s mesh support: YES. http://wireless.kernel.org/en/users/Drivers
>>
>>
>> 3) EDIMAX EW-7811USC
>>
>> link:
>> http://www.edimax.com/edimax/merchandise/merchandise_detail/data/edimax/global/wireless_adapters_ac600_dual-band/ew-7811usc/
>> chipset: Realtek RTL8812AU. AC/A/B/G/N
>> mac80211 support: NO. Not supported by rtlwifi.
>> http://wireless.kernel.org/en/users/Drivers/rtl819x
>> mac8011 mesh support: NO.
>>
>> 4) ALFA AWUS036HAC 1200
>>
>> link:
>> http://www.alfanetworkeurope.eu/en/alfa-awus036hac-ac1200-dual-band-ultra-fast-wifi-u.html
>> chipset: Realtek RTL8812AU. AC/A/B/G/N. link:
>> https://wikidevi.com/wiki/List_of_802.11ac_Hardware
>> mac80211 support: NO.
>> mac80211s support: NO.
>>
>> 5) ASUS USB-AC56
>>
>> link: http://www.asus.com/de/Networking/USBAC56/
>> chipset: Realtek RTL8812AU. AC/B/G/N.
>> https://wikidevi.com/wiki/List_of_802.11ac_Hardware
>> mac80211 support: NO.
>> mac80211s support: NO.
>>
>> 6) ABOCOM AU7212
>>
>> link: http://www.abocom.com.tw/product.aspx?id=180
>> chipset: Mediatek MT7610U. AC/A/B/G/N
>> mac80211 support: NO.
>> mac80211s support: NO.
>>
>> 7) D-LINK DWA-172
>>
>> link: http://www.dlink-forum.info/showthread.php?tid=3006
>> chipset: Realtek RTL8812AU.
>> mac80211 support: NO.
>> mac80211s support: NO.
>>
>> 8) HAWKING HD65U
>>
>> link: http://www.newegg.com/Product/Product.aspx?Item=N82E16833164060
>> chipset: Realtek RTL8812AU.
>> mac80211 support: NO.
>> mac80211s support: NO.
>
>
> In general, the USB group at Realtek does not support mac80211, the way the
> PCI group does. The only exception is driver rtl8192cu for the RTL81xxCU
> chips, and that driver has received little attention from them since the
> original release. I can fix problems in the interface between the hardware
> manipulation and Linux, but I have no knowledge of the internals of any of
> the Realtek chips.
>
> As for the RTL8812AU, I have not seen any Linux driver for this chip, but I
> doubt that it supports mac80211; however, most of the drivers for the latest
> USB chips have supported cfg80211, and will work with the latest hostapd
> version.
>
> It is unfortunate that the USB group at Realtek has taken this stance as I
> know of several users that have chosen not to use their chips because of the
> incomplete Linux drivers. I assume they have good reasons, but I do not know
> what they are.
>
> Larry
>
