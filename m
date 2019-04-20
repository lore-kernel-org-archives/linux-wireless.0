Return-Path: <SRS0=vWlE=SW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8817FC282DD
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Apr 2019 21:32:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F1912087B
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Apr 2019 21:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbfDTVQC convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Apr 2019 17:16:02 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45251 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfDTVQC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Apr 2019 17:16:02 -0400
Received: by mail-ed1-f67.google.com with SMTP id k92so6859552edc.12
        for <linux-wireless@vger.kernel.org>; Sat, 20 Apr 2019 14:16:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=bFHba6g5LOK2hpMjgYJcXDbjHK43XE3J6EaoLQMq7Sg=;
        b=LgEEQe6NvdL7svm96K48jwc5I3XJbnZGDAnvL1beLyNqsZQ9KNtcHyPLARgMzUhbKs
         dUKXKIqyc+Kyxh8wQQnqNLK8oYMhGxEq6H9cZv7xbx9x9eGh8uFX92yPUuKcwUhICe3y
         tWTFoH9KzEhYlKNSK4F1hzzNnLyMSP44i9qQMtuzDWNKFmsEL9c2Fa3nMl4aeuE+8lZD
         2ziJdUIo1q60JQ5UZBUqk5FjpDdYMp9UwBsNSeByNEaRU4hZWvNBVtFy9NE8pjc7RvLw
         x6qzscy2hiMnNuZx8DSjYeENp3gZufmP3FEt5KUSQ7/qXpCc0VfC94tdsDx0FZ9iFu07
         w7TQ==
X-Gm-Message-State: APjAAAVL1hsWJcNS5Xaz6oRdoBE5W55v6WxrJwP3kBY/AnJHeX3EMw1F
        LLDU/qMTGzXK/39HWlIBgselIQ==
X-Google-Smtp-Source: APXvYqw9Up3ilL5pgWilKGFr08FrPWNcybTFrD9EsQciNZZJGBuoCtUGhlZHdjq2dSUZrOozVLgmJA==
X-Received: by 2002:a50:9a02:: with SMTP id o2mr6845822edb.182.1555794959968;
        Sat, 20 Apr 2019 14:15:59 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id b8sm1363381edk.16.2019.04.20.14.15.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 20 Apr 2019 14:15:59 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3C02E1800E8; Sat, 20 Apr 2019 23:15:55 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Yibo Zhao <yiboz@codeaurora.org>
Cc:     make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC/RFT] mac80211: Switch to a virtual time-based airtime scheduler
In-Reply-To: <76591d2924d7b6fec06d0df07247166a@codeaurora.org>
References: <20190215170512.31512-1-toke@redhat.com> <753b328855b85f960ceaf974194a7506@codeaurora.org> <87ftqy41ea.fsf@toke.dk> <acd33756e87ea64c608e306e5ee60aa2@codeaurora.org> <877ec2ykrh.fsf@toke.dk> <89d32174b282006c8d4e7614657171be@codeaurora.org> <87a7gyw3cu.fsf@toke.dk> <73077ba7cda566d5eeb2395978b3524c@codeaurora.org> <877ec0u6mu.fsf@toke.dk> <76591d2924d7b6fec06d0df07247166a@codeaurora.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 20 Apr 2019 22:15:55 +0100
Message-ID: <87bm10ped0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yibo Zhao <yiboz@codeaurora.org> writes:

