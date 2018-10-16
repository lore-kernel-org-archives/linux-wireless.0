Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61642C04EBD
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 10:20:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 277E62086E
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 10:20:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="y3SXdKFe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 277E62086E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbeJPSKA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 14:10:00 -0400
Received: from mail.toke.dk ([52.28.52.200]:59359 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727055AbeJPSKA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 14:10:00 -0400
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1539685213; bh=5F2H2HgASlKhZ1P09d/jPbG4vVLaZ5anc5EFheaeT2U=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=y3SXdKFefYizd/Dn2boMHUB9VYEOuvDkpASFhYSzopt7rk5+k0gUCPcqlae+/jHwN
         U4XNdDXpQ69v3LXWr2JrmYjPnKajwVrfmkgm6hzkL6RkNkth4IzcOyxHIQclvvvR5P
         PWDhDFT2FAHctReB1GE/p/YB0TOxgHKKPm5n3xZujLkeuN+eSnrTt+Mi5LEYO7Kxrz
         EiaTm+sBxdUp+3OhxzQ3lGkI6P0I+YB4IsdB4phP1TMguTlQDmaRsFmYMc/OJxbpTE
         1FAHq3701t1NIlsGHJ9QlYGQjhOSy8Tc7QNAYDI891TWMFNqYu4WZbLnUfm3AxVXPU
         nYUnyRRDKt7xQ==
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH RFC v5 3/4] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <a582bd5865268ac69b0105c22dd927a3@codeaurora.org>
References: <153908805217.9471.9290979918041653328.stgit@alrua-kau> <153908837900.9471.5394468800857658136.stgit@alrua-kau> <a65909ee425585a49d9e17f6504cf0ba@codeaurora.org> <87zhvm832s.fsf@toke.dk> <187bade306627912c70d800819ef0b87@codeaurora.org> <87pnwg93at.fsf@toke.dk> <7dfcb7a13a3f75f01f7b88163f2c33d6@codeaurora.org> <875zy7qxle.fsf@toke.dk> <a582bd5865268ac69b0105c22dd927a3@codeaurora.org>
Date:   Tue, 16 Oct 2018 12:20:12 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87a7nery5f.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-10-12 03:16, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>=20
>> - Just loop with the smaller quantum until one of the stations go into
>>   the positive (what we do now).
>>=20
>> - Go through all active stations, find the one that is closest being in
>>   the positive, and add that amount to the quantum. I.e., something
>>   like (assuming no station has positive deficit; if one does, you=20
>> don't
>>   want to add anything anyway):
>>=20
>>   to_add =3D -(max(stn.deficit) for stn in active stations)
>>   for stn in active stations:
>>     stn.deficit +=3D to_add + stn.weight
>>=20
> Toke,
>
> Sorry for the delayed response. I did lot of experiments. Below are my=20
> observations.
> Sorry for lengthy reply.
>
> In current model, next_txq() is main routine that serves DRR and
> fairness is enforced by serving only only first txq. Here the first
> node could be either newly initiated traffic or returned node by
> return_txq(). This works perfectly as long as the driver is running
> any RR algo.
>
> Whereas in ath10k, firmware runs its own RR in pull mode and builds
> txq list based on driver's hostq table. In this case it can not be
> simply assumed that firmware always gives fetch request for first node
> of mac80211's txq list. i.e both RR algo could be out of sync.

So I'm wondering why they don't sync; if the hardware is just doing RR
scheduling, eventually it should hit the TXQ that's first in the queue
and keep in sync after that?

How are you testing, and what metrics are you using?

> On an idle condition a single fetch indication can dequeue ~190 msdus
> from each tid of give stn list.

Wow, that sounds pretty bad. Guess we need the airtime queue limits! :)

> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wirel=
ess/ath/ath10k/htt_rx.c
> index 625a4ab37ea0..269ae8311056 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -2352,7 +2352,7 @@ static void ath10k_htt_rx_tx_fetch_ind(struct ath10=
k *ar, struct sk_buff *skb)
>  			num_msdus++;
>  			num_bytes +=3D ret;
>  		}
> -		ieee80211_return_txq(hw, txq);
> +		ieee80211_return_txq(hw, txq, true);

I don't like the extra parameter; a similar one was in an earlier
version of my patch set, but I'd prefer that mac80211 just does the
right thing...

Do I understand it correctly that push/pull mode is selected solely by
hardware/firmware versions? Because in that case we could split it into
two feature flags instead...

> @@ -3670,13 +3670,8 @@ bool ieee80211_txq_may_transmit(struct ieee80211_h=
w *hw,
>  	if (sta->airtime[ac].deficit >=3D 0)
>  		goto out;
>=20=20
> -	list_for_each_entry(txqi, &local->active_txqs[ac], schedule_order) {
> -		if (!txqi->txq.sta)
> -			continue;
> -		sta =3D container_of(txqi->txq.sta, struct sta_info, sta);
> -		sta->airtime[ac].deficit +=3D
> -			(IEEE80211_TXQ_MAY_TX_QUANTUM * sta->airtime_weight);
> -	}
> +	sta->airtime[ac].deficit +=3D sta->airtime_weight;
> +	list_move_tail(&txqi->schedule_order, &local->active_txqs[ac]);

I'm wondering whether this actually succeeds in achieving fairness? This
basically allows a TXQ to be plucked from any point in the list, get a
quantum increase and be put back on, no matter the state of other TXQs.

Did you test how well the stations divide their airtime? And if so,
under which conditions?

-Toke
