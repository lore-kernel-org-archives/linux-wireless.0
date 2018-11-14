Return-Path: <SRS0=SE/f=NZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C0B3C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 10:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B75102146D
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 10:58:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="qlCCVkRP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B75102146D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbeKNVAr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Nov 2018 16:00:47 -0500
Received: from nbd.name ([46.4.11.11]:49060 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727773AbeKNVAr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Nov 2018 16:00:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0EeqKR4uT4Mjamf/RGEZWxQZMTD+/D21ZCEL3QHwYN4=; b=qlCCVkRPw3j0VpR/Iu3QRJ0HAR
        TxC14JFhsxERwtyW7GWOvOptYdzEM21xnwWEmYv1Y11xM2xcHZ+TFO9PKyLaqqD6u6HvJEAKsFZ4c
        ZL80xgNfDd2sqEe4iLUo9QSGApCwbDACTBG+aRi1uW8KAR43peXrpbUYqKHYRg3l8/+w=;
Subject: Re: [PATCH v3 3/6] mac80211: Add airtime accounting and scheduling to
 TXQs
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     make-wifi-fast@lists.bufferbloat.net,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
References: <1542063113-22438-1-git-send-email-rmanohar@codeaurora.org>
 <1542063113-22438-4-git-send-email-rmanohar@codeaurora.org>
From:   Felix Fietkau <nbd@nbd.name>
Openpgp: preference=signencrypt
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 xsDiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwc0cRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPsJgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQzsFNBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabwkkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <e5344cad-2a18-a938-f2ed-43870027251c@nbd.name>
Date:   Wed, 14 Nov 2018 11:57:51 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1542063113-22438-4-git-send-email-rmanohar@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-11-12 23:51, Rajkumar Manoharan wrote:
> From: Toke Høiland-Jørgensen <toke@toke.dk>
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
> to check if the TXQ is eligible for transmission, or should be throttled to
> enforce fairness. Calls to this function must also be enclosed in
> ieee80211_txq_schedule_{start,end}() calls to ensure proper locking.
> 
> The API ieee80211_txq_may_transmit() also ensures that TXQ list will be
> aligned aginst driver's own round-robin scheduler list. i.e it rotates
> the TXQ list till it makes the requested node becomes the first entry
> in TXQ list. Thus both the TXQ list and driver's list are in sync.
> 
> Co-Developed-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
> ---
>  include/net/mac80211.h     | 59 ++++++++++++++++++++++++++++++
>  net/mac80211/cfg.c         |  3 ++
>  net/mac80211/debugfs.c     |  3 ++
>  net/mac80211/debugfs_sta.c | 50 ++++++++++++++++++++++++--
>  net/mac80211/ieee80211_i.h |  2 ++
>  net/mac80211/main.c        |  4 +++
>  net/mac80211/sta_info.c    | 44 +++++++++++++++++++++--
>  net/mac80211/sta_info.h    | 13 +++++++
>  net/mac80211/status.c      |  6 ++++
>  net/mac80211/tx.c          | 90 +++++++++++++++++++++++++++++++++++++++++++---
>  10 files changed, 264 insertions(+), 10 deletions(-)
> 
> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
> index aa4afbf0abaf..a1f1256448f5 100644
> --- a/net/mac80211/status.c
> +++ b/net/mac80211/status.c
> @@ -818,6 +818,12 @@ static void __ieee80211_tx_status(struct ieee80211_hw *hw,
>  			ieee80211_sta_tx_notify(sta->sdata, (void *) skb->data,
>  						acked, info->status.tx_time);
>  
> +		if (info->status.tx_time &&
> +		    wiphy_ext_feature_isset(local->hw.wiphy,
> +					    NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
> +			ieee80211_sta_register_airtime(&sta->sta, tid,
> +						       info->status.tx_time, 0);
> +
>  		if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
>  			if (info->flags & IEEE80211_TX_STAT_ACK) {
>  				if (sta->status_stats.lost_packets)
I think the same is needed in ieee80211_tx_status_ext.

> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 305965283506..3f417e80e041 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -3660,12 +3680,74 @@ void ieee80211_return_txq(struct ieee80211_hw *hw,
>  	lockdep_assert_held(&local->active_txq_lock[txq->ac]);
>  
>  	if (list_empty(&txqi->schedule_order) &&
> -	    (!skb_queue_empty(&txqi->frags) || txqi->tin.backlog_packets))
> -		list_add_tail(&txqi->schedule_order,
> -			      &local->active_txqs[txq->ac]);
> +	    (!skb_queue_empty(&txqi->frags) || txqi->tin.backlog_packets)) {
> +		/* If airtime accounting is active, always enqueue STAs at the
> +		 * head of the list to ensure that they only get moved to the
> +		 * back by the airtime DRR scheduler once they have a negative
> +		 * deficit. A station that already has a negative deficit will
> +		 * get immediately moved to the back of the list on the next
> +		 * call to ieee80211_next_txq().
> +		 */
> +		if (txqi->txq.sta &&
> +		    wiphy_ext_feature_isset(local->hw.wiphy,
> +					    NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
> +			list_add(&txqi->schedule_order,
> +				 &local->active_txqs[txq->ac]);
> +		else
> +			list_add_tail(&txqi->schedule_order,
> +				      &local->active_txqs[txq->ac]);
> +	}
>  }
This part doesn't really make much sense to me, but maybe I'm
misunderstanding how the code works.
Let's assume we have a driver like ath9k or mt76, which tries to keep a
number of aggregates in the hardware queue, and the hardware queue is
currently empty.
If the current txq entry is kept at the head of the schedule list,
wouldn't the code just pull from that one over and over again, until
enough packets are transmitted by the hardware and their tx status
processed?
It seems to me that while fairness is still preserved in the long run,
this could lead to rather bursty scheduling, which may not be
particularly latency friendly.

- Felix
