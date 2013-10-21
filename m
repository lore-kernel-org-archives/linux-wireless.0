Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:41004 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3JUI3k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 04:29:40 -0400
Received: by mail-ie0-f178.google.com with SMTP id to1so14231365ieb.23
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 01:29:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <525316EF.6070102@rempel-privat.de>
References: <E8A6515F57A7AE4EA65BED3559D774CE1B151ABF@exc1.jambit.com>
	<525316EF.6070102@rempel-privat.de>
Date: Mon, 21 Oct 2013 10:29:40 +0200
Message-ID: <CANq1E4SiDU66NwAjm67AZQC_fk0dfQjLM9rvXZpMXv+V3=T8aw@mail.gmail.com> (sfid-20131021_102944_323746_C09A2202)
Subject: Re: WIFI USB-Stick for P2P
From: David Herrmann <dh.herrmann@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: =?ISO-8859-1?Q?Alexander_M=FCller?= <Alexander.Mueller@jambit.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Mon, Oct 7, 2013 at 10:17 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Am 07.10.2013 11:08, schrieb Alexander Müller:
>> Hello linux-wireless,
>>
>> I'm wondering if there is a list of usb wifi devices having a good and stable p2p support for wifi direct. We are currently using an AVM Fritz wifi stick that is supported by the carl9170 driver, but it is experiencing random failures and stalls which require a hardware reset. The p2p howto page at http://wireless.kernel.org/en/developers/p2p/howto suggests that there may be other devices and drivers supporting p2p, but I haven't figured out exactly which devices work best.
>>
>> Can you give me a hint?
>
> You can try ath9k_htc based device. It should be able to support P2P,
> but right now i was not able to transfer any data. p2p_find and
> p2p_connect seems to work.
>
> If you wont to do some more testing with ath9k_htc, please contact me.

If anyone else is trying this, I was able to transfer data between my
Android device and a linux host:

Android device is a Nexus 4. To wait for connections, go to
Settings->Wifi->Wifi-Direct

On the linux host, I used "Sony UWABR100", a ath9k_htc dual-band
(2.4/5Ghz) USB pluggable device. As kernel I used 3.12-rc3.
At least wpa_supplicant-2.0 is needed. As config-file I used:
  ctrl_interface=/var/run/wpa_supplicant
  ap_scan=1
  device_name=my-device-name
  device_type=1-0050F204-1

Then run wpa_supplicant via:
  wpa_supplicant -Dnl80211 -c /path/to/p2p.conf -i wlan0 -dt

This information is also available here:
  http://wireless.kernel.org/en/developers/p2p/howto

To connect your device, run "wpa_cli" on the host. Use "p2p_find" and
wait for your android device to be detected. Then run "p2p_connect
<android-mac> pbc" to connect via WPS-PBC. After a few seconds the
android device shows a pop-up where you need to press "Accept".

This will give you a new interface p2p-wlan0-0 (or similar). If you're
the GO, you need to assign an IP address and start a dhcp-daemon (I
used udhcpd). Otherwise, Android disconnects after a short timeout
(about 5s). Once the dhcpd is running, the android device acquires an
IP address and you can start communication. The IP network is fully
set up.

I hope this helps!
David

Some links I found useful:
http://processors.wiki.ti.com/index.php/OMAP_Wireless_Connectivity_NLCP_WiFi_Direct_Configuration_Scripts

http://svn.dd-wrt.com/browser/src/router/hostapd-wps/wpa_supplicant/README-P2P?rev=16495

http://developer.android.com/guide/topics/connectivity/wifip2p.html
