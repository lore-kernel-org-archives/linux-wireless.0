Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCF53C10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 19:07:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADCF420663
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 19:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbfDPTHc convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 15:07:32 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:33295 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727136AbfDPTHc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 15:07:32 -0400
Received: by mail-ed1-f66.google.com with SMTP id d55so18069278ede.0
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2019 12:07:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=xVaMaqVCFTcxKeNV1hDB4g5+xzkRnhqj5thBZSfVPBU=;
        b=kHA9edfvmh58FgFR8d2igQiT3tDWYFK6T2/jrQYBHPdEwRtgxJo1yPByky3yXrtAGg
         4GIPDXuXyxS9XqMOQbhrET8lE3gZAYD38M+kMY8jfQqQ21B8Cby6NSySBgjnan5ig3dp
         /xJPYExD87sJr7RhmX5lZDlMkSO6AjesHDVq+2AMm3X1KLVB070Tvj5VC5jpaA16gnIP
         XCKK1GcClS05JK5sGQjho5EGNz/h7mjD73+LuWHAyALBiI2CpjvtG5d6xbKaD6F8dp36
         HuUXVHF47MEzFA14HSeFswEm3I9vjHXE+/GAbrew8hm/V8NWyEHokroE2ZcWeu11CKwu
         USkQ==
X-Gm-Message-State: APjAAAXX6UmZqYAYa++Re5J914HPt4DM7vS0T+jFHq1H0812TO/463UG
        4bVUvlwOefJqid5v2y0/WWlXYg==
X-Google-Smtp-Source: APXvYqw2e9N5vGDhkJEsbKF9R0Gb9fY5++3PIUR9fJRM7VgtvTM99P1oDs5hors3fepzBuW6zYV9OQ==
X-Received: by 2002:aa7:c5c4:: with SMTP id h4mr51808770eds.19.1555441650878;
        Tue, 16 Apr 2019 12:07:30 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.vpn.toke.dk. [2a00:7660:6da:10::2])
        by smtp.gmail.com with ESMTPSA id ga13sm9748114ejb.9.2019.04.16.12.07.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Apr 2019 12:07:29 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D98541800E8; Tue, 16 Apr 2019 20:07:27 +0100 (+01)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Erik Stromdahl <erik.stromdahl@gmail.com>, kvalo@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     yiboz@codeaurora.org
Subject: Re: [PATCH] ath10k: remove iteration in wake_tx_queue
In-Reply-To: <8772dfe6-3f52-05ca-f55a-b7eae14fa7ac@gmail.com>
References: <20190327162906.6010-1-erik.stromdahl@gmail.com> <87bm1qq92j.fsf@toke.dk> <8772dfe6-3f52-05ca-f55a-b7eae14fa7ac@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 16 Apr 2019 20:07:27 +0100
Message-ID: <87imvdu5u8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> On 4/1/19 1:05 PM, Toke Høiland-Jørgensen wrote:
>> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
>> 
>>> Iterating the TX queue and thereby dequeuing all available packets in the
>>> queue could result in performance penalties on some SMP systems.
>>>
>>> The reason for this is most likely that the per-ac lock (active_txq_lock)
>>> in mac80211 will be held by the CPU iterating the current queue.
>>>
>>> This will lock up other CPUs trying to push new messages on the TX
>>> queue.
>>>
>>> Instead of iterating the queue we fetch just one packet at the time,
>>> resulting in minimal starvation of the other CPUs.
>> 
>> Did you test this with Felix' patches reducing the time the lock is held
>> in mac80211?
>> 
>> -Toke
>> 
> Hi Toke,
>
> I am not aware of these patches. Can you please point them out for me?

They've already been merged. Commits dcec1d9bc8a7 and 7ef769459f14 in
mac80211-next :)

-Toke
