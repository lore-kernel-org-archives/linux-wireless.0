Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:35890 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab0JOSr3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 14:47:29 -0400
Received: by pxi16 with SMTP id 16so167999pxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 11:47:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CB886AF.3070800@candelatech.com>
References: <AANLkTimp_GSwwX_RnQSyN9QNe55HQ+0HZJ1yd8Xp+dWG@mail.gmail.com>
 <AANLkTinyVqdgPqzpyihuaPtVVqDmzj-ZbXzQ-4qdA2yH@mail.gmail.com>
 <4CB77EA0.1000005@candelatech.com> <AANLkTimC0+6PiqWO+LmtBV7uKCVpZueAQs6m_6kAnbq9@mail.gmail.com>
 <AANLkTi=1oOCcdvBHo+8WAVHv-M8tE14ntmK4M_09SWh5@mail.gmail.com>
 <AANLkTi=pp2Ob06YCi6GsR9rtRaDWPP95n2M72qWLdbwM@mail.gmail.com>
 <20101014225150.GB15740@tux> <20101014231958.GA3242@tux> <4CB79299.7000005@candelatech.com>
 <AANLkTinQmE6wm1pXkRL6p_3rkMvNrppmirjj3-jagMp8@mail.gmail.com>
 <20101014234853.GA10113@tux> <4CB886AF.3070800@candelatech.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 15 Oct 2010 11:47:07 -0700
Message-ID: <AANLkTinhFj_iYjVzyfSfpUVdytfk4O9kCBnN8=Bwv0N7@mail.gmail.com>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
To: Ben Greear <greearb@candelatech.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 15, 2010 at 9:51 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 10/14/2010 04:48 PM, Luis R. Rodriguez wrote:
>>
>> On Thu, Oct 14, 2010 at 04:39:45PM -0700, Luis R. Rodriguez wrote:
>>>
>>> On Thu, Oct 14, 2010 at 4:30 PM, Ben Greear<greearb@candelatech.com>
>>>  wrote:
>>>>
>>>> On 10/14/2010 04:19 PM, Luis R. Rodriguez wrote:
>>>>>
>>>>> Ok please try this patch, it cures it for me.
>>>>
>>>> Well, it got a lot further than normal, but it still
>>>> hit the poison check after a few minutes.
>>>>
>>>> Current test case is my app loading 130 or so stations, each running
>>>> wpa_supplicant.  All were created, and quite a few had associated
>>>> when the poison check hit.
>>>>
>>>> So, it definitely looks like a step in the right direction, but
>>>> not fully fixed yet.
>>>>
>>>> I'll do some more testing with this patch applied and using just my
>>>> perl script to make sure the problem is reproducible outside of my
>>>> application.
>>>
>>> Ok, whatever userspace does it should not corrupt to kernel, unless
>>> its poking /dev/mem
>>
>> Can also try this one instead, it will prevent any other instances
>> we would not have caught on stopping and starting RX here.
>
> It ran longer than before any of your locking patches (about 3 minutes), but
> it did hit the poison check.
>
> Before it did, I had a bunch of OOM errors trying to allocate
> skbs.  I have 2GB of RAM on this system, but maybe it's not tuned
> properly, and not all of that can be used for networking on 32-bit
> kernels....
>
> I have Felix's 3 ani patches from ~3 days ago applied, running 130 stations
> in WPA mode.
>
> I'm going to try running fewer to dodge the OOM case,
> but I have a few other things to take care of first.

Thanks for testing. So now I cannot reproduce the poison anymore, any
other ideas what I can try? Does the perl script still give you poison
or just with your Über proprietary application?

  Luis
