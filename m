Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbbHaNHt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 09:07:49 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	johannes@sipsolutions.net
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	<1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	<55E289A3.6030001@lwfinger.net> <wrfjegik8vqy.fsf@redhat.com>
	<55E39707.60101@lwfinger.net>
Date: Sun, 30 Aug 2015 22:39:46 -0400
In-Reply-To: <55E39707.60101@lwfinger.net> (Larry Finger's message of "Sun, 30
	Aug 2015 18:51:35 -0500")
Message-ID: <wrfjy4gs5ggd.fsf@redhat.com> (sfid-20150831_150800_746636_3539741D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:
> On 08/30/2015 01:41 PM, Jes Sorensen wrote:
>>> The above statement generated a "scheduling while atomic" splat. The
>>> gfp_t argument needs to be GFP_KERNEL.
>>
>> You are seeing scheduling while atomic in the TX path? That just seems
>> wrong to me - Johannes is the mac80211 TX path not meant to allow
>> sleeping?
>>
>> I have never seen this on x86 and I have been running the driver for a
>> long time. It is puzzling this causes a problem on PowerPC. It there
>> something special in the config for it? I am inclined to say there is
>> something wrong with the PPC32 setup rather than with my usage of
>> GFP_KERNEL in the TX path.
>
> The scheduling while atomic problem is on x86_64, not on PPC. I have
> lots of debugging/testing turned on in my configuration, but I cannot
> really identify which one might turn on the message. My config uses
> SLUB memory allocation, but that shouldn't matter either.

I had some problems with mail delivery, so you may receive another
answer later - I checked up on it, and it was indeed a bug. You can
check my git branch for a version that won't suffer from this.

>>>> +{USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x817e, 0xff,
>>> 0xff, 0xff),
>>>> +	.driver_info = (unsigned long)&rtl8192cu_fops},
>>>
>>> I have tested a device with USB ID 0x0bda (USB_VENDOR_ID_REALTEK):0x817e.
>>
>> Were you happy with the results, or did it cause problems? Ie. did you
>> try on x86 or on PPC32?
>
> As covered in the other mail, it works very well at G rates.

I see - I am a little confused, it works well on G rates but not on N
rates, or was this due to the AP used?

>> I don't think any of this is showstopper material for inclusion right
>> now, albeit I do want to address them.
>
> The scheduling while atomic problems do need to be fixed, and I am
> still working on the failure to get a wifi device on PPC.

It's already fixed :)

Cheers,
Jes
