Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B486C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 09:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADFD621480
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 09:22:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="XS69LDGZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADFD621480
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbeIZPei (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 11:34:38 -0400
Received: from mail.toke.dk ([52.28.52.200]:42571 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbeIZPeh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 11:34:37 -0400
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1537953755; bh=kVEyBNxjXCiEhRnJtO363TPunYLUfKSE1UDeWPc1L7E=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=XS69LDGZqgBAq9OzOA/5Vjj1gZi0bhzsOkVfdEDpVnDxBEzB64ooa+7xslDV6Hbdf
         /kXeWSZB5LzG18RPeVypkXeAZE7ObnN2TVW9yhYChYDVBVj3ZRRmplc+H6V/wZ4UGs
         fgyPqwHQVNJTOysIOE/x5WOk7U5h4ZRXOCqjQNKqRG7bztYXOJuFnPFlMyX8tCvoBr
         V/ZqTBjR3c+moE8yBpaUHCG9zwI0SlUKd5m5T24gaXXiHXH/sHNFh82kCrYVQ3ze4b
         hURgdX4X/bNwWFc6l3RETzmrop0K7+TwTpVSnKrHDjFajELYL21EQV1s7E+XWBjnL8
         e9JOqfGQttIEA==
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH RFC v4 3/4] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <826b6251746ee4d280d532f4ecdc5aa3@codeaurora.org>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1> <153711973134.9231.18038849900399644494.stgit@alrua-x1.karlstad.toke.dk> <826b6251746ee4d280d532f4ecdc5aa3@codeaurora.org>
Date:   Wed, 26 Sep 2018 11:22:34 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87pnx0haud.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-09-16 10:42, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> This adds airtime accounting and scheduling to the mac80211 TXQ
>> scheduler. A new callback, ieee80211_sta_register_airtime(), is added
>> that drivers can call to report airtime usage for stations.
>>=20
>> +bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
>> +				struct ieee80211_txq *txq)
>> +{
>
> [...]
>
>> +	if (ret) {
>> +		clear_bit(IEEE80211_TXQ_AIRTIME_THROTTLE, &txqi->flags);
>> +		list_del_init(&txqi->schedule_order);
>> +	} else
>> +		set_bit(IEEE80211_TXQ_AIRTIME_THROTTLE, &txqi->flags);
>> +
>>=20
> This looks wrong to me. txqi->flags are protected by fq->lock but here
> it is by active_txq_lock. no?

Both set_bit() and clear_bit() are atomic operations, so they don't need
separate locking. See Documentation/atomic_bitops.txt

>> @@ -3677,6 +3751,7 @@ void ieee80211_txq_schedule_end(struct
>> ieee80211_hw *hw, u8 ac)
>>  	struct ieee80211_local *local =3D hw_to_local(hw);
>>=20
>>  	spin_unlock_bh(&local->active_txq_lock[ac]);
>> +	tasklet_schedule(&local->wake_txqs_tasklet);
>>  }
>>=20
> It is an overload to schedule wake_txqs_tasklet for each txq unlock.
> Instead I would prefer to call __ieee80211_kick_airtime from=20
> schedule_end.
> Thoughts?

Yeah, I realise scheduling the whole wake_txqs_tasklet is maybe a bit
heavy-handed here. However just calling into __ieee80211_kick_airtime()
means we'll end up recursing back to the same place, which is not good
either (we could in theory flip-flop between two queues until we run out
of stack space).

My "backup plan" if the wake_txqs_tasklet turns out to be too heavy was
to define a new tasklet just for this use; but wanted to see if this
actually turned out to be a problem first...

-Toke
