Return-Path: <SRS0=49bh=RV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75266C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 11:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 434152084F
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 11:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfCRLRz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Mar 2019 07:17:55 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41317 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbfCRLRz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Mar 2019 07:17:55 -0400
Received: by mail-ed1-f68.google.com with SMTP id a25so5922290edc.8
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2019 04:17:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=RaoGTWd7DCC2yWCTHanOHfNSTBnCr0hbHt12kwDeiR4=;
        b=qka8a3e0SwP5Tz5Zx/F801O4W94GKpYB+Y6szh3vK2PA9ERrDE7awNkIu7QoIzml9t
         S4p0SHp60aIdkfxH0XI9BhWH/ExsTbL8r4GQZgZ7mwNUvoRBIOVaBCrLSAiXNaKplx0W
         oPg1VihB6q6TGe5YPP2xTvXp0RSB+S81hMB64orY/23iaGofa67Z0pJrgCTFpV7EbZcU
         PwKN46i8YXUv+uVHV/EwMTCaH3h9+YRJrwzyexxVHjq87VnsTYd8Vry/MCkmI9BSKt1X
         u2/YIJmvy6oSFcktStgNbUO0aIZNrZzoj3NElN9HywX6PPQNp1AjqosCAOG/9HR3xFS3
         63lg==
X-Gm-Message-State: APjAAAUK/ijQ/552sBqoFCQPnz9NIRbP/4eqey8Mc2BorTVJwyFKU/NG
        +KbHgOf3m8laIyzbzIyj3Ut5xHFRn+g=
X-Google-Smtp-Source: APXvYqx6RB0kdlmjpN9juZBfgV9ny3YVWwBE2itA7fmj+zZmJ8KRIjYLcHRrTdds8brnJxQR77lAzg==
X-Received: by 2002:aa7:c707:: with SMTP id i7mr13025850edq.260.1552907873641;
        Mon, 18 Mar 2019 04:17:53 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id t33sm3385087edd.55.2019.03.18.04.17.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 18 Mar 2019 04:17:53 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EBBE01804A4; Mon, 18 Mar 2019 12:17:51 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: Re: [PATCH v3] mac80211: make ieee80211_schedule_txq schedule empty TXQs
In-Reply-To: <20190318110058.73586-1-nbd@nbd.name>
References: <20190318110058.73586-1-nbd@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 18 Mar 2019 12:17:51 +0100
Message-ID: <871s34tork.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
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
> internal retry queue is not empty.
>
> Also add an extra argument to ieee80211_return_txq to get the same behavior.
>
> This fixes an issue on ath9k where tx queues with packets to retry (and no
> new packets in mac80211) would not get serviced.
>
> Fixes: 89cea7493a346 ("ath9k: Switch to mac80211 TXQ scheduling and airtime APIs")
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
