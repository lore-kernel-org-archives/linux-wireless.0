Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58128 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab0LWXBs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Dec 2010 18:01:48 -0500
Received: by fxm20 with SMTP id 20so7526445fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Dec 2010 15:01:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <142357.30253.qm@web56803.mail.re3.yahoo.com>
References: <AANLkTimDPcxSthO=TAqPx4fyrU0U_WPkwMHLGGiCSMKw@mail.gmail.com>
	<142357.30253.qm@web56803.mail.re3.yahoo.com>
Date: Thu, 23 Dec 2010 18:01:46 -0500
Message-ID: <AANLkTimL=JSK6jcF4d97Nc-vLZdeRLj8o=MbpCas-H7z@mail.gmail.com>
Subject: Re: carl9170 and debian squeeze
From: Der Engel <engelster@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for your quick replies.

I have install compat-wireless-2010-12-23  with 'driver-select
carl9170' because the whole thing didn't want to compile for me, the
usb wifi card is working fine now with the carl9170 but now my
internal intel card isn't coming up, if tried to load the iwlagn or
iwlcore driver and get the following:
FATAL: Error inserting iwlagn
(/lib/modules/2.6.32-5-686/kernel/drivers/net/wireless/iwlwifi/iwlagn.ko):
Unknown symbol in module, or unknown parameter (see dmesg)

dmesg outputs the following:

7.368050] iwlcore: disagrees about version of symbol
ieee80211_start_tx_ba_cb_irqsafe
[    7.368053] iwlcore: Unknown symbol ieee80211_start_tx_ba_cb_irqsafe
[    7.368292] iwlcore: disagrees about version of symbol ieee80211_alloc_hw
[    7.368293] iwlcore: Unknown symbol ieee80211_alloc_hw
[    7.368356] iwlcore: disagrees about version of symbol ieee80211_register_hw
[    7.368358] iwlcore: Unknown symbol ieee80211_register_hw
[    7.368537] iwlcore: disagrees about version of symbol
__ieee80211_get_radio_led_name
[    7.368539] iwlcore: Unknown symbol __ieee80211_get_radio_led_name
[    7.368602] iwlcore: disagrees about version of symbol ieee80211_wake_queue
[    7.368604] iwlcore: Unknown symbol ieee80211_wake_queue
[    7.368657] iwlcore: disagrees about version of symbol ieee80211_get_tkip_key
[    7.368658] iwlcore: Unknown symbol ieee80211_get_tkip_key
[    7.368713] iwlcore: disagrees about version of symbol
__ieee80211_get_tx_led_name
[    7.368714] iwlcore: Unknown symbol __ieee80211_get_tx_led_name
[    7.368791] iwlcore: disagrees about version of symbol ieee80211_find_sta
[    7.368793] iwlcore: Unknown symbol ieee80211_find_sta
[    7.368876] iwlcore: disagrees about version of symbol
ieee80211_tx_status_irqsafe
[    7.368877] iwlcore: Unknown symbol ieee80211_tx_status_irqsafe
[    7.368992] iwlcore: disagrees about version of symbol
__ieee80211_get_rx_led_name
[    7.368994] iwlcore: Unknown symbol __ieee80211_get_rx_led_name
[    7.369100] iwlcore: disagrees about version of symbol
ieee80211_stop_tx_ba_cb_irqsafe
[    7.369102] iwlcore: Unknown symbol ieee80211_stop_tx_ba_cb_irqsafe
[    7.369245] iwlcore: disagrees about version of symbol ieee80211_rx
[    7.369246] iwlcore: Unknown symbol ieee80211_rx
[    7.369308] iwlcore: disagrees about version of symbol ieee80211_wake_queues
[    7.369310] iwlcore: Unknown symbol ieee80211_wake_queues
[    7.369440] iwlcore: disagrees about version of symbol ieee80211_stop_queue
[    7.369442] iwlcore: Unknown symbol ieee80211_stop_queue
[    7.369494] iwlcore: disagrees about version of symbol ieee80211_stop_queues
[    7.369496] iwlcore: Unknown symbol ieee80211_stop_queues
[    7.369558] iwlcore: disagrees about version of symbol
__ieee80211_get_assoc_led_name
[    7.369560] iwlcore: Unknown symbol __ieee80211_get_assoc_led_name
[    7.369617] iwlcore: disagrees about version of symbol
ieee80211_scan_completed
[    7.369619] iwlcore: Unknown symbol ieee80211_scan_completed
[    7.369834] iwlcore: disagrees about version of symbol ieee80211_hdrlen
[    7.369835] iwlcore: Unknown symbol ieee80211_hdrlen
[    7.369928] iwlcore: Unknown symbol ieee80211_beacon_get

Linux laptop 2.6.32-5-686 #1 SMP Fri Dec 10 16:12:40 UTC 2010 i686 GNU/Linux

How can I make both cards work at the same time?

Thanks,
Der

- Hide quoted text -
On Thu, Dec 23, 2010 at 6:34 PM, Der Engel <engelster@gmail.com> wrote:
> Hi,
>
> I have a ubiquiti sr71-usb wireless adapter, 'lsusb' shows it as:
> 'Atheros Communications, Inc. AR9170 802.11n', the adapter works with
> the ar9170.fw firmware but I'm trying to make it work with the
> carl9170.fw, until now I have tried the following:
>
> I have put the carl9170.fw in /lib/firmware (debian default for
> firmware files) without the ar9170.fw, dmesg shows that the system its
> looking for a firmware with the exact name as 'ar9170.fw' or if it
> doesn't find that one it tries to finds the legacy ones(ar9170-1.fw &
> ar9170-2.fw), so it ignores carl9170.fw because is not named
> ar9170.fw, changing the name of carl9170.fw to ar9170.fw shows the
> following:
>
> dmesg | grep 9170
> [    2.329719] usb 2-2: New USB device found, idVendor=0cf3, idProduct=9170
> [    8.817173] usb 2-2: firmware: requesting ar9170.fw
> [    9.862192] ar9170usb: probe of 2-2:1.0 failed with error -110
> [    9.862227] usbcore: registered new interface driver ar9170usb
>
> The kernel is debian stock one:Linux laptop 2.6.32-5-686 #1 SMP Fri
> Dec 10 16:12:40 UTC 2010 i686 GNU/Linux
>
> Any ideas how can I make carl9170.fw work in debian squeeze?
>
> Thanks,
> Der

Looks like the vendor-id/product-id is not considered in your kernel,
check [1] if your device is listed as supported devices.
I am not sure if the squeeze kernel has support for carl9170.

An easy way is to use compat-wireless (stable or bleeding edge) which
offers you newer wireless hardware support and features.
The wiki in [2] has informations and instructions for you.

- Sedat -

[1] http://wireless.kernel.org/en/users/Devices
[2] http://wireless.kernel.org/en/users/Download/stable/


On Thu, Dec 23, 2010 at 2:05 PM, Walter Goldens
<goldenstranger@yahoo.com> wrote:
>
>> Any ideas how can I make carl9170.fw work in debian
>> squeeze?
>
> Download and install compat-wireless. Then blacklist ar9170 and call carl9170 instead.
>
> Walter
>
>
>
>
