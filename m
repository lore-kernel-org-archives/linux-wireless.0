Return-Path: <SRS0=pME5=RU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C526C43381
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Mar 2019 22:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F11F62087C
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Mar 2019 22:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfCQWFs convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 17 Mar 2019 18:05:48 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42904 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfCQWFr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Mar 2019 18:05:47 -0400
Received: by mail-ed1-f68.google.com with SMTP id j89so11886476edb.9
        for <linux-wireless@vger.kernel.org>; Sun, 17 Mar 2019 15:05:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=qkhLc6XSlP+LW0BF+eVNa7dTLKuEdM3TUqsK/GzljTY=;
        b=YqUMHFK0Ffunmu1neHVXnTCEFi+Aj+xok8CG3ES0OTs8yG8kkmDNN4YMHslw+8jv8G
         EnvpKNlrAfExw2vkjHx9V8Xmb42+44/REpOxB+Zony3ev5spMVMnOLPB0areJzcRbBxZ
         l3MDPjXUlPipRvodtAtK4FKSzJgFEfViiLqfg6HUxPOWmHlWx4xBVfffkOTLMaQhLnBD
         MNpgS580WE/WuQT01mv5Y/ZLPzRrvRotExJWuVfMrotu4QQ0QG9omIXrGSCoexBm8oH4
         vsCwEq0+9IIQb/SbFD2zDImoKsgzmPtImhGKNa3QuPNAAuN5Rvtav7bpFgg1ZQlzlOFT
         /9Bw==
X-Gm-Message-State: APjAAAVcT6ulW8WFg30YOJJcO0os4pzMOW8/3TrG+OTK00fs5+zXUqa8
        UAITi96KoHHPJDR8STFzcpI0WA==
X-Google-Smtp-Source: APXvYqyWqyctzvVAXNwlfZipg9yUdt9R1aC4W7Zq/WYYdgSB+uk6F4vCjCflWD+qIfGHSSTuuQfvOg==
X-Received: by 2002:a50:a54b:: with SMTP id z11mr5075911edb.133.1552860345952;
        Sun, 17 Mar 2019 15:05:45 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id a58sm2847362eda.91.2019.03.17.15.05.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 17 Mar 2019 15:05:45 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A06551804A4; Sun, 17 Mar 2019 22:59:09 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/6] mt76: use mac80211 txq scheduling
In-Reply-To: <2cc1f1d4-f07e-faa0-ede7-95dd2917a64a@nbd.name>
References: <20190316204242.73560-1-nbd@nbd.name> <87muluv4hd.fsf@toke.dk> <7b9a0a24-14b0-9b96-0010-ce9f96308ad0@nbd.name> <875zshviqg.fsf@toke.dk> <2cc1f1d4-f07e-faa0-ede7-95dd2917a64a@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 17 Mar 2019 22:59:09 +0100
Message-ID: <87r2b5tb6a.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> On 2019-03-17 12:32, Toke Høiland-Jørgensen wrote:
>> Felix Fietkau <nbd@nbd.name> writes:
>> 
>>> On 2019-03-16 23:28, Toke Høiland-Jørgensen wrote:
>>>> Felix Fietkau <nbd@nbd.name> writes:
>>>> 
>>>>> Performance improvement and preparation for adding airtime fairness
>>>>> support
>>>> 
>>>> Great to see this! Do you have a plan for the airtime fairness part?
>>>> I.e., how to get the airtime information?
>>> Not yet. Still need to investigate what kind of information the hardware
>>> can provide. On a first glance it seems rather limited, so we may have
>>> to approximate based on tx status rates/retry and average packet size.
>> 
>> OK, cool. A byte-based estimator can also be useful for preventing dumb
>> firmware from buffering too much. The Chromium guys did that for ath10k:
>> 
>> https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/588190/13/drivers/net/wireless-4.2/ath/ath10k/mac.c#3826
> Interesting, thanks. I can probably use some ideas from that.
>
>>>> The call to ieee80211_return_txq() is really meant to be unconditional.
>>>> The TXQ will only actually be scheduled if it still has packets queued.
>>>> I know it's slightly more expensive to have the check in mac80211, but
>>>> this is what makes it possible to change the implementation without
>>>> touching the drivers (such as in the RFC patch I sent earlier that
>>>> switches the scheduling algorithm)...
>>> I think this API needs to be extended to allow the driver to specify
>>> that it has buffered packets for a txq. Otherwise there's a small window
>>> where the driver has packets for a txq but mac80211 doesn't, and
>>> mac80211 won't schedule the queue in that case.
>>> I'll send a patch for this soon.
>> 
>> Right, makes sense. As long as mac80211 is in control over how it will
>> react to that information (thus allowing to e.g., invert the logic if
>> needed), I have no objections to extending the API... :)I'm thinking of changing the code to make ieee80211_schedule_txq add the
> txq to the list, even if mac80211 does not have any frames buffered for it.
>
> I've looked at ath9k (the only user at the moment), and it seems to call
> the function in that way already: at PS wake or tx status time if it has
> frames in its internal retry queue.
> While it does not match the current documented behavior for that
> function, it nicely fits ath9k's currently unfulfilled expectations ;)

Heh, fair point :)

-Toke
