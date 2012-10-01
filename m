Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44154 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab2JAMtt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 08:49:49 -0400
Received: by obbuo13 with SMTP id uo13so4871404obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2012 05:49:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHbMyCY=cvF6RLkn8SToRS2heHZpxxmC0TH9Ds-Yqo6SrzO8UA@mail.gmail.com>
References: <CAHbMyCZ0YU5Jim9kBaBNxmp946ZJfJyNf6f4HNEm8Eti9gO9QA@mail.gmail.com>
	<CAHbMyCYW3qW8R4VV4jGimaqYQHMRd8aeV8GU6Uu5CYNcWVch5Q@mail.gmail.com>
	<5069872D.4050607@broadcom.com>
	<CAHbMyCY=cvF6RLkn8SToRS2heHZpxxmC0TH9Ds-Yqo6SrzO8UA@mail.gmail.com>
Date: Mon, 1 Oct 2012 14:49:49 +0200
Message-ID: <CAHbMyCbJx3QwUMYV-QiZ=C0WSODa0uChnvuD6jAehY9=FLxu-w@mail.gmail.com> (sfid-20121001_144953_494892_8B76DB65)
Subject: Re: broadcom-sta-dkms: to version >= 6.20.55.19 (r300276)
From: Jasmine Hassan <jasmine.aura@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: 688823@bugs.debian.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And because, the log you're referencing, begins with:

# wpa_supplicant -d -Dnl80211,wext -ieth2 -u -s -O /var/run/wpa_supplicant

I obviously ran it with the same -D option used in functions.sh:
nl80211,wext (in the same order). Pointless, of course, as I know that
the wl.ko module loaded at the time was built with wext only. I guess
I could've just as well ran with -

On Mon, Oct 1, 2012 at 2:26 PM, Jasmine Hassan <jasmine.aura@gmail.com> wrote:
> Resend. Sorry, forgot to "reply all" on the last 2 emails
>
> because wpa_supplicant 1.0 (at least on LMDE/Debian testing) always
> tries nl80211 first
> # grep -i wext /etc/wpa_supplicant/*
> /etc/wpa_supplicant/functions.sh:# -D   driver backend ('wext' if none given)
> /etc/wpa_supplicant/functions.sh:
> WPA_SUP_OPTIONS="$WPA_SUP_OPTIONS
> -D nl80211,wext"
> /etc/wpa_supplicant/functions.sh:
> wpa_msg stderr "using
> \"nl80211,wext\" wpa-driver instead ..."
> /etc/wpa_supplicant/functions.sh:
> WPA_SUP_OPTIONS="$WPA_SUP_OPTIONS
> -D nl80211,wext"
> /etc/wpa_supplicant/functions.sh:               wpa_msg verbose "wpa-driver
> nl80211,wext (default)"
>
> --
>
> And to answer your other question, attached the complete snipped part
>
> --
> Jasmine
>
> On Mon, Oct 1, 2012 at 2:06 PM, Arend van Spriel <arend@broadcom.com> wrote:
>> On 09/27/2012 04:24 PM, Jasmine Hassan wrote:
>>>
>>> Update on 3.6-rc7 problems with wpasupplicant-1.0-2 and broadcom-sta
>>> 6.20.55.19 (r300276)
>>> 1. Fails to associate to AP (WPA encryption used) when wl.ko built with
>>> wext
>>> 2. Kernel bug when wl.ko built with nl/cfg80211
>>
>>
>> Commenting on issue 1 only, here.
>>
>>
>>>> Updated deb:
>>>> http://jas.gemnetworks.com/debian/wireless-bcm43142-dkms-6.20.55.19_amd64.deb
>>>>
>>>> Also tested on linux 3.5.0-4.dmz.1-liquorix-amd64, and it works for me
>>>>
>>>> Now, given a power regression in kernel 3.5, I was eager to test drive
>>>> 3.6-rc6, and found rc7 out already!
>>>> So yesterday I installed linux 3.6-rc7.towo.1-siduction-amd64, the
>>>> "wl" module compiles and installs, and loads okay upon boot to
>>>> 3.6-rc7. However, I'm unable to associate to my AP:
>>>>
>>>> Pointers in syslog
>>>> Sep 25 21:34:10 terra wpa_supplicant[2787]: nl80211: 'nl80211' generic
>>>> netlink not found
>>>> Sep 25 21:34:10 terra wpa_supplicant[2787]: Failed to initialize
>>>> driver 'nl80211'
>>>> [..snip]
>>
>>
>> Not sure what is snipped here. Your wpa_supplicant seems to try nl80211.
>> Maybe it goes and try WEXT instead, but that is missing from the log. Do you
>> recall or still have the entire syslog?
>>
>>
>>>> Sep 25 21:34:31 terra wpa_supplicant[2787]: eth2: Trying to associate
>>>> with 00:xx:xx:xx:xx:xx (SSID='xxxxxxx' freq=2452 MHz)
>>>> Sep 25 21:34:31 terra wpa_supplicant[2787]: eth2: Association request
>>>> to the driver failed
>>>>
>>>> As bcm43142 is fairly new, this proprietary driver is all that's there
>>>> to support it. Sad face.
>>>>
>>>> Cheers,
>>>> Jasmine
>>
>>
>> Gr. AvS
>>
>>
