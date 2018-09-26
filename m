Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6811DC43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 07:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0832F206B5
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 07:09:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="j11yTpGP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Y6AmZRiM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0832F206B5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbeIZNUr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 09:20:47 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34516 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbeIZNUq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 09:20:46 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3DEC760251; Wed, 26 Sep 2018 07:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1537945758;
        bh=pm7b8SuxGfV/QvMIsg4IwovrbzJg3A87KWcOVYcjLco=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j11yTpGPz1o9yyGbhx5dWNKL59uUscyavCGKp2X0c0Jf8gVxgBlYSBe50p/MCMc5U
         T4wSW870xTqCKk5WUdCjMxgybKKoX5HP1xh/GwRwuzjmknX5TQEV691puGRcE68GQx
         eM5ukg7Dl5LR/goLsWquEVrfZHVeS0jELeXkf3Po=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id A8B7B60251;
        Wed, 26 Sep 2018 07:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1537945757;
        bh=pm7b8SuxGfV/QvMIsg4IwovrbzJg3A87KWcOVYcjLco=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y6AmZRiMAAdmwOsLF+E60KDhHdkx7l8TbG7MKQX+d1Ob/T7sqw1y+vsB++bR0ERyL
         KjL0pRpGs13aLuAQdRfrypJ5aN4olzBxfkWvb1Gb4D009Pt2CvTu385BRtS1qkEv+q
         lvJpIKnbH7SAs69VXsMsGSc/8yMAStuLLELQJfyE=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 26 Sep 2018 00:09:17 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH RFC v4 3/4] mac80211: Add airtime accounting and
 scheduling to TXQs
In-Reply-To: <153711973134.9231.18038849900399644494.stgit@alrua-x1.karlstad.toke.dk>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1>
 <153711973134.9231.18038849900399644494.stgit@alrua-x1.karlstad.toke.dk>
Message-ID: <826b6251746ee4d280d532f4ecdc5aa3@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-09-16 10:42, Toke Høiland-Jørgensen wrote:
> This adds airtime accounting and scheduling to the mac80211 TXQ
> scheduler. A new callback, ieee80211_sta_register_airtime(), is added
> that drivers can call to report airtime usage for stations.
> 
> +bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
> +				struct ieee80211_txq *txq)
> +{

[...]

> +	if (ret) {
> +		clear_bit(IEEE80211_TXQ_AIRTIME_THROTTLE, &txqi->flags);
> +		list_del_init(&txqi->schedule_order);
> +	} else
> +		set_bit(IEEE80211_TXQ_AIRTIME_THROTTLE, &txqi->flags);
> +
> 
This looks wrong to me. txqi->flags are protected by fq->lock but here
it is by active_txq_lock. no?

> @@ -3677,6 +3751,7 @@ void ieee80211_txq_schedule_end(struct
> ieee80211_hw *hw, u8 ac)
>  	struct ieee80211_local *local = hw_to_local(hw);
> 
>  	spin_unlock_bh(&local->active_txq_lock[ac]);
> +	tasklet_schedule(&local->wake_txqs_tasklet);
>  }
> 
It is an overload to schedule wake_txqs_tasklet for each txq unlock.
Instead I would prefer to call __ieee80211_kick_airtime from 
schedule_end.
Thoughts?

-Rajkumar
