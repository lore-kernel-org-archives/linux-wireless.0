Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37113 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab3IKQxV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 12:53:21 -0400
Received: by mail-wi0-f171.google.com with SMTP id hm2so2445087wib.10
        for <linux-wireless@vger.kernel.org>; Wed, 11 Sep 2013 09:53:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52309B75.3010408@lwfinger.net>
References: <CAEZsi7Hde5NyTRgm7Lf_4LvHMAEJouzaqMNUwxr-iSipuEcsyQ@mail.gmail.com>
	<522E4315.4040806@lwfinger.net>
	<1378764913.31180.9.camel@dcbw.foobar.com>
	<CAEZsi7FY8HdBcb0p1svijAdFjB0MbrYv_Zft0B_+RQTpGWCnhQ@mail.gmail.com>
	<1378916091.1693.21.camel@dcbw.foobar.com>
	<52309B75.3010408@lwfinger.net>
Date: Wed, 11 Sep 2013 18:53:20 +0200
Message-ID: <CAEZsi7GYj5Lf4vOxJfkU+_sHk-UqHJ605Z5yPOmMcucVanR3uQ@mail.gmail.com> (sfid-20130911_185326_962174_59EF7A22)
Subject: Re: No connection with TP-Link TL-WN823N (rtl8192cu)
From: Vincent Thiele <vincentthiele@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So what should i do?

2013/9/11 Larry Finger <Larry.Finger@lwfinger.net>:
> On 09/11/2013 11:14 AM, Dan Williams wrote:
>>
>> Some relevant bits:
>>
>> Sep 11 16:49:38 Arbeits-PC NetworkManager[1104]: <info> (wlan0):
>> supplicant interface state: 4-way handshake -> completed
>> Sep 11 16:49:44 Arbeits-PC kernel: [ 1749.454788] wlan0: Connection to AP
>> a0:f3:c1:05:80:ec lost
>> Sep 11 16:49:45 Arbeits-PC wpa_supplicant[1205]: wlan0:
>> CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=4
>> Sep 11 16:49:45 Arbeits-PC NetworkManager[1104]: <info> (wlan0):
>> supplicant interface state: completed -> disconnected
>> Sep 11 16:49:45 Arbeits-PC NetworkManager[1104]: <info> (wlan0):
>> supplicant interface state: disconnected -> scanning
>> Sep 11 16:49:45 Arbeits-PC wpa_supplicant[1205]: wlan0: SME: Trying to
>> authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
>> Sep 11 16:49:45 Arbeits-PC kernel: [ 1750.282343] wlan0: authenticate with
>> a0:f3:c1:05:80:ec
>> Sep 11 16:49:45 Arbeits-PC NetworkManager[1104]: <info> (wlan0):
>> supplicant interface state: scanning -> authenticating
>> Sep 11 16:49:45 Arbeits-PC kernel: [ 1750.306287] wlan0: send auth to
>> a0:f3:c1:05:80:ec (try 1/3)
>> Sep 11 16:49:45 Arbeits-PC kernel: [ 1750.410098] wlan0: send auth to
>> a0:f3:c1:05:80:ec (try 2/3)
>> Sep 11 16:49:46 Arbeits-PC kernel: [ 1750.514232] wlan0: send auth to
>> a0:f3:c1:05:80:ec (try 3/3)
>> Sep 11 16:49:46 Arbeits-PC kernel: [ 1750.618374] wlan0: authentication
>> with a0:f3:c1:05:80:ec timed out
>>
>> So the AP is disconnecting the device a couple seconds with reason 4,
>> which is "Disassociated due to inactivity".  My thought is that this
>> points to a driver bug (Larry?).
>
>
> Possibly, but for reference, my Edimax EW-7811Un has been running for 37
> hours. During that time, I have had no deauthentications and only 2
> instances of the "AP lost" reconnections. The latter is what I am currently
> trying to fix, but at that error rate, it is difficult. I am running the
> latest 3.11 kernel from wireless testing.
>
> The only thing I am doing that is unusual is that I am pinging my router at
> a 5 second interval using the command
>
> ping -i5 192.168.1.1
>
> It is possible that I am preventing a power save operation, which is making
> a difference.
>
> Larry
>
