Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60971 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab0JNXkI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 19:40:08 -0400
Received: by gxk6 with SMTP id 6so97343gxk.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 16:40:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CB79299.7000005@candelatech.com>
References: <4CB4AA89.1070009@candelatech.com> <20101013053141.GA15798@vasanth-laptop>
 <4CB5E0A8.5020502@candelatech.com> <AANLkTimp_GSwwX_RnQSyN9QNe55HQ+0HZJ1yd8Xp+dWG@mail.gmail.com>
 <AANLkTinyVqdgPqzpyihuaPtVVqDmzj-ZbXzQ-4qdA2yH@mail.gmail.com>
 <4CB77EA0.1000005@candelatech.com> <AANLkTimC0+6PiqWO+LmtBV7uKCVpZueAQs6m_6kAnbq9@mail.gmail.com>
 <AANLkTi=1oOCcdvBHo+8WAVHv-M8tE14ntmK4M_09SWh5@mail.gmail.com>
 <AANLkTi=pp2Ob06YCi6GsR9rtRaDWPP95n2M72qWLdbwM@mail.gmail.com>
 <20101014225150.GB15740@tux> <20101014231958.GA3242@tux> <4CB79299.7000005@candelatech.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 14 Oct 2010 16:39:45 -0700
Message-ID: <AANLkTinQmE6wm1pXkRL6p_3rkMvNrppmirjj3-jagMp8@mail.gmail.com>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
To: Ben Greear <greearb@candelatech.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 14, 2010 at 4:30 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 10/14/2010 04:19 PM, Luis R. Rodriguez wrote:
>>
>> Ok please try this patch, it cures it for me.
>
> Well, it got a lot further than normal, but it still
> hit the poison check after a few minutes.
>
> Current test case is my app loading 130 or so stations, each running
> wpa_supplicant.  All were created, and quite a few had associated
> when the poison check hit.
>
> So, it definitely looks like a step in the right direction, but
> not fully fixed yet.
>
> I'll do some more testing with this patch applied and using just my
> perl script to make sure the problem is reproducible outside of my
> application.

Ok, whatever userspace does it should not corrupt to kernel, unless
its poking /dev/mem

  Luis
