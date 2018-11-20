Return-Path: <SRS0=1os+=N7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A4DDC43441
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 00:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D407820851
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 00:20:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D407820851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=candelatech.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731284AbeKTKrB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Nov 2018 05:47:01 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:44758 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbeKTKrB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Nov 2018 05:47:01 -0500
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id CD5DE40A5A2;
        Mon, 19 Nov 2018 16:20:42 -0800 (PST)
Subject: Re: [Make-wifi-fast] [PATCH v3 3/6] mac80211: Add airtime accounting
 and scheduling to TXQs
To:     Dave Taht <dave.taht@gmail.com>
References: <1542063113-22438-1-git-send-email-rmanohar@codeaurora.org>
 <1542063113-22438-4-git-send-email-rmanohar@codeaurora.org>
 <e5344cad-2a18-a938-f2ed-43870027251c@nbd.name> <871s7nv9pl.fsf@toke.dk>
 <8e7847ff-4c88-10ae-2223-2fc7321641d9@nbd.name> <87sh02tfsp.fsf@toke.dk>
 <878t1p2bqz.fsf@taht.net> <87muq4sn50.fsf@toke.dk>
 <4DD985B6-7DBE-42F8-AC87-D6B40CEAE553@superduper.net>
 <CAA93jw4Cih5HkHYUOy7Vr5G7zi0KkKmNnNohDAVaj65goWOh+A@mail.gmail.com>
 <b0662c97-fb17-3f9d-693e-2fec92535076@candelatech.com>
 <CAA93jw5tgKcRM9x0gd-7SKf=qBbjhSip64e1oQqUB6N67FhdmA@mail.gmail.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>,
        Simon Barber <simon@superduper.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>, Felix Fietkau <nbd@nbd.name>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <6beaeb84-b705-335b-93a7-36176495099b@candelatech.com>
Date:   Mon, 19 Nov 2018 16:20:42 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.0
MIME-Version: 1.0
In-Reply-To: <CAA93jw5tgKcRM9x0gd-7SKf=qBbjhSip64e1oQqUB6N67FhdmA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/19/2018 04:13 PM, Dave Taht wrote:
> On Mon, Nov 19, 2018 at 3:56 PM Ben Greear <greearb@candelatech.com> wrote:
>>
>> On 11/19/2018 03:47 PM, Dave Taht wrote:
>>> On Mon, Nov 19, 2018 at 3:30 PM Simon Barber <simon@superduper.net> wrote:
>>>>
>>>>
>>>>
>>>> On Nov 19, 2018, at 2:44 PM, Toke Høiland-Jørgensen <toke@toke.dk> wrote:
>>>>
>>>> Dave Taht <dave@taht.net> writes:
>>>>
>>>> Toke Høiland-Jørgensen <toke@toke.dk> writes:
>>>>
>>>> Felix Fietkau <nbd@nbd.name> writes:
>>>>
>>>> On 2018-11-14 18:40, Toke Høiland-Jørgensen wrote:
>>>>
>>>> This part doesn't really make much sense to me, but maybe I'm
>>>> misunderstanding how the code works.
>>>> Let's assume we have a driver like ath9k or mt76, which tries to keep a
>>>>
>>>> ….
>>>>
>>>>
>>>> Well, there's going to be a BQL-like queue limit (but for airtime) on
>>>> top, which drivers can opt-in to if the hardware has too much queueing.
>>>>
>>>>
>>>> Very happy to read this - I first talked to Dave Taht about the need for Time Queue Limits more than 5 years ago!
>>>
>>> Michal faked up a dql estimator 3 (?) years ago. it worked.
>>>
>>> http://blog.cerowrt.org/post/dql_on_wifi_2/
>>>
>>> As a side note, in *any* real world working mu-mimo situation at any
>>> scale, on any equipment, does anyone have any stats on how often the
>>> feature is actually used and useful?
>>>
>>> My personal guess, from looking at the standard, was in home
>>> scenarios, usage would be about... 0, and in a controlled environment
>>> in a football stadium, quite a lot.
>>>
>>> In a office or apartment complex, I figured interference and so forth
>>> would make it a negative benefit due to retransmits.
>>>
>>> I felt when that part of the standard rolled around... that mu-mimo
>>> was an idea that should never have escaped the lab. I can be convinced
>>> by data, that we can aim for a higher goal here. But it would be
>>> comforting to have a measured non-lab, real-world, at real world
>>> rates, result for it, on some platform, of it actually being useful.
>>
>> We're working on building a lab with 20 or 30 mixed 'real' devices
>> using various different /AC NICs (QCA wave2 on OpenWRT, Fedora, realtek USB 8812au on OpenWRT, Fedora,
>> and some Intel NICs in NUCs on Windows, and maybe more).  I'm not actually sure if that realtek
>>   or the NUCs can do MU-MIMO or not, but the QCA NICs will be able to.  It should be at least somewhat similar
>> to a classroom environment or coffee shop.
>
> In the last 3 coffee shops I went to, I could hear over 30 APs on
> competing SSIDs, running G, N, and AC,
> occupying every available channel.

I especially like when someone uses channel 3 because, I guess, they
think it is un-used :)

I'm not sure if this was a fluke or not, but at Starbucks recently I sat outside,
right next to their window, and could not scan their AP at all.  Previously, I sat
inside, 3 feet away through the glass, and got great signal.  I wonder what that was
all about!  Maybe special tinting that blocks RF?  Or just dumb luck of some sort.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

