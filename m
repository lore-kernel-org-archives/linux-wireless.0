Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3538 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab2JAMGS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 08:06:18 -0400
Message-ID: <5069872D.4050607@broadcom.com> (sfid-20121001_140621_360521_03C8A963)
Date: Mon, 1 Oct 2012 14:06:05 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Jasmine Hassan" <jasmine.aura@gmail.com>
cc: 688823@bugs.debian.org, linux-wireless@vger.kernel.org
Subject: Re: broadcom-sta-dkms: to version >= 6.20.55.19 (r300276)
References: <CAHbMyCZ0YU5Jim9kBaBNxmp946ZJfJyNf6f4HNEm8Eti9gO9QA@mail.gmail.com>
 <CAHbMyCYW3qW8R4VV4jGimaqYQHMRd8aeV8GU6Uu5CYNcWVch5Q@mail.gmail.com>
In-Reply-To: <CAHbMyCYW3qW8R4VV4jGimaqYQHMRd8aeV8GU6Uu5CYNcWVch5Q@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/27/2012 04:24 PM, Jasmine Hassan wrote:
> Update on 3.6-rc7 problems with wpasupplicant-1.0-2 and broadcom-sta
> 6.20.55.19 (r300276)
> 1. Fails to associate to AP (WPA encryption used) when wl.ko built with wext
> 2. Kernel bug when wl.ko built with nl/cfg80211

Commenting on issue 1 only, here.

>> Updated deb: http://jas.gemnetworks.com/debian/wireless-bcm43142-dkms-6.20.55.19_amd64.deb
>>
>> Also tested on linux 3.5.0-4.dmz.1-liquorix-amd64, and it works for me
>>
>> Now, given a power regression in kernel 3.5, I was eager to test drive
>> 3.6-rc6, and found rc7 out already!
>> So yesterday I installed linux 3.6-rc7.towo.1-siduction-amd64, the
>> "wl" module compiles and installs, and loads okay upon boot to
>> 3.6-rc7. However, I'm unable to associate to my AP:
>>
>> Pointers in syslog
>> Sep 25 21:34:10 terra wpa_supplicant[2787]: nl80211: 'nl80211' generic
>> netlink not found
>> Sep 25 21:34:10 terra wpa_supplicant[2787]: Failed to initialize
>> driver 'nl80211'
>> [..snip]

Not sure what is snipped here. Your wpa_supplicant seems to try nl80211. 
Maybe it goes and try WEXT instead, but that is missing from the log. Do 
you recall or still have the entire syslog?

>> Sep 25 21:34:31 terra wpa_supplicant[2787]: eth2: Trying to associate
>> with 00:xx:xx:xx:xx:xx (SSID='xxxxxxx' freq=2452 MHz)
>> Sep 25 21:34:31 terra wpa_supplicant[2787]: eth2: Association request
>> to the driver failed
>>
>> As bcm43142 is fairly new, this proprietary driver is all that's there
>> to support it. Sad face.
>>
>> Cheers,
>> Jasmine

Gr. AvS


