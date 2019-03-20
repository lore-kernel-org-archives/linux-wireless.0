Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E755C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 13:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10B5B21850
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 13:50:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wvwvc17/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbfCTNt7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 09:49:59 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:43395 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727269AbfCTNt7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 09:49:59 -0400
Received: by mail-ot1-f68.google.com with SMTP id u15so2136803otq.10
        for <linux-wireless@vger.kernel.org>; Wed, 20 Mar 2019 06:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=wjwSfrRNV/58HmEXEnsXT/l4B7AS2HG57puVEwDo52I=;
        b=Wvwvc17/uvXn81QriDSln7QWzF4QXiKI1bVm8jFdN05OLjUx4rsH3LzCp1bb0wTgug
         1yu3mCvMQ7GkbQNApjuhGRRRbKnqZerTVU5WT3q5McydWitzBk2rpGC+N2TRbWIF9k+p
         KVggdYfjX6nJq/oaA+hpt9fRFRRlkcmp8guuS8INBQFbWINjXNU5vAOtowE01TtP7k8O
         9QH3EfwXvDqbWbAYJc34kzOH0TaIGqZKWM0mNP7X2pyMd8Q7HIhM1EYLoq86JVXGfLCN
         puZZ9+hdEEpNSM3dfwgohljgWVZQwTa4syjJxNkY2tOzw1vegCxJzCnHDOGj2MPmDGWi
         hoYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=wjwSfrRNV/58HmEXEnsXT/l4B7AS2HG57puVEwDo52I=;
        b=oyMlj0xrF5RRSxOTiKCV3L5wAuRAXPmH+Quodex9jpAMlxnh7m0L1lp0hNSmtrcSdc
         5GUcvb602D4bDno/QxoiCWVq06CrIZAyqUsR8w9uHZIy0Dyd9fP9HU5U65TEjSRYU5zt
         Q80S+BrlB9V3QelCEWpwopyPKWhddMFU4x9Afkem7pw7H/uDl2HUnN5DQl7q+ln+KzaJ
         UQvePnhz8ELNNtpYt353rkguIc9/FvwtqNJnALqKJXNdqKPBdlo23SAiFXuHwaLYaqFC
         Ha+vo0aiRLDcvMAhsJmFYkBBib7O1SJAzOZQbU0vxlWVoZVzHTmDlh+xogTICifYvzWI
         Slvw==
X-Gm-Message-State: APjAAAWsfuU9aNbCjlh8N6TTsL7IlK7QyNfC56sFXl91IxLYClls6VV1
        ZzApD8K3opek0ICRFKEeAy9lgp9KHI1wgSXTONU=
X-Google-Smtp-Source: APXvYqyt3dZHvJ2K8sVqCb2WEHWVlC+ResNjC87t3UDZSrKyznAIoSplrTXGvUWDxdqxX6P+L5sOZc9KFZgD6nFsrAc=
X-Received: by 2002:a9d:4605:: with SMTP id y5mr5547549ote.296.1553089798292;
 Wed, 20 Mar 2019 06:49:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:628c:0:0:0:0:0 with HTTP; Wed, 20 Mar 2019 06:49:57
 -0700 (PDT)
In-Reply-To: <20190320103723.27228-1-sven@narfation.org>
References: <20190320103723.27228-1-sven@narfation.org>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Wed, 20 Mar 2019 14:49:57 +0100
Message-ID: <CAKR_QV+eHK4FN6V5aduS9vc8Zd2kbK5Ry3NO35Q1BwY58arZug@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Differentiate between max combined and per chain power
To:     Sven Eckelmann <sven@narfation.org>
Cc:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 20/03/2019, Sven Eckelmann <sven@narfation.org> wrote:

> This also means that a device with multiple tx chains is even limited
> further:
>
> * 1 chain:  31 dBm per chain
> * 2 chains: 28 dBm per chain
> * 3 chains: 26 dBm per chain
>

This is flawed theory and should be reverted instead of making further
complications. Simplest way would be to remove
POWER_CORRECTION_FOR_TWO_CHAIN and POWER_CORRECTION_FOR_THREE_CHAIN;
from driver
