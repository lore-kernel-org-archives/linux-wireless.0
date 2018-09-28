Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC30FC43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 10:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95AAA2172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 10:20:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="S4ckuXhh";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="B+K2mvGH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95AAA2172C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbeI1QnF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 12:43:05 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50340 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729118AbeI1QnE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 12:43:04 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4639A600C1; Fri, 28 Sep 2018 10:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538130000;
        bh=Afy7hSd0GHhFd+2tuZvGDxU7w1G4EJHsbot+8srH2AY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S4ckuXhhUEzx+ufACDCQrUHbRNfqVGWXqlkCR3A4hb57SQErbQ5WCpP8Y4Lkbqbog
         ABWEhkLqiBgQUoPZfYLXj+hvUmg2HARR5RXJxGPa/0LApSporJyu/kd5y03MeZl3aF
         WuFqy+WDnZcEL7LS9BuWIGp/M+057WooXp1tRREo=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 79CAB600C1;
        Fri, 28 Sep 2018 10:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538129999;
        bh=Afy7hSd0GHhFd+2tuZvGDxU7w1G4EJHsbot+8srH2AY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B+K2mvGH9af34BL7As+XuefOuh7fktR4D9Ky2chup5gkWlTm1AHVQb+It980jBInJ
         LAe3EUTGuVq7W+D06DxbVUp8+1k6r4PrkKSR6sKeev5htfX7eGwtDVDx9M1CFzx1Ct
         iuz0A7I7BB2nmkPxAMHAPU8RAtxwRtY+/vNtM18I=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 28 Sep 2018 03:19:59 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH RFC v4 3/4] mac80211: Add airtime accounting and
 scheduling to TXQs
In-Reply-To: <87zhw2eyfo.fsf@toke.dk>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1>
 <153711973134.9231.18038849900399644494.stgit@alrua-x1.karlstad.toke.dk>
 <826b6251746ee4d280d532f4ecdc5aa3@codeaurora.org> <87pnx0haud.fsf@toke.dk>
 <8f7145bf5abe50194bced025a5e739b9@codeaurora.org>
 <863bc54fbf04441d38dd53f523300a7e@codeaurora.org>
 <93015743-5D16-4D79-948F-E2F46CF2450A@toke.dk>
 <7ba8513b0ec5a7c35b396c7739fc2d7d@codeaurora.org> <87zhw2eyfo.fsf@toke.dk>
Message-ID: <5d961a5f61de45b85b1b037bcef9270d@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-09-28 02:58, Toke Høiland-Jørgensen wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 
>> On 2018-09-28 00:51, Toke Høiland-Jørgensen wrote:
>>> On 28 September 2018 07:29:03 CEST, Rajkumar Manoharan
>>> <rmanohar@codeaurora.org> wrote:
>>>> On 2018-09-26 17:09, Rajkumar Manoharan wrote:
>>>>> On 2018-09-26 02:22, Toke Høiland-Jørgensen wrote:
>>>>>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>>> 
>>>>> :( Yeah... I got confused with attached soft lockup in ARM 
>>>>> platform.
>>>>> 
>>>> Toke,
>>>> 
>>>> Cause for the soft lockup exposed in multi client scenario is due to
>>>> mixed order of fq_lock and active_txqs_lock. In wake_tx_queue or
>>>> push_pending
>>>> case, driver acquires active_txq_lock first by schedule_start and
>>>> followed by
>>>> fq_lock in tx_dequeue. The same order should be maintained in sta
>>>> cleanup.
>>>> Below change fixed the issue.
>>> 
>>> Ah, great find! I'll fold this into the next version, thanks!
>>> 
>> 
>> One more thing. As I mentioned earlier, scheduling wake_txqs_tasklet
>> is heavy load and causing random rcu stall issue. Hence I added
>> another API to schedule throttled txqs once for all. Also I did
>> a cleanup in kick_airtime by traversing list only once. With these
>> changes I don't see rcu stall issue. Please review and fold them as
>> well.
>> 
>> -Rajkumar
>> 
>> 
>> single_iter - clean up kick_airtime
>> sched_throttle - new API and separate tasklet for throttled txqs
>> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
>> index 404c5e82e4ca..023bc81bd4a0 100644
>> --- a/net/mac80211/util.c
>> +++ b/net/mac80211/util.c
>> @@ -242,13 +242,11 @@ EXPORT_SYMBOL(ieee80211_ctstoself_duration);
>> 
>>  static void __ieee80211_kick_airtime(struct ieee80211_local *local, 
>> int ac)
>>  {
>> -	bool seen_eligible = false;
>>  	struct txq_info *txqi;
>>  	struct sta_info *sta;
>> 
>>  	spin_lock_bh(&local->active_txq_lock[ac]);
>> 
>> - begin:
>>  	if (list_empty(&local->active_txqs[ac]))
>>  		goto out;
>> 
>> @@ -258,12 +256,12 @@ static void __ieee80211_kick_airtime(struct 
>> ieee80211_local *local, int ac)
>> 
>>  		sta = container_of(txqi->txq.sta, struct sta_info, sta);
>> 
>> -		if (sta->airtime[ac].deficit >= 0) {
>> -			seen_eligible = true;
>> -
>> -			if (!test_and_clear_bit(IEEE80211_TXQ_AIRTIME_THROTTLE,
>> -						&txqi->flags))
>> +		if (test_bit(IEEE80211_TXQ_AIRTIME_THROTTLE, &txqi->flags)) {
>> +			clear_bit(IEEE80211_TXQ_AIRTIME_THROTTLE, &txqi->flags);
>> +			if (sta->airtime[ac].deficit < 0) {
>> +				sta->airtime[ac].deficit += sta->airtime_weight;
>>  				continue;
>> +			}
> 
> This is going to break fairness; we only want to increase deficits when
> all stations' deficits are negative. Hence the two loops. Did you see
> any problems with those specifically?
> 

No. I didn't see any issue but the loop won't exit until one txq becomes 
positive.
Till then the lock won't be released. Hence I converged into single 
iteration.

-Rajkumar
