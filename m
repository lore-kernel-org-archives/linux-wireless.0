Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:31561 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbYGINvj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 09:51:39 -0400
Received: by yx-out-2324.google.com with SMTP id 8so823683yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 06:51:36 -0700 (PDT)
Message-ID: <69e28c910807090651xc253bcawf3900c53d1a3e046@mail.gmail.com> (sfid-20080709_155143_510928_33AEC887)
Date: Wed, 9 Jul 2008 15:51:35 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Stefan Monnier" <monnier@iro.umontreal.ca>
Subject: Re: Slow b43 with 2.6.25.9 on an asus wl-700ge home-router
Cc: linux-wireless@vger.kernel.org,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>,
	"Michael Buesch" <mb@bu3sch.de>
In-Reply-To: <jwvlk0bsjk7.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <jwvlk0bsjk7.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 9, 2008 at 7:50 AM, Stefan Monnier <monnier@iro.umontreal.ca> wrote:
> I finally started to use the b43 driver on my home-router and am happy
> to have it working at all (with WPA), but I notice that the speed is
> pretty terrible: I cannot seem to get more than 100KB/s out of it (I
> use it as a personal web proxy, so it ends up slowing down my
> web-surfing :-( ).
>
> Originally "iwconfig" told me that the bit rate was 2Mb/s (and even
> that should allow me to get a bit more than 100KB/s).
> After "iwconfig wlan0 rate 54M", the result is the same (except that
> "iwconfig" tells me the bit rate is 54Mb/s).
>
> More specifically, iwconfig tells me things like:
>
> wlan0     IEEE 802.11  ESSID:"test"
>          Mode:Managed  Frequency:2.457 GHz  Access Point: 00:10:30:C0:50:50
>          Bit Rate=54 Mb/s   Tx-Power=27 dBm
>          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
>          Link Quality=95/100  Signal level:-54 dBm  Noise level=-63 dBm
>          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>
> which seems to indicate that the reception is indeed good.
> Any idea what I might want to check?
>
> I did notice that my dmesg says things like
> "received packet with  own address as source address".  This seems
> related to my use of bridging, but:
> 1 - I have no bridging loop (actually I unplugged all ethernet cables,
>    so the only active network interface in the bridge is wlan0).
> 2 - taking wlan0 out of the bridge eliminates those messages, but
>    doesn't improve the bandwidth.
>
> Any idea what might be going on?
>
>
>        Stefan
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Can you see "PHY transmission error" messages in dmesg? If you get
those, then that's a known bug.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
