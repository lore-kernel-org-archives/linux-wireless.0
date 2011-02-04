Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41632 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab1BDT0G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 14:26:06 -0500
Message-ID: <4D4C52CA.3030806@openwrt.org>
Date: Fri, 04 Feb 2011 20:26:02 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Mark Mentovai <mark@moxienet.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: fix maximum tx power handling
References: <AANLkTi=4z31H+v2=Dve2FY3aw0iEBm5UQPz55Qx9UkwR@mail.gmail.com> <AANLkTikNUv2VuL8ftQAF_x4R-ccB0Y_aPFFdF52UBnBt@mail.gmail.com>
In-Reply-To: <AANLkTikNUv2VuL8ftQAF_x4R-ccB0Y_aPFFdF52UBnBt@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-02-04 8:20 PM, Luis R. Rodriguez wrote:
> On Sun, Jan 30, 2011 at 9:01 AM, Mark Mentovai <mark@moxienet.com> wrote:
>> I certainly like the idea of providing better feedback of the
>> effective power level, or even the power level limit, back to users.
>> This patch seems to artificially limit the effective power level in
>> some cases, while allowing a value in excess of what would be
>> appropriate in others.
> 
> John, Mark's interpretation is correct, the exception here is accepted
> because the driver request is being respected to override the max
> regulatory power, nothing more. Felix are you observing userspace
> requests overriding the orig power?
What I'm observing is that with the first regdomain setting it sets
orig_power to something that exceeds the tx power value that the
hardware is capable of using.
Because of that, the tx power setting reported to the user is wrong.

- Felix
