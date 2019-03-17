Return-Path: <SRS0=pME5=RU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9995EC43381
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Mar 2019 11:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67CE22064A
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Mar 2019 11:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfCQLdV convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 17 Mar 2019 07:33:21 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38313 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbfCQLdV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Mar 2019 07:33:21 -0400
Received: by mail-ed1-f66.google.com with SMTP id e10so7266694edy.5
        for <linux-wireless@vger.kernel.org>; Sun, 17 Mar 2019 04:33:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=6Hbd8AjwRU0ubqKf5IjMkP1r+zjUGT8RiBg+HciueeM=;
        b=aMuG26oQiaZxTTmWwoXw+lhCBgzhAPV9XcsUfAK5yxZrSDbNhUpwzVev0ivnBO0G10
         aFcy2yZgOVqWt9gBlnmO09Ur/n7aJm8MXbzy1Xfm8oJjlNfK43vA9sHYSneD62pRm9bD
         gyRD5woOZafLmhAulCH0ybgSF6oz/JZUd6q1/kZ4jKMeWEkXtMJXIdzSBLKIsACVbJsT
         68iMzB193UD0aO3wtAM5tAL/XvmwK+eQoPnyE+gShZP0x+ByC3aTAM9gRcnNtQWeaDpX
         8BRSC2YKeWQuTocxAR9aEHO2Em3EYhmIZxpB0NqcgTI7yTtA9YkiMrN2Kl0QqJzkqutB
         JOuQ==
X-Gm-Message-State: APjAAAXfBiiKiXb92COzGr5gVBghaV+thJoFln8dOHHiWOtS1M2UMsC6
        t9aGIxpzVWGGd2+P8B4UtOncNw==
X-Google-Smtp-Source: APXvYqy7TG1gETLLOZl/bmNFOdwcPUYVCckaT7qDCPNNrSY5PE9MLIrerKggQmxuR4sA461PCn1wmw==
X-Received: by 2002:a17:906:5a19:: with SMTP id p25mr7888873ejq.169.1552822399305;
        Sun, 17 Mar 2019 04:33:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id a51sm2486012edd.57.2019.03.17.04.33.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 17 Mar 2019 04:33:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B89311804A2; Sun, 17 Mar 2019 12:32:55 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/6] mt76: use mac80211 txq scheduling
In-Reply-To: <7b9a0a24-14b0-9b96-0010-ce9f96308ad0@nbd.name>
References: <20190316204242.73560-1-nbd@nbd.name> <87muluv4hd.fsf@toke.dk> <7b9a0a24-14b0-9b96-0010-ce9f96308ad0@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 17 Mar 2019 12:32:55 +0100
Message-ID: <875zshviqg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> On 2019-03-16 23:28, Toke Høiland-Jørgensen wrote:
>> Felix Fietkau <nbd@nbd.name> writes:
>> 
>>> Performance improvement and preparation for adding airtime fairness
>>> support
>> 
>> Great to see this! Do you have a plan for the airtime fairness part?
>> I.e., how to get the airtime information?
> Not yet. Still need to investigate what kind of information the hardware
> can provide. On a first glance it seems rather limited, so we may have
> to approximate based on tx status rates/retry and average packet size.

OK, cool. A byte-based estimator can also be useful for preventing dumb
firmware from buffering too much. The Chromium guys did that for ath10k:

https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/588190/13/drivers/net/wireless-4.2/ath/ath10k/mac.c#3826

>> The call to ieee80211_return_txq() is really meant to be unconditional.
>> The TXQ will only actually be scheduled if it still has packets queued.
>> I know it's slightly more expensive to have the check in mac80211, but
>> this is what makes it possible to change the implementation without
>> touching the drivers (such as in the RFC patch I sent earlier that
>> switches the scheduling algorithm)...
> I think this API needs to be extended to allow the driver to specify
> that it has buffered packets for a txq. Otherwise there's a small window
> where the driver has packets for a txq but mac80211 doesn't, and
> mac80211 won't schedule the queue in that case.
> I'll send a patch for this soon.

Right, makes sense. As long as mac80211 is in control over how it will
react to that information (thus allowing to e.g., invert the logic if
needed), I have no objections to extending the API... :)

-Toke
