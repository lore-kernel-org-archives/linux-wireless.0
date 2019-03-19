Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B3ECC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 22:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D29D62175B
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 22:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfCSWPc convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 18:15:32 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:46427 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbfCSWPc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 18:15:32 -0400
Received: by mail-ed1-f65.google.com with SMTP id d1so237684edd.13
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2019 15:15:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=kziuXU0Z45Y0ipJyuk3/G5QWYSbbgOjzmOZBEkWXnJc=;
        b=ObEdHdnroGjwYuMYjVDy1FKArp4yO7QaDL3+0jYm4YWTghDOmH3qwsVWHUA+7lE7bG
         n8o9V2Iu2gDyUUV4MTjtXSCxxeyatXoL0mAE9SgPkDJFd5cmJbQyjIclCIm0neCAZvDx
         nW8e3Oy/429u23UiJMEseKM3cjCBidLY3MYV6FhBO7VfQ4/Sx5ZdxaZEM24VZ89cPotc
         BwYEIUThKVAs3FRshNf3d7khgwlZTfF3FIOgcIAloehARV5XQMWfh7CGRVvp6W2fd9CJ
         4TCxcbrIoGMLh5MVKXxdpeTXdRNPHZYJjoydxwEWTdE2gZjc1br2XZTbsexoepr1maQZ
         SnKg==
X-Gm-Message-State: APjAAAXQGt/76JVbzppATDXxbg8vRu/Q41zXACtZtA76fyJh+FCHJQDz
        FlMH3EBOSJ8lfmpswt4zX/53Ew==
X-Google-Smtp-Source: APXvYqxz6tGpz3EPoQVSS5XnwrYgoJeeAQhqNVFvVGFBHoO2cAOSjomD/EgzFZwsOrfQhnv3Asp9oA==
X-Received: by 2002:aa7:c1ce:: with SMTP id d14mr18209909edp.50.1553033730984;
        Tue, 19 Mar 2019 15:15:30 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id k32sm65744ede.97.2019.03.19.15.15.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Mar 2019 15:15:29 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BE5861804A4; Tue, 19 Mar 2019 23:15:28 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: Re: [PATCH v2] mac80211: un-schedule TXQs on powersave start
In-Reply-To: <20190319110013.45228-1-nbd@nbd.name>
References: <20190319110013.45228-1-nbd@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 19 Mar 2019 23:15:28 +0100
Message-ID: <871s32se7z.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> Once a station enters powersave, its queues should not be returned by
> ieee80211_next_txq() anymore. They will be re-scheduled again after the
> station has woken up again
>
> Fixes: 1866760096bf4 ("mac80211: Add TXQ scheduling API")
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>

> ---
>  net/mac80211/rx.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 295535b75184..60aac91e35d0 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1568,7 +1568,15 @@ static void sta_ps_start(struct sta_info *sta)
>  		return;
>  
>  	for (tid = 0; tid < IEEE80211_NUM_TIDS; tid++) {
> -		if (txq_has_queue(sta->sta.txq[tid]))
> +		struct ieee80211_txq *txq = sta->sta.txq[tid];
> +		struct txq_info *txqi = to_txq_info(txq);
> +
> +		spin_lock(&local->active_txq_lock[txq->ac]);
> +		if (!list_empty(&txqi->schedule_order))
> +			list_del_init(&txqi->schedule_order);
> +		spin_unlock(&local->active_txq_lock[txq->ac]);
> +
> +		if (txq_has_queue(txq))
>  			set_bit(tid, &sta->txq_buffered_tids);
>  		else
>  			clear_bit(tid, &sta->txq_buffered_tids);
> -- 
> 2.17.0
