Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC632C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 05:29:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CD292170E
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 05:29:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PMP+YdZI";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dN3ZRhDL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7CD292170E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbeI1LvC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 07:51:02 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46440 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbeI1LvC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 07:51:02 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4407060B1E; Fri, 28 Sep 2018 05:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538112544;
        bh=1SiFD8AY6RUDGSj60uX2d0vSWDmaFqUHPBYNNBqveww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PMP+YdZI1y4EqIHP9oMUK3uHyl6TiuHSb565dHw7Tze82Fatdjs2dLD+XE2Rxgaje
         Bo9XSPWTbHxeqqM+I49R0acRQ3VjZ9Gipmq23DqPFJF8yQWcUmEDtwJY+qltI3PYuc
         CMC6nvw/oprIwHBJZbP6KGKJP7ZFqtQZ19igUroc=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 65869605FF;
        Fri, 28 Sep 2018 05:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538112543;
        bh=1SiFD8AY6RUDGSj60uX2d0vSWDmaFqUHPBYNNBqveww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dN3ZRhDL+OzuRqYrbV27t+mtiRt9cQONIvYrZNclra5OtHAkntIn//MHI1h2pOJ1L
         HJGRy8IUYMRRo6MwbnVEOJEsH1F+kZnR2hlTjay/ossjVXMQnmBHmI8YHUCyjYlmtu
         h1JXm1Rf9XPjex15LU4ZbhWoqF67gr/Shc0JBpMw=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 27 Sep 2018 22:29:03 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH RFC v4 3/4] mac80211: Add airtime accounting and
 scheduling to TXQs
In-Reply-To: <8f7145bf5abe50194bced025a5e739b9@codeaurora.org>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1>
 <153711973134.9231.18038849900399644494.stgit@alrua-x1.karlstad.toke.dk>
 <826b6251746ee4d280d532f4ecdc5aa3@codeaurora.org> <87pnx0haud.fsf@toke.dk>
 <8f7145bf5abe50194bced025a5e739b9@codeaurora.org>
Message-ID: <863bc54fbf04441d38dd53f523300a7e@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-09-26 17:09, Rajkumar Manoharan wrote:
> On 2018-09-26 02:22, Toke Høiland-Jørgensen wrote:
>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> :( Yeah... I got confused with attached soft lockup in ARM platform.
> 
Toke,

Cause for the soft lockup exposed in multi client scenario is due to
mixed order of fq_lock and active_txqs_lock. In wake_tx_queue or 
push_pending
case, driver acquires active_txq_lock first by schedule_start and 
followed by
fq_lock in tx_dequeue. The same order should be maintained in sta 
cleanup.
Below change fixed the issue.

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 4814710a64f3..2029d600663b 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -114,9 +114,7 @@ static void __cleanup_single_sta(struct sta_info 
*sta)
                 for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
                         struct txq_info *txqi = 
to_txq_info(sta->sta.txq[i]);

-                       spin_lock_bh(&fq->lock);
                         ieee80211_txq_purge(local, txqi);
-                       spin_unlock_bh(&fq->lock);
                 }
         }

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 884d9ce5ce4b..5d70f64a205c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1467,8 +1467,10 @@ void ieee80211_txq_purge(struct ieee80211_local 
*local,
         struct fq *fq = &local->fq;
         struct fq_tin *tin = &txqi->tin;

+       spin_lock_bh(&fq->lock);
         fq_tin_reset(fq, tin, fq_skb_free_func);
         ieee80211_purge_tx_queue(&local->hw, &txqi->frags);
+       spin_unlock_bh(&fq->lock);
         spin_lock_bh(&local->active_txq_lock[txqi->txq.ac]);
         list_del_init(&txqi->schedule_order);
         spin_unlock_bh(&local->active_txq_lock[txqi->txq.ac]);

-Rajkumar
