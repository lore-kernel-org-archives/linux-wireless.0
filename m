Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6945C10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 20:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 927882084B
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 20:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbfDIUlL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 16:41:11 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:33817 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbfDIUlK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 16:41:10 -0400
Received: by mail-ed1-f68.google.com with SMTP id x14so56317eds.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2019 13:41:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=XPe7jI+WcE4ii926/vq4cq+lBNXK2hucWmRJ86xgeZk=;
        b=evPN3za3dEEe2TUox2bAz+dn8njA7KuGtDbA2F5DZlIO8ngjmZ2tnfUntPoekWeT3J
         gWVzLQNydsm3uHrHZdyfPicaHsk8hZdFsOvCOBNoC+mPhF25zlJncttXUCL0aru0OqyD
         ypYdSip9gPFZheA/ETP3p2u39wrSr02/22/YRpxyLqe7gCUT1JEqyK5jLYncoocpg9Px
         vjEERKrrSKeJGFfYgxONLiY0fvW7syCeSJanks5bW0Lqyy0e2boRvOHNCCCCKpyRP4kh
         6FF53t3AMohAO46o1jstRuhO3rN529Zvsof4Euth7HeUUlqmS7nA8vjvhUhKsGwMKqph
         QuUg==
X-Gm-Message-State: APjAAAUN1WdPdaGoyo+UyKL0DH66VHPhsO+uoUSMEBWVwUY0MgLtwU23
        NLPaKIE0jfSzvomcdi67VIlqWQ==
X-Google-Smtp-Source: APXvYqzRy5WEosfm03JGPl6V8NT73z3+etyqXt6ZzYa5vhxqbtYEY3JNB4RoUQUttNO38FVKvKY6xg==
X-Received: by 2002:a05:6402:180c:: with SMTP id g12mr14336772edy.181.1554842468615;
        Tue, 09 Apr 2019 13:41:08 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id b34sm9790443edd.24.2019.04.09.13.41.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 09 Apr 2019 13:41:07 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C87481804A4; Tue,  9 Apr 2019 22:41:06 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Yibo Zhao <yiboz@codeaurora.org>
Cc:     make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC/RFT] mac80211: Switch to a virtual time-based airtime scheduler
In-Reply-To: <acd33756e87ea64c608e306e5ee60aa2@codeaurora.org>
References: <20190215170512.31512-1-toke@redhat.com> <753b328855b85f960ceaf974194a7506@codeaurora.org> <87ftqy41ea.fsf@toke.dk> <acd33756e87ea64c608e306e5ee60aa2@codeaurora.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 09 Apr 2019 22:41:06 +0200
Message-ID: <877ec2ykrh.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yibo Zhao <yiboz@codeaurora.org> writes:

