Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:35413 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbbEPSSz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2015 14:18:55 -0400
Received: by labbd9 with SMTP id bd9so166174086lab.2
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2015 11:18:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1431714949.2117.0.camel@sipsolutions.net>
References: <CANUX_P31bbOr8WhTY5D+M7QraVqJeCdw-qxME0GWmOQtLksb9A@mail.gmail.com>
	<1431674716.2426.2.camel@sipsolutions.net>
	<CANUX_P0HN5z-c6M_KcnJxT1LBPDP=OC9JnsaPPRf9RcDuw4hug@mail.gmail.com>
	<1431714949.2117.0.camel@sipsolutions.net>
Date: Sat, 16 May 2015 21:18:53 +0300
Message-ID: <CANUX_P2Xf9i9P3G5LgUm0bjCMSMpQwecJ1S4qH6RuurrkuSp-A@mail.gmail.com> (sfid-20150516_201906_439805_243190EE)
Subject: Re: mac80211 drops packet with old IV after rekeying
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 15, 2015 at 9:35 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2015-05-15 at 10:52 +0300, Emmanuel Grumbach wrote:
>> >> I'd be glad if someone could take a look. If not, I'll have someone
>> >> from our team to look at it, but I don't know how long it will take...
>> >
>> > Without looking too much - it seems to me that this is a fundamental
>> > problem with PTK rekeying, in that it re-uses the key index that is
>> > intended to avoid this.
>>
>> In this case, the AP is openWRT. I guess the Key idx is chosen in
>> software, so maybe the proper fix would be to have openWRT increment
>> the key index when it rekeys?
>
> Neither the spec nor the code allow that.
>

I don't get it. I might have misunderstood your previous mail, but I
thought that you were saying the key index was meant to solve this:
the peer could know what key was used based on the key index written
in the frame (I guess it is there somehow) so that the Rx handling
code can know that the jump in the PN is due to a rekeying and not use
any heuristic. I though you meant that the Txing side had a poor
implementation because it reused the same key index before and after
the rekeying which can obviously lead to problems.
Now you seem to say that changing the key index upon rekeying is not
allowed by spec?
What is it good for then?

Again - I am just trying to close this bug, not to learn this subject.
I can learn by reading spec / reading code and less by wasting your
time :)
