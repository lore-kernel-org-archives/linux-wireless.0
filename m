Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45546 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab0JBGS3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 02:18:29 -0400
Received: by wyb28 with SMTP id 28so3602000wyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 23:18:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimmSaQsBdTLAjZT2_8sQ9V7r4OvAzGATr+bmOxG@mail.gmail.com>
References: <AANLkTimN3X_e4fZhUSoTs-GmQ9kmaJUrgnxAu8=W2dT_@mail.gmail.com>
 <201010020452.24306.chunkeey@googlemail.com> <AANLkTin2ycTicNim+ZiwNV3pWr7AQWPp432vJVLUL1k1@mail.gmail.com>
 <201010020519.29042.chunkeey@googlemail.com> <AANLkTimmSaQsBdTLAjZT2_8sQ9V7r4OvAzGATr+bmOxG@mail.gmail.com>
From: Saqeb Akhter <saqeb.akhter@gmail.com>
Date: Sat, 2 Oct 2010 02:18:07 -0400
Message-ID: <AANLkTimXGQLnSaU6ASeRPkw1YThF18_zC7peu_uCeGKU@mail.gmail.com>
Subject: Re: carl9170: wnda3100 only 54MB/s
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I guess you were right about it being unstable - almost unusable for
video streaming.

sakhter@sakhter-laptop:~$ dmesg | grep Reason
[ 1166.512087] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
[ 1526.059997] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
[ 2125.324356] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
[ 2845.783011] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
[ 3565.994832] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
[ 5128.903576] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
[ 5726.046230] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
[ 6326.042938] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
[ 6835.689445] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
[ 7197.337060] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)

Seems to disconnect quite frequently. Even tried uninstalling networkmanager.


On Fri, Oct 1, 2010 at 11:28 PM, Saqeb Akhter <saqeb.akhter@gmail.com> wrote:
> Yeah, doesn't look like its NetworkManager from what I can tell. I
> don't notice any scanning going on, etc.
>
> Thanks for all the help. I guess the code for the channel changes just
> isn't fast enough ?
>
> This is what I get in dmesg:
>
> [  174.026110] wlan1: associated
> [  207.799194] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> [  208.065258] cfg80211: All devices are disconnected, going to
> restore regulatory settings
> [  208.065265] cfg80211: Restoring regulatory settings
> [  208.065269] cfg80211: Calling CRDA to update world regulatory domain
> [  208.070474] cfg80211: World regulatory domain updated:
> [  208.070478]     (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [  208.070482]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  208.070486]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [  208.070489]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [  208.070492]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  208.070495]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  213.390525] wlan1: authenticate with 30:46:9a:10:49:f7 (try 1)
>
>
>
>
>
> On Fri, Oct 1, 2010 at 11:19 PM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
>> On Saturday 02 October 2010 04:56:35 Saqeb Akhter wrote:
>>> Nope I already noticed that 1.8.8.3 was available so to that step, I
>>> am getting frequent disconnects though, it might have to do with
>>> NetworkManager doing background scanning so going to try and it it to
>>> stop doing that.
>> Channel changes (especially with HT) are more expensive with AR9170
>> than AR9271 which features "fastcc" (fast channel change).
>>
>>> The NetGear driver on windows seems to ignore the WMM requirement
>>> looks like.
>> You can actually peek into the Windows' driver logic.
>> The code is available under drivers/staging/otus/(80211core)
>> AFAIK, it only checks if the HT IEs are all present.
>>
>>> Either way that's what the problem was, going to see if i
>>> can get this disconnect problem sorted out.
>> I thought "the new" NetworkManager is more intelligent and
>> doesn't schedule scans while the device is actively
>> transmitting/receiving data. Anyway, NetworkManager is
>> "just" a manager for wpa_supplicant and wpa_supp works
>> well enough.
>>
>> bye.
>>
>>
>
