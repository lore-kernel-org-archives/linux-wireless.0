Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:37035 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab3CLTtb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 15:49:31 -0400
Message-ID: <513F86C8.1010407@iki.fi> (sfid-20130312_204936_153901_AC0B2330)
Date: Tue, 12 Mar 2013 21:49:28 +0200
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org,
	'George0505' <george0505@realtek.com>
Subject: Re: rtl8192cu gets confused when scan is aborted by bringing interface
 down (Re: rtl8192cu goes silent/dead after some time...)
References: <20130225185141.14193yyf1vunany8@www.dalek.fi> <512E58DF.4050001@lwfinger.net> <20130310142919.4375603d5escwu4g@www.dalek.fi> <20130311211709.17775i5d1zo9c8co@www.dalek.fi> <513E3DCD.5040507@lwfinger.net> <20130311230656.949364zqs1dt100s@www.dalek.fi> <513E4D1B.5000902@lwfinger.net> <20130312111035.96082dc0scui0tu8@www.dalek.fi> <513F5D14.3060409@lwfinger.net>
In-Reply-To: <513F5D14.3060409@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12.03.2013 18:51, Larry Finger wrote:
> On 03/12/2013 04:10 AM, Jussi Kivilinna wrote:
>>
>> That patch alone did not help.. however replacing
>> _rtl92cu_set_check_bssid()
>> with that new rtl92cu_set_check_bssid() does fix the issue (patch
>> attached).
>>
>> But I think _rtl92cu_set_check_bssid() needs to be rechecked since it has
>> '(IS_NORMAL_CHIP(rtlhal->version))' conditional etc.
> 
> I doubt that that IS_NORMAL_CHIP business affects us - the test chips
> are not supposed to be in the wild, but I modified your patch to include
> that test.
> 

Modified patch works here.

> With that patch I am getting watchdog_wq callbacks that force a
> reconnection every 6 seconds, but that is due to other changes in my
> code. The result is a 34% loss of pings, but the connection stays up.
> 

No problems here.. <1% loss and can do large transfers, rtl8192cu being
able to reconnect is connection is dropped.

-Jussi
