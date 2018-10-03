Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34FFDC00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 06:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEA9420652
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 06:27:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JErG+VDW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JErG+VDW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EEA9420652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbeJCNOO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 09:14:14 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35414 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbeJCNOO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 09:14:14 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BFB5760C6A; Wed,  3 Oct 2018 06:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538548036;
        bh=2CN7A384fqLG8Wv7yQlJ/lhfQD75xVr6J4FB6r4zKkw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JErG+VDWU14g0Z1C9BbftgIP7VLWh75Cz3BEzeWg3dPOjf42OicoX0+fT/8Aqvtqu
         QZFeMQ/AaCuoA0VMZek4tyIlnsNao9Culo+LBNgy5Z9ZRjkzTkZIm8f2t3jiMNTd0m
         66ugZR+tIk9N43WYe1AH3R4MPmF+ua7+26U5JFU4=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 1824260A9B;
        Wed,  3 Oct 2018 06:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538548036;
        bh=2CN7A384fqLG8Wv7yQlJ/lhfQD75xVr6J4FB6r4zKkw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JErG+VDWU14g0Z1C9BbftgIP7VLWh75Cz3BEzeWg3dPOjf42OicoX0+fT/8Aqvtqu
         QZFeMQ/AaCuoA0VMZek4tyIlnsNao9Culo+LBNgy5Z9ZRjkzTkZIm8f2t3jiMNTd0m
         66ugZR+tIk9N43WYe1AH3R4MPmF+ua7+26U5JFU4=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 02 Oct 2018 23:27:16 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Jonathan Morton <chromatix99@gmail.com>, Kan Yan <kyan@google.com>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless-owner@vger.kernel.org,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [Make-wifi-fast] [PATCH RFC v4 3/4] mac80211: Add airtime
 accounting and scheduling to TXQs
In-Reply-To: <08dabe69e625c11f70b217ae9695c7f4@codeaurora.org>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1>
 <153711973134.9231.18038849900399644494.stgit@alrua-x1.karlstad.toke.dk>
 <826b6251746ee4d280d532f4ecdc5aa3@codeaurora.org> <87pnx0haud.fsf@toke.dk>
 <8f7145bf5abe50194bced025a5e739b9@codeaurora.org>
 <863bc54fbf04441d38dd53f523300a7e@codeaurora.org>
 <93015743-5D16-4D79-948F-E2F46CF2450A@toke.dk>
 <7ba8513b0ec5a7c35b396c7739fc2d7d@codeaurora.org> <87zhw2eyfo.fsf@toke.dk>
 <5d961a5f61de45b85b1b037bcef9270d@codeaurora.org>
 <44B09168-C08F-4C85-8D74-D576CCC79880@gmail.com>
 <586459da6ec36edc2284df8533915d62@codeaurora.org>
 <4929C006-3452-4C17-9500-8D7485EB538E@toke.dk>
 <0531def170ef7f9cadcf85a6dc9af22b@codeaurora.org> <87a7nwbvwu.fsf@toke.dk>
 <a5a7e11d6913c32385cc74ea3d0e1c76@codeaurora.org> <877ej0b2d8.fsf@toke.dk>
 <30cf3754fa970aa1af11791c2625a7c9@codeaurora.org>
 <08dabe69e625c11f70b217ae9695c7f4@codeaurora.org>
Message-ID: <9483b0f1835ddda56c4bebc6e6c920e4@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-02 22:53, Rajkumar Manoharan wrote:

Shouldn't have to call next_txq(). It should be as below.
Anyway drv_wake_tx_queue is just an indication to driver and
driver will always dequeue first node from list.

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 2dbfd1d8eb5f..74ac0b19cd54 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -242,7 +242,7 @@ EXPORT_SYMBOL(ieee80211_ctstoself_duration);

  static void __ieee80211_kick_airtime(struct ieee80211_local *local, int 
ac)
  {
-       struct ieee80211_txq *txq;
+       struct ieee80211_txq *txq = NULL;
         bool seen_eligible = false;
         struct txq_info *txqi;
         struct sta_info *sta;
@@ -263,6 +263,7 @@ static void __ieee80211_kick_airtime(struct 
ieee80211_local *local, int ac)
                 if (sta->airtime[ac].deficit >= 0) {
                         seen_eligible = true;
                         clear_bit(IEEE80211_TXQ_AIRTIME_THROTTLE, 
&txqi->flags);
+                       txq = &txqi->txq;
                 }
         }

@@ -283,7 +284,6 @@ static void __ieee80211_kick_airtime(struct 
ieee80211_local *local, int ac)
         }
   out:
         rcu_read_unlock();
-       txq = ieee80211_next_txq(&local->hw, ac);
         spin_unlock_bh(&local->active_txq_lock[ac]);

-Rajkumar
