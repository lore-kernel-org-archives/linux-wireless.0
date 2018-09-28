Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3986C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 09:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A283C2150B
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 09:58:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="Alnm/XoT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A283C2150B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbeI1QVE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 12:21:04 -0400
Received: from mail.toke.dk ([52.28.52.200]:43113 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729040AbeI1QVD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 12:21:03 -0400
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1538128683; bh=ZZtgmlKhGSImAMCwI5/30V2NHWx2KU0Qgj4yMjXE5IA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Alnm/XoTWayMg+/0UxIfJ6ubwhv8fn4aqVJVmD7G12BO5ChQlIHedAr2ZtveqU0+D
         jqKe71SEv0YXtXC4sv71UB/HNpH2BPE+TAnCfF5SgbFE3nOBll0ZfoMkrOoFMzq5cj
         aX9ktQ37tX7caO1ciu09a+1t8D5EBATFSf1GftxrYqKjpMa87bdb/iCk29mylIf5H1
         lElrx0AKTOrOi2Obib1Vu+xJ6w7X3bbf/4pn5B4jk1ExSCnh7U7OcTxJ9SvgvcKG7S
         yMUQLeGFLZjeEal7+QYIgEoW8/Ze8xxv1H0adxXUuKF2lqfDzt+YjOu7XtNWEgzbFk
         dfM0Qt+hRgfNw==
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH RFC v4 3/4] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <7ba8513b0ec5a7c35b396c7739fc2d7d@codeaurora.org>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1> <153711973134.9231.18038849900399644494.stgit@alrua-x1.karlstad.toke.dk> <826b6251746ee4d280d532f4ecdc5aa3@codeaurora.org> <87pnx0haud.fsf@toke.dk> <8f7145bf5abe50194bced025a5e739b9@codeaurora.org> <863bc54fbf04441d38dd53f523300a7e@codeaurora.org> <93015743-5D16-4D79-948F-E2F46CF2450A@toke.dk> <7ba8513b0ec5a7c35b396c7739fc2d7d@codeaurora.org>
Date:   Fri, 28 Sep 2018 11:58:03 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87zhw2eyfo.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-09-28 00:51, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> On 28 September 2018 07:29:03 CEST, Rajkumar Manoharan
>> <rmanohar@codeaurora.org> wrote:
>>> On 2018-09-26 17:09, Rajkumar Manoharan wrote:
>>>> On 2018-09-26 02:22, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>>=20
>>>> :( Yeah... I got confused with attached soft lockup in ARM platform.
>>>>=20
>>> Toke,
>>>=20
>>> Cause for the soft lockup exposed in multi client scenario is due to
>>> mixed order of fq_lock and active_txqs_lock. In wake_tx_queue or
>>> push_pending
>>> case, driver acquires active_txq_lock first by schedule_start and
>>> followed by
>>> fq_lock in tx_dequeue. The same order should be maintained in sta
>>> cleanup.
>>> Below change fixed the issue.
>>=20
>> Ah, great find! I'll fold this into the next version, thanks!
>>=20
>
> One more thing. As I mentioned earlier, scheduling wake_txqs_tasklet
> is heavy load and causing random rcu stall issue. Hence I added
> another API to schedule throttled txqs once for all. Also I did
> a cleanup in kick_airtime by traversing list only once. With these
> changes I don't see rcu stall issue. Please review and fold them as=20
> well.
>
> -Rajkumar
>
>
> single_iter - clean up kick_airtime
> sched_throttle - new API and separate tasklet for throttled txqs
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 404c5e82e4ca..023bc81bd4a0 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -242,13 +242,11 @@ EXPORT_SYMBOL(ieee80211_ctstoself_duration);
>=20=20
>  static void __ieee80211_kick_airtime(struct ieee80211_local *local, int =
ac)
>  {
> -	bool seen_eligible =3D false;
>  	struct txq_info *txqi;
>  	struct sta_info *sta;
>=20=20
>  	spin_lock_bh(&local->active_txq_lock[ac]);
>=20=20
> - begin:
>  	if (list_empty(&local->active_txqs[ac]))
>  		goto out;
>=20=20
> @@ -258,12 +256,12 @@ static void __ieee80211_kick_airtime(struct ieee802=
11_local *local, int ac)
>=20=20
>  		sta =3D container_of(txqi->txq.sta, struct sta_info, sta);
>=20=20
> -		if (sta->airtime[ac].deficit >=3D 0) {
> -			seen_eligible =3D true;
> -
> -			if (!test_and_clear_bit(IEEE80211_TXQ_AIRTIME_THROTTLE,
> -						&txqi->flags))
> +		if (test_bit(IEEE80211_TXQ_AIRTIME_THROTTLE, &txqi->flags)) {
> +			clear_bit(IEEE80211_TXQ_AIRTIME_THROTTLE, &txqi->flags);
> +			if (sta->airtime[ac].deficit < 0) {
> +				sta->airtime[ac].deficit +=3D sta->airtime_weight;
>  				continue;
> +			}

This is going to break fairness; we only want to increase deficits when
all stations' deficits are negative. Hence the two loops. Did you see
any problems with those specifically?

-Toke
