Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbbCGFXy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 00:23:54 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/1] New driver: rtl8723au (mac80211)
References: <1425680126-25928-1-git-send-email-Jes.Sorensen@redhat.com>
	<54FA3D9E.40107@lwfinger.net>
Date: Sat, 07 Mar 2015 00:23:49 -0500
In-Reply-To: <54FA3D9E.40107@lwfinger.net> (Larry Finger's message of "Fri, 06
	Mar 2015 17:51:58 -0600")
Message-ID: <wrfj385hwfbu.fsf@ultrasam.lan.trained-monkey.org> (sfid-20150307_062357_833863_4D4CA18C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:
> On 03/06/2015 04:15 PM, Jes.Sorensen@redhat.com wrote:
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> This is a new driver for the rtl8723au which was written from scratch,
>> to utilize the Linux mac80211 stack.
>>
>> This has been a pet project for me for some time I finally feel it
>> is stable enough to submit. I have used it for a while without any
>> serious issues.
>>
>> I started working on cleaning up the vendor provided driver in
>> staging/rtl8723au over a year ago. After spending 6 months on it, it
>> became obvious to me that it was a rather hopeless task, and I started
>> writing this driver from scratch. I do not have any specs for the
>> chip, so everything is based on knowledge I obtained from dissecting
>> the vendor driver.
>>
>> Special thanks to Larry Finger for help with the original rtl8723au
>> driver, and Johannes Berg for answering all my silly questions about
>> 802.11 innards and the mac80211 stack. Had I known then what I know
>> today about 802.11, I probably would never have so mad as to start
>> this project in the first place!
>>
>> Cheers,
>> Jes
>
> Jes,
>
> Congratulations. You did something that I have wanted to do for some
> time, but I have never found the time. I hope a roadmap will help.
>
> I do have some suggestions:
>
> The name of your driver should be rtl8723au, rather than
> rtl8xxxu. When introducing any Realtek drivers into staging, I was
> careful to use only r8xxxyy so that the full rtl name would not
> conflict. This naming scheme also allows the possibility of adding
> more drivers such as RTL8723BU, RTL8188EU, RTL8192DU, etc. I also
> think that this code should be placed in a separate sub directory
> under drivers/net/wireless. If you want a separate directory, the name
> rtl8xxxu would be appropriate. I think it would also work to put these
> drivers in rtlwifi. Any of these other drivers should be able to share
> routines with this one, probably in the form of mini drivers such as
> rtlwifi for the PCI devices.
>
> I will do a review of the code, and I will have some suggestions there.
>
> Thanks,
>
> Larry

Hi Larry,

Actually the name 8xxxu was deliberate, it is not meant to be 8723au
only long term. I'd like to add support for some of the other recent USB
chips down the line. The difference between the 8xxxU devices is
relatively minor, so I don't think introducing full mini-drivers like in
rtlwifi is really ideal here. If the code grows substantially, we can
move it into a sub directory, but for now I think it's fine to keep it
as is.

This one is still a work in progress project, but I have been using it
as my primary driver for several months without issues. Plenty of work
to do, but it's getting there :)

Cheers,
Jes
