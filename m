Return-Path: <SRS0=rthY=NG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6205C6786E
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 14:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3568F2085B
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 14:16:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="YgXUP72G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3568F2085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbeJZWxa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 18:53:30 -0400
Received: from mail.toke.dk ([52.28.52.200]:33657 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726113AbeJZWxa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 18:53:30 -0400
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1540563374; bh=rUHJB8Hin3czoeUn7ehilxSPOpddCtiBXKATwqXpxfM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=YgXUP72GBzdrnHIXL6KYDm6Pwg/XkuASROcxSevXC2LXo833gR3tC71vj7CyPa7F9
         uu467Oaq5g+giC3Tlj2Jg1oQeSfAw3BOmemomu1Ev8e42Y+ibQDK6g0Hriy2n7R/Mw
         fGWhm6ZugQIjBY/r5MxjB252KORQThKmN4tRnsLySazV2eIEjH19KQTCeJoj6iWSzG
         YDRuehuuwVA7RnOPl6JqHhhtfKqFF9RVLNo4G3EWhJVC9+B91UH5sGxzwKu0M2OBnm
         MJ0pAXpPDwId1s87KWbh2/JwWcSKCncXB4G9y15I8t1ZAG2+VQYbvGauhrWoM7Xuak
         LMxZ+A7/pQZMQ==
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: Re: [PATCH 3/6] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <1540033534-11211-4-git-send-email-rmanohar@codeaurora.org>
References: <1540033534-11211-1-git-send-email-rmanohar@codeaurora.org> <1540033534-11211-4-git-send-email-rmanohar@codeaurora.org>
Date:   Fri, 26 Oct 2018 16:16:02 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <8736ssbxp9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>
> This adds airtime accounting and scheduling to the mac80211 TXQ
> scheduler. A new callback, ieee80211_sta_register_airtime(), is added
> that drivers can call to report airtime usage for stations.
>
> When airtime information is present, mac80211 will schedule TXQs
> (through ieee80211_next_txq()) in a way that enforces airtime fairness
> between active stations. This scheduling works the same way as the ath9k
> in-driver airtime fairness scheduling. If no airtime usage is reported
> by the driver, the scheduler will default to round-robin scheduling.
>
> For drivers that don't control TXQ scheduling in software, a new API
> function, ieee80211_txq_may_transmit(), is added which the driver can use
> to check if the TXQ is eligible for transmission, or should be throttled =
to
> enforce fairness. Calls to this function must also be enclosed in
> ieee80211_txq_schedule_{start,end}() calls to ensure proper locking.
>
> The API ieee80211_txq_may_transmit() also ensures that TXQ list will be
> aligned aginst driver's own round-robin scheduler list. i.e it rotates
> the TXQ list till it makes the requested node becomes the first entry
> in TXQ list. Thus both the TXQ list and driver's list are in sync.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
> Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
> ---
>  include/net/mac80211.h     | 58 ++++++++++++++++++++++++++++++
>  net/mac80211/cfg.c         |  3 ++
>  net/mac80211/debugfs.c     |  3 ++
>  net/mac80211/debugfs_sta.c | 50 ++++++++++++++++++++++++--
>  net/mac80211/ieee80211_i.h |  2 ++
>  net/mac80211/main.c        |  4 +++
>  net/mac80211/sta_info.c    | 45 +++++++++++++++++++++--
>  net/mac80211/sta_info.h    | 13 +++++++
>  net/mac80211/status.c      |  6 ++++
>  net/mac80211/tx.c          | 90 ++++++++++++++++++++++++++++++++++++++++=
+++---
>  10 files changed, 264 insertions(+), 10 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 2f5c0fbd453c..0ced3adb09ac 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -2334,6 +2334,8 @@ enum ieee80211_hw_flags {
>   * @tx_sk_pacing_shift: Pacing shift to set on TCP sockets when frames f=
rom
>   *	them are encountered. The default should typically not be changed,
>   *	unless the driver has good reasons for needing more buffers.
> + *
> + * @airtime_weight: Default airtime weight preferred by driver.
>   */
>  struct ieee80211_hw {
>  	struct ieee80211_conf conf;
> @@ -2370,6 +2372,7 @@ struct ieee80211_hw {
>  	const struct ieee80211_cipher_scheme *cipher_schemes;
>  	u8 max_nan_de_entries;
>  	u8 tx_sk_pacing_shift;
> +	u32 airtime_weight;
>  };

This doesn't make sense. Airtime weights can be set by userspace, so
even if a driver sets another default it is not guaranteed to be
honoured. So what's the point?

> +bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
> +				struct ieee80211_txq *txq)
> +{
> +	struct ieee80211_local *local =3D hw_to_local(hw);
> +	struct txq_info *iter, *tmp, *txqi =3D to_txq_info(txq);
> +	struct sta_info *sta;
> +	u8 ac =3D txq->ac;
> +
> +	lockdep_assert_held(&local->active_txq_lock[ac]);
> +
> +	if (!txqi->txq.sta)
> +		goto out;
> +
> +	if (list_empty(&txqi->schedule_order))
> +		goto out;
> +
> +	list_for_each_entry_safe(iter, tmp, &local->active_txqs[ac],
> +				 schedule_order) {
> +		if (iter =3D=3D txqi)
> +			break;
> +
> +		if (!iter->txq.sta) {
> +			list_move_tail(&iter->schedule_order,
> +				       &local->active_txqs[ac]);
> +			continue;
> +		}
> +		sta =3D container_of(iter->txq.sta, struct sta_info, sta);
> +		if (sta->airtime[ac].deficit < 0)
> +			sta->airtime[ac].deficit +=3D sta->airtime_weight;
> +		list_move_tail(&iter->schedule_order, &local->active_txqs[ac]);
> +	}

So since we're rotating the queue on every call to the function, I'm
wondering if this actually succeeds in throttling the slow station's
airtime usage enough to achieve fairness? So I'll ask again: Did you
test the fairness performance, and how?


Also, taking a step back:

With this, we're doing lots of work to make sure that the hardware's
round-robin scheduling queue lines up with mac80211; so if we do this
anyway, why can't we just control the order directly from mac80211
(which is what we do with the other next_txq() API)?

-Toke
