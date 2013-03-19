Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932663Ab3CSVgk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 17:36:40 -0400
Message-ID: <1363729054.8874.11.camel@dcbw.foobar.com> (sfid-20130319_223646_127736_8DF61047)
Subject: Re: Intel Centrino Advanced-N 6205 master mode support
From: Dan Williams <dcbw@redhat.com>
To: =?ISO-8859-1?Q?D=E9nes_N=E9meth?= <mr.nemeth.denes@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 19 Mar 2013 16:37:34 -0500
In-Reply-To: <CAHwWuAE0MxN9_Bf1aTmpsefMAED-9HVsV7VtxorDvF3hSHZ2Ng@mail.gmail.com>
References: <CAHwWuAE0MxN9_Bf1aTmpsefMAED-9HVsV7VtxorDvF3hSHZ2Ng@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-19 at 21:54 +0100, Dénes Németh wrote:
> Hi
> 
> Could you help me the determine if the Intel Centrino Advanced-N 6205
> is supported in AP / master mode?
> 
> Your website http://wireless.kernel.org/en/users/Drivers/iwlwifi states
> that the "AP mode (experimental; only on some devices/firmware versions)"
> 
> Is the wifi card above supported?

If it lists AP in "Supported interface modes", then yes, your device is
capable of it.

> Here is my debug info, at the bottom with the failure of changing to master mode
> dmesg:
>     loaded firmware version 18.168.6.1
>     cfg80211: Regulatory domain changed to country: EU
> 
> iw list wlan0
>     Supported interface modes:
>          * IBSS
>          * managed
>          * AP
>          * AP/VLAN
>          * monitor
>     software interface modes (can always be added):
>          * AP/VLAN
>          * monitor
> 
> iwconfig wlan0 mode master
> Error for wireless request "Set Mode" (8B06) :
>     SET failed on device wlan0 ; Invalid argument

Don't use iwconfig, because these days a *lot* more information needs to
be sent to the device for AP mode, and WEXT is long deprecated.  Use
wpa_supplicant and its lightweight AP mode, or use hostapd.  Make sure
you use them with the "nl80211" driver too, as in "-Dnl80211" on the
command line of the supplicant.

Dan

