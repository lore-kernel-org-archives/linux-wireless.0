Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E4A1C04EBF
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 13:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3300E20672
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 13:43:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aC8Vw6Jy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3300E20672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbeLCNoc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 08:44:32 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:35903 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbeLCNoc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 08:44:32 -0500
Received: by mail-io1-f68.google.com with SMTP id m19so10499180ioh.3;
        Mon, 03 Dec 2018 05:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gW+KSjqs2PpYMSyO9GU3uPBiVRo78NGjBZEO4gEST0A=;
        b=aC8Vw6JyayR8N1/lD1rLtgH7CR1CJPshEIxuIgGM6M/9sa1YpfgR3O4u0GcX7uBECv
         dEEJS8MxVJusxl5OE4wIJJJKg/HnqtJX6UhCqW9jLv/0DsnMunv9jgDB6RPrPmYD2bvJ
         c4iebTbwbO0NeBssQ06GS0H8fnFSLEz8T79oMPzpa22CkJPsEiN/KvNm8Uk9UPW6SflK
         X0Yms8b0JypGQS5yWxB2+EY9cNE+X1YxbrYtGjHrXnmRdnpZP5+VT9biAcZbEYbQ4FF8
         wcdWzDls3DPgesle5HKGdZDZRQ4OZiUqP4BcjccRDlMXEmSAeYW/Jxili+pHRXb/MQ3S
         T39A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gW+KSjqs2PpYMSyO9GU3uPBiVRo78NGjBZEO4gEST0A=;
        b=Own5dcMywzQRmgjj4X46fdZJ9ZohaO3hVqi2DtyNai0CcswsChPd8vLhad+3iTczV3
         HRlc9Ya8YjS3FEcqXoHDnUIl2drpwV8B2xtLQQt2uadz9001H/BPPplfh9lrzgx58GXS
         T7EhEWoxtS6gsypBvmt3ed0OxX3EXq6nbt0CgHdzbNfvTO9vf1tG8nM3ak/m5OPPgjQw
         4VoVJbqsuiiDBU7PeOppbZhNSMafV7Oj4GwyDk9e0RZw0ZYC/sIUUfUA6bfI094O5pka
         sq/dz/RKOCGbRMA6uscP5OhbCNR207tL78XfnEeRnsOfSgxr4wovHBQnvzviZDr0CCGM
         DARA==
X-Gm-Message-State: AA+aEWaw85qoMfLQ3hgyKxigA62dEVAQZ5nvAbroIMPwy8zUvB+pWs4Z
        lz58LX/NmLqiKg2NlXkZEU0fnrOmdMBHskxvr84=
X-Google-Smtp-Source: AFSGD/URe4rUXKdGyT+7yoaEGPsgvX33p8pMrVLChUAMe0951iU5BickBs5nnnJ7+Ln7qdXAjqBEu0QopmoGaHW8JGk=
X-Received: by 2002:a6b:ba0a:: with SMTP id k10mr14349634iof.40.1543844606681;
 Mon, 03 Dec 2018 05:43:26 -0800 (PST)
MIME-Version: 1.0
References: <20181203133145.12430-1-tiny.windzz@gmail.com> <87zhtmenno.fsf@codeaurora.org>
In-Reply-To: <87zhtmenno.fsf@codeaurora.org>
From:   Frank Lee <tiny.windzz@gmail.com>
Date:   Mon, 3 Dec 2018 21:43:04 +0800
Message-ID: <CAEExFWusB4uNfqvyk-zbQeCJnizgFf73qK3a79NhEMGrTnnfqg@mail.gmail.com>
Subject: Re: [PATCH] wireless/cw1200: convert to DEFINE_SHOW_ATTRIBUTE
To:     kvalo@codeaurora.org
Cc:     Solomon Peachy <pizza@shaftnet.org>, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Dec 3, 2018 at 9:38 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Yangtao Li <tiny.windzz@gmail.com> writes:
>
> > Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
> >
> > Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
>
> The prefix should be "cw1200:", I can fix that.
>
> --
> Kalle Valo
OK.

Thanks,
Yangtao
