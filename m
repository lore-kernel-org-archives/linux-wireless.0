Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:36740 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbdB0ULO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 15:11:14 -0500
Received: by mail-pf0-f172.google.com with SMTP id 89so6448577pfi.3
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2017 12:10:18 -0800 (PST)
From: Alexis Green <agreen@uniumwifi.com>
Reply-To: agreen@cococorp.com
Subject: Re: [PATCH v2] mac80211: Jitter HWMP MPATH reply frames to reduce
 collision on dense networks.
References: <58B09082.7020704@cococorp.com>
 (sfid-20170224_205905_277542_E6C0402D)
 <1488202227.28431.9.camel@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Jesse Jones <jjones@cococorp.com>
Message-ID: <58B487A8.7000602@cococorp.com> (sfid-20170227_211136_182377_6C5F67A7)
Date: Mon, 27 Feb 2017 12:10:16 -0800
MIME-Version: 1.0
In-Reply-To: <1488202227.28431.9.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

This is loosely based on RFC5148, specifically event-triggered message generation as described in section 5.2.
The frames are not duplicated, but, hopefully offset enough so they don't collide at the receiver (and, since, these are management frames, there is no retransmission and we may lose the information contained in them). If the two (or more) devices that reply are synchronized well enough, carrier sense will tell them that air is clear and messages will go out at the same time. It doesn't happen too often, but we found it noticeable enough in our testing.

Best regards,

Alexis Green

On 2/27/2017 5:30 AM, Johannes Berg wrote:
> On Fri, 2017-02-24 at 11:58 -0800, Alexis Green wrote:
>> From: Jesse Jones <jjones@uniumwifi.com>
>>
>> When more than one station hears a broadcast request, it is possible
>> that multiple devices will reply at the same time, potentially
>> causing collision. This patch helps reduce this issue.
> 
> It's not clear to me what you mean by "collision"? Over the air the NAV
> should handle the avoidance thereof, so I don't really see what this
> does wrt. collisions?
> 
> Are these frames somehow duplicates? But I don't see any suppression if
> you've already put a frame on the "jittered" list then it will never be
> deleted from it again, so it doesn't suppress anything in that sense?
> 
> johannes
> 
