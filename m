Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22277C433E0
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Jan 2021 15:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFAB72310D
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Jan 2021 15:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbhAFPmO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Jan 2021 10:42:14 -0500
Received: from mail.toke.dk ([45.145.95.4]:49459 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbhAFPmN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Jan 2021 10:42:13 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1609947662; bh=KDGE0W8yzFBpgLufLewOmSfqW6XhZh/N+JY/uG+SGxs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=jchxXj9pRUgpAbrQVb3bTyisE35esffYoIx+XszbaOMk6pmMmPlbFoBJORBNQOdKO
         3EsEMYfioracL3mnHogf/kfdxdDNN9FN1Lb9p6jnZXqV2K9ucPOPayLjD+aBbX4OGr
         SsZ4b8dPFyDQeZSqJZGORG62ZpEoeyHFmBbCMriAKn1iZsMWbP1GAZVxEgFd5F/GkQ
         F0XYEh+PkorUxe0SzEsyURKWLCjHukxsAS/hktOWthvbuFWKid5eFnbUxDYJ93evb9
         p1y423XJkWXo9Zd+fXG40bqz+fkSBS7Sg6/whNqRKkDtk3fIbYrj2wWPXN64+iq4S0
         xeBM+hSgCQ0zQ==
To:     Felix Fietkau <nbd@nbd.name>, Ryder Lee <ryder.lee@mediatek.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] mac80211: check ATF flag in ieee80211_next_txq()
In-Reply-To: <68ab89bc-70f4-e822-3d96-21ba3bd6511f@nbd.name>
References: <d9aef825d186a91ff91f6a81045d49d375533b14.1609894402.git.ryder.lee@mediatek.com>
 <87r1my49us.fsf@toke.dk> <68ab89bc-70f4-e822-3d96-21ba3bd6511f@nbd.name>
Date:   Wed, 06 Jan 2021 16:41:02 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87k0sq3wfl.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> On 2021-01-06 11:51, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Ryder Lee <ryder.lee@mediatek.com> writes:
>>=20
>>> The selected txq should be scheduled unconditionally if
>>> NL80211_EXT_FEATURE_AIRTIME_FAIRNESS is not set by driver.
>>>
>>> Also put the sta to the end of the active_txqs list if
>>> deficit is negative then move on to the next txq.
>>=20
>> Why is this needed? If the feature is not set, no airtime should ever be
>> accounted to the station, and so sta->airtime[txqi->txq.ac].deficit will
>> always be 0 - so you're just adding another check that doesn't actually
>> change the behaviour, aren't you?
>
> I think it might make sense to keep airtime reporting even when airtime
> fairness is disabled at run time, so this patch makes sense to me.
> Instead of this patch, the right place to deal with this would probably
> be ieee80211_sta_register_airtime.

When the fairness mechanism is user-disabled I agree it makes sense to
still keep the accounting; and in fact that's what
ieee80211_sta_register_airtime() already does when the accounting is
turned off by way of the airtime_flags field... So don't think anything
else is needed there either?

-Toke
