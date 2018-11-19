Return-Path: <SRS0=j5ME=N6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E0AC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 23:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 159F02080C
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 23:02:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="WP8lfD14"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 159F02080C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731513AbeKTJ2t (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Nov 2018 04:28:49 -0500
Received: from mail.toke.dk ([52.28.52.200]:46957 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731164AbeKTJ2t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Nov 2018 04:28:49 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1542668571; bh=r0zkPtNh1fdkyLfxhd6PdDI3vCgInr/zZWfL+E2RVN0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=WP8lfD1424sd4hOC5gofgjso1gd1YdxfLwxLHAZ6iBAPjZ/Xx2RoNlBMGhjNTFp/Q
         YLg+skMX3hZGmDh3nvDTeZ7ppUrZ+CjSXp/2sRmsnTl1ZPkOH470lxJx6eIeyTxQdy
         SOJlwL2SohtfMufUGxxxBb85/9blCGdxFPF3vohh6SfsdD5HUYkuRItwJQB33m6Afw
         P3CvaTC66J0OljbDH6b4PF+cob/ZHX1jUyjrJ3zDmRfT0JTtAI6In01pVbKz8E1mqC
         SGiCDz9Z1RaNbSVzFWrk7Hiu0QhEwk/NC5EvveKw8IE9/K4mWIAqu3d0EEpaIvn0bV
         1vJxTNWJbx9mw==
To:     Felix Fietkau <nbd@nbd.name>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     make-wifi-fast@lists.bufferbloat.net
Subject: Re: [PATCH v3 3/6] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <8e7847ff-4c88-10ae-2223-2fc7321641d9@nbd.name>
References: <1542063113-22438-1-git-send-email-rmanohar@codeaurora.org> <1542063113-22438-4-git-send-email-rmanohar@codeaurora.org> <e5344cad-2a18-a938-f2ed-43870027251c@nbd.name> <871s7nv9pl.fsf@toke.dk> <8e7847ff-4c88-10ae-2223-2fc7321641d9@nbd.name>
Date:   Mon, 19 Nov 2018 15:02:50 -0800
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87k1l8smat.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Felix

Thinking a bit more about this, I think that rather than having the
driver work around the API as in your example...

> do {
> 	struct ieee80211_txq *pending_txq[4];
> 	int n_pending_txq = 0;
> 	int i;
>
> 	if (hwq->pending < 4)
> 		break;p
>
> 	nframes = 0;
>
> 	ieee80211_txq_schedule_start(hw, ac)
> 	do {
> 		bool requeue = false;
>
> 		struct ieee80211_txq *txq;
>
> 		txq = ieee80211_next_txq(hw, ac);
> 		if (!txq)
> 			break;
>
> 		nframes += schedule_txq(txq, &requeue);
> 		if (requeue)
> 			pending_txq[n_pending_txq++] = txq;
>
> 	} while (n_pending_txq < ARRAY_SIZE(pending_txq));
>
> 	for (i = n_pending_txq; i > 0; i--)
> 		ieee80211_return_txq(hw, pending_txq[i - 1]);
>
> 	ieee80211_txq_schedule_end(hw, ac)
> } while (nframes);

... really what we want is that the driver can just do this:

ieee80211_txq_schedule_start(hw, ac);
while ((txq = ieee80211_next_txq(hw, ac)) {
	schedule_txq(txq, &requeue);
        return_txq(txq);
}
ieee80211_txq_schedule_end(hw, ac);

and expect so get through all eligible TXQs. Note that there will be
cases where there is only a single eligible TXQ (such as the example I
gave in the other email); in which case the current version is fine. But
there is (probably) also going to be cases where more than one TXQ is
eligible at the same time, which we cannot handle with the current RR
scheduler.

However, I think that assuming we can get the scheduler to guarantee
that it will return all eligible TXQs between each pair of calls to
schedule_start()/schedule_end(), we should be fine with the current API.
Do you agree with this?

-Toke
