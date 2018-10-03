Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3338DC00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 05:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB57D20835
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 05:53:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ArmfWRm/";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SV3PknZe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB57D20835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbeJCMkZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 08:40:25 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49364 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbeJCMkZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 08:40:25 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0FA1460C62; Wed,  3 Oct 2018 05:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538546013;
        bh=1gr5jzRw/Rd52gKtX4McqF7VxE2Fj5DJswvM3H99odc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ArmfWRm/9SQEWioCKoS6uEA1owbNTG3Ta0qEZ7lnu28cQwz3me0jIIowZwEUB8PLk
         LFmcweTplBUQ8vbShYbZs5aeYVAK73wHcpfh1b15ZXyDigcR2XbY1U6Dn0XsWq5w+x
         f8+qAvKSzYeBshr/QEsA/PN6D2J/3HgQ+96tjMFo=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 3ED4160C4B;
        Wed,  3 Oct 2018 05:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538546012;
        bh=1gr5jzRw/Rd52gKtX4McqF7VxE2Fj5DJswvM3H99odc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SV3PknZeB+6PHZ7TGO8r1mayRCsVLJiK3IKbKE7H1P7az6N8Tyo05Hrr4BmqmBy2S
         KwaYLLSJs/eOVLfI8muv0cKtbWfOYWLaPVNJnMJ74L6++Gljk7eeSvLgmGpSM125bN
         ReJuWMwhSwJaYT/2M3MJRTcXGOK4xwLvLYV9GF9M=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 02 Oct 2018 22:53:32 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Jonathan Morton <chromatix99@gmail.com>, Kan Yan <kyan@google.com>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless-owner@vger.kernel.org,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [Make-wifi-fast] [PATCH RFC v4 3/4] mac80211: Add airtime
 accounting and scheduling to TXQs
In-Reply-To: <30cf3754fa970aa1af11791c2625a7c9@codeaurora.org>
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
Message-ID: <08dabe69e625c11f70b217ae9695c7f4@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-02 16:07, Rajkumar Manoharan wrote:
> On 2018-10-02 12:00, Toke Høiland-Jørgensen wrote:
>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>> I noticed a race condition b/w sta cleanup and kick_airtime tasklet.
>>>>> How do you plan to exit kick_airtime gracefully during sta_cleanup?
>>>> 
>>>> Ah, right, there's a lot of stuff going on before we get to 
>>>> purge_txq.
>>>> Hmm, I guess we should either make sure we remove the station from
>>>> active_txqs earlier in the sta cleanup process, or maybe it'd enough 
>>>> to
>>>> just check the removed flag in the tasklet?
>>>> 
>>>> Does the below patch fix the issue?
>>>> 
>>> 
>>> No. Attaching backtrace. Any clue?
>> 
>> Ah, that's my bad. Just having a 'continue' there can make the 
>> function
>> loop forever. Oops. Try something like this instead?
>> 
> 
> But 'continue' also used in other places. Will give a try but I think 
> that
> calling drv_wake_tx_queue within iteration is dangerous as it alters
> the list. no?
> 
How about below change? Just schedule first txq and remaining will be
scheduled later by driver upon tx-compl.

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 0bb590928dd0..2dbfd1d8eb5f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -242,6 +242,7 @@ EXPORT_SYMBOL(ieee80211_ctstoself_duration);

  static void __ieee80211_kick_airtime(struct ieee80211_local *local, int 
ac)
  {
+       struct ieee80211_txq *txq;
         bool seen_eligible = false;
         struct txq_info *txqi;
         struct sta_info *sta;
@@ -261,14 +262,7 @@ static void __ieee80211_kick_airtime(struct 
ieee80211_local *local, int ac)

                 if (sta->airtime[ac].deficit >= 0) {
                         seen_eligible = true;
-
-                       if 
(!test_and_clear_bit(IEEE80211_TXQ_AIRTIME_THROTTLE,
-                                               &txqi->flags))
-                               continue;
-
-                       spin_unlock_bh(&local->active_txq_lock[ac]);
-                       drv_wake_tx_queue(local, txqi);
-                       spin_lock_bh(&local->active_txq_lock[ac]);
+                       clear_bit(IEEE80211_TXQ_AIRTIME_THROTTLE, 
&txqi->flags);
                 }
         }

@@ -289,8 +283,10 @@ static void __ieee80211_kick_airtime(struct 
ieee80211_local *local, int ac)
         }
   out:
         rcu_read_unlock();
+       txq = ieee80211_next_txq(&local->hw, ac);
         spin_unlock_bh(&local->active_txq_lock[ac]);
-
+       if (txq)
+               drv_wake_tx_queue(local, to_txq_info(txq));
  }

-Rajkumar
