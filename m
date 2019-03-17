Return-Path: <SRS0=pME5=RU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B90C43381
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Mar 2019 22:00:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 202762087C
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Mar 2019 22:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfCQWAe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 17 Mar 2019 18:00:34 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33765 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727173AbfCQWAe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Mar 2019 18:00:34 -0400
Received: by mail-ed1-f67.google.com with SMTP id q3so5244866edg.0
        for <linux-wireless@vger.kernel.org>; Sun, 17 Mar 2019 15:00:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=zxBpDT5c+1S4wQ9e/zXNg1CoGxrLZ9nruOX6xCe8kFc=;
        b=ltyWHL0jZeKbkR+S6/EnHLXPiqKDu9tUt8BzpqGQj5qOcwqbJ8Dc4TOht8dwI9HElX
         KuErvpOPyKR/7WpNyiG697uYO/JpHiy8FmsXOxpX9F4pmSqCnYMz95/9TYaVjaHSi4kR
         sslYIOgAyy88msxZDT81rSdQsRM1BJ16L0EDPVClQb0AqseHr8GbU21+PLtnokgCQLAS
         XBy0EodDyimDkqItB4qqYLoWYet30ayCVnLHC1eskLGLJZ9SNmMwxtmoO8VPdF8D9Snu
         W5jSj2fuAHPM/0iIxqv0GeeQ5D/a6kViJHngTv4yb9z82QZeTEpixUHWd79G5wdrE7mD
         TVYA==
X-Gm-Message-State: APjAAAWV3CEJaLiZmydnYGNHYYRokW3U0vGDfXRyBFQ3tlYlUS77AOBn
        CIf1hol9IAscyW0nOpVX+HyFeQrh7bU=
X-Google-Smtp-Source: APXvYqyAyvpYU4ZDApl63ZZ+3+u2Y/6JZnbrTT+uD8NiqJQsg8LijKCW7dQcgOpvwPmFRdqRaXGD4w==
X-Received: by 2002:a50:cc48:: with SMTP id n8mr10634507edi.66.1552860032909;
        Sun, 17 Mar 2019 15:00:32 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id h22sm2019193ejj.43.2019.03.17.15.00.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 17 Mar 2019 15:00:32 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 77F03182010; Sun, 17 Mar 2019 23:00:30 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: Re: [PATCH v2] mac80211: make ieee80211_schedule_txq schedule empty TXQs
In-Reply-To: <20190317170251.71185-1-nbd@nbd.name>
References: <20190317170251.71185-1-nbd@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 17 Mar 2019 23:00:30 +0100
Message-ID: <87o969tb41.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> Currently there is no way for the driver to signal to mac80211 that it should
> schedule a TXQ even if there are no packets on the mac80211 part of that queue.
> This is problematic if the driver has an internal retry queue to deal with
> software A-MPDU retry.
>
> This patch changes the behavior of ieee80211_schedule_txq to always schedule
> the queue, as its only user (ath9k) seems to expect such behavior already:
> it calls this function on tx status and on powersave wakeup whenever its
> internal retry queue is not empty
>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  include/net/mac80211.h | 17 ++++++++++++++---
>  net/mac80211/tx.c      | 10 ++++++----
>  2 files changed, 20 insertions(+), 7 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 0de0aba580eb..630941e5a20e 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -6291,15 +6291,26 @@ static inline void ieee80211_txq_schedule_end(struct ieee80211_hw *hw, u8 ac)
>  {
>  }
>  
> +void __ieee80211_schedule_txq(struct ieee80211_hw *hw,
> +			      struct ieee80211_txq *txq, bool force);
> +

So are you planning to also change return_txq() to take the 'force'
argument and wrap __ieee80211_schedule_txq()? Since that was the context
we originally started discussing this :)

-Toke
