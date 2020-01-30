Return-Path: <SRS0=/tVN=3T=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD69C33C9E
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Jan 2020 06:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDCE9206D5
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Jan 2020 06:39:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=endlessm-com.20150623.gappssmtp.com header.i=@endlessm-com.20150623.gappssmtp.com header.b="cumx5HYt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgA3GjB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 30 Jan 2020 01:39:01 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:36494 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgA3GjB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Jan 2020 01:39:01 -0500
Received: by mail-ot1-f68.google.com with SMTP id g15so2149779otp.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jan 2020 22:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5NQ5/JMeWC6oZj8pgMTE3iesEUdrxrzyD0L9JsU0ilA=;
        b=cumx5HYtsinWwOdqw6SfUUXpHryu5ZJgX48pTgrKWBcs5jO+IPwpiQdFb82pMvSYzK
         UijCaXIBbGGTcHAariorBnapV3Fru/BgZGzywQp9UQMHpr4a7wsFdXd8V0g32W/cQDyW
         ARhBR35PkOdFRKvbsJGkIXjX8IkjbxvIJvAs5DTx54yGbevdkqFfACj1vjVKTY3IA1EQ
         7lJ+c8j6wqaxUjYHbUSqCT4BLrELJs5kXKg5sLfK6DwkzhOaPj6laRFHfoKEKpRgljRp
         TWpnkCopG7r23nfQZEIpoeOkfGsuuHkkOh0je5FZs4kiA/D8q+RV6ToIQ0yFk3XR6HG9
         oHdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5NQ5/JMeWC6oZj8pgMTE3iesEUdrxrzyD0L9JsU0ilA=;
        b=okl7eucnUi8YmEgFmcNA7L6jDJKlVHIufFq4gB+pfA4cce+3wtro/KRJnqYa82d5ki
         cesiusWn7s1HMdJNz+KL4V7kB1AvdocBdn42AEnKQ+TtcykuKvLReUGmKLIAFQ5CrpsG
         AwWC0fU4J8Qu08s7jAmCiSdEjH6T8qGBYRRWcO6dVH0TS4zOSWSkD8PZw9ibuUGoa4Nz
         me3Glg/pV97G7zUSO/woelG7L3fNdbsV3l8KOjamUq/s3GduVPV+ZlEM0TC64X8Ix/UI
         VZ6DL9RnXYSrvZcRZuApPmS5e55j9HqrkuCxmMcS4P8+kfn5RNet7e5ONEkfsP6Q5tQm
         br2A==
X-Gm-Message-State: APjAAAUahibKdVh2YhtZ8hNkQIAcOPNAuuW6lmTe3Ibw55yVj7V6Wl5y
        eB8v1hVa9h1lIvSql9BkAXb38NxaOWU5UPupaMw/OA==
X-Google-Smtp-Source: APXvYqwFuGz0XpZ1ht+K27TJ44X1JVScAdNgKRDZAEHhaU3nOSY2g8wAxsJKkQNQ1EpBh6me2DSs26PjhyEZ8fzwalM=
X-Received: by 2002:a9d:774e:: with SMTP id t14mr2394036otl.358.1580366340059;
 Wed, 29 Jan 2020 22:39:00 -0800 (PST)
MIME-Version: 1.0
References: <20200130053112.28162-1-yhchuang@realtek.com> <20200130053112.28162-2-yhchuang@realtek.com>
In-Reply-To: <20200130053112.28162-2-yhchuang@realtek.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Thu, 30 Jan 2020 14:38:49 +0800
Message-ID: <CAB4CAwd4ji4dOghtjAO2vCYuL1Y7ZDC3K5W0qkoy9aBCShOTZg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] rtw88: Use secondary channel offset enumeration
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Jan 30, 2020 at 1:31 PM <yhchuang@realtek.com> wrote:
>
> From: Ping-Ke Shih <pkshih@realtek.com>
>
> The hardware value of secondary channel offset isn't very intuitive. This
> commit adds enumeration, so we can easier to check the logic with the
> suffix of enumeration name, likes _UPPER or _LOWER.
>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> ---
Reviewed-by: Chris Chiu <chiu@endlessm.com>
>
> v1 -> v2
>  * rename RTW_SC_20_UPPERST to RTW_SC_20_UPMOST
>
>  drivers/net/wireless/realtek/rtw88/mac.c      |  6 +++---
>  drivers/net/wireless/realtek/rtw88/main.c     | 14 +++++++-------
>  drivers/net/wireless/realtek/rtw88/main.h     | 10 ++++++++++
>  drivers/net/wireless/realtek/rtw88/rtw8822b.c |  2 +-
>  drivers/net/wireless/realtek/rtw88/rtw8822c.c |  2 +-
>  5 files changed, 22 insertions(+), 12 deletions(-)
>
