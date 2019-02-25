Return-Path: <SRS0=l+aR=RA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03420C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 09:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5A662084D
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 09:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfBYJus convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Feb 2019 04:50:48 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:43390 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbfBYJus (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Feb 2019 04:50:48 -0500
Received: by mail-ed1-f66.google.com with SMTP id m35so6968119ede.10
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2019 01:50:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=CtJC3ioRXikd5ggtdAjYIVsGKPDK2LEDVrHLgIwN4HI=;
        b=gbQUdj+/JhhuZ4zmNakQu1M2Fo/u5tzdq/CHJE/EhDNdiLcVaJqu/XA82hCWvuqlzJ
         pULbRapdCuAIZigP1fF47IM77mDPRafJ0DZb1sbFcRD46n5Pk/+Zu4U9AdsBv9etM+nS
         R5prnpQABoxpAlh4HxFmKJiKym02mhvv1aqxyvsb8xmYTeLCtYktREawPc19cDeM6Zac
         g/vWGM2xZz/ygGk9CcP2BOYJb52KKXX1rCJEz2k989g47CHGvzneNxF/FFDxNzEAkenM
         /zw9NUkRoIpCVgxFBdwRXBTeJUDX1SCnXus/zfVe7V/nS3pgBQKWzaivsYED5LwCnzv1
         zMlQ==
X-Gm-Message-State: AHQUAuZH06mdqAFrRfj8bhbXNuLKvncTgbvp1w4trCrBX65dK34nmC5q
        xqww24G0dyGiNd5RsWIXS/k6qA==
X-Google-Smtp-Source: AHgI3IaJzVZl5adQbbZGgnkhXnZkKYlhFnU1B1BXhPk5nsxK3QuwvQDwWpEPbGpNZ7dWaZ51+Sw1yg==
X-Received: by 2002:a17:906:e2d4:: with SMTP id gr20mr11946664ejb.210.1551088246544;
        Mon, 25 Feb 2019 01:50:46 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id c8sm1644662ejb.9.2019.02.25.01.50.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Feb 2019 01:50:45 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 81AD618350A; Mon, 25 Feb 2019 10:50:45 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     YueHaibing <yuehaibing@huawei.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ath9k: remove set but not used variable 'acq'
In-Reply-To: <20190225033246.127410-1-yuehaibing@huawei.com>
References: <20190225033246.127410-1-yuehaibing@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 25 Feb 2019 10:50:45 +0100
Message-ID: <87lg24urgq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> writes:

> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/net/wireless/ath/ath9k/recv.c: In function 'ath_rx_count_airtime':
> drivers/net/wireless/ath/ath9k/recv.c:1010:18: warning:
>  variable 'acq' set but not used [-Wunused-but-set-variable]
>
> It's not used after 89cea7493a34 ("ath9k: Switch to mac80211 TXQ scheduling
> and airtime APIs"). Also remove related variables.

Ah, right, seems I forgot to clean that up. I wonder why I didn't get a
compiler warning for it. Anyway, nice catch :)

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>

-Toke
