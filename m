Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F6AC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 12:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 096D020657
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 12:29:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EROl5b4O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfAQM3W (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 07:29:22 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46066 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfAQM3W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 07:29:22 -0500
Received: by mail-wr1-f68.google.com with SMTP id t6so10749997wrr.12
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jan 2019 04:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5rAbVo16b9QfTtSA6qwmRWiDKFta03xdZjOoD2bJw4M=;
        b=EROl5b4OmT9Ib+86IS5hA4hVZUg0HVTDvryZzVrKWZmbbWc0hVuZEAZTLGpqglx12Z
         S4MAophHcE6N3/tbHfaMPSB+3DsvA+4vSWYvATmJ4FZ8LjxaBQB/noDt3z1V+YaH4rr8
         nJn+iHeRUUltOFoCvLnRmVSuAMpCxa9dY+ruWTDg/AFqd5X5jh8TTSOEEIXlZv4ASwTK
         3CuMl+GEawKlKkvQ6YZazUOlaTPH4LB8oW6LXAUHLf8n0Ls6fBHGMO1MgGcIPmLcOnQD
         SMjylaLoqteQR6fQKb8YILUVPZXK0YJI89sizPHGNDAq7BSutahXpPnzLMNZitqJjJJw
         +02Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5rAbVo16b9QfTtSA6qwmRWiDKFta03xdZjOoD2bJw4M=;
        b=dtGYp010QMbLcgnDUP9mkSfhaoTPeNflB7gaiD/oSc3O8DXyKibdl1dU0EBcnNHS1M
         1WRS+WROCWChBE6xKMGSIOddMYmIgYycLUSIR3HvxvsgWOJ4/CC9mH4H1LsSukEeZxhy
         //cy/2MRI9yjw32I/ph+GQnxvcPwlg23AZhm2ti72tE5oR+V3aexSN+Y88pPPtHrjjTb
         P/Kw7mqmtVeozepdtsFRW5dVWQa8rUpzYfJlm22L0+8Or10SQOAUTTF9kAC59partkF7
         dq547XLXP0uep+R5mpqoS5bgnDB0+1sZX6j/EOi1GUakcewkGbHgcDtDlfOqoUzV5Wlq
         /UAQ==
X-Gm-Message-State: AJcUukdGTLqVA7R/8xrUD+X+VmzMwKShArz+EboS5CvyQC+2Tf6iQbxB
        VE1JLanNc4ePJIqoZkqcwT0Eso9qfwM6lHCxfboffA==
X-Google-Smtp-Source: ALg8bN5HY5ovGi3NMUEXs1kbe43ssYcoObBTxKJFZy4TOZQPpfRjsKQiKc8nePfrLA3X1pWXCtRxS3A9iYBz+Alqt9c=
X-Received: by 2002:a05:6000:1251:: with SMTP id j17mr11516772wrx.315.1547728160169;
 Thu, 17 Jan 2019 04:29:20 -0800 (PST)
MIME-Version: 1.0
References: <20190115233303.226908-1-julanhsu@google.com>
In-Reply-To: <20190115233303.226908-1-julanhsu@google.com>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Thu, 17 Jan 2019 23:29:08 +1100
Message-ID: <CAGRGNgVR3+5AjYc6qWAY09-UwDA-3Zv8kCT3=pGTqEqKPu57eg@mail.gmail.com>
Subject: Re: [PATCH] mac80211: mesh: only switch path when new metric is at
 least 10% better
To:     julanhsu@google.com
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Julan,

On Thu, Jan 17, 2019 at 4:06 AM <julanhsu@google.com> wrote:
>
> From: Julan Hsu <julanhsu@google.com>
>
> This helps to reduce frequent path switches when multiple path
> candidates have the same or very similar path metrics.

Should this be configurable?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
