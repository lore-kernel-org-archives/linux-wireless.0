Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9928C43143
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 08:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE45120645
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 08:22:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="FRKkOP2v"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE45120645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbeJBPEP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 11:04:15 -0400
Received: from mail.toke.dk ([52.28.52.200]:51371 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727011AbeJBPEP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 11:04:15 -0400
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1538468530; bh=/A4+Fi3ZLHFavVvxaWqWsn3IsREVLA1BldRM2ZWYomg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=FRKkOP2v8Og8Hei/CAED0X74PlLS7VNlTrdDTO+N6y6rLu4Y29ppGZa0t5x/nuZeg
         UEl06kx6I/nDkonAo/Vu6mxj5JAuP7pqle9gvcIaluScTHFdyF1ZCtaXo7wDCZ52lg
         ZTJFFmCkyef9BjQPbXA6rOVyXXnkEhvvUz3KNmEHvTmDsVevJivdgU+WGt7OhcWNGW
         t9lcN7pMfIH5fpUnhLqQp8+yj+VYe895wuhYb9JAAqOtF4eLNmNP2nT23mFHZnsVNa
         g84yD/Y+8JO6AE0HJOhSzU2Zxdtk0hf1YrNut1fZ8ez3cCoXkhEo2F3Qt+XDlTpIFB
         oxXKoJOmpgqYQ==
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     Jonathan Morton <chromatix99@gmail.com>, Kan Yan <kyan@google.com>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless-owner@vger.kernel.org,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [Make-wifi-fast] [PATCH RFC v4 3/4] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <0531def170ef7f9cadcf85a6dc9af22b@codeaurora.org>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1> <153711973134.9231.18038849900399644494.stgit@alrua-x1.karlstad.toke.dk> <826b6251746ee4d280d532f4ecdc5aa3@codeaurora.org> <87pnx0haud.fsf@toke.dk> <8f7145bf5abe50194bced025a5e739b9@codeaurora.org> <863bc54fbf04441d38dd53f523300a7e@codeaurora.org> <93015743-5D16-4D79-948F-E2F46CF2450A@toke.dk> <7ba8513b0ec5a7c35b396c7739fc2d7d@codeaurora.org> <87zhw2eyfo.fsf@toke.dk> <5d961a5f61de45b85b1b037bcef9270d@codeaurora.org> <44B09168-C08F-4C85-8D74-D576CCC79880@gmail.com> <586459da6ec36edc2284df8533915d62@codeaurora.org> <4929C006-3452-4C17-9500-8D7485EB538E@toke.dk> <0531def170ef7f9cadcf85a6dc9af22b@codeaurora.org>
Date:   Tue, 02 Oct 2018 10:22:09 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87a7nwbvwu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

>> Great! I'll fold in the rest, test it with ath9k and submit as a proper 
>> patch :)
>> 
> Toke,
>
> I noticed a race condition b/w sta cleanup and kick_airtime tasklet.
> How do you plan to exit kick_airtime gracefully during sta_cleanup?

Ah, right, there's a lot of stuff going on before we get to purge_txq.
Hmm, I guess we should either make sure we remove the station from
active_txqs earlier in the sta cleanup process, or maybe it'd enough to
just check the removed flag in the tasklet?

Does the below patch fix the issue?

-Toke


diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 9c889da48ef0..8fa3c09d041c 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -258,6 +258,9 @@ static void __ieee80211_kick_airtime(struct ieee80211_local *local, int ac)
 
 		sta = container_of(txqi->txq.sta, struct sta_info, sta);
 
+		if (sta->removed)
+			continue;
+
 		if (sta->airtime[ac].deficit >= 0) {
 			seen_eligible = true;
 
