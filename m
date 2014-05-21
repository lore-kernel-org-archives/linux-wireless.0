Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:61203 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaEUHig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 03:38:36 -0400
Received: by mail-ob0-f178.google.com with SMTP id va2so1746149obc.9
        for <linux-wireless@vger.kernel.org>; Wed, 21 May 2014 00:38:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <m3k39fmyqg.fsf@t19.piap.pl>
References: <m3k39fmyqg.fsf@t19.piap.pl>
Date: Wed, 21 May 2014 10:38:36 +0300
Message-ID: <CANUX_P0CyqhFU5fpTMa=q=du2ZkEPkyuvE32VBmFPUejgn0xOA@mail.gmail.com> (sfid-20140521_093839_869219_E44AF9DB)
Subject: Re: iwlwifi Microcode SW error and subsequent WARNINGs
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hi,
>
> I'm having problems with an Intel Corporation Wireless 7260 (rev 6b)
> adapter running in ad hoc mode. Any ideas?
>
> The hardware is Getac F110 tablet, Core i5 Haswell. I've tried to use
> Linux v. 3.13, 3.14, 3.15-rc5+ with microcode v. 22.24.8.0 and
> 23.214.9.0.
>
> What I'm trying to do is:
>
> # iwconfig wlan0 mode ad-hoc essid xxx txpower 16 channel 11
> # ip link set up dev wlan0
> # sleep 1
> # iwconfig wlan0 mode ad-hoc essid xxx txpower 16 channel 11 rate 6M
> # sleep 10
> # iwconfig wlan0 mode ad-hoc essid xxx txpower 16 channel 11 rate 6M
>
> wlan0 works in ad hoc mode after "sleep 10" and subsequent iwconfig.
>

Please use iw instead of iwconfig. If it reproduces with iw, please
reprdoduce with debug=0xf. Or even better while tracing:
As root:
trace-cmd record -e cfg80211 -e mac80211 -e iwlwifi
and then send me the trace.dat file that it will create.

thanks.
