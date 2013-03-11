Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:58529 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab3CKVKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 17:10:54 -0400
Received: by mail-oa0-f53.google.com with SMTP id m1so4927550oag.40
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2013 14:10:54 -0700 (PDT)
Message-ID: <513E485B.2030505@lwfinger.net> (sfid-20130311_221100_753125_99865852)
Date: Mon, 11 Mar 2013 16:10:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
CC: linux-wireless@vger.kernel.org,
	'George0505' <george0505@realtek.com>
Subject: Re: rtl8192cu gets confused when scan is aborted by bringing interface
 down (Re: rtl8192cu goes silent/dead after some time...)
References: <20130225185141.14193yyf1vunany8@www.dalek.fi> <512E58DF.4050001@lwfinger.net> <20130310142919.4375603d5escwu4g@www.dalek.fi> <20130311211709.17775i5d1zo9c8co@www.dalek.fi> <513E3DCD.5040507@lwfinger.net> <20130311230656.949364zqs1dt100s@www.dalek.fi>
In-Reply-To: <20130311230656.949364zqs1dt100s@www.dalek.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/11/2013 04:06 PM, Jussi Kivilinna wrote:
>
> Scan appearently is not necessary, 'ifconfig wlan0 up & sleep 0.02; ifconfig
> wlan0 down' is enough. Just doing 'ifconfig wlan0 up; ifconfig wlan0 down' is
> enough.
>
> I also tested with monitor interface opened for tcpdump while doing 'ifconfig
> up&down' on wlan0 and still triggered the issue. Then turning wlan0 up resulted
> monitor interface only receiving probe requests from nearby devices.

Thanks for the test. Something is not being cleared in the 
authentication/association/keying process.

Larry


