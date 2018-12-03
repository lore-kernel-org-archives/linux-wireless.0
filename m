Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB898C07E85
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 13:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A31932082F
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 13:37:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gb2ThYGs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A31932082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbeLCNiB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 08:38:01 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:53130 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbeLCNiB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 08:38:01 -0500
Received: by mail-it1-f195.google.com with SMTP id i7so9210169iti.2;
        Mon, 03 Dec 2018 05:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Op1WtoRQH4YIsq266fhE1+m1P43P7a7YfLKrOrxSCDk=;
        b=Gb2ThYGsofvR3y0rRVw8f4fmZNrD9uSpGqpDktgmiIiayB7swFwmW/JrBJs0+t69pU
         1tRM8+/eoGRNwAzOoWrtiqBtjla6Z5BgE+1WKIePCTfbdbpN9VOsOwRNSs3Z8nJb0q9X
         J7tmeDTirEbsf89R9ZPRQIo1X1ZyPBZZRr6Ty+7gwEmWTosqjbPKKxCWjUVaSl9FoBWs
         8+OhhOKXAJ3MrSm7dc8xxdG9Skggeqt7lu6QXioqggabiEGcDri3iKWASs0FtjXSNEwp
         OoUD6sFIxDDz8UWPbiEHC8u+7kgsNAAVr0n5iLlsNbw4B9iYld/ItHTpvhWLqe9C/HVH
         iNQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Op1WtoRQH4YIsq266fhE1+m1P43P7a7YfLKrOrxSCDk=;
        b=CD/wbbFynHHt0L+Iiu0mWnsyO1EcyLqZZW1gt1adZd+WFdyPKvJbb4xiJUeZY0ctMg
         lKIlJ5IV3qfEGXNkseSS0T/AHpQv9+loUxpKWcEREpzUCd/bdMHhu701zn06oCVDgaT8
         FyPaeQcX3Agxw9wnqQKwSPb3zeei2juvwZCML6V6KUMqGz2smil3dHIGWuDcYuL1wjaD
         PbjAGt91WEp3O3c3znOB5DuEuVGkbMCsnAP+4whNCwhkerutKOSC0vxS3p6AdDTcOShl
         QyxErrjb/2ojy1xQIXd3n6ebRzX+VIDecCIcoZsu9Q6E3l8JoW+PHfclXejpQnPx3K7N
         QWDw==
X-Gm-Message-State: AA+aEWZCjHyyLj9K/sZmQ/TC8CrUkCfJsmek2u9HVsykQk1TvlU13yZy
        P548k/rYX6TP9HebKW/3MqVgKPpXVb6frvg0xZY=
X-Google-Smtp-Source: AFSGD/WnJ87mdlL9Dadrhz1U0DxFOxXxJJ+65vakz0pp7tM3IWn9CLRwwkSmkvZa4ebOzckCZgNkA+AHPhArWiegxIY=
X-Received: by 2002:a24:7b90:: with SMTP id q138mr7511367itc.37.1543844216327;
 Mon, 03 Dec 2018 05:36:56 -0800 (PST)
MIME-Version: 1.0
References: <20181203132557.12269-1-tiny.windzz@gmail.com> <874lbug2fr.fsf@codeaurora.org>
In-Reply-To: <874lbug2fr.fsf@codeaurora.org>
From:   Frank Lee <tiny.windzz@gmail.com>
Date:   Mon, 3 Dec 2018 21:36:33 +0800
Message-ID: <CAEExFWtc2vRm7k2YpoNae+tOtnusSbVnapU-Wmo7kR-WfY+dzQ@mail.gmail.com>
Subject: Re: [PATCH] wireless/wil6210: convert to DEFINE_SHOW_ATTRIBUTE
To:     kvalo@codeaurora.org
Cc:     merez@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Dec 3, 2018 at 9:33 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Yangtao Li <tiny.windzz@gmail.com> writes:
>
> > Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
> >
> > Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
>
> The prefix for the title should be just "wil6210:", I can fix that.
>
> --
> Kalle Valo
Okay.

Yours,
Yangtao
