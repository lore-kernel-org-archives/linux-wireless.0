Return-Path: <SRS0=M0/e=RK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDAB3C43381
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 14:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1D1620675
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 14:27:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="lG3VVBXV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbfCGO14 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Mar 2019 09:27:56 -0500
Received: from nbd.name ([46.4.11.11]:55744 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbfCGO14 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Mar 2019 09:27:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=B3lRoMD3jLWsb/pJ+QjzrEsBJLR1wKFgTArpJT1MvPw=; b=lG3VVBXV5SFQRZZefT2713BdlJ
        pNv0zhLLimnI2cx2yTm02ar2Hv5X3QOrXHE3rDmmUxRxbXhwf8I1uMTRG+crgSZmrjuRPnKzbmhq5
        oKD+MhRR13BeeJ7Png/FoTxCV4Kdo99s1wIsJG5Iq2IcBg6HTzO3jn6beA83mJSZNdFU=;
Subject: Re: [RFC/RFT] mac80211: Switch to a virtual time-based airtime
 scheduler
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Kan Yan <kyan@google.com>
References: <20190215170512.31512-1-toke@redhat.com>
From:   Felix Fietkau <nbd@nbd.name>
Openpgp: preference=signencrypt
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 mQGiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwbQcRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPohgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQuQINBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabiEkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <f6c5bc25-a8b3-bac3-8d62-d41347a6c070@nbd.name>
Date:   Thu, 7 Mar 2019 15:27:52 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190215170512.31512-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-02-15 18:05, Toke Høiland-Jørgensen wrote:
> This switches the airtime scheduler in mac80211 to use a virtual time-based
> scheduler instead of the round-robin scheduler used before. This has a
> couple of advantages:
> 
> - No need to sync up the round-robin scheduler in firmware/hardware with
>   the round-robin airtime scheduler.
> 
> - If several stations are eligible for transmission we can schedule both of
>   them; no need to hard-block the scheduling rotation until the head of the
>   queue has used up its quantum.
> 
> - The check of whether a station is eligible for transmission becomes
>   simpler (in ieee80211_txq_may_transmit()).
> 
> The drawback is that scheduling becomes slightly more expensive, as we need
> to maintain an rbtree of TXQs sorted by virtual time. This means that
> ieee80211_register_airtime() becomes O(logN) in the number of currently
> scheduled TXQs. However, hopefully this number rarely grows too big (it's
> only TXQs currently backlogged, not all associated stations), so it
> shouldn't be too big of an issue.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
The approach looks good to me, but I haven't really reviewed it very
carefully yet. Just some points that I noticed below:

> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index 11f058987a54..9d01fdd86e2d 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -389,7 +389,6 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
>  	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
>  		skb_queue_head_init(&sta->ps_tx_buf[i]);
>  		skb_queue_head_init(&sta->tx_filtered[i]);
> -		sta->airtime[i].deficit = sta->airtime_weight;
>  	}
>  
>  	for (i = 0; i < IEEE80211_NUM_TIDS; i++)
> @@ -1831,18 +1830,32 @@ void ieee80211_sta_register_airtime(struct ieee80211_sta *pubsta, u8 tid,
>  {
>  	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
>  	struct ieee80211_local *local = sta->sdata->local;
> +	struct ieee80211_txq *txq = sta->sta.txq[tid];
>  	u8 ac = ieee80211_ac_from_tid(tid);
> -	u32 airtime = 0;
> +	u64 airtime = 0, weight_sum;
> +
> +	if (!txq)
> +		return;
>  
>  	if (sta->local->airtime_flags & AIRTIME_USE_TX)
>  		airtime += tx_airtime;
>  	if (sta->local->airtime_flags & AIRTIME_USE_RX)
>  		airtime += rx_airtime;
>  
> +	/* Weights scale so the unit weight is 256 */
> +	airtime <<= 8;
> +
>  	spin_lock_bh(&local->active_txq_lock[ac]);
> +
>  	sta->airtime[ac].tx_airtime += tx_airtime;
>  	sta->airtime[ac].rx_airtime += rx_airtime;
> -	sta->airtime[ac].deficit -= airtime;
> +
> +	weight_sum = local->airtime_weight_sum[ac] ?: sta->airtime_weight;
> +
> +	local->airtime_v_t[ac] += airtime / weight_sum;
> +	sta->airtime[ac].v_t += airtime / sta->airtime_weight;
> +	ieee80211_resort_txq(&local->hw, txq);
These divisions could be a bit expensive, any way to change the
calculation to avoid them?

> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> -void ieee80211_return_txq(struct ieee80211_hw *hw,
> +static void __ieee80211_insert_txq(struct rb_root_cached *root,
> +				   struct txq_info *txqi, u8 ac)
> +{
> +	struct rb_node **new = &root->rb_root.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct txq_info *__txqi;
> +	bool leftmost = true;
> +
> +	while (*new) {
> +		parent = *new;
> +		__txqi = rb_entry(parent, struct txq_info, schedule_order);
> +
> +		if (!txqi->txq.sta) {
> +			/* new txqi has no sta - insert to the left */
> +			new = &parent->rb_left;
> +		} else if (!__txqi->txq.sta) {
> +			/* existing txqi has no sta - insert to the right */
> +			new = &parent->rb_right;
> +			leftmost = false;
> +		} else {
> +			struct sta_info *old_sta = container_of(__txqi->txq.sta,
> +								struct sta_info,
> +								sta);
> +			struct sta_info *new_sta = container_of(txqi->txq.sta,
> +								struct sta_info,
> +								sta);
> +
> +			if (new_sta->airtime[ac].v_t <= old_sta->airtime[ac].v_t)
> +				new = &parent->rb_left;
> +			else {
> +				new = &parent->rb_right;
> +				leftmost = false;
> +			}
> +
> +		}
> +	}
> +
> +	rb_link_node(&txqi->schedule_order, parent, new);
> +	rb_insert_color_cached(&txqi->schedule_order, root, leftmost);
> +}
I'm a bit worried about this part. Does that mean that vif txqs always
have priority over sta txqs?

- Felix
