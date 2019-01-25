Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDECC282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 13:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39AC9218CD
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 13:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbfAYNbS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 08:31:18 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39272 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfAYNbR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 08:31:17 -0500
Received: by mail-ed1-f65.google.com with SMTP id b14so7378648edt.6
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2019 05:31:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=oW0YjdioBzygfQLIXbGcfk9XwuMvEyBwg03MuEkyQ4U=;
        b=pMQ6ujdDHE7H7+uk3Tk4/Tgf1CNwNbvIxUWpQGFiLI4sHsv3bdJ1eu3cPpOLSIcP/N
         q0MEVb7gzarxtvUEzyFPAvvUxm8JkNuNrAJJbFoo21D5LGhklJRPpkSA5LcQop2v747w
         m3l6RaFFuC1XeBT/c7sKEDqrBLjR7QXJpFa6bLAFgFKZie+CSiGibcF5wOep4MGdOnPR
         8DvrNgmTnEkh/H8Ok8w6YySMugWKyz+vQ52BuUb4UH5+glwjBguwlCLIjHuKlF9G3AxW
         /FpCQGxNYabhNV0/gcBJ7KY7yPWb8PX1kw4wQApzldTVBxa/xCeRzjHkv4dxewL0UNy+
         /6qw==
X-Gm-Message-State: AJcUukdi2ClYtg/7aiqX1FF2Ttcy4JgC/2iGCXGcZSALhZ1+3mgMaYHF
        9gZdz6XGo3XkOSJ8uGXrTfB8FA==
X-Google-Smtp-Source: ALg8bN454CPKq51bh99h0FpNN22O7bH5jDCgmoeIW6xcle6mocUol8sbeBAAD+69DI6dkuxb4SkZcw==
X-Received: by 2002:a17:906:4058:: with SMTP id y24mr7330628ejj.230.1548423076074;
        Fri, 25 Jan 2019 05:31:16 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:10::2])
        by smtp.gmail.com with ESMTPSA id g31sm11462866eda.96.2019.01.25.05.31.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 25 Jan 2019 05:31:15 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 89292180327; Fri, 25 Jan 2019 14:31:14 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        ath10k@lists.infradead.org, make-wifi-fast@lists.bufferbloat.net
Subject: Re: [PATCH v7 1/4] mac80211: Expose ieee80211_schedule_txq() function
In-Reply-To: <4f4eab34a995000d230c8b99cb6cff3f9dfd5c64.camel@sipsolutions.net>
References: <20190122142019.21417-1-toke@redhat.com> <20190122142019.21417-2-toke@redhat.com> <4f4eab34a995000d230c8b99cb6cff3f9dfd5c64.camel@sipsolutions.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 25 Jan 2019 14:31:14 +0100
Message-ID: <87sgxgc199.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

>> +void ieee80211_schedule_txq(struct ieee80211_hw *hw,
>> +			    struct ieee80211_txq *txq)
>> +	__acquires(txq_lock) __releases(txq_lock)
>> +{
>> +	struct ieee80211_local *local = hw_to_local(hw);
>> +	struct txq_info *txqi = to_txq_info(txq);
>> +
>> +	spin_lock_bh(&local->active_txq_lock[txq->ac]);
>> +	ieee80211_return_txq(hw, txq);
>> +	spin_unlock_bh(&local->active_txq_lock[ac]);
>> 
> Maybe v6 had txq->ac here instead of just ac which doesn't compile ;-)
>
> I fixed it up, but I hope you tested a compiling version :P

Ah, right, thanks for fixing it! I think this was an artifact of moving
things around while rebasing for submission (I have another patch on top
of this series that I need to test first).

So yeah, I definitely have a version in my tree somewhere that actually
compiles ;)

-Toke
