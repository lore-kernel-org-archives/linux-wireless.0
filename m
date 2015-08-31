Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:36656 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbbHaPpi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 11:45:38 -0400
Received: by obkg7 with SMTP id g7so93927838obk.3
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2015 08:45:38 -0700 (PDT)
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
To: Jes Sorensen <Jes.Sorensen@redhat.com>
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
 <1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
 <55E289A3.6030001@lwfinger.net> <wrfjegik8vqy.fsf@redhat.com>
 <55E39707.60101@lwfinger.net> <wrfjy4gs5ggd.fsf@redhat.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	johannes@sipsolutions.net
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <55E476A0.4080601@lwfinger.net> (sfid-20150831_174541_249461_53FDF668)
Date: Mon, 31 Aug 2015 10:45:36 -0500
MIME-Version: 1.0
In-Reply-To: <wrfjy4gs5ggd.fsf@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/30/2015 09:39 PM, Jes Sorensen wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>> On 08/30/2015 01:41 PM, Jes Sorensen wrote:
>>>> The above statement generated a "scheduling while atomic" splat. The
>>>> gfp_t argument needs to be GFP_KERNEL.
>>>
>>> You are seeing scheduling while atomic in the TX path? That just seems
>>> wrong to me - Johannes is the mac80211 TX path not meant to allow
>>> sleeping?
>>>
>>> I have never seen this on x86 and I have been running the driver for a
>>> long time. It is puzzling this causes a problem on PowerPC. It there
>>> something special in the config for it? I am inclined to say there is
>>> something wrong with the PPC32 setup rather than with my usage of
>>> GFP_KERNEL in the TX path.
>>
>> The scheduling while atomic problem is on x86_64, not on PPC. I have
>> lots of debugging/testing turned on in my configuration, but I cannot
>> really identify which one might turn on the message. My config uses
>> SLUB memory allocation, but that shouldn't matter either.
>
> I had some problems with mail delivery, so you may receive another
> answer later - I checked up on it, and it was indeed a bug. You can
> check my git branch for a version that won't suffer from this.
>
>>>>> +{USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x817e, 0xff,
>>>> 0xff, 0xff),
>>>>> +	.driver_info = (unsigned long)&rtl8192cu_fops},
>>>>
>>>> I have tested a device with USB ID 0x0bda (USB_VENDOR_ID_REALTEK):0x817e.
>>>
>>> Were you happy with the results, or did it cause problems? Ie. did you
>>> try on x86 or on PPC32?
>>
>> As covered in the other mail, it works very well at G rates.
>
> I see - I am a little confused, it works well on G rates but not on N
> rates, or was this due to the AP used?

The AP is AC1200. It supports full N rates on other devices.
>
>>> I don't think any of this is showstopper material for inclusion right
>>> now, albeit I do want to address them.
>>
>> The scheduling while atomic problems do need to be fixed, and I am
>> still working on the failure to get a wifi device on PPC.
>
> It's already fixed :)

A full debug=0x3fff showed me one problem on the PPC. I will be testing a patch 
later today.

Larry


