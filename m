Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B65C4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 08:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A954120674
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 08:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfDDIbo convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 04:31:44 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:47022 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbfDDIbo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 04:31:44 -0400
Received: by mail-ed1-f65.google.com with SMTP id d1so1342772edd.13
        for <linux-wireless@vger.kernel.org>; Thu, 04 Apr 2019 01:31:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Bsm1vVxwYVQoULCK7mCDz5ULCYHmGqc3KOmWINvNgm4=;
        b=HljZjq1elyXTSxpXBRZ3yo0ff3J8qk4TnOusOLnO3jYs2Gffp/+tsClgXvS0Hss6Ka
         XwTMb5757xvFqdK1kKnesf4lnt8lGlc3VrpW9f8ACof6Ptl9Wg347c6SAJYH9WTZGrCs
         /dZZCeYnOTVVLYIbiOJ441WlMY4mzYBoF2o9a2ri0rLUQZgesDW3QXtKbgaUst9OhMAY
         pQXKVAChrCCKQyLrcRmkA2Xr95HgcPvOlgWEOUzUiRJn4O19/fpjyO2iu32bralbnqny
         5FJEZI/62SwD1AhvdG+c27c7anI7XpZNuPMf9hZo5iNAoQW9Qn0OBNn+XU+HpGYnXKEN
         300Q==
X-Gm-Message-State: APjAAAW3VHbtlGbFQhmrysROjbsmFZr/5sgnwBQ6B6rCACLlEO2dDuCh
        CwympFsYJqtwSEoAd2WSGdw/jQ==
X-Google-Smtp-Source: APXvYqy0nI3NvxiMR/YDaYwtd6uF7mlSwubfgtUL4T/La9x8We99+YViYodxB4hgJt7VjuBJB2WfBw==
X-Received: by 2002:a50:bdc4:: with SMTP id z4mr2823292edh.199.1554366702830;
        Thu, 04 Apr 2019 01:31:42 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.vpn.toke.dk. [2a00:7660:6da:10::2])
        by smtp.gmail.com with ESMTPSA id 25sm3418542ejv.27.2019.04.04.01.31.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Apr 2019 01:31:42 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 921DA1804A5; Thu,  4 Apr 2019 10:31:41 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Yibo Zhao <yiboz@codeaurora.org>
Cc:     make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC/RFT] mac80211: Switch to a virtual time-based airtime scheduler
In-Reply-To: <753b328855b85f960ceaf974194a7506@codeaurora.org>
References: <20190215170512.31512-1-toke@redhat.com> <753b328855b85f960ceaf974194a7506@codeaurora.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 04 Apr 2019 10:31:41 +0200
Message-ID: <87ftqy41ea.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yibo Zhao <yiboz@codeaurora.org> writes:

> On 2019-02-16 01:05, Toke Høiland-Jørgensen wrote:
>> This switches the airtime scheduler in mac80211 to use a virtual 
>> time-based
>> scheduler instead of the round-robin scheduler used before. This has a
>> couple of advantages:
>> 
>> - No need to sync up the round-robin scheduler in firmware/hardware 
>> with
>>   the round-robin airtime scheduler.
>> 
>> - If several stations are eligible for transmission we can schedule 
>> both of
>>   them; no need to hard-block the scheduling rotation until the head of 
>> the
>>   queue has used up its quantum.
>> 
>> - The check of whether a station is eligible for transmission becomes
>>   simpler (in ieee80211_txq_may_transmit()).
>> 
>> The drawback is that scheduling becomes slightly more expensive, as we 
>> need
>> to maintain an rbtree of TXQs sorted by virtual time. This means that
>> ieee80211_register_airtime() becomes O(logN) in the number of currently
>> scheduled TXQs. However, hopefully this number rarely grows too big 
>> (it's
>> only TXQs currently backlogged, not all associated stations), so it
>> shouldn't be too big of an issue.
>> 
>> @@ -1831,18 +1830,32 @@ void ieee80211_sta_register_airtime(struct
>> ieee80211_sta *pubsta, u8 tid,
>>  {
>>  	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
>>  	struct ieee80211_local *local = sta->sdata->local;
>> +	struct ieee80211_txq *txq = sta->sta.txq[tid];
>>  	u8 ac = ieee80211_ac_from_tid(tid);
>> -	u32 airtime = 0;
>> +	u64 airtime = 0, weight_sum;
>> +
>> +	if (!txq)
>> +		return;
>> 
>>  	if (sta->local->airtime_flags & AIRTIME_USE_TX)
>>  		airtime += tx_airtime;
>>  	if (sta->local->airtime_flags & AIRTIME_USE_RX)
>>  		airtime += rx_airtime;
>> 
>> +	/* Weights scale so the unit weight is 256 */
>> +	airtime <<= 8;
>> +
>>  	spin_lock_bh(&local->active_txq_lock[ac]);
>> +
>>  	sta->airtime[ac].tx_airtime += tx_airtime;
>>  	sta->airtime[ac].rx_airtime += rx_airtime;
>> -	sta->airtime[ac].deficit -= airtime;
>> +
>> +	weight_sum = local->airtime_weight_sum[ac] ?: sta->airtime_weight;
>> +
>> +	local->airtime_v_t[ac] += airtime / weight_sum;
> Hi Toke,
>
> Please ignore the previous two broken emails regarding this new proposal 
> from me.
>
> It looks like local->airtime_v_t acts like a Tx criteria. Only the 
> stations with less airtime than that are valid for Tx. That means there 
> are situations, like 50 clients, that some of the stations can be used 
> to Tx when putting next_txq in the loop. Am I right?

I'm not sure what you mean here. Are you referring to the case where new
stations appear with a very low (zero) airtime_v_t? That is handled when
the station is enqueued.

>> +	sta->airtime[ac].v_t += airtime / sta->airtime_weight;
> Another question. Any plan for taking v_t overflow situation into 
> consideration? u64 might be enough for low throughput products but not 
> sure for high end products. Something like below for reference:

The unit for the variable is time, not bytes, so it is unaffected by
throughput. 2**64 microseconds is 584554 *years* according to my
'units' binary, so don't think we have to worry too much about this
overflowing ;)

-Toke
