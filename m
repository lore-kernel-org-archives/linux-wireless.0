Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from imr-ma03.mx.aol.com ([64.12.206.41]:54554 "EHLO
	imr-ma03.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab1LBUBr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 15:01:47 -0500
Message-ID: <4ED92E9E.3040802@aol.com> (sfid-20111202_210150_500504_BE648EE0)
Date: Fri, 02 Dec 2011 15:01:34 -0500
From: AndrewL733 <AndrewL733@aol.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Trouble with Macbook Pro 8,2 (broadcom 4331) and latest b43
References: <4ED3A6E8.4050000@aol.com>  <CACna6ryNkHeVXWXxFfod1-KQs8HQVv7wF-xpY5MA-Qs6fCypCg@mail.gmail.com>  <CACna6rzRJgfddE4jPivxBJCCZEyKSHsdRX7cE15rRxk2nhiRkA@mail.gmail.com>  <4ED3B33E.8020309@lwfinger.net> <4ED3FA65.7010104@aol.com>  <CACna6rw1gEjd_hcX=5hLHt0YwUqDaVBs7_MO50GLKeok57YtVw@mail.gmail.com>  <4ED51DB5.5090202@aol.com> <4ED52FBD.5030302@lwfinger.net>  <4ED5535E.50605@aol.com> <4ED56E02.6040601@lwfinger.net>  <CACna6rxEW9Bc6vZRPR=t=zfnA3RJoWO4Rd6m7SuY2+6_uoxuLg@mail.gmail.com>  <4ED9152F.5060104@aol.com> <4ED921B8.6060107@aol.com> <1322854811.1883.29.camel@dcbw.foobar.com>
In-Reply-To: <1322854811.1883.29.camel@dcbw.foobar.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi
> See my other mail on this... it's not really NM, but I believe it's a
> bug in the driver exposed by some behavior that NM has that static
> wpa_supplicant does not.  You should be able to trigger the same
> behavior by periodically executing 'iwlist wlan0 scan' on the command
> line, or by asking wpa_supplicant to scan by using wpa_cli.
>
> Grabbing more debugging info using "-dddt" as arguments to the
> supplicant would help.
Sure, I will do that
>
> Also, are you sure your manually started copy of wpa_supplicant is the
> only copy that's running?
Yes, I'm sure.  I did "ps aux | grep wpa" before  starting wpa_supplicant.
>> wpa on the command line:
>>
>> [root@andynewmac andy]# wpa_supplicant -Dwext -i wlan0 -c
>> /etc/wpa_supplicant.conf
>> CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=0
>> ioctl[SIOCSIWSCAN]: Device or resource busy
>> Failed to initiate AP scan.
>> ioctl[SIOCSIWSCAN]: Device or resource busy
>> Failed to initiate AP scan.
> These aren't necessarily a good start, though sometimes they are
> expected.
>
>> Trying to associate with 48:5b:39:5b:67:27 (SSID='es-network2' freq=2412
>> MHz)
>> Associated with 48:5b:39:5b:67:27
>> WPA: Key negotiation completed with 48:5b:39:5b:67:27 [PTK=CCMP GTK=TKIP]
>> CTRL-EVENT-CONNECTED - Connection to 48:5b:39:5b:67:27 completed (auth)
>> [id=1 id_str=]
>> CTRL-EVENT-DISCONNECTED bssid=48:5b:39:5b:67:27 reason=0
>> ioctl[SIOCSIWSCAN]: Device or resource busy
>> Failed to initiate AP scan.
>> ioctl[SIOCSIWSCAN]: Device or resource busy
>> Failed to initiate AP scan.
> There's not enough debugging output from the supplicant to figure out
> why the disconnect event occurred though.  That's the real reason there
> are problems here.  WEXT doesn't give us enough information about why
> the disconnect occurred.  Instead of using "-Dwext", can you use
> "-Dnl80211" instead?  WEXT is an old API and is replaced by nl80211,
> which gives us much more usable information.

Will try and report back.
> Dan
>
>
Andy
