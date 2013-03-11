Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:33051 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab3CKTRO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 15:17:14 -0400
Message-ID: <20130311211709.17775i5d1zo9c8co@www.dalek.fi> (sfid-20130311_201719_991953_50165346)
Date: Mon, 11 Mar 2013 21:17:09 +0200
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-wireless@vger.kernel.org,
	'George0505' <george0505@realtek.com>
Subject: rtl8192cu gets confused when scan is aborted by bringing interface
 down (Re: rtl8192cu goes silent/dead after some time...)
References: <20130225185141.14193yyf1vunany8@www.dalek.fi>
 <512E58DF.4050001@lwfinger.net>
 <20130310142919.4375603d5escwu4g@www.dalek.fi>
In-Reply-To: <20130310142919.4375603d5escwu4g@www.dalek.fi>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Jussi Kivilinna <jussi.kivilinna@iki.fi>:

> Hello,
>
> I've made some more testing, and noticed that device does not go  
> completely silent...

I can now reproduce this hang without large transfers with 'ifconfig  
wlan0 up; iw dev wlan0 scan & sleep 0.02; ifconfig wlan0 down'.

The large tranfers caused connection to fail sometimes, leading  
wpa_supplicant to issue scan that is aborted. Manually aborting scan  
causes device/driver go into this partial silence state too (with  
beacons/probe requests received).

So maybe driver does not do all the required clean-ups for aborted scans?

-Jussi

>
> After device stops working in managed mode, I added monitor  
> interface and it receives beacons and other broadcast packets.  
> However if I turn on any monitor interface for device, managed  
> interface is silent and monitor interface only receives probe  
> requests.
>
> Before this condition appears, there is "wlan0: deauthenticated from  
> xx:xx:xx:xx:xx:xx (Reason: 2)" with reconnect to AP:
>
<snip>
>
> After which silence strikes. So maybe that signal average bug is not  
> related to this connection issue, but driver/device goes in to some  
> mixed up state because of disconnect/reconnect?
>
> -Jussi
>
> Quoting Larry Finger <Larry.Finger@lwfinger.net>:
>
>>
>> Thanks for the log and the signal average data. All of the BUGs  
>> come from a single debug statement in the source. I will delete  
>> that trace call.
>>
>> Realtek has apparently stopped development on the mac80211-based  
>> driver. The latest version is dated 2011.02.10. The latest driver  
>> with Realtek's softmac stack is 2012.06.22. As the two drivers are  
>> totally different, porting the fixes from one to the other are  
>> quite difficult.
>>
>> My plan is to try to improve rtl8192cu; however, if that does not  
>> work, I will pull it in favor of the version with Realtek's stack.  
>> It will, of course, need to be placed in staging. The downside is  
>> that a number of distros do not install drivers from staging, and  
>> all the mac80211 features will be lost. That is the worst case  
>> outcome.
>>
>> Larry
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



