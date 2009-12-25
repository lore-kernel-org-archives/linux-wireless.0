Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756476AbZLYWMc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Dec 2009 17:12:32 -0500
Subject: Re: Problems with ath5k and WPA2 keys
From: Dan Williams <dcbw@redhat.com>
To: "J.A." =?ISO-8859-1?Q?Magall=F3n?= <jamagallon@ono.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20091224105648.6b3ae67e@werewolf.home>
References: <20091224105648.6b3ae67e@werewolf.home>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Dec 2009 14:12:30 -0600
Message-Id: <1261771950.7657.2.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-12-24 at 10:56 +0100, J.A. Magallón wrote:
> Hi all...
> 
> With last 2.6.32.2 kernel, I can't connect to my home WiFi router.
> I use WPA2+PSK mode.
> 
> I have discovered it's related to key length:
> 
> one:~# iwconfig wlan0 key s:password
> Error for wireless request "Set Encode" (8B2A) :
>     SET failed on device wlan0 ; Invalid argument.
> one:~# iwconfig wlan0 key s:passwor
> Error for wireless request "Set Encode" (8B2A) :
>     SET failed on device wlan0 ; Invalid argument.
> one:~# iwconfig wlan0 key s:passwo
> Error for wireless request "Set Encode" (8B2A) :
>     SET failed on device wlan0 ; Invalid argument.
> one:~# iwconfig wlan0 key s:passw
> 
> (this last works...)
> 
> So network scripts can not set my key...

iwconfig does not do WPA.  You want wpa_supplicant if you want to make
WPA connections, because a daemon is required to handle the rekeying and
other WPA operations.  WPA is a lot more complex and thus you cannot
just use command-line tools.

The reason iwconfig only accepts certain key lengths is because it can
only accept WEP keys, and WEP keys have specific key lengths.  WEP Hex
keys can be either 10 or 26 hex characters, and WEP ASCII keys can
either be 5 or 13 characters.  Which is why the last example above
works; because the key is 5 ASCII characters.

But in the end, if you're using WPA, you want to use wpa_supplicant to
set up and manage the connection, or a connection manager like
NetworkManager.  Plain iwconfig simply does not work with WPA and never
will.

Dan

> I don't know if this is a problem in iwconfig or in the driver...
> 
> Any idea ? Any way to debug this ?
> 
> pd: hardware is Acer Aspire One 150:
> 
> 03:00.0 Ethernet controller: Atheros Communications Inc. AR5001 Wireless Network Adapter (rev 01)
>     Subsystem: Foxconn International, Inc. Device e008
>     Flags: bus master, fast devsel, latency 0, IRQ 18
>     Memory at 35200000 (64-bit, non-prefetchable) [size=64K]
>     Capabilities: [40] Power Management version 2
>     Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
>     Capabilities: [60] Express Legacy Endpoint, MSI 00
>     Capabilities: [90] MSI-X: Enable- Count=1 Masked-
>     Capabilities: [100] Advanced Error Reporting
>     Capabilities: [140] Virtual Channel <?>
>     Kernel driver in use: ath5k
>     Kernel modules: ath5k
> 
> TIA
> 
> (plz, CC me, I'm not subscribed...)
> 

