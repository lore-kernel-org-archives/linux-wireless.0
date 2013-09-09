Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p15195424.pureserver.info ([82.165.34.74]:57532 "EHLO
	p15195424.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab3IIORu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 10:17:50 -0400
Message-ID: <522DD856.7050309@ilande.co.uk> (sfid-20130909_161800_438186_E95F1137)
Date: Mon, 09 Sep 2013 15:16:54 +0100
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Timothy Rundle <tgrundlesr@gmail.com>,
	linux-wireless@vger.kernel.org
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com> <522D054B.5060205@lwfinger.net>
In-Reply-To: <522D054B.5060205@lwfinger.net>
Subject: Re: RTL8192CU continually reconnecting
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/09/13 00:16, Larry Finger wrote:

> On 09/08/2013 06:53 AM, Timothy Rundle wrote:
>> My TL-WN821N with a RTL8192CU chipsets fails to stay connected. It
>> appears to be disconnecting every 5-10 seconds. Since the issue
>> happens with the mainline kernel, the downstream maintainer ask me to
>> post here. Here is a section of my kernel log:
>
> This problem has been reported before; however, I cannot duplicate it on
> my openSUSE KDE system that controls the wireless using NetworkManager.

Yes, this sounds like exactly the same problem that I reported a couple 
of weeks ago. Note that I see the issue invoking wpa_supplicant manually 
rather than using NetworkManager, so I don't think that this is part of 
the problem.

I can also clarify that if I remove *all* entries from 
wpa_supplicant.conf except for the one AP I'm trying to associate with, 
then I can generally get an initial association within about 30-60s. 
However I still repeatedly see drop-outs every 30s or so.

> When taking another look at the code, I realized that rtl8192cu has
> duplicated a routine that is found in rtlwifi. The attached patch
> implements that change. Please try it and report back. I don't expect it
> to do much good as your problem appears to be a bad interaction with the
> Ubuntu front-end to wireless.

I've just tried the attached patch, and while it applies cleanly, I see 
no change in behaviour in that I keep associating/deassociating from the 
AP :(

Larry, did those traces I sent you off-list help at all? I'm also happy 
to test patches that include more verbose debugging information in order 
to help further with this.

Also I notice that Debian Wheezy includes a slightly older version of 
wpa_supplicant:

# wpa_supplicant -v
wpa_supplicant v1.0
Copyright (c) 2003-2012, Jouni Malinen <j@w1.fi> and contributors

I could try building directly from source 1.1 and/or 2.0 if you think 
that would help too? Perhaps some internal Debian patches are having an 
effect here?


ATB,

Mark.
