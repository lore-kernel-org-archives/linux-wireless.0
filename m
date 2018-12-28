Return-Path: <SRS0=+yu+=PF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB00C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Dec 2018 00:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E64121741
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Dec 2018 00:45:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BM9oPDp5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730608AbeL1Apa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Dec 2018 19:45:30 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:38696 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbeL1Apa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Dec 2018 19:45:30 -0500
Received: by mail-oi1-f193.google.com with SMTP id a77so16308991oii.5
        for <linux-wireless@vger.kernel.org>; Thu, 27 Dec 2018 16:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=smEg2yH8McUbvpQlPIN8Lm+KQ8bKlfNoGO5JwOYkiK0=;
        b=BM9oPDp5ZNN5cYZyCAuaEoRrsii0Fe+Mo8eK3rMFwdjbybypEkmAQZp0lZRqVfyObH
         LLw3fVdkSO6m8YE3UngAO4+CVGYfU/3zqa2QEt6bCx8J9LBpLz25V1MY9FS7f68noD2p
         0SPXWjMY1yG/dPT87DswXhmP4n+cozeCNG3yCbW2ftrPrU6+vwhav8yWY38G+tWXt1XJ
         ovdm0MHKZd/fn0fr/ndx9NjKgPx2tsOR51j8Rw7N/t24a3BD/YUQXxhSVsLkF2ENBGKM
         d2jFOkDWN+PDHtMivD5MuPSc2aszC6YGEl8tAo6LVMY5GrejFsIZ0IZdV5GYri5O9S0W
         yj7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=smEg2yH8McUbvpQlPIN8Lm+KQ8bKlfNoGO5JwOYkiK0=;
        b=iZV1b6kbcHvzvT/hmGP+WrirQ5V5fKaXXxCx6RIIlhBv+ASbXDoFgd3TIY4XAhdB7r
         RrmH3mNF+hkzyHjxg4qqow52czXNbtjjdzYXpCsdJKDFwAeMpec3ODa4+43JXnTMK8se
         XSAEa/bO4A/c3ystWMEJF3LBvNDqcQbbquCxDFpg7RD7QeQpSx/oQ3rspLclwzqJK33m
         nYoN14cbbbFjBg/NVoCqe4e0Mcuxx3fiNUpmrV8MTV1cfMjXHrVtEJQiaea4yFHHGEgC
         n/Mqlq7Rl8ZV1tf6zuv/IuY3KsTIYIiyt8pYV2U6X8bt6BFiTREMRhDcOnfkxG356f4l
         F1ow==
X-Gm-Message-State: AJcUukc18pf+Ryww5mzr0Nl0tkXRm+tBYsxEkNqm0rj+dcGLBqja97au
        UJEYWil+0MCxc/A4ARsvWkXl+W6XmRv43Pk/cM4=
X-Google-Smtp-Source: ALg8bN5BrOpe405U6ZRnddBfx61/MUegsvqjrhgrHPX82GQV4LqOpSMFX3n8W0sg+wRNsQ4c+r+XGJByTvi/GOg3ZUE=
X-Received: by 2002:aca:6c4:: with SMTP id 187mr9586469oig.290.1545957928173;
 Thu, 27 Dec 2018 16:45:28 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9d:6c19:0:0:0:0:0 with HTTP; Thu, 27 Dec 2018 16:45:27
 -0800 (PST)
In-Reply-To: <20181227102535.GA25885@redhat.com>
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
 <1545318971-28351-3-git-send-email-sgruszka@redhat.com> <CAKR_QVJeteexpQX=pJm17WrrarmihYw56hKuTbsNagbcA6U96A@mail.gmail.com>
 <20181221095938.GA29536@redhat.com> <CAKR_QVKQMcGGpY_3ur9kFjuYpaKgca=YfUJxjSjLEfP1HELuJw@mail.gmail.com>
 <20181227102535.GA25885@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Fri, 28 Dec 2018 01:45:27 +0100
Message-ID: <CAKR_QVK_2j6a9YiwUEKuWF+ss0-pr808Sr=AUrX4a6L3Zw=F0w@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] rt2x00: do not print error when queue is full
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> I move prints to debug level for for "arrived at non-free entry" from
> "Dropping frame due to full tx queue" . For some users those 5 patches
> improve things, they fix problem of router connection hung completely.
> Printk problem is connection stall due to CPU being busy, but
> is possible to reconnect to AP after that. It's different issue.
>
yes they fix hung. same hung that does this single patch fix by moving
to dbg so they're not printed at all. FYI "Dropping frame due to full
tx queue" causes "arrived at non-free entry" eventually that freezes
interface so only reboot helps, removing "Dropping frame due to full
tx queue" from printing to logs prevents this kind of hung and is
better solution than 5 patches. oh and don't forget to add note that
rt2x00_err/rt2x00_dbg prints can cause serious bug so you don't
acidentally enable them again in a year or two!

> Also 'result in lower throughput' is over-generalized statement. More
> precise would be 'it lower throughput on some test cases', but even
> in those specific cases, throughput vary randomly with and without
> patches.
>

100Mbps TX 70Mbps RX without and 80Mbps TX 55 Mbps RX with 5
patches--> EA2750 HT40 CH2 4.14.82+4.19-rc5-1-1
