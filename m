Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C680C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 11:05:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC62B20851
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 11:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbfCHLFJ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 06:05:09 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46705 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfCHLFJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 06:05:09 -0500
Received: by mail-ed1-f66.google.com with SMTP id f2so16050601edy.13
        for <linux-wireless@vger.kernel.org>; Fri, 08 Mar 2019 03:05:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ABca4EoLzrJgYdMirNp2lP/sA/gVHBZHoR9KRUIIm0s=;
        b=Ob42Yvs17GT5x33GVfOIDYMWbUCBw5e2qd9GdlOWp8lnc44GMkhyd4AF9IB+wd6FmD
         FDXOOUomPsdhv9rGtwjP+ZNGl3g1HWl5amKCyI6KqlSz/5vC8q0eqkFpaNtv+5EAkP5l
         tCXFzGUDdwRkO4X6tIU0Euq9apf0HHapzhZM7JwoAsdSolDjinp1y2MrVWIsDpBjd8q/
         Nv7WjV094Q5wNeuYZXoVwR6V4m/4zrn824hyCJ9YbphtlfvrW7j7t+pX/QtR0NoZHnNC
         Kb7ORFn4+Wf8oBeI3Xz23+RH8kayRf35GSRGqtyGsBNVAj4kJ7+GMwIXCzVumfvibr0H
         5qCA==
X-Gm-Message-State: APjAAAWmT8iK+7vlj7Kv0jFjK6eV01xvvPionS7bpz2CWCGBs8pGcZF6
        6V4Laym6PnYpbz1k2+Zmoe0BdA==
X-Google-Smtp-Source: APXvYqwOROezSumd74yZbKtbF4LypI4LK7W7T6hNaCbaWo6Oz57AmLkyEUlyiwASipEtSKQLD5MiCw==
X-Received: by 2002:a17:906:5583:: with SMTP id y3mr11392084ejp.42.1552043106570;
        Fri, 08 Mar 2019 03:05:06 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id c20sm1356251ejm.58.2019.03.08.03.05.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 03:05:05 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2AFEB180454; Fri,  8 Mar 2019 12:05:05 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Kan Yan <kyan@google.com>
Subject: Re: [RFC/RFT] mac80211: Switch to a virtual time-based airtime scheduler
In-Reply-To: <f6c5bc25-a8b3-bac3-8d62-d41347a6c070@nbd.name>
References: <20190215170512.31512-1-toke@redhat.com> <f6c5bc25-a8b3-bac3-8d62-d41347a6c070@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 08 Mar 2019 12:05:05 +0100
Message-ID: <874l8d7hjy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> On 2019-02-15 18:05, Toke Høiland-Jørgensen wrote:
>> This switches the airtime scheduler in mac80211 to use a virtual time-based
>> scheduler instead of the round-robin scheduler used before. This has a
>> couple of advantages:
>> 
>> - No need to sync up the round-robin scheduler in firmware/hardware with
>>   the round-robin airtime scheduler.
>> 
>> - If several stations are eligible for transmission we can schedule both of
>>   them; no need to hard-block the scheduling rotation until the head of the
>>   queue has used up its quantum.
>> 
>> - The check of whether a station is eligible for transmission becomes
>>   simpler (in ieee80211_txq_may_transmit()).
>> 
>> The drawback is that scheduling becomes slightly more expensive, as we need
>> to maintain an rbtree of TXQs sorted by virtual time. This means that
>> ieee80211_register_airtime() becomes O(logN) in the number of currently
>> scheduled TXQs. However, hopefully this number rarely grows too big (it's
>> only TXQs currently backlogged, not all associated stations), so it
>> shouldn't be too big of an issue.
>> 
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> The approach looks good to me, but I haven't really reviewed it very
> carefully yet. Just some points that I noticed below:

Cool!

>> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
>> index 11f058987a54..9d01fdd86e2d 100644
>> --- a/net/mac80211/sta_info.c
>> +++ b/net/mac80211/sta_info.c
>> @@ -389,7 +389,6 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
>>  	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
>>  		skb_queue_head_init(&sta->ps_tx_buf[i]);
>>  		skb_queue_head_init(&sta->tx_filtered[i]);
>> -		sta->airtime[i].deficit = sta->airtime_weight;
>>  	}
>>  
>>  	for (i = 0; i < IEEE80211_NUM_TIDS; i++)
>> @@ -1831,18 +1830,32 @@ void ieee80211_sta_register_airtime(struct ieee80211_sta *pubsta, u8 tid,
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
>> +	sta->airtime[ac].v_t += airtime / sta->airtime_weight;
>> +	ieee80211_resort_txq(&local->hw, txq);
> These divisions could be a bit expensive, any way to change the
> calculation to avoid them?

Yeah, given that the denominators are constant from the PoV of the fast
path, we can pre-compute reciprocals and turn these divides into
multiplications. Will incorporate that...

>> --- a/net/mac80211/tx.c
>> +++ b/net/mac80211/tx.c
>> -void ieee80211_return_txq(struct ieee80211_hw *hw,
>> +static void __ieee80211_insert_txq(struct rb_root_cached *root,
>> +				   struct txq_info *txqi, u8 ac)
>> +{
>> +	struct rb_node **new = &root->rb_root.rb_node;
>> +	struct rb_node *parent = NULL;
>> +	struct txq_info *__txqi;
>> +	bool leftmost = true;
>> +
>> +	while (*new) {
>> +		parent = *new;
>> +		__txqi = rb_entry(parent, struct txq_info, schedule_order);
>> +
>> +		if (!txqi->txq.sta) {
>> +			/* new txqi has no sta - insert to the left */
>> +			new = &parent->rb_left;
>> +		} else if (!__txqi->txq.sta) {
>> +			/* existing txqi has no sta - insert to the right */
>> +			new = &parent->rb_right;
>> +			leftmost = false;
>> +		} else {
>> +			struct sta_info *old_sta = container_of(__txqi->txq.sta,
>> +								struct sta_info,
>> +								sta);
>> +			struct sta_info *new_sta = container_of(txqi->txq.sta,
>> +								struct sta_info,
>> +								sta);
>> +
>> +			if (new_sta->airtime[ac].v_t <= old_sta->airtime[ac].v_t)
>> +				new = &parent->rb_left;
>> +			else {
>> +				new = &parent->rb_right;
>> +				leftmost = false;
>> +			}
>> +
>> +		}
>> +	}
>> +
>> +	rb_link_node(&txqi->schedule_order, parent, new);
>> +	rb_insert_color_cached(&txqi->schedule_order, root, leftmost);
>> +}
> I'm a bit worried about this part. Does that mean that vif txqs always
> have priority over sta txqs?

Yeah, it does. This sort of mirrors what the existing airtime scheduler
does (because VIFs don't have an airtime deficit), but because it's a
round-robin scheduler the effect is less severe as long as there are
stations able to transmit.

I guess the obvious fix is to start accounting airtime usage for the VIF
as well? We may want to do that in any case, as that would also give
users a convenient way to set policy for multicast traffic. Any
objections to this?

-Toke
