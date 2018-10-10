Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A878C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 04:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02CFE2085B
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 04:52:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gAqO6NGP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mMdnO77y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02CFE2085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbeJJMM6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 08:12:58 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48128 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbeJJMM5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 08:12:57 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5002660C4B; Wed, 10 Oct 2018 04:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539147158;
        bh=iOzgbAVzAIcSWA+ffRzZN/iGg+Lgn5t3ojuyNHUFy2I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gAqO6NGPkp9guRP95e918t7h3zf1Ua6Kto5TempWJsJojAKGEtDhmY2jg/pxLtrW1
         9ejX1p/3hqXB5/lXwD4xTfMT+VyYz8GvYouMTeADnc49Q6ImWT9HqTtH5VUTHP7+GX
         W6yQceij9w7jwRSPsJ8oRyA7pmJ7YwqT3G9L3c0A=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id AF4FB60769;
        Wed, 10 Oct 2018 04:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539147157;
        bh=iOzgbAVzAIcSWA+ffRzZN/iGg+Lgn5t3ojuyNHUFy2I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mMdnO77ye/jxDCHMK+UQrUJ7r06ZYgr18ODAa3OsCm+pLBa/xNUbPxwFYzS7Gcx/f
         jpn2YQy1IFnBKvCumLimpHiV1fHEGCB/fknDnPq9s45omAgpffChmOSe3G3l79KDiz
         e0SZenzfzj4kNBVw/0Kw5u/tXap0Cpy3Z2m+pYbU=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 09 Oct 2018 21:52:37 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>
Subject: Re: [PATCH RFC v5 3/4] mac80211: Add airtime accounting and
 scheduling to TXQs
In-Reply-To: <153908837900.9471.5394468800857658136.stgit@alrua-kau>
References: <153908805217.9471.9290979918041653328.stgit@alrua-kau>
 <153908837900.9471.5394468800857658136.stgit@alrua-kau>
Message-ID: <a65909ee425585a49d9e17f6504cf0ba@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-09 05:32, Toke Høiland-Jørgensen wrote:
> This adds airtime accounting and scheduling to the mac80211 TXQ
> scheduler. A new callback, ieee80211_sta_register_airtime(), is added
> that drivers can call to report airtime usage for stations.
> 
> When airtime information is present, mac80211 will schedule TXQs
> (through ieee80211_next_txq()) in a way that enforces airtime fairness
> between active stations. This scheduling works the same way as the 
> ath9k
> in-driver airtime fairness scheduling. If no airtime usage is reported
> by the driver, the scheduler will default to round-robin scheduling.
> 
> For drivers that don't control TXQ scheduling in software, a new API
> function, ieee80211_txq_may_transmit(), is added which the driver can 
> use
> to check if the TXQ is eligible for transmission, or should be 
> throttled to
> enforce fairness. Calls to this function must also be enclosed in
> ieee80211_txq_schedule_{start,end}() calls to ensure proper locking. 
> TXQs
> that are throttled by ieee802111_txq_may_transmit() will be woken up 
> again
> by a check added to the ieee80211_wake_txqs() tasklet.
> 

Toke,

I am observing soft lockup issues again with this new series while 
running
traffic with 50 clients. I am continuing testing with earlier series 
along with
snippet I shared. When driver operates in pull-mode, throttled txqs are 
marked
and refilled in airtime_tasklet. This is causing major throughput drops 
and
packet loss and I am suspecting the latency in replenishing deficit.
Whereas in push-mode or in ath9k model, refill happens quicker at every 
packet
indication as well as tx completion.

I am planning to get rid of tasklet completely as it is only meant for 
pull-mode.
It would be better to refill in may_transmit() itself.

-Rajkumar
