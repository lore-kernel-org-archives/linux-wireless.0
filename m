Return-Path: <SRS0=e8Py=RI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEBB0C43381
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Mar 2019 15:45:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C849A20684
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Mar 2019 15:45:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbfCEPpv convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Mar 2019 10:45:51 -0500
Received: from mail-ed1-f43.google.com ([209.85.208.43]:35401 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728590AbfCEPpu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Mar 2019 10:45:50 -0500
Received: by mail-ed1-f43.google.com with SMTP id g19so7624517edp.2
        for <linux-wireless@vger.kernel.org>; Tue, 05 Mar 2019 07:45:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=rxj+mSh+wWBLvZbSVbS2ycCqaXjf5XQapmLLhn9oNTQ=;
        b=BtruA1gBvzY+bwq4d8NygabznpTRbwah/L2oSKIxZnICBRI9FUtHxpeVruHdTScNWI
         5revreWALdlbSt0zzl20l/e5Do+uo138g9d4EvfRZK/5sSd/UkRNL1ukhvDjipeTr16y
         myywEGIDgPBscAD4rFe62c+SK33YPgVlsNg37seeVMNVWClry5LTXBDaO8ngcL45Ce5q
         4alYK2QbQpQC0TWCkbvYlebsF8nBndRZoDinLGhn6aV1EsrIz7v7fXIsIH4SMd0YuJA7
         29ALcvPuv2T7a2lHjPAAw3gJ8LidMX6zgBTx2a4g9Jj4fc6e158UoRf2aDPbWsG+Lr+j
         QuTQ==
X-Gm-Message-State: APjAAAXTqK+7HcOxfGmNvBCcKwCr7s4lM1dqXFGFC5k4Yv1D4/b0CJw4
        yz6pBDucS7NXLis+QJu1lRNO+g==
X-Google-Smtp-Source: APXvYqytgs6Ajs2s0x0Q/WS1LAVHHs16rTlbXSA7hos38jXNuJkoRRDz/Wot08VO0csTRyV7jaNQaA==
X-Received: by 2002:a05:6402:1495:: with SMTP id e21mr19772510edv.52.1551800749364;
        Tue, 05 Mar 2019 07:45:49 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.vpn.toke.dk. [2a00:7660:6da:10::2])
        by smtp.gmail.com with ESMTPSA id i20sm1474686ejv.26.2019.03.05.07.45.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Mar 2019 07:45:48 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3F5C4182F35; Tue,  5 Mar 2019 16:45:48 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Kan Yan <kyan@google.com>
Subject: Re: [RFC/RFT] mac80211: Switch to a virtual time-based airtime scheduler
In-Reply-To: <20190215170512.31512-1-toke@redhat.com>
References: <20190215170512.31512-1-toke@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 05 Mar 2019 16:45:48 +0100
Message-ID: <87va0x1g0j.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Toke Høiland-Jørgensen <toke@redhat.com> writes:

> This switches the airtime scheduler in mac80211 to use a virtual time-based
> scheduler instead of the round-robin scheduler used before. This has a
> couple of advantages:
>
> - No need to sync up the round-robin scheduler in firmware/hardware with
>   the round-robin airtime scheduler.
>
> - If several stations are eligible for transmission we can schedule both of
>   them; no need to hard-block the scheduling rotation until the head of the
>   queue has used up its quantum.
>
> - The check of whether a station is eligible for transmission becomes
>   simpler (in ieee80211_txq_may_transmit()).
>
> The drawback is that scheduling becomes slightly more expensive, as we need
> to maintain an rbtree of TXQs sorted by virtual time. This means that
> ieee80211_register_airtime() becomes O(logN) in the number of currently
> scheduled TXQs. However, hopefully this number rarely grows too big (it's
> only TXQs currently backlogged, not all associated stations), so it
> shouldn't be too big of an issue.
>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
> This is basically the idea I mentioned earlier for a different way to
> handle the airtime scheduling.
>
> I've tested it on ath9k, where it achieves the same fairness and
> weighing properties as the old scheduler. It would be good if you could
> test it on your ath10k setup, Rajkumar; and all of you please comment on
> whether you agree that this is better from an API point of view.

So no one has any comments on this? :)

-Toke
