Return-Path: <SRS0=49bh=RV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A164C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 23:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5157A2171F
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 23:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfCRXF0 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Mar 2019 19:05:26 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35464 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbfCRXF0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Mar 2019 19:05:26 -0400
Received: by mail-ed1-f67.google.com with SMTP id d6so14418188eds.2
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2019 16:05:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=h9HkbMxy54/9xUHwokT6pYihjJmC9lOksvnTNkh9nKw=;
        b=qVoXXXxkdmADcL2EvQESmgf+S4bIKmOSG/jFaIKXa3EqB8uhpnp7i+zUNUzOgPUzC9
         NgSTC5zVOP64xfUUGtkcKVg3/3rzfIFUMcCaL2OCVWChJm8HBzr9JpDGitJQ/d9gJi8V
         P79HZbSrb9Em3bDkbqJXo0H3xk5yauydWYGKMsZr/lJ8ZMNSCcM/Or1krC/kzWV85fMX
         uw46iPLljC8+CRHmDGAc9fWhdBjt1oD7w/x783h8xKpU7gjW+jzReDNP16mKyKbITGDy
         twjgIoxJzA79JsCCvW+pHw7Uo5hRe3DCKKn4FSWY9VxbIjL7yAGCbIbozmWTDccH6j31
         uYRw==
X-Gm-Message-State: APjAAAXfpCxCHM0c4WAog+nykBTijRVyOaEvV2UkwegIfbVAUF1+4Ttw
        XgZHhLvgomW9pia3nKlkqFWT9Q==
X-Google-Smtp-Source: APXvYqxoc8IiteoGg3z/to/OEsdd3tpUoexbRYNtgZ2vgaYKfMJIvJSvKwDQUGeE72Wn8hKMyVA+4A==
X-Received: by 2002:a50:cccc:: with SMTP id b12mr2045517edj.94.1552950324582;
        Mon, 18 Mar 2019 16:05:24 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.vpn.toke.dk. [2a00:7660:6da:10::2])
        by smtp.gmail.com with ESMTPSA id 50sm2350328edz.73.2019.03.18.16.05.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 18 Mar 2019 16:05:23 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EB3601804A4; Tue, 19 Mar 2019 00:05:21 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/6] mt76: use mac80211 txq scheduling
In-Reply-To: <d3bc4ad2-d4b7-d95d-dd49-105297653713@nbd.name>
References: <20190316204242.73560-1-nbd@nbd.name> <87muluv4hd.fsf@toke.dk> <7b9a0a24-14b0-9b96-0010-ce9f96308ad0@nbd.name> <875zshviqg.fsf@toke.dk> <2cc1f1d4-f07e-faa0-ede7-95dd2917a64a@nbd.name> <87r2b5tb6a.fsf@toke.dk> <111434f9-f04c-2fe2-c2b4-de757efc884c@nbd.name> <87sgvjsud7.fsf@toke.dk> <d3bc4ad2-d4b7-d95d-dd49-105297653713@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 19 Mar 2019 00:05:21 +0100
Message-ID: <87pnqnss0e.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> On 2019-03-18 23:14, Toke Høiland-Jørgensen wrote:
>> Felix Fietkau <nbd@nbd.name> writes:
>> 
>>> On 2019-03-17 22:59, Toke Høiland-Jørgensen wrote:
>>>> Felix Fietkau <nbd@nbd.name> writes:
>>>>> I've looked at ath9k (the only user at the moment), and it seems to call
>>>>> the function in that way already: at PS wake or tx status time if it has
>>>>> frames in its internal retry queue.
>>>>> While it does not match the current documented behavior for that
>>>>> function, it nicely fits ath9k's currently unfulfilled expectations ;)
>>>> 
>>>> Heh, fair point :)
>>> I noticed another issue: after the migration to the mac80211 txq
>>> scheduling code, ath9k does not handle stations going to powersave
>>> properly anymore. mac80211 keeps returning txqs for stations that have
>>> gone to sleep and ath9k will send out frames for them.
>> 
>> Ah, right. Never did have a good grip on the powersave code...
>> 
>>> We could deal with this in the driver and simply not return queues for
>>> stations in PS mode, or mac80211 could actively cancel them once a
>>> station enters PS mode. What do you prefer?
>> 
>> I think the cleanest would be if mac80211 handled it and just
>> un-scheduled stations when they go to sleep.
> I agree. I'll send a patch tomorrow.

Cool, thanks! :)

>> BTW, I was just thinking the other day about why the retry queue is kept
>> around when a station goes to sleep? Isn't the station usually sleeping
>> pretty long (>100 ms), where it might make more sense to drop things
>> rather than try again once i comes back?
> It doesn't always sleep long. It might just be background scanning.
> There's no way for the AP to know in advance.
> In any case, the A-MPDU receiver reorder window still needs to be
> maintained, so dropping frames means we'd have to send a BAR frame to
> notify the receiver, which costs airtime as well.

Right, makes sense; thanks for the explanation.

-Toke
