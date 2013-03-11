Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:44712 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3CKVHA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 17:07:00 -0400
Message-ID: <20130311230656.949364zqs1dt100s@www.dalek.fi> (sfid-20130311_220705_386840_3EA62622)
Date: Mon, 11 Mar 2013 23:06:56 +0200
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	'George0505' <george0505@realtek.com>
Subject: Re: rtl8192cu gets confused when scan is aborted by bringing
 interface down (Re: rtl8192cu goes silent/dead after some time...)
References: <20130225185141.14193yyf1vunany8@www.dalek.fi>
 <512E58DF.4050001@lwfinger.net>
 <20130310142919.4375603d5escwu4g@www.dalek.fi>
 <20130311211709.17775i5d1zo9c8co@www.dalek.fi>
 <513E3DCD.5040507@lwfinger.net>
In-Reply-To: <513E3DCD.5040507@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Larry Finger <Larry.Finger@lwfinger.net>:

> On 03/11/2013 02:17 PM, Jussi Kivilinna wrote:
>> Quoting Jussi Kivilinna <jussi.kivilinna@iki.fi>:
>>
>>> Hello,
>>>
>>> I've made some more testing, and noticed that device does not go completely
>>> silent...
>>
>> I can now reproduce this hang without large transfers with  
>> 'ifconfig wlan0 up;
>> iw dev wlan0 scan & sleep 0.02; ifconfig wlan0 down'.
>>
>> The large tranfers caused connection to fail sometimes, leading  
>> wpa_supplicant
>> to issue scan that is aborted. Manually aborting scan causes  
>> device/driver go
>> into this partial silence state too (with beacons/probe requests received).
>>
>> So maybe driver does not do all the required clean-ups for aborted scans?
>
> Have you tested 'ifconfig wlan0 up & sleep 0.02; ifconfig wlan0  
> down'? Is the scan part absolutely necessary?

Scan appearently is not necessary, 'ifconfig wlan0 up & sleep 0.02;  
ifconfig wlan0 down' is enough. Just doing 'ifconfig wlan0 up;  
ifconfig wlan0 down' is enough.

I also tested with monitor interface opened for tcpdump while doing  
'ifconfig up&down' on wlan0 and still triggered the issue. Then  
turning wlan0 up resulted monitor interface only receiving probe  
requests from nearby devices.

-Jussi


