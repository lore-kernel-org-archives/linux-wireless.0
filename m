Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40120 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab1HIQhj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 12:37:39 -0400
Received: by gxk21 with SMTP id 21so121611gxk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 09:37:38 -0700 (PDT)
Message-ID: <4E41624E.3010904@lwfinger.net> (sfid-20110809_183751_301880_6086A737)
Date: Tue, 09 Aug 2011 11:37:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: kc@cobradevil.org
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8192cu sometimes it can authenticate to ap
References: <b3059ba2eac66b7ef0ec17c8fe81a1e6@cobradevil.org> <34676454425401d650be733a43191a53@cobradevil.org> <532595cb4d5ef910de54a4736ba76185@cobradevil.org>
In-Reply-To: <532595cb4d5ef910de54a4736ba76185@cobradevil.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/09/2011 10:12 AM, kc@cobradevil.org wrote:
> Hello all,
>
> not sure what is happening but so far i have the following results:
> i downloaded the latest bleeding edge wireless from
> http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2
> I installed kernel headers and build-essentials end run:
> ./scripts/driver-select rtlwifi
> make && make install
>
> i downloaded the firmware from
> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git
>
> Running on Ubuntu maverick kernel 2.6.35-30 update 56 i get sometimes an
> authenticated message when running wpa_supplicant -Dnl80211 -c
> /etc/wpa_supplicant.conf -i wlan0 but most times it will timeout
> Running on Ubuntu natty kernel 2.6.38-10 update 46 i always get the
> authenticated message when running wpa_supplicant -Dnl80211 -c
> /etc/wpa_supplicant.conf -i wlan0
>
> only when using dhcp request on two accespoint i get different results on the
> natty driver but that has todo with:
> https://bugzilla.kernel.org/show_bug.cgi?id=38012 when applied i can connect two
> both accespoints.
>
> Any ideas why it does not work on the maverick kernel?

How does it work at all with a 2.6.38 kernel? Driver rtl8192cu was not added to 
the kernel until 2.6 39.

> Also when stopping the wpa_supplicant with ctrl+c and restart i first have to
> replug the device before it tries todo anything with the card.

What info is in the dmesg output in this case?

To debug the authentication case, run wpa_supplicant with the "-ddd" and "-f 
wpa_supplicant.log" switches. That way you will get a log of what is going wrong.

Larry
