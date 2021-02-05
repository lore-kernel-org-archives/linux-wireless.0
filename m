Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF77C433DB
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Feb 2021 22:49:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D58264FFB
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Feb 2021 22:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbhBEWsr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Feb 2021 17:48:47 -0500
Received: from mail.toke.dk ([45.145.95.4]:51631 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhBENaZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Feb 2021 08:30:25 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1612531761; bh=dmsbQlJ0XheT/EofpoyzXPiARJ/fSUNhNxNGar8huVs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Oaiu280JaBF6yYQgA0lDT/mkVsk7l59DQGSfIV2yss0+9ccBduhvodiSKWTEI764f
         h2hyss/+dpbNwM9scbmxpAq+HrHEcvQMszRynTXCONz7JUx57eOMGTB7hRe6fVFJND
         WKB8dT51ZlcyP1HXCx7S3WqxZRx/6tiGtDUX9dEIXSuvM3E+43418KJQ4S6SGEe2in
         G6UTxKTfIj6LszNqmikdE31QXNzWf7pb2cFrAsao7iRMQU8xZ783RVErRCU8s8QlF7
         +t4hx0LNu+7/CLlivdmLe65U/wjc/6dXUODpDFpG/c+WSkeqbvLx0kEp99X3+TnWIP
         CDhgAHjRbQ5rQ==
To:     Ryder Lee <ryder.lee@mediatek.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Ryder Lee <ryder.lee@mediatek.com>
Subject: Re: [PATCH] mac80211: only schedule TXQ when reasonable airtime
 reporting
In-Reply-To: <c48c3555ab2261d6b6674ac7de8203359b80b127.1612529311.git.ryder.lee@mediatek.com>
References: <c48c3555ab2261d6b6674ac7de8203359b80b127.1612529311.git.ryder.lee@mediatek.com>
Date:   Fri, 05 Feb 2021 14:29:19 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <878s82ve1c.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ryder Lee <ryder.lee@mediatek.com> writes:

> For some drivers and hardware may report faulty airtime, which ends up
> with excessive hold time (~0.9s on mt7915 multiclent tests) impacting
> system performance.
>
> Although issue has been fixed in driver, but it make sense to select txqi
> depends on a reasonable airtime reporting to prevent such a case from
> happening again.

I think I see what you're trying to do with the patch, but this commit
message makes no sense. What, exactly, was the error you were seeing
that this is supposed to fix?

> Tested-by: Jiao Bo <jiao.bao@mediatek.com>
> Tested-by: Sujuan Chen <sujuan.chen@mediatek.com>
> Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
> ---
>  net/mac80211/tx.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 6422da6690f7..0b8a8c3600f4 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -3770,6 +3770,10 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 ac)
>  				sta->airtime_weight;
>  
>  		if (deficit < 0 || !aql_check) {
> +			if (txqi->schedule_round == local->schedule_round[ac])
> +				goto out;
> +
> +			txqi->schedule_round = local->schedule_round[ac];

I think this change may be worth making anyway, but for a different
reason: Without it, a station that fails aql_check will keep getting
recycled through the list, advancing its deficit. Which could actually
be the reason AQL breaks airtime fairness; did you observe any
difference in fairness with this change?

-Toke
