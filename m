Return-Path: <SRS0=49bh=RV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 557CDC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 22:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C7662171F
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 22:21:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfCRWVa convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Mar 2019 18:21:30 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37828 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfCRWVa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Mar 2019 18:21:30 -0400
Received: by mail-ed1-f65.google.com with SMTP id m12so14919622edv.4
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2019 15:21:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=3zdcdakfT5x8PElj0wofgv6B62rBrTdPpndtlVW8tBc=;
        b=EKXi6WXyJ83Fmz35sUSxGDDvY/bpPlTWhAWjhzlWqdhiDT5Ct7oeKIjLdHLrdzKlLS
         pxrMwolowhK6o4muIWs4xHJXZ1XXWYXMNeBmTgWZZGkO1GevkDVQCrOe6XuWDn6cjkTj
         lYEiBbz5mMBBT5COuY8ZHIhiMx+YJcVGjMxdXPHsFZ2NY+PVvuVy55tv5znQloY3nDpz
         R3QE1A4521pBmYAj8lZTxgwoW7Wn52kxhe2Rp/+5rfS6F9kK/XLz2rZVIiNGTvgFl+5C
         KRaJEGjka02mQexVcrTrpX575Ipvk33ptFcLxFVXIEqpFK1QSs3B1aZCV424WXSTPutu
         hQNg==
X-Gm-Message-State: APjAAAUfOuNW8O6Z6c64CQDYn2/wcfcUYPW+Rs1FLvFS5/UhJEZx3Q+v
        xcy/KFl0e2MzKX1h+agmKbUtbp9kOiI=
X-Google-Smtp-Source: APXvYqyPni3AwDcq41NMTNSuQOrs5g4ukMwAo6efj5JvMHyTgzvaU8gjqh42Eq3FvT4vjPh5Rz3RVQ==
X-Received: by 2002:a50:cb49:: with SMTP id h9mr14188601edi.197.1552947688834;
        Mon, 18 Mar 2019 15:21:28 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id c6sm3657038edw.33.2019.03.18.15.21.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 18 Mar 2019 15:21:28 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AD9411804A4; Mon, 18 Mar 2019 23:14:28 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/6] mt76: use mac80211 txq scheduling
In-Reply-To: <111434f9-f04c-2fe2-c2b4-de757efc884c@nbd.name>
References: <20190316204242.73560-1-nbd@nbd.name> <87muluv4hd.fsf@toke.dk> <7b9a0a24-14b0-9b96-0010-ce9f96308ad0@nbd.name> <875zshviqg.fsf@toke.dk> <2cc1f1d4-f07e-faa0-ede7-95dd2917a64a@nbd.name> <87r2b5tb6a.fsf@toke.dk> <111434f9-f04c-2fe2-c2b4-de757efc884c@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 18 Mar 2019 23:14:28 +0100
Message-ID: <87sgvjsud7.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> On 2019-03-17 22:59, Toke Høiland-Jørgensen wrote:
>> Felix Fietkau <nbd@nbd.name> writes:
>>> I've looked at ath9k (the only user at the moment), and it seems to call
>>> the function in that way already: at PS wake or tx status time if it has
>>> frames in its internal retry queue.
>>> While it does not match the current documented behavior for that
>>> function, it nicely fits ath9k's currently unfulfilled expectations ;)
>> 
>> Heh, fair point :)
> I noticed another issue: after the migration to the mac80211 txq
> scheduling code, ath9k does not handle stations going to powersave
> properly anymore. mac80211 keeps returning txqs for stations that have
> gone to sleep and ath9k will send out frames for them.

Ah, right. Never did have a good grip on the powersave code...

> We could deal with this in the driver and simply not return queues for
> stations in PS mode, or mac80211 could actively cancel them once a
> station enters PS mode. What do you prefer?

I think the cleanest would be if mac80211 handled it and just
un-scheduled stations when they go to sleep.

BTW, I was just thinking the other day about why the retry queue is kept
around when a station goes to sleep? Isn't the station usually sleeping
pretty long (>100 ms), where it might make more sense to drop things
rather than try again once i comes back?

-Toke
