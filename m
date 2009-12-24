Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp14.ono.com ([62.42.230.176]:19076 "EHLO resmaa14.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751430AbZLXKCW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2009 05:02:22 -0500
Received: from werewolf.home (83.138.217.78) by resmaa14.ono.com (8.5.113) (authenticated as jamagallon)
        id 4AE71A750073ECA9 for linux-wireless@vger.kernel.org; Thu, 24 Dec 2009 10:43:57 +0100
Date: Thu, 24 Dec 2009 10:56:48 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: linux-wireless@vger.kernel.org
Subject: Problems with ath5k and WPA2 keys
Message-ID: <20091224105648.6b3ae67e@werewolf.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all...

With last 2.6.32.2 kernel, I can't connect to my home WiFi router.
I use WPA2+PSK mode.

I have discovered it's related to key length:

one:~# iwconfig wlan0 key s:password
Error for wireless request "Set Encode" (8B2A) :
    SET failed on device wlan0 ; Invalid argument.
one:~# iwconfig wlan0 key s:passwor
Error for wireless request "Set Encode" (8B2A) :
    SET failed on device wlan0 ; Invalid argument.
one:~# iwconfig wlan0 key s:passwo
Error for wireless request "Set Encode" (8B2A) :
    SET failed on device wlan0 ; Invalid argument.
one:~# iwconfig wlan0 key s:passw

(this last works...)

So network scripts can not set my key...

I don't know if this is a problem in iwconfig or in the driver...

Any idea ? Any way to debug this ?

pd: hardware is Acer Aspire One 150:

03:00.0 Ethernet controller: Atheros Communications Inc. AR5001 Wireless Network Adapter (rev 01)
    Subsystem: Foxconn International, Inc. Device e008
    Flags: bus master, fast devsel, latency 0, IRQ 18
    Memory at 35200000 (64-bit, non-prefetchable) [size=64K]
    Capabilities: [40] Power Management version 2
    Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
    Capabilities: [60] Express Legacy Endpoint, MSI 00
    Capabilities: [90] MSI-X: Enable- Count=1 Masked-
    Capabilities: [100] Advanced Error Reporting
    Capabilities: [140] Virtual Channel <?>
    Kernel driver in use: ath5k
    Kernel modules: ath5k

TIA

(plz, CC me, I'm not subscribed...)

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2010.0 (Cooker) for x86_64
Linux 2.6.29.3-desktop-1mnb (gcc 4.3.2 (GCC) #1 Wed May
