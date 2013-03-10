Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:56150 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3CJMk3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Mar 2013 08:40:29 -0400
Message-ID: <20130310142919.4375603d5escwu4g@www.dalek.fi> (sfid-20130310_134035_544360_9547B4D1)
Date: Sun, 10 Mar 2013 14:29:19 +0200
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-wireless@vger.kernel.org,
	'George0505' <george0505@realtek.com>
Subject: Re: rtl8192cu goes silent/dead after some time...
References: <20130225185141.14193yyf1vunany8@www.dalek.fi>
 <512E58DF.4050001@lwfinger.net>
In-Reply-To: <512E58DF.4050001@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I've made some more testing, and noticed that device does not go  
completely silent...

After device stops working in managed mode, I added monitor interface  
and it receives beacons and other broadcast packets. However if I turn  
on any monitor interface for device, managed interface is silent and  
monitor interface only receives probe requests.

Before this condition appears, there is "wlan0: deauthenticated from  
xx:xx:xx:xx:xx:xx (Reason: 2)" with reconnect to AP:

[   22.910000] wlan0: authenticate with xx:xx:xx:xx:xx:xx
[   22.940000] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[   22.980000] wlan0: authenticated
[   23.000000] wlan0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[   23.030000] wlan0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x411  
status=0 aid=2)
[   23.040000] wlan0: associated
[   23.050000] cfg80211: Calling CRDA for country: FI
[   23.080000] cfg80211: Updating information on frequency 2412 MHz  
for a 20 MHz width channel with regulatory rule:
[   23.090000] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A  
mBi, 2000 mBm)
[   23.100000] cfg80211: Updating information on frequency 2417 MHz  
for a 20 MHz width channel with regulatory rule:
[   23.110000] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A  
mBi, 2000 mBm)
[   23.120000] cfg80211: Updating information on frequency 2422 MHz  
for a 20 MHz width channel with regulatory rule:
[   23.130000] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A  
mBi, 2000 mBm)
[   23.140000] cfg80211: Updating information on frequency 2427 MHz  
for a 20 MHz width channel with regulatory rule:
[   23.150000] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A  
mBi, 2000 mBm)
[   23.160000] cfg80211: Updating information on frequency 2432 MHz  
for a 20 MHz width channel with regulatory rule:
[   23.170000] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A  
mBi, 2000 mBm)
[   23.180000] cfg80211: Updating information on frequency 2437 MHz  
for a 20 MHz width channel with regulatory rule:
[   23.190000] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A  
mBi, 2000 mBm)
[   23.200000] cfg80211: Updating information on frequency 2442 MHz  
for a 20 MHz width channel with regulatory rule:
[   23.210000] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A  
mBi, 2000 mBm)
[   23.220000] cfg80211: Updating information on frequency 2447 MHz  
for a 20 MHz width channel with regulatory rule:
[   23.230000] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A  
mBi, 2000 mBm)
[   23.240000] cfg80211: Updating information on frequency 2452 MHz  
for a 20 MHz width channel with regulatory rule:
[   23.250000] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A  
mBi, 2000 mBm)
[   23.260000] cfg80211: Updating information on frequency 2457 MHz  
for a 20 MHz width channel with regulatory rule:
[   23.270000] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A  
mBi, 2000 mBm)
[   23.280000] cfg80211: Updating information on frequency 2462 MHz  
for a 20 MHz width channel with regulatory rule:
[   23.290000] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A  
mBi, 2000 mBm)
[   23.300000] cfg80211: Updating information on frequency 2467 MHz  
for a 20 MHz width channel with regulatory rule:
[   23.310000] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A  
mBi, 2000 mBm)
[   23.320000] cfg80211: Updating information on frequency 2472 MHz  
for a 20 MHz width channel with regulatory rule:
[   23.330000] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A  
mBi, 2000 mBm)
[   23.340000] cfg80211: Disabling freq 2484 MHz
[   23.350000] cfg80211: Regulatory domain changed to country: FI
[   23.360000] cfg80211:   (start_freq - end_freq @ bandwidth),  
(max_antenna_gain, max_eirp)
[   23.370000] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz),  
(N/A, 2000 mBm)
[   23.380000] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),  
(N/A, 2000 mBm)
[   23.390000] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz),  
(N/A, 2000 mBm)
[   23.400000] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz),  
(N/A, 2700 mBm)

After which silence strikes. So maybe that signal average bug is not  
related to this connection issue, but driver/device goes in to some  
mixed up state because of disconnect/reconnect?

-Jussi

Quoting Larry Finger <Larry.Finger@lwfinger.net>:

>
> Thanks for the log and the signal average data. All of the BUGs come  
> from a single debug statement in the source. I will delete that  
> trace call.
>
> Realtek has apparently stopped development on the mac80211-based  
> driver. The latest version is dated 2011.02.10. The latest driver  
> with Realtek's softmac stack is 2012.06.22. As the two drivers are  
> totally different, porting the fixes from one to the other are quite  
> difficult.
>
> My plan is to try to improve rtl8192cu; however, if that does not  
> work, I will pull it in favor of the version with Realtek's stack.  
> It will, of course, need to be placed in staging. The downside is  
> that a number of distros do not install drivers from staging, and  
> all the mac80211 features will be lost. That is the worst case  
> outcome.
>
> Larry
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



