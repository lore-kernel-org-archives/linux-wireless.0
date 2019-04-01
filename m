Return-Path: <SRS0=CFp0=SD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32144C43381
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 11:06:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2A5720870
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 11:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfDALGE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Apr 2019 07:06:04 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35193 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbfDALGE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Apr 2019 07:06:04 -0400
Received: by mail-lf1-f66.google.com with SMTP id u21so5977469lfu.2
        for <linux-wireless@vger.kernel.org>; Mon, 01 Apr 2019 04:06:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=c3r2m+YCe/wq6frpwAFFoTbrFsSUsOfPgWBlp/6TXCc=;
        b=Crj+cOxWRbc6COXrYVYZBmBlMRsJbW6iqhdtCo6Yj5TJwqGmG8R6wESBujPDKQi0sz
         kpBBjNQOTza4TpQhNrZrTNwxUHi5JK0ObP+y2qxvHJb/LsNwi9/G3rfscF4V+EFEo6oJ
         jR5Zx21wwx7ozxWENHPGzuy//ImOi6bM5GTmNwk1p17zSN91IcxLgBrrrwOUj8kdIr4f
         AyqYQEstTGH7e7G8TcQubBK81pjU6FjgZy9ISxMmNLET5LM12T3FMMwQiPraFIWWJwzZ
         1ZCsBG0wZvHXZs9SpEEQc7x2WMW3VNSfB7UOaZW6iNVf7UQAQPOlkNfhIKW07VciToNe
         jOlw==
X-Gm-Message-State: APjAAAXgS0ZE+/SHNiPiBGsrViX0V2sx8IvRozQrIrySXjQi0PfD00UP
        1WW+PiBbCT5hoM292mBpnKiuQw==
X-Google-Smtp-Source: APXvYqy7aLhs4fL4enHI65vORzmrJbzhme/e4NHKi5NSdh+2S3CXCEei5i9RuCogHQS57zOn4yUwUA==
X-Received: by 2002:a19:5201:: with SMTP id m1mr11332372lfb.68.1554116762068;
        Mon, 01 Apr 2019 04:06:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.vpn.toke.dk. [2a00:7660:6da:10::2])
        by smtp.gmail.com with ESMTPSA id j9sm2032419lja.92.2019.04.01.04.05.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Apr 2019 04:06:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 27E7718200F; Mon,  1 Apr 2019 13:05:56 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Erik Stromdahl <erik.stromdahl@gmail.com>, kvalo@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     yiboz@codeaurora.org, Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: Re: [PATCH] ath10k: remove iteration in wake_tx_queue
In-Reply-To: <20190327162906.6010-1-erik.stromdahl@gmail.com>
References: <20190327162906.6010-1-erik.stromdahl@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 01 Apr 2019 13:05:56 +0200
Message-ID: <87bm1qq92j.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> Iterating the TX queue and thereby dequeuing all available packets in the
> queue could result in performance penalties on some SMP systems.
>
> The reason for this is most likely that the per-ac lock (active_txq_lock)
> in mac80211 will be held by the CPU iterating the current queue.
>
> This will lock up other CPUs trying to push new messages on the TX
> queue.
>
> Instead of iterating the queue we fetch just one packet at the time,
> resulting in minimal starvation of the other CPUs.

Did you test this with Felix' patches reducing the time the lock is held
in mac80211?

-Toke
