Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD23BC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 08:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8769D2082F
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 08:39:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tQ5bGcGr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388844AbfAPIjR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 03:39:17 -0500
Received: from mail-it1-f174.google.com ([209.85.166.174]:53977 "EHLO
        mail-it1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729177AbfAPIjR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 03:39:17 -0500
Received: by mail-it1-f174.google.com with SMTP id g85so1822332ita.3
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jan 2019 00:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ungSskqan5pxhYrZZ5DVVjj7cGzoOE7GOim/KbYktlg=;
        b=tQ5bGcGryupKL7CRTGUoAMnsD60mGbmIn2QMGG3bPQgpQV7BHH4FqA7Eg30uWLtVWA
         M9YpwzZnMwEEibzu4jvhPBBclNqeRsKXWgGf28ql1XkA6rfqnI2qRVxYHwfsochsGgCW
         WkVaRtArSxhyJFsgkROQcfALN76v9O+mDXJ+6u1X5+Za5ia14zL7hS5JZEwcjCwL2jXw
         3i6uFQu6DxMJgnXdsy6otGqqoRnRu3lWkjTmoqQTWDSBRtxxE9Qc/m3Ow1jBoFvaF4yj
         AEw3cIta6etueMO3PTjViRa38IlIXT7s6lfe8U9YHrAP1wYW8eQ7MzoS9m+IwNzoPLAU
         aIeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ungSskqan5pxhYrZZ5DVVjj7cGzoOE7GOim/KbYktlg=;
        b=TPmvKLUmsMFpsuQmEwlBjrYSx0jrm0H/TrgABwTYsxyc+LWSk0UOcDQTIntMOmfF6k
         sHQoaVBU7oonuTUmbh7URvyNFRXIyKNiZn7ur/EhNfq5rSYWxfvYDoeQkf/rRPvzDhCj
         Pv7KXGKRkEraForwEp9zS4VmKhnoJSaGU1SGW+KFD4AUub6oE3v07fY73Usx6YrPA711
         s4ryDfhg8YMKeERCeui8O7ygC+kpdzOjm4nzABXbgYzmKrshqKbrFuzr3vW3fMKZ3OWg
         xgOr6Y9NQvvJpb5n1KrYnvLfmZX/YDbs7WxnaD6BncWR4OzMaIHWUG9/6eo+RiGNs10X
         fgrQ==
X-Gm-Message-State: AJcUukehLibsQMlbcYe/Hl1C7ZX58wD6nigsJDEGApbFmHAKlbU3PMfQ
        V/x3ZZgxloOB4wW6o6I5eHlW4hjlike80ubZyzJbeLk4
X-Google-Smtp-Source: ALg8bN7tCp5ZEnoyhwICx7TXBtbNXqSD4Jbq0KfuKxX67zV+A3PZp7M4VMaEKnrxjpAFl3Eo8BsLCeK/zs7kVqvclS8=
X-Received: by 2002:a24:3a0d:: with SMTP id m13mr4562224itm.74.1547627956685;
 Wed, 16 Jan 2019 00:39:16 -0800 (PST)
MIME-Version: 1.0
References: <20181218080815.19395-1-chaitanya.mgit@gmail.com>
In-Reply-To: <20181218080815.19395-1-chaitanya.mgit@gmail.com>
From:   Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date:   Wed, 16 Jan 2019 14:09:05 +0530
Message-ID: <CABPxzYK+Tu678C=84i3+67gA1EBw_pG3cJ1y1ZvWZobU6iS8Dg@mail.gmail.com>
Subject: Re: [PATCH] wireless-regdb: update 60ghz band rules for us
To:     Seth Forshee <seth.forshee@canonical.com>
Cc:     wireless-regdb@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Dec 18, 2018 at 1:38 PM <chaitanya.mgit@gmail.com> wrote:
>
> From: Chaitanya Tata <Chaitanya.Mgit@gmail.com>
>
> Include channels 4, 5 & 6 for US in 60GHz band. FCC extended the
> 57-64GHz band till 71GHz with almost same rules.
> ---
>  db.txt | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/db.txt b/db.txt
> index fa5c0e0..ae650dd 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -1280,9 +1280,9 @@ country US: DFS-FCC
>         (5490 - 5730 @ 160), (23), DFS
>         (5735 - 5835 @ 80), (30)
>         # 60g band
> -       # reference: http://cfr.regstoday.com/47cfr15.aspx#47_CFR_15p255
> -       # channels 1,2,3, EIRP=40dBm(43dBm peak)
> -       (57240 - 63720 @ 2160), (40)
> +       # reference: section IV-D https://docs.fcc.gov/public/attachments/FCC-16-89A1.pdf
> +       # channels 1-6 EIRP=40dBm(43dBm peak)
> +       (57240 - 71000 @ 2160), (40)
>
>  country UY: DFS-FCC
>         (2402 - 2482 @ 40), (20)
>
Kalle/Seth,

Any update on this? Patchwork shows its delegated to you(may be by default).
