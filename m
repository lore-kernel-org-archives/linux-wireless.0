Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB78EC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 13:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A322C2186A
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 13:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbfCONEx convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 09:04:53 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44199 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728157AbfCONEx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 09:04:53 -0400
Received: by mail-ed1-f68.google.com with SMTP id x10so4377378edh.11
        for <linux-wireless@vger.kernel.org>; Fri, 15 Mar 2019 06:04:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=LFx2Gwg/AzhO763/02uE+dhDTcL3ORAtS9tEofIl/CY=;
        b=lxwK/s8T3eW3TRyxSC1JYtImGSmffdxLYQnDt1pOiic5f3TcWtUPsK522m/nI26BY6
         pyh730lCGhp+pPp0SF3y2YQ/9Mgp/aCxb5MTaI4DC1OGVrFNoqSc4L3rgm86daBW5qma
         zIFnmycI3bDg2AYNSKDTARo+oUI49emZ5jq0xRtsiVGCcdxHkWsmN7GbCmt5PrltMa58
         VvZtnRxF6HbQlTRLWDKUs6vUpTe9ojNcJkZz4gbLGtMQk32y57+c/Qw/RVPcmVe0Y8vS
         omCXFbKDg4x1fV5hDfg6AZJxl3+nyWq8dGYJHG9AtFmf265/uJQo89902PIa1LHs/wPP
         MQbg==
X-Gm-Message-State: APjAAAUFxtLD5lZw1u0nJ504OYqRVKj1kbcRNFw4cq+X5w48N3EEPzo6
        MZwhCErLXmgoSsdmpFfiIohYjA==
X-Google-Smtp-Source: APXvYqwpMMGSBR/hJddxtl929h3XzWnn4nTtiZ1YHiEvFEYs4bfNEk7GCNyLxTTLxOikm0KLWqLvhA==
X-Received: by 2002:a17:906:54d:: with SMTP id k13mr2181708eja.207.1552655092141;
        Fri, 15 Mar 2019 06:04:52 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id p25sm406943ejb.20.2019.03.15.06.04.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Mar 2019 06:04:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B6E961804A2; Fri, 15 Mar 2019 14:04:49 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: Re: [PATCH] mac80211: rework locking for txq scheduling / airtime fairness
In-Reply-To: <20190315100335.91445-1-nbd@nbd.name>
References: <20190315100335.91445-1-nbd@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 15 Mar 2019 14:04:49 +0100
Message-ID: <87zhpwwaoe.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> Holding the lock around the entire duration of tx scheduling can create
> some nasty lock contention, especially when processing airtime information
> from the tx status or the rx path.
> Improve locking by only holding the active_txq_lock for lookups / scheduling
> list modifications.
>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>

>  include/net/mac80211.h | 49 ++++++++++++++++--------------------------
>  net/mac80211/tx.c      | 44 ++++++++++++++-----------------------
>  2 files changed, 35 insertions(+), 58 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 3771625b7a9d..0de0aba580eb 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h

[ ... ]
> -void ieee80211_txq_schedule_start(struct ieee80211_hw *hw, u8 ac)

> -	__acquires(txq_lock);
> +void ieee80211_txq_schedule_start(struct ieee80211_hw *hw, u8 ac);
> +
> +/* (deprecated) */
> +static inline void ieee80211_txq_schedule_end(struct ieee80211_hw *hw, u8 ac)
> +{
> +}

I figure I'll post a cleanup of this as part of my reworked schedule
change patch; since I'll be messing around with these bits anyway...

-Toke