> On 2019-04-11 19:24, Toke Høiland-Jørgensen wrote:
>> Yibo Zhao <yiboz@codeaurora.org> writes:
>> 
>>> On 2019-04-10 18:40, Toke Høiland-Jørgensen wrote:
>>>> Yibo Zhao <yiboz@codeaurora.org> writes:
>>>> 
>>>>> On 2019-04-10 04:41, Toke Høiland-Jørgensen wrote:
>>>>>> Yibo Zhao <yiboz@codeaurora.org> writes:
>>>>>> 
>>>>>>> On 2019-04-04 16:31, Toke Høiland-Jørgensen wrote:
>>>>>>>> Yibo Zhao <yiboz@codeaurora.org> writes:
>>>>>>>> 
>>>>>>>>> On 2019-02-16 01:05, Toke Høiland-Jørgensen wrote:
>>>>>>>>>> This switches the airtime scheduler in mac80211 to use a 
>>>>>>>>>> virtual
>>>>>>>>>> time-based
>>>>>>>>>> scheduler instead of the round-robin scheduler used before. 
>>>>>>>>>> This
>>>>>>>>>> has
>>>>>>>>>> a
>>>>>>>>>> couple of advantages:
>>>>>>>>>> 
>>>>>>>>>> - No need to sync up the round-robin scheduler in
>>>>>>>>>> firmware/hardware
>>>>>>>>>> with
>>>>>>>>>>   the round-robin airtime scheduler.
>>>>>>>>>> 
>>>>>>>>>> - If several stations are eligible for transmission we can
>>>>>>>>>> schedule
>>>>>>>>>> both of
>>>>>>>>>>   them; no need to hard-block the scheduling rotation until the
>>>>>>>>>> head
>>>>>>>>>> of
>>>>>>>>>> the
>>>>>>>>>>   queue has used up its quantum.
>>>>>>>>>> 
>>>>>>>>>> - The check of whether a station is eligible for transmission
>>>>>>>>>> becomes
>>>>>>>>>>   simpler (in ieee80211_txq_may_transmit()).
>>>>>>>>>> 
>>>>>>>>>> The drawback is that scheduling becomes slightly more 
>>>>>>>>>> expensive,
>>>>>>>>>> as
>>>>>>>>>> we
>>>>>>>>>> need
>>>>>>>>>> to maintain an rbtree of TXQs sorted by virtual time. This 
>>>>>>>>>> means
>>>>>>>>>> that
>>>>>>>>>> ieee80211_register_airtime() becomes O(logN) in the number of
>>>>>>>>>> currently
>>>>>>>>>> scheduled TXQs. However, hopefully this number rarely grows too
>>>>>>>>>> big
>>>>>>>>>> (it's
>>>>>>>>>> only TXQs currently backlogged, not all associated stations), 
>>>>>>>>>> so
>>>>>>>>>> it
>>>>>>>>>> shouldn't be too big of an issue.
>>>>>>>>>> 
>>>>>>>>>> @@ -1831,18 +1830,32 @@ void
>>>>>>>>>> ieee80211_sta_register_airtime(struct
>>>>>>>>>> ieee80211_sta *pubsta, u8 tid,
>>>>>>>>>>  {
>>>>>>>>>>  	struct sta_info *sta = container_of(pubsta, struct sta_info,
>>>>>>>>>> sta);
>>>>>>>>>>  	struct ieee80211_local *local = sta->sdata->local;
>>>>>>>>>> +	struct ieee80211_txq *txq = sta->sta.txq[tid];
>>>>>>>>>>  	u8 ac = ieee80211_ac_from_tid(tid);
>>>>>>>>>> -	u32 airtime = 0;
>>>>>>>>>> +	u64 airtime = 0, weight_sum;
>>>>>>>>>> +
>>>>>>>>>> +	if (!txq)
>>>>>>>>>> +		return;
>>>>>>>>>> 
>>>>>>>>>>  	if (sta->local->airtime_flags & AIRTIME_USE_TX)
>>>>>>>>>>  		airtime += tx_airtime;
>>>>>>>>>>  	if (sta->local->airtime_flags & AIRTIME_USE_RX)
>>>>>>>>>>  		airtime += rx_airtime;
>>>>>>>>>> 
>>>>>>>>>> +	/* Weights scale so the unit weight is 256 */
>>>>>>>>>> +	airtime <<= 8;
>>>>>>>>>> +
>>>>>>>>>>  	spin_lock_bh(&local->active_txq_lock[ac]);
>>>>>>>>>> +
>>>>>>>>>>  	sta->airtime[ac].tx_airtime += tx_airtime;
>>>>>>>>>>  	sta->airtime[ac].rx_airtime += rx_airtime;
>>>>>>>>>> -	sta->airtime[ac].deficit -= airtime;
>>>>>>>>>> +
>>>>>>>>>> +	weight_sum = local->airtime_weight_sum[ac] ?:
>>>>>>>>>> sta->airtime_weight;
>>>>>>>>>> +
>>>>>>>>>> +	local->airtime_v_t[ac] += airtime / weight_sum;
> Hi Toke,
>
> I was porting this version of ATF design to my ath10k platform and found 
> my old kernel version not supporting 64bit division. I'm wondering if it 
> is necessary to use u64 for airtime and weight_sum here though I can 
> find a solution for it. I think u32 might be enough. For airtime, 
> u32_max / 256 = 7182219 us(718 ms). As for weight_sum, u32_max / 8092 us 
> = 130490, meaning we can support more than 130000 nodes with airtime 
> weight 8092 us.

As Felix said, we don't really want divides in the fast path at all. And
since the divisors are constant, we should be able to just pre-compute
reciprocals and turn the whole thing into multiplications...

> Another finding was when I configured two 11ac STAs with different
> airtime weight, such as 256 and 1024 meaning ratio is 1:4, the
> throughput ratio was not roughly matching the ratio. Could you please
> share your results? I am not sure if it is due to platform difference.

Hmm, I tested them with ath9k where things seemed to work equivalently
to the DRR. Are you testing the same hardware with that? Would be a good
baseline.

I am on vacation until the end of the month, but can share my actual
test results once I get back...

-Toke
