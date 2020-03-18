Return-Path: <SRS0=7roA=5D=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BB8C10DCE
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Mar 2020 12:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44A5E2076E
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Mar 2020 12:09:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tomaszubiri-com.20150623.gappssmtp.com header.i=@tomaszubiri-com.20150623.gappssmtp.com header.b="U6zEZB+K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgCRMJs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 18 Mar 2020 08:09:48 -0400
Received: from mail-qk1-f178.google.com ([209.85.222.178]:39281 "EHLO
        mail-qk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgCRMJs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Mar 2020 08:09:48 -0400
Received: by mail-qk1-f178.google.com with SMTP id t17so16430878qkm.6
        for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2020 05:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tomaszubiri-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=exM5rHuPAvT1r9I19f8wjfTyrdyCTzHnnyoaIeIH93A=;
        b=U6zEZB+KYNB+jkBuzQMRWaDuErTyoTL1CvTWzHCFCT/WcOf/OvWeDDthD/mwlQXe52
         bc1SylWTyWOqAoMBaWgfT9aAuqGHgZXR/GMJW8rQ3Kn0VoUrAKIiEqpzUJmbWNwDLFjw
         bC7iiDB3KCPtHY1apgiDMtAReQcja41ussj9nFJVjvkbhMoL5U6BSqYH0CaHYSjb5c42
         H2XtmBFBb7szS8MOEDgdLvOChETAl8dLpDgoyQP7Gy9Nl/fekTdhuHgTXZm3YYkoqeMu
         UoCggRfeVWQfmv66J6bMTjANBccanQio4YHer/3aFacKCjgu7diUnKoLfMwASX/Kv/VS
         wkPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=exM5rHuPAvT1r9I19f8wjfTyrdyCTzHnnyoaIeIH93A=;
        b=ecKzUCH0R7RM4WwPYUcQ8qmBAvmokLCMYVFOw/v5Ua+sM4edVMzPBpidDufslW4wqU
         TLtFVdQMDhFwc3HwID51MTTNRe7qhZbRgklwip6i+zEebfjAZWY0ekIxEkxF79x9myqL
         l1C+hq0QXMhem4QthR9OuHphoZEz8WDmqam9dmDop3eAqP2kS0vUR94zaujTpK61fyHP
         pbvjV0FM6Blwkb28RhLyh1MoHe+euMgsNrvWSVMSDx6kCM/PhoV6MD4M/v0B1TvmKriD
         7GTZmsrSeIlFmlD32txB5LougybhXw6A2OU2OfYzgXnI/gQPvnD3uhXTLJLaxFzx/Ian
         uOPg==
X-Gm-Message-State: ANhLgQ12fY/U8CDnSuRA98dsWbm5hXbGwn7UmbyqpsOtFlJupCU7rwpc
        6kuySXp8wl+Kg5IXSD5fJB4ltUQOdt71NTY/mTCO+Q==
X-Google-Smtp-Source: ADFU+vv/3Ch0Yi7GpqCDlN2Qu3nA9Yr2og+pQJay5/2Ywr4dbmU4mDS4f+pX52wvOulahilIFOijVFjo9k3FJYj4qmo=
X-Received: by 2002:a37:8707:: with SMTP id j7mr3591041qkd.394.1584533387262;
 Wed, 18 Mar 2020 05:09:47 -0700 (PDT)
MIME-Version: 1.0
From:   Tomas Zubiri <me@tomaszubiri.com>
Date:   Wed, 18 Mar 2020 09:09:36 -0300
Message-ID: <CAE3VKEqUGmzh6X6kZYsBcCpQMGL-xQZXW1Zfpr-n5Ku8HsDMAw@mail.gmail.com>
Subject: Broken wireless documentation urls
To:     linux-doc@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello, I'm writing to let you know that there are some links to the
wireless documentation that stopped working. This is important because
other documentation might link to the kernel docs.

Take this url for example:

https://wireless.kernel.org/en/users/Documentation/acs

Which is linked by:

https://w1.fi/cgit/hostap/plain/hostapd/hostapd.conf


It appears the wireless document moved to
https://wireless.wiki.kernel.org/en/users/Documentation/acs

I think the best solution in this case would be to add a DNS record
for wireless.kernel.org to point to the same ip
wireless.wiki.kernel.org does. If this can't happen due to
wireless.kernel.org being used for other purposes, a server HTTP 301
redirect would be next best.

Thank you

Tomas Zubiri
