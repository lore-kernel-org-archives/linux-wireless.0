Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAA7BC43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 19:06:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7FFB20661
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 19:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfCHTGJ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 14:06:09 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35946 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbfCHTGJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 14:06:09 -0500
Received: by mail-ed1-f65.google.com with SMTP id g9so17240803eds.3
        for <linux-wireless@vger.kernel.org>; Fri, 08 Mar 2019 11:06:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=8z01g5zwuFq7bgyK/hshJLvTveVcR3huiQ8sO5CsujY=;
        b=MIdIXO+KbSslzI3ZDvEzBoVxjhYLFesotBJeRZ+nBU2zkUfhyrs+N2FoetSSj/+kvB
         E+BHvCoc1fLM4YqQPoF/iOgfNIdIdJeZs+S6tW5evDknvUrEPAUwwTUQCzUgi6xGSk1q
         2DOM1SMIRl1GYN4bv+zzDmdgnWHkPIleAzVbnOgB4zLPU78E1o0G3wlLPdX4JetlAYEd
         pGA2uIXjw/MmHJw4t6B7uSIeT3X6+XeGrmKe0nTzvlTBLFEvYpiXm/b2JYvZfGALLGc5
         AVAYxonwoFyYzQ6t9yQX7pJfE0/rzNy9yloQwkmnVMXj214lqNl45tFH89PNf1jGa8P3
         Y4VA==
X-Gm-Message-State: APjAAAX+Z1Y2CHqYHcAA82Pd6jNBBIwkefL5Cr/lWUxY8y0G5WJAkRAS
        /Ujg365/rycSi3TQF9G9oNIC4A==
X-Google-Smtp-Source: APXvYqxkvBNGGEGC7qlOG/rRtPEpntBGHeIBxPhWB+kmyhZhBz8jtJ9noyvdiHizEYwKHag1GfvPTw==
X-Received: by 2002:a50:a5f6:: with SMTP id b51mr34220982edc.9.1552071966965;
        Fri, 08 Mar 2019 11:06:06 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:10::2])
        by smtp.gmail.com with ESMTPSA id n19sm1553892eja.38.2019.03.08.11.06.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 11:06:06 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 73A6818049E; Fri,  8 Mar 2019 20:06:00 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Kan Yan <kyan@google.com>
Subject: Re: [RFC/RFT] mac80211: Switch to a virtual time-based airtime scheduler
In-Reply-To: <a2b4c6c5-7b49-b809-a087-73548954e0bf@nbd.name>
References: <20190215170512.31512-1-toke@redhat.com> <f6c5bc25-a8b3-bac3-8d62-d41347a6c070@nbd.name> <874l8d7hjy.fsf@toke.dk> <a2b4c6c5-7b49-b809-a087-73548954e0bf@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 08 Mar 2019 20:06:00 +0100
Message-ID: <87mum55gpz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> On 2019-03-08 12:05, Toke Høiland-Jørgensen wrote:
>> Felix Fietkau <nbd@nbd.name> writes:
>> 
>>> On 2019-02-15 18:05, Toke Høiland-Jørgensen wrote:
>>>> This switches the airtime scheduler in mac80211 to use a virtual time-based
>>>> scheduler instead of the round-robin scheduler used before. This has a
>>>> couple of advantages:
>>>> 
>>>> - No need to sync up the round-robin scheduler in firmware/hardware with
>>>>   the round-robin airtime scheduler.
>>>> 
>>>> - If several stations are eligible for transmission we can schedule both of
>>>>   them; no need to hard-block the scheduling rotation until the head of the
>>>>   queue has used up its quantum.
>>>> 
>>>> - The check of whether a station is eligible for transmission becomes
>>>>   simpler (in ieee80211_txq_may_transmit()).
>>>> 
>>>> The drawback is that scheduling becomes slightly more expensive, as we need
>>>> to maintain an rbtree of TXQs sorted by virtual time. This means that
>>>> ieee80211_register_airtime() becomes O(logN) in the number of currently
>>>> scheduled TXQs. However, hopefully this number rarely grows too big (it's
>>>> only TXQs currently backlogged, not all associated stations), so it
>>>> shouldn't be too big of an issue.
>>>> 
>>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>> The approach looks good to me, but I haven't really reviewed it very
>>> carefully yet. Just some points that I noticed below:
>> 
>> Cool!
>> 
>>>> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
>>>> index 11f058987a54..9d01fdd86e2d 100644
>>>> --- a/net/mac80211/sta_info.c
>>>> +++ b/net/mac80211/sta_info.c
>>>> @@ -389,7 +389,6 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
>>>>  	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
>>>>  		skb_queue_head_init(&sta->ps_tx_buf[i]);
>>>>  		skb_queue_head_init(&sta->tx_filtered[i]);
>>>> -		sta->airtime[i].deficit = sta->airtime_weight;
>>>>  	}
>>>>  
>>>>  	for (i = 0; i < IEEE80211_NUM_TIDS; i++)
>>>> @@ -1831,18 +1830,32 @@ void ieee80211_sta_register_airtime(struct ieee80211_sta *pubsta, u8 tid,
>>>>  {
>>>>  	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
>>>>  	struct ieee80211_local *local = sta->sdata->local;
>>>> +	struct ieee80211_txq *txq = sta->sta.txq[tid];
>>>>  	u8 ac = ieee80211_ac_from_tid(tid);
>>>> -	u32 airtime = 0;
>>>> +	u64 airtime = 0, weight_sum;
>>>> +
>>>> +	if (!txq)
>>>> +		return;
>>>>  
>>>>  	if (sta->local->airtime_flags & AIRTIME_USE_TX)
>>>>  		airtime += tx_airtime;
>>>>  	if (sta->local->airtime_flags & AIRTIME_USE_RX)
>>>>  		airtime += rx_airtime;
>>>>  
>>>> +	/* Weights scale so the unit weight is 256 */
>>>> +	airtime <<= 8;
>>>> +
>>>>  	spin_lock_bh(&local->active_txq_lock[ac]);
>>>> +
>>>>  	sta->airtime[ac].tx_airtime += tx_airtime;
>>>>  	sta->airtime[ac].rx_airtime += rx_airtime;
>>>> -	sta->airtime[ac].deficit -= airtime;
>>>> +
>>>> +	weight_sum = local->airtime_weight_sum[ac] ?: sta->airtime_weight;
>>>> +
>>>> +	local->airtime_v_t[ac] += airtime / weight_sum;
>>>> +	sta->airtime[ac].v_t += airtime / sta->airtime_weight;
>>>> +	ieee80211_resort_txq(&local->hw, txq);
>>> These divisions could be a bit expensive, any way to change the
>>> calculation to avoid them?
>> 
>> Yeah, given that the denominators are constant from the PoV of the fast
>> path, we can pre-compute reciprocals and turn these divides into
>> multiplications. Will incorporate that...
> Sounds good.
>
>>> I'm a bit worried about this part. Does that mean that vif txqs always
>>> have priority over sta txqs?
>> 
>> Yeah, it does. This sort of mirrors what the existing airtime scheduler
>> does (because VIFs don't have an airtime deficit), but because it's a
>> round-robin scheduler the effect is less severe as long as there are
>> stations able to transmit.
>> 
>> I guess the obvious fix is to start accounting airtime usage for the VIF
>> as well? We may want to do that in any case, as that would also give
>> users a convenient way to set policy for multicast traffic. Any
>> objections to this?
> I think this is a good idea.

Great, thanks! I'll do a separate patch for accounting airtime for the
VIF queue, and then respin this on top. Will probably be a little while
before I get around to it, though.

-Toke
