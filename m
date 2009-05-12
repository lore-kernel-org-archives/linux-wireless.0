Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:63504 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbZELT73 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 15:59:29 -0400
Received: by fxm2 with SMTP id 2so202097fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 12:59:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242156469.14227.7.camel@johannes.local>
References: <1242125077.4331.0.camel@johannes.local>
	 <3ace41890905121205v76d6b61cg94d0bbe55c04da7e@mail.gmail.com>
	 <3ace41890905121208s2029db39p730b2e174cd4b1e6@mail.gmail.com>
	 <1242156469.14227.7.camel@johannes.local>
Date: Tue, 12 May 2009 20:59:28 +0100
Message-ID: <3ace41890905121259jeb504d7v78fe8f062fca7d21@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: fix a couple of bugs with key ioctls
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/12/09, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2009-05-12 at 20:05 +0100, Hin-Tak Leung wrote:
>
>> I tried this, NM/wpa_suplicany still doesn't work, but if I shut those
>> down and do it the old fashioned iwconfig way, I can get
>> connectivity...
>
> That's odd. Are you getting "connectivity" with a WEP network then?

Yes,


On 5/12/09, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2009-05-12 at 20:08 +0100, Hin-Tak Leung wrote:
>
>> BTW, nm fails to connect with
>>  <WARN>  nm_device_wifi_disable_encryption(): error setting key for
>> device wlan2: No such file or directory
>
> As Dan said, you can ignore this message. However, I'm certainly no
> longer getting it. Are you sure you rebooted into the correct kernel and
> loaded the correct cfg80211 module?

This is a different one from the last - it was 'Invalid argument' ,
now 'No such file or directory' - but wlan2 is certainly there...

I am operating in compat-wireless, so it is just make clean && make ,
etc, blow away /lib/module/<ver>/updates, depmod -a ; and I did run
modprobe -v to see it is loaded from the alternative...

> I have now tested WPA-PSK and WEP with wpa_supplicant and WEP with
> manual configuration and it all works.

I'll give it another try with NM/wpa_supplicant...
