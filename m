Return-Path: <SRS0=PZxT=RJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6272C43381
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 23:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7146320684
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 23:10:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BkxcypsZ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YgJ0Czr3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfCFXKA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Mar 2019 18:10:00 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39412 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfCFXKA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Mar 2019 18:10:00 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2BB2360364; Wed,  6 Mar 2019 23:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551913799;
        bh=u2F2xJi1/W2mYn9QpjsBVXphR/g/s+CREv01qaEgJYU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BkxcypsZkKYTu1ub8DUwZPT/XgJQODmCiAxEnfQc1A1XOfSx88RWR0Y0bc2kmqiml
         lPGMnhgl4H+DCq4EEZKu/J6QYocOpHFhG1KX4GvY2h5SC4DWQLsCq/2S2ogdPMYbwQ
         nBv0f/c5zEuL730N3N7w9enz7zdsRaQsiQEIICF0=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 71C9C60364;
        Wed,  6 Mar 2019 23:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551913798;
        bh=u2F2xJi1/W2mYn9QpjsBVXphR/g/s+CREv01qaEgJYU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YgJ0Czr38CZl+3gHeYVr+pVZmoQbjjLLCuinz+kK3lvsFyblmnZfyBQGhPUubFMlV
         4V1wvRGNzBxuvtJMnM0feO+u1hfeHTiwjnFo3rHhpJ1RclZpWhO0Q5CAi0Ox50zneK
         jMuwKEXfE/eaLKrpqwmjznTv/baYgVaO5hix5xXM=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 06 Mar 2019 15:09:58 -0800
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC/RFT] mac80211: Switch to a virtual time-based airtime
 scheduler
In-Reply-To: <87va0x1g0j.fsf@toke.dk>
References: <20190215170512.31512-1-toke@redhat.com>
 <87va0x1g0j.fsf@toke.dk>
Message-ID: <69d22b9e3ea08a81fea8b8742cb697c5@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-03-05 07:45, Toke Høiland-Jørgensen wrote:
> Toke Høiland-Jørgensen <toke@redhat.com> writes:
> 
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
>>   them; no need to hard-block the scheduling rotation until the head 
>> of the
>>   queue has used up its quantum.
>> 
>> - The check of whether a station is eligible for transmission becomes
>>   simpler (in ieee80211_txq_may_transmit()).
>> 
>> The drawback is that scheduling becomes slightly more expensive, as we 
>> need
>> to maintain an rbtree of TXQs sorted by virtual time. This means that
>> ieee80211_register_airtime() becomes O(logN) in the number of 
>> currently
>> scheduled TXQs. However, hopefully this number rarely grows too big 
>> (it's
>> only TXQs currently backlogged, not all associated stations), so it
>> shouldn't be too big of an issue.
>> 
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> ---
>> This is basically the idea I mentioned earlier for a different way to
>> handle the airtime scheduling.
>> 
>> I've tested it on ath9k, where it achieves the same fairness and
>> weighing properties as the old scheduler. It would be good if you 
>> could
>> test it on your ath10k setup, Rajkumar; and all of you please comment 
>> on
>> whether you agree that this is better from an API point of view.
> 
> So no one has any comments on this? :)
> 
Toke,

This is kind of design change. ;) FMU w.r.t ath10k, earlier deficit 
adjustment
and list rotation happens at next_txq and may_transmit. Now it seems the 
rbtree
adjustment happens upon new txq insertion through wake_txq and whenever 
driver
reports airtime by register_airtime. Am I right?

We are using pretty old kernel (3.14, 4.4). It definitely needs backport 
of rbtree.
Have you used *Wrt image or validation on x86?

-Rajkumar


