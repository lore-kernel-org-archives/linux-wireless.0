Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:36755 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753498AbcIEIdR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Sep 2016 04:33:17 -0400
Received: by mail-pf0-f182.google.com with SMTP id h186so62883683pfg.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Sep 2016 01:33:16 -0700 (PDT)
Subject: Re: [PATCH] mwifiex: handle edmac vendor command
To: Kalle Valo <kvalo@codeaurora.org>,
        Amitkumar Karwar <akarwar@marvell.com>
References: <1461945483-3239-1-git-send-email-akarwar@marvell.com>
 <cbd542a552db4d368a5b402307976494@SC-EXCH04.marvell.com>
 <87zirg8qxo.fsf@kamboji.qca.qualcomm.com>
 <e2b7d7d9aef1488a97eb7ec44b4c46af@SC-EXCH04.marvell.com>
 <87poon1xka.fsf@kamboji.qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <2320ad20-164e-12c5-0b01-9612a1d24300@broadcom.com> (sfid-20160905_103321_153519_FF9C90CC)
Date: Mon, 5 Sep 2016 10:33:02 +0200
MIME-Version: 1.0
In-Reply-To: <87poon1xka.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1-9-2016 16:53, Kalle Valo wrote:
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
>>> From: Kalle Valo [mailto:kvalo@codeaurora.org]
>>> Sent: Tuesday, May 24, 2016 1:53 AM
>>> To: Amitkumar Karwar
>>> Cc: linux-wireless@vger.kernel.org
>>> Subject: Re: [PATCH] mwifiex: handle edmac vendor command
>>>
>>> Amitkumar Karwar <akarwar@marvell.com> writes:
>>>
>>>> Hi Kalle,
>>>>
>>>>> From: Amitkumar Karwar [mailto:akarwar@marvell.com]
>>>>> Sent: Friday, April 29, 2016 9:28 PM
>>>>> To: linux-wireless@vger.kernel.org
>>>>> Cc: Jeff CF Chen; Amitkumar Karwar
>>>>> Subject: [PATCH] mwifiex: handle edmac vendor command
>>>>>
>>>>> From: chunfan chen <jeffc@marvell.com>
>>>>>
>>>>> Userspace can configure edmac values through a custom vendor command.
>>>>> They will be used by hardware for adaptivity.
>>>>>
>>>>> Signed-off-by: chunfan chen <jeffc@marvell.com>
>>>>> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
>>>
>>> [deleted over 200 lines of unnecessary quotes]
>>>
>>>> This patch seems to have deferred. We basically want a way to download
>>>> a vendor specific configuration to our firmware. Do you have any
>>>> suggestions on how can achieve this in better way?
>>>>
>>>> I can see below iw command suits our requirement.
>>>>
>>>> iw dev <devname> vendor send <oui> <subcmd> <filename|-|hex data>
>>>>
>>>> Please guide.
>>>
>>> It was deferred because use of the nl80211 vendor interface (which I
>>> don't think belong to upstream drivers). I'll take a look at this patch
>>> in detail after the merge window.
>>>
>>
>> Did you get a chance to check this patch?
>> Please let me know if you have any suggestions.
> 
> Sorry for the delay. I have been thinking about vendor commands quite a
> lot and I don't think they belong to upstream drivers. For regular use
> cases (used by normal users) we have nl80211, for developer and testing
> purposes we have debugfs and for manufacturing type of tests we have
> nl80211 testmode interface. The focus of development should be adding
> new functionality to nl80211 (and other generic interfaces), not to
> driver specific vendor commands.
> 
> I know brcm80211 and ti's wlcore have few vendor commands but I'm hoping
> to remove them sometime soon.
> 
> Thoughts?

Grabbing the original commit message for vendor commands:

commit ad7e718c9b4f717823fd920a0103f7b0fb06183f
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Wed Nov 13 13:37:47 2013 +0100

    nl80211: vendor command support

    Add support for vendor-specific commands to nl80211. This is
    intended to be used for really vendor-specific functionality
    that can't be implemented in a generic fashion for any reason.
    It's *NOT* intended to be used for any normal/generic feature
    or any optimisations that could be implemented across drivers.

I agree that the effort needs to be made to come up with a solution that
is usable by (most of) all drivers in the upstream wireless subsystem.

The thing with the test mode is that you need to enable it in Kconfig.
We have 1 vendor command in brcmfmac and it used to be under testmode
api. However, because of the Kconfig thing it would mean we need a
different kernel to do manufacturing testing. Especially when the
modules are built-in. The OEMs typically don't like that as they want to
do the testing using the same kernel as what ends up in the product.
This was our motivation to use the vendor command when that was added.

It does have a nasty side-effect that some will see it as a drop-in
replacement of the driver private ioctl-s. To some extent (as mentioned
in the commit message above) that should be fine, but we need to make a
good effort to move things to nl80211.

Regards,
Arend
