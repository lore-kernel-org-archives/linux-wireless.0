Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:49534 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab3CKUZw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 16:25:52 -0400
Received: by mail-ob0-f170.google.com with SMTP id wc20so3787886obb.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2013 13:25:52 -0700 (PDT)
Message-ID: <513E3DCD.5040507@lwfinger.net> (sfid-20130311_212600_609763_EEF24CD4)
Date: Mon, 11 Mar 2013 15:25:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
CC: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-wireless@vger.kernel.org,
	'George0505' <george0505@realtek.com>
Subject: Re: rtl8192cu gets confused when scan is aborted by bringing interface
 down (Re: rtl8192cu goes silent/dead after some time...)
References: <20130225185141.14193yyf1vunany8@www.dalek.fi> <512E58DF.4050001@lwfinger.net> <20130310142919.4375603d5escwu4g@www.dalek.fi> <20130311211709.17775i5d1zo9c8co@www.dalek.fi>
In-Reply-To: <20130311211709.17775i5d1zo9c8co@www.dalek.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/11/2013 02:17 PM, Jussi Kivilinna wrote:
> Quoting Jussi Kivilinna <jussi.kivilinna@iki.fi>:
>
>> Hello,
>>
>> I've made some more testing, and noticed that device does not go completely
>> silent...
>
> I can now reproduce this hang without large transfers with 'ifconfig wlan0 up;
> iw dev wlan0 scan & sleep 0.02; ifconfig wlan0 down'.
>
> The large tranfers caused connection to fail sometimes, leading wpa_supplicant
> to issue scan that is aborted. Manually aborting scan causes device/driver go
> into this partial silence state too (with beacons/probe requests received).
>
> So maybe driver does not do all the required clean-ups for aborted scans?

Have you tested 'ifconfig wlan0 up & sleep 0.02; ifconfig wlan0 down'? Is the 
scan part absolutely necessary?

Larry