> On 2019-04-04 16:31, Toke Høiland-Jørgensen wrote:
>> Yibo Zhao <yiboz@codeaurora.org> writes:
>> 
>>> On 2019-02-16 01:05, Toke Høiland-Jørgensen wrote:
>>>> This switches the airtime scheduler in mac80211 to use a virtual
>>>> time-based
>>>> scheduler instead of the round-robin scheduler used before. This has 
>>>> a
>>>> couple of advantages:
>>>> 
>>>> - No need to sync up the round-robin scheduler in firmware/hardware
>>>> with
>>>>   the round-robin airtime scheduler.
>>>> 
>>>> - If several stations are eligible for transmission we can schedule
>>>> both of
>>>>   them; no need to hard-block the scheduling rotation until the head 
>>>> of
>>>> the
>>>>   queue has used up its quantum.
>>>> 
>>>> - The check of whether a station is eligible for transmission becomes
>>>>   simpler (in ieee80211_txq_may_transmit()).
>>>> 
>>>> The drawback is that scheduling becomes slightly more expensive, as 
>>>> we
>>>> need
>>>> to maintain an rbtree of TXQs sorted by virtual time. This means that
>>>> ieee80211_register_airtime() becomes O(logN) in the number of 
>>>> currently
>>>> scheduled TXQs. However, hopefully this number rarely grows too big
>>>> (it's
>>>> only TXQs currently backlogged, not all associated stations), so it
>>>> shouldn't be too big of an issue.
>>>> 
>>>> @@ -1831,18 +1830,32 @@ void ieee80211_sta_register_airtime(struct
>>>> ieee80211_sta *pubsta, u8 tid,
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
>>> Hi Toke,
>>> 
>>> Please ignore the previous two broken emails regarding this new 
>>> proposal
>>> from me.
>>> 
>>> It looks like local->airtime_v_t acts like a Tx criteria. Only the
>>> stations with less airtime than that are valid for Tx. That means 
>>> there
>>> are situations, like 50 clients, that some of the stations can be used
>>> to Tx when putting next_txq in the loop. Am I right?
>> 
>> I'm not sure what you mean here. Are you referring to the case where 
>> new
>> stations appear with a very low (zero) airtime_v_t? That is handled 
>> when
>> the station is enqueued.
> Hi Toke,
>
> Sorry for the confusion. I am not referring to the case that you 
> mentioned though it can be solved by your subtle design, max(local vt, 
> sta vt). :-)
>
> Actually, my concern is situation about putting next_txq in the loop. 
> Let me explain a little more and see below.
>
>> @@ -3640,126 +3638,191 @@ EXPORT_SYMBOL(ieee80211_tx_dequeue);
>>  struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8
>> ac)
>>  {
>>  	struct ieee80211_local *local = hw_to_local(hw);
>> +	struct rb_node *node = local->schedule_pos[ac];
>>  	struct txq_info *txqi = NULL;
>> +	bool first = false;
>> 
>>  	lockdep_assert_held(&local->active_txq_lock[ac]);
>> 
>> - begin:
>> -	txqi = list_first_entry_or_null(&local->active_txqs[ac],
>> -					struct txq_info,
>> -					schedule_order);
>> -	if (!txqi)
>> +	if (!node) {
>> +		node = rb_first_cached(&local->active_txqs[ac]);
>> +		first = true;
>> +	} else
>> +		node = rb_next(node);
>
> Consider below piece of code from ath10k_mac_schedule_txq:
>
>          ieee80211_txq_schedule_start(hw, ac);
>          while ((txq = ieee80211_next_txq(hw, ac))) {
>                  while (ath10k_mac_tx_can_push(hw, txq)) {
>                          ret = ath10k_mac_tx_push_txq(hw, txq);
>                          if (ret < 0)
>                                  break;
>                  }
>                  ieee80211_return_txq(hw, txq);
>                  ath10k_htt_tx_txq_update(hw, txq);
>                  if (ret == -EBUSY)
>                          break;
>          }
>          ieee80211_txq_schedule_end(hw, ac);
>
> If my understanding is right, local->schedule_pos is used to record the 
> last scheduled node and used for traversal rbtree for valid txq. There 
> is chance that an empty txq is feeded to return_txq and got removed from 
> rbtree. The empty txq will always be the rb_first node. Then in the 
> following next_txq, local->schedule_pos becomes meaningless since its 
> rb_next will return NULL and the loop break. Only rb_first get dequeued 
> during this loop.
>
> 	if (!node || RB_EMPTY_NODE(node)) {
> 		node = rb_first_cached(&local->active_txqs[ac]);
> 		first = true;
> 	} else
> 		node = rb_next(node);

Ah, I see what you mean. Yes, that would indeed be a problem - nice
catch! :)

> How about this? The nodes on the rbtree will be dequeued and removed
> from rbtree one by one until HW is busy. Please note local vt and sta
> vt will not be updated since txq lock is held during this time.

Insertion and removal from the rbtree are relatively expensive, so I'd
rather not do that for every txq. I think a better way to solve this
is to just defer the actual removal from the tree until
ieee80211_txq_schedule_end()... Will fix that when I submit this again.

-Toke
