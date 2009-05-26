Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:57147 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759054AbZEZXvl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 19:51:41 -0400
Received: by bwz22 with SMTP id 22so4207023bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 26 May 2009 16:51:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A1C74C1.7060600@gmx.net>
References: <4A199FED.7000609@gmx.net>
	 <3ace41890905242315i53dbb93dsf98e7a3a574a3c29@mail.gmail.com>
	 <4A1B00E7.5070801@gmx.net>
	 <3ace41890905251414v75544ed4o7bafdb3cdc170d1d@mail.gmail.com>
	 <4A1B2186.3070107@gmx.net>
	 <3ace41890905252258p54d858b0qfc172284cb65423f@mail.gmail.com>
	 <4A1C1766.3030004@gmx.net> <4A1C74C1.7060600@gmx.net>
Date: Wed, 27 May 2009 00:51:41 +0100
Message-ID: <3ace41890905261651l1cd3742bu5ac1af6f631798f3@mail.gmail.com>
Subject: Re: RTL 8185
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Barkle <barkle@gmx.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 27, 2009 at 12:01 AM, Barkle <barkle@gmx.net> wrote:
> Barkle schrieb:
>>
>> Hin-Tak Leung schrieb:
>>>
>>> I am asking to a 2nd time - try compat-wireless.
>>
>> When I compile compat-wireless, I get an error
>>
> After commenting out in the file "config.mk" the line
> #CONFIG_MAC80211_LEDS=y

Hmm, your kernel config did not seem to have LEDS_TRIGGER defined.
That's a problem with non-distro custom-rolled kernel... For that
matter, which bits of the kernel did you build as modules and which
compiled in? I guess I need the output of these two commands:

    lsmod
    find /lib/modules/`uname -r`/updates

> the code compiles without an error.
> Then "make install", reboot and "wpa_supplicant -Dwext -iwlan0
> -c/etc/wpa_supplicant/wpa_supplicant.conf -W -dd" => kernel freeze.

Hmm, can you *not* run wpa_supplicant? This is about the 3rd time I
asked - if you are not using encryption, you don't need
wpa_supplicant. You should be doing just 'ifconfig wlan0 up', and
'ifconfig wlan0' and 'iwconfig wlan0' and see what they say. And do
*not* do it in X - if there is any last minute crash message, it would
be in the text console and you should be better doing these in
run-level 3.

> What else can I do?
> Where can I see which version of the driver are used?

There isn't really a 'version' for the driver - it entered the kernel
about a year and half ago, and only a few people had worked on it
since, and not in any major way.
