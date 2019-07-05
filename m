Return-Path: <SRS0=5Iat=VC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E4B5C46499
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Jul 2019 18:27:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19D5D2089C
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Jul 2019 18:27:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lkW117w9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfGES1v (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Jul 2019 14:27:51 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39820 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfGES1u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Jul 2019 14:27:50 -0400
Received: by mail-qt1-f194.google.com with SMTP id l9so3782288qtu.6;
        Fri, 05 Jul 2019 11:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=55JbN6zcysMUy2ZEV0xCsehVFqfZmF31tReahPIbYpE=;
        b=lkW117w9uXyWCnnqNc8EFXZb0GASxBo2JqAAECSQuoYYsXmO1K/rMjNLo3vTpxzwBL
         ial1FrtYO+8wcH03o1reYVaDuR1ZisT8/kevcTR9ew7Feq/FXU8JMGsUpIqN7YwFyir/
         LHk78kOK0NQsO7OFT0YkYKrvRl6RT1hS3EGkM9jm9yJDll+AWnhGSUuKELYFleeHQeQZ
         woS8IIW5HbqQM6hgtfCzVd+jqHwSz4qJqjDjGa7aHIO752Hwh3MGZXk6rXVJuwjsOiRg
         4rpy1L9dW6CjOJYGSODLYvqUtSCrcTaqNCiVkvqzhq4qmWaBmrYXYMoZ2Yj3GAOIFw2l
         aTig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=55JbN6zcysMUy2ZEV0xCsehVFqfZmF31tReahPIbYpE=;
        b=iTSt/m0ONj0G0ft5MXYk5iGcZ7GaOhyKpEpGBvJhRQWMHCEITIIC6lMP4y32Xly3zw
         F3r//EbGXLVxKcfS+Tb1r6PtB4jxihgVS3iFMrhpjOPxdLT6MgraRT1Sqfz2LLNyOAXb
         UDAW77PCyhRIF7w5RTd0RJiIvh8tXmlQmwmGRxx7oW0yNo+FrCX5wK9URCuLAGrkAHqj
         BcYVmnXib5JbhHZyPxbEHYrDd3WA8DBwyPWBClpcLTRZtgSmKJd3KprU4jKHIKd/2KOw
         daFYBUxYR1qAnhY+Nh4XjQha2TcIeMchDLNY+STxahN4ju1eA56o0CaZDPY8jeNZIytS
         3LWQ==
X-Gm-Message-State: APjAAAVCyKSPkYrrC/g4m3j9JFK/XxUbAcZkbXIRAfTPga2dbBfXnn7E
        VYcMnkJJjqr+UhaUPi5Dxgk=
X-Google-Smtp-Source: APXvYqxB0nlDAdH81y5ICSoFhLT2CIwCJsk09y2JWx23A0hHg/1YDABx7FwqwLndRwtvWMh26oHIyA==
X-Received: by 2002:ac8:47cd:: with SMTP id d13mr3751315qtr.156.1562351269354;
        Fri, 05 Jul 2019 11:27:49 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11d1::107e? ([2620:10d:c091:480::a5e6])
        by smtp.gmail.com with ESMTPSA id a6sm4028410qth.76.2019.07.05.11.27.47
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 11:27:48 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH] rtl8xxxu: Fix wifi low signal strength issue of RTL8723BU
To:     Daniel Drake <drake@endlessm.com>
Cc:     Chris Chiu <chiu@endlessm.com>, Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
References: <20190627095247.8792-1-chiu@endlessm.com>
 <CAD8Lp44R0a1=fVi=fGv69w1ppdcaFV01opkdkhaX-eJ=K=tYeA@mail.gmail.com>
 <4c99866e-55b7-8852-c078-6b31dce21ee4@gmail.com>
 <CAD8Lp47mWH1-VsZaHr6_qmSU2EEOr9tQJ3CUhfi_JkQGgKpegA@mail.gmail.com>
 <89dbfb9d-a31a-9ecb-66bd-42ac0fc49e70@gmail.com>
 <CAD8Lp44HLPgOU+Z+w4Pq6ukLjZv2hM0=uBL7pWzQp+RsdRgG6Q@mail.gmail.com>
Message-ID: <c9c4ab99-2cb8-5e5d-227e-d56efdb46504@gmail.com>
Date:   Fri, 5 Jul 2019 14:27:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAD8Lp44HLPgOU+Z+w4Pq6ukLjZv2hM0=uBL7pWzQp+RsdRgG6Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 7/4/19 11:44 PM, Daniel Drake wrote:
> On Wed, Jul 3, 2019 at 8:59 PM Jes Sorensen <jes.sorensen@gmail.com> wrote:
>> My point is this seems to be very dongle dependent :( We have to be
>> careful not breaking it for some users while fixing it for others.
> 
> Do you still have your device?
> 
> Once we get to the point when you are happy with Chris's two patches
> here on a code review level, we'll reach out to other driver
> contributors plus people who previously complained about these types
> of problems, and see if we can get some wider testing.

I should have them, but I won't have access to them for another 2.5
weeks unfortunately.

Cheers,
Jes


