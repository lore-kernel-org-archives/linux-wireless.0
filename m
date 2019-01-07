Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59891C43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 08:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21B6520675
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 08:35:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qqqsRCrM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfAGIfz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 03:35:55 -0500
Received: from mail-qt1-f173.google.com ([209.85.160.173]:34448 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbfAGIfz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 03:35:55 -0500
Received: by mail-qt1-f173.google.com with SMTP id r14so46948029qtp.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2019 00:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BmGXtZGxyeOylk35mksQVXxh9KprlD+SFHd0XOCqYaI=;
        b=qqqsRCrMvL98zwhPJLgf2c8Fseq2U8KI64LXD2KCW1kpz/+A0hEpwnersiYWFGBgAo
         eQGVAXpvQvJIMtoU0MrNUmfKYSyaYDFD0rWV+y000/xvW/RrJOWtdczwEFv7I9LNZH/r
         42kTxC0uuN4HAkcyamjqux1q5h6ZRQL7HYpRmO/Mg8tTV+KDaCLjoyiu/i/qe3hB0gEw
         4x1dXOjRnkO+7FVw1hR9VFMXFsi4rh6PR54NlGswsF27AWkSgi7JLItVAn3bCxqntPN5
         otitpeV7eX+PnCNyfYcc5xByyHa4tAuMJiGyUs97JrCkszwini9Hxd+HpVxkGluenLYs
         Ljxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BmGXtZGxyeOylk35mksQVXxh9KprlD+SFHd0XOCqYaI=;
        b=aZkcpE7CqldgqEoAi1/CYzdjfha2ZybIpebVprSKSCku869Z7T/NlpyUrZxrxjmY2g
         7B0+jk510ZT84Sz+ruGJSariQPkgqv4c64ei9A+PgW0JmvlVZfqR40ipYxY90JyqsXdl
         JBOB6NoaDVTtv9/nxIONFB1RhhRXsQnq1FBHAylUlfitH7Z4bg9/PEMpK8ZG2tylu8MB
         IypSIz0YV4yD1pQ5y5EJdv9c45qbY6tqVPBybpwiGGfjB/VPChY1eNLBUBFwblhgLKqi
         jRLPD+42k59/HcJyS/qRj+QTbbYxyNlH+k2L76DYgfe1yfyc5zRU5p6L0AxZ56geZLa8
         c4Yw==
X-Gm-Message-State: AA+aEWaXx6igVBJx6BFgonovz38LPSoxJfWecjKO8+Q+8YSCyXHrNEdx
        TJpKdS6ZHRWXj9oRPXK6AFMQziUG4/wZddcopuNN3A==
X-Google-Smtp-Source: AFSGD/XmPy9wR2QYWjG1AWQC50j7AF6sL4UpOFjsk017+keSCk+exqU4FOqtlp/Of7F3zZyUqgpRGXdNSXh0lW7QBIM=
X-Received: by 2002:ac8:1308:: with SMTP id e8mr59663643qtj.201.1546850154648;
 Mon, 07 Jan 2019 00:35:54 -0800 (PST)
MIME-Version: 1.0
References: <1542163824-795-1-git-send-email-wgong@codeaurora.org>
 <CABvG-CWg-VXAtoN8HZumW-ZdP6dX9cO_8fWJ58C22kD2yDcXdw@mail.gmail.com> <195f3bb0c88c43a6b1ca0ad336f947c0@aptaiexm02f.ap.qualcomm.com>
In-Reply-To: <195f3bb0c88c43a6b1ca0ad336f947c0@aptaiexm02f.ap.qualcomm.com>
From:   =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Date:   Mon, 7 Jan 2019 09:35:43 +0100
Message-ID: <CABvG-CWAfB8jjCDW4ggjJ8_YC++CjttJOMOt4s24F3mymvNR9A@mail.gmail.com>
Subject: Re: [PATCH] ath10k: Remove ATH10K_STATE_RESTARTED in simulate fw crash
To:     Wen Gong <wgong@qti.qualcomm.com>
Cc:     Wen Gong <wgong@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 7 Jan 2019 at 08:16, Wen Gong <wgong@qti.qualcomm.com> wrote:
>
> > > It is because the state has not changed to ATH10K_STATE_ON
> > > immediately, then it will have more than two simulate crash process
> > > running meanwhile, and complete/wakeup some field twice, it destroy
> > > the normal recovery process.
> >
> > This was intended to allow testing not only firmware crash path (and
> > recovery) but also firmware crash while recovering from a firmware cras=
h.
> >
> If firmware is recovering from crash, then simulate a new crash will trig=
ger error.
> So remove it.

That's actually a feature, not a bug. If firmware crashes while driver
is restarting after a crash then its likely going to fail again and
again causing a crash-restart loop which can affect system performance
and responsiveness. It's better to give up and let the system admin
take over.

If it's still bothering you then please consider a crash counter
threshold so that, e.g. after 5 crash-while-restarting it's going to
give up. However I doubt it's worth the effort. My experience tells me
firmware crashes during recovery are rarely, if at all, transient.

The simulated fw crash is not representative here. It's a mere tool to
test driver code.


Micha=C5=82
