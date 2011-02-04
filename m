Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46689 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab1BDTgm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 14:36:42 -0500
Received: by iwn9 with SMTP id 9so2493624iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Feb 2011 11:36:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D4C52CA.3030806@openwrt.org>
References: <AANLkTi=4z31H+v2=Dve2FY3aw0iEBm5UQPz55Qx9UkwR@mail.gmail.com>
 <AANLkTikNUv2VuL8ftQAF_x4R-ccB0Y_aPFFdF52UBnBt@mail.gmail.com> <4D4C52CA.3030806@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 4 Feb 2011 11:36:22 -0800
Message-ID: <AANLkTi=x1HW0=a9_a4sPxHg-u7ApzDPbxpvobQzR9qeC@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: fix maximum tx power handling
To: Felix Fietkau <nbd@openwrt.org>
Cc: Mark Mentovai <mark@moxienet.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 4, 2011 at 11:26 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2011-02-04 8:20 PM, Luis R. Rodriguez wrote:
>> On Sun, Jan 30, 2011 at 9:01 AM, Mark Mentovai <mark@moxienet.com> wrote:
>>> I certainly like the idea of providing better feedback of the
>>> effective power level, or even the power level limit, back to users.
>>> This patch seems to artificially limit the effective power level in
>>> some cases, while allowing a value in excess of what would be
>>> appropriate in others.
>>
>> John, Mark's interpretation is correct, the exception here is accepted
>> because the driver request is being respected to override the max
>> regulatory power, nothing more. Felix are you observing userspace
>> requests overriding the orig power?
>
> What I'm observing is that with the first regdomain setting it sets
> orig_power to something that exceeds the tx power value that the
> hardware is capable of using.

Can you provide me with steps to repro?

> Because of that, the tx power setting reported to the user is wrong.

I see

  Luis
