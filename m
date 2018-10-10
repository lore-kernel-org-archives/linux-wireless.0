Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 483E9C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 23:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D57A72087A
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 23:20:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ru1dONuY";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="pB+GejwC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D57A72087A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbeJKGo1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 02:44:27 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35988 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbeJKGo1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 02:44:27 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 34B5F60B73; Wed, 10 Oct 2018 23:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539213603;
        bh=KQaTuEil+2UWfKjJJVRaRHxtCICkycyy9f/m66Uz59o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ru1dONuY7M7peuA+KrNc+sDEOnnAG/dq0a9SjWpU7Cjx+Hqvq6eW5MGXl49zvA23+
         Q+7qx/c2q4VjUhOFZg/LBapTAL0eqzbstgggZqXfXJ9f9vsa/C8SRpNZP/TSxrlCA2
         eA5VqVH96Q2q05o3aQrpJu+yCcrcXwYjeESQKUvU=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 42DBE60249;
        Wed, 10 Oct 2018 23:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539213602;
        bh=KQaTuEil+2UWfKjJJVRaRHxtCICkycyy9f/m66Uz59o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pB+GejwCY68Agsu+HrbqkPK5HTE1XVRoga24xArpvcLovoD0FOCm06jgKW7OurUnX
         ld26MGZZsR/eFIuom/s4u5t6NdohszulnlNKxVvuyRE6irE4ngVbIqq65aLObfMbFL
         sLTxo/sfmvqdzBk+IloITFcFZSajcF8bDmbOEqLs=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 10 Oct 2018 16:20:02 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH RFC v5 3/4] mac80211: Add airtime accounting and
 scheduling to TXQs
In-Reply-To: <87zhvm832s.fsf@toke.dk>
References: <153908805217.9471.9290979918041653328.stgit@alrua-kau>
 <153908837900.9471.5394468800857658136.stgit@alrua-kau>
 <a65909ee425585a49d9e17f6504cf0ba@codeaurora.org> <87zhvm832s.fsf@toke.dk>
Message-ID: <187bade306627912c70d800819ef0b87@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-10 04:15, Toke Høiland-Jørgensen wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 
>> On 2018-10-09 05:32, Toke Høiland-Jørgensen wrote:
>>> This adds airtime accounting and scheduling to the mac80211 TXQ
>>> scheduler. A new callback, ieee80211_sta_register_airtime(), is added
>>> that drivers can call to report airtime usage for stations.
>>> 
>>> When airtime information is present, mac80211 will schedule TXQs
>>> (through ieee80211_next_txq()) in a way that enforces airtime 
>>> fairness
>>> between active stations. This scheduling works the same way as the
>>> ath9k
>>> in-driver airtime fairness scheduling. If no airtime usage is 
>>> reported
>>> by the driver, the scheduler will default to round-robin scheduling.
>>> 
>>> For drivers that don't control TXQ scheduling in software, a new API
>>> function, ieee80211_txq_may_transmit(), is added which the driver can
>>> use
>>> to check if the TXQ is eligible for transmission, or should be
>>> throttled to
>>> enforce fairness. Calls to this function must also be enclosed in
>>> ieee80211_txq_schedule_{start,end}() calls to ensure proper locking.
>>> TXQs
>>> that are throttled by ieee802111_txq_may_transmit() will be woken up
>>> again
>>> by a check added to the ieee80211_wake_txqs() tasklet.
>>> 
>> 
>> Toke,
>> 
>> I am observing soft lockup issues again with this new series while
>> running traffic with 50 clients. I am continuing testing with earlier
>> series along with snippet I shared.
> 
> Are these new lockups (that was not in your patched previous version),
> or did I just not get all your lock-related fixes incorporated?
> 
>> When driver operates in pull-mode, throttled txqs are marked and
>> refilled in airtime_tasklet. This is causing major throughput drops
>> and packet loss and I am suspecting the latency in replenishing
>> deficit. Whereas in push-mode or in ath9k model, refill happens
>> quicker at every packet indication as well as tx completion.
> 
> Yeah, the tasklet shouldn't be the main source of deficit replenishing.
> Can see why that would give bad performance :)
> 
>> I am planning to get rid of tasklet completely as it is only meant for
>> pull-mode. It would be better to refill in may_transmit() itself.
> 
> Hmm, right. So the way to do this correctly (from a fairness point of
> view) would be something like this (in max_tx()):
> 
> if (this_txq.stn.deficit > 0)
>   return true;
> 
> else if (any queued TXQ currently have positive deficit)
>   return false; /* other TXQ should try may_tx() later and get 
> permission */
> 
> else /* all deficits < 0 */
>   return replenish_deficits(this_txq);
> 
> And replenish_deficits() would be something like:
> 
> replenish_deficits(this_txq) {
> repeat:
>   for (txq in queued txqs) {
>     txq.stn.deficit += stn.weight;
>     if (txq.stn.deficit > 0 && !wake_txq)
>       wake_txq = txq;
>   }
>   if not wake_txq:
>     goto repeat;
> 
>   if (this_txq.stn.deficit > 0)
>     return true;
>   else
>     drv_wake_tx_queue(wake_txq);
> }
> 
> The wake_tx_queue call may have to be delegated to a tasklet still, to
> avoid the infinite recursion problem I mentioned earlier. But the
> tasklet could be made simpler and wouldn't have to be called so 
> often...
> 
> Does the above make sense?
> 
Hmm... mine is bit different. txqs are refilled only once for all txqs.
It will give more opportunity for non-served txqs. drv_wake_tx_queue 
won't be
called from may_tx as the driver anyway will not push packets in 
pull-mode.

bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
                                 struct ieee80211_txq *txq)
{
         struct ieee80211_local *local = hw_to_local(hw);
         struct txq_info *txqi = to_txq_info(txq);
         struct sta_info *sta;
         u8 ac = txq->ac;

         lockdep_assert_held(&local->active_txq_lock[ac]);

         if (!txqi->txq.sta)
                 goto out;

         sta = container_of(txqi->txq.sta, struct sta_info, sta);
         if (sta->airtime[ac].deficit >= 0)
                 goto out;

         list_for_each_entry(txqi, &local->active_txqs[ac], 
schedule_order) {
                 if (!txqi->txq.sta)
                         continue;
                 sta = container_of(txqi->txq.sta, struct sta_info, sta);
                 sta->airtime[ac].deficit += sta->airtime_weight;
         }

         return false;

  out:
         list_del_init(&txqi->schedule_order);
         return true;
}

-Rajkumar
