Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39079 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbaCNT2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2014 15:28:55 -0400
Received: by mail-pa0-f41.google.com with SMTP id fa1so3067174pad.28
        for <linux-wireless@vger.kernel.org>; Fri, 14 Mar 2014 12:28:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53232690.5040603@candelatech.com>
References: <CAGVrzcaWBAo3kiQ5jLKv_XMyuUL-pf1Vj2kL8E8YVnLrm4Mj7A@mail.gmail.com>
 <CAGXE3d9s-FjVWF-y1n8Zrgzz3YZJ-yNnEQNoVeMfZYJRfbdXTA@mail.gmail.com> <53232690.5040603@candelatech.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 14 Mar 2014 12:28:14 -0700
Message-ID: <CAGVrzcYBcXc=SL5S=oajj=OLMoD1mqy4=6nEc35xB0eUjGTSUA@mail.gmail.com> (sfid-20140314_202858_422511_2BC7F770)
Subject: Re: skb->priority magic values as part of UAPI headers?
To: Ben Greear <greearb@candelatech.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"open list:ATHEROS ATH5K WIR..." <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-03-14 8:56 GMT-07:00 Ben Greear <greearb@candelatech.com>:
> On 03/14/2014 02:26 AM, Helmut Schaa wrote:
>> On Thu, Mar 13, 2014 at 6:04 AM, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>> While browsing through net/wireless/util.c::cfg80211_classify8021d() I
>>> stumbled upon the "magic values" range 256 to 263, should not those be
>>> made part of some sort of user-space API header file, just so if
>>> things need to be changed, they suddenly do not break?
>>
>> I stumbled over that some time ago as well [1].
>> The question is if this is required at all anymore or if it could just
>> be removed.
>> Helmut
>
> I use it to easily poke user-space generated packets into specific
> transmit queues on the NIC.  Please do not remove it.

The initial question was whether that should be clearly stated as part
of ABI contract between the kernel and user-space, do you think this
belongs in some header in include/uapi?

Thanks!
-- 
Florian
