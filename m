Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE457C10F04
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 15:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3843222DB
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 15:58:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="evLk1DyO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502351AbfBNP6r (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 10:58:47 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:56255 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407642AbfBNP6q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 10:58:46 -0500
Received: by mail-it1-f195.google.com with SMTP id z131so5762505itf.5;
        Thu, 14 Feb 2019 07:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bJ317pROPPauW0d4GYjzsfJxMdqcuOVotsNqo12tNDk=;
        b=evLk1DyOyEDgzJqKir9LEOXSOFqqRVg0UlTxPPyJBjmiNjX6NQG2xQFus3gcmti6He
         7xR6iVaypjKFjIXF1dAVmlMBRIV2iIcr1J6Rz2FaWHU2mRGOylJ74CKuBKVenKFYJbN1
         UuxtdjDvPC+6AZdMp07tjR0oh4qTByBZ7wwn8XLOEFlMgW390yTNpP/CA+Ob5dPTbz9c
         g7vKrLX9TWvS4qTAYbi/Qy+To2Xu6PCN5Ikayq1md5DkBDj8x6PeLwz1YimKa0QQT9DZ
         v8i8VfOLYs27VYm4OJLFPd2StV5Ld3R+kF98Oxoicd4TODJq6WpBVVjv4UM7WO+htvef
         wd5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bJ317pROPPauW0d4GYjzsfJxMdqcuOVotsNqo12tNDk=;
        b=ZGGgGqzPAkQeudxDcG1V5vfesgG50WVuWU7SQKKwvdiM0yC/9nm9LF+P3uj1KxMcxi
         l/hoBQlgwJxvdEE+OH4CHYDP16FDBHzvM6athcNoRRCXGkMXfuUe3/InH9RMCjMlCbJe
         FrdWVvCqEPNzFwhBpwdlII3SGtoduF01k4YfquGuo2VDZaZDJgVdHGV6Id/2StR+SbsZ
         bw0rh4gs2tlCr9uyBDk/jv9DtJwTfD3K6CJEh2uOTeEL2ozpniX5t+bHPHy9PxJruUGe
         qshKZg5St9VcVq3M19hkosi6u9fVn5QxrVqnnhKKWA6dmy92fr3BAbxfIZMu894DonV5
         b7dw==
X-Gm-Message-State: AHQUAuZ3sRiptbUXuFss7aypyBbpWAGS2BfvDxrMfCAb1CR8gHSumwpp
        cjqeMAnitgrB4SuqTyaZVYkNCvYJliRVs4WDzXA=
X-Google-Smtp-Source: AHgI3IY5dzjmcyd+7TGsygqUU0TWHYGau0RgaBbQPAk+bybbnfzEgtgO7V3KR0JUq2UBgEbbGIsrFosZ4SyM306uYS8=
X-Received: by 2002:a24:2bd3:: with SMTP id h202mr2663387ita.50.1550159925637;
 Thu, 14 Feb 2019 07:58:45 -0800 (PST)
MIME-Version: 1.0
References: <20190213014917.164506-1-yuehaibing@huawei.com>
In-Reply-To: <20190213014917.164506-1-yuehaibing@huawei.com>
From:   Steve deRosier <derosier@gmail.com>
Date:   Thu, 14 Feb 2019 07:58:07 -0800
Message-ID: <CALLGbRLa75S_ugu-JwXiUu2rtN-a4DX_Kta2viteEQDTW3ATMw@mail.gmail.com>
Subject: Re: [PATCH] libertas_tf: remove set but not used variable 'flags'
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Colin Ian King <colin.king@canonical.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Feb 12, 2019 at 5:35 PM YueHaibing <yuehaibing@huawei.com> wrote:
>
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/net/wireless/marvell/libertas_tf/main.c: In function 'lbtf_rx':
> drivers/net/wireless/marvell/libertas_tf/main.c:554:15: warning:
>  variable 'flags' set but not used [-Wunused-but-set-variable]
>
> It never used and can be removed.
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Steve deRosier <derosier@cal-sierra.com>
