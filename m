Return-Path: <SRS0=OLg+=23=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC09C33C8C
	for <linux-wireless@archiver.kernel.org>; Mon,  6 Jan 2020 22:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91ABD2075A
	for <linux-wireless@archiver.kernel.org>; Mon,  6 Jan 2020 22:51:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="d35htZm0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbgAFWvq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 6 Jan 2020 17:51:46 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37684 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727300AbgAFWvn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Jan 2020 17:51:43 -0500
Received: by mail-qk1-f194.google.com with SMTP id 21so41061301qky.4
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jan 2020 14:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DcDJpyHhT/zuHt9L/g76CdYSvylHBQA1EbFEZdNVtEg=;
        b=d35htZm0gVCK/o7dbN8yxRvxzIEDYFhUfHYTtCUanbQlAQUMbA7D9fJQ7sI+7YkUYI
         fpuj36oPW2PXPysY4rVwdiRH0I2zfeUYPpyYdP1pGpAM2VHM60s2z5fmvIrfO0S+4CcN
         lOApLOvozrkfiXp8w2ciqEbwqOGsPZ9cKipyo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DcDJpyHhT/zuHt9L/g76CdYSvylHBQA1EbFEZdNVtEg=;
        b=qD4j5Mm812W3/aoZ9iiDQ0c5h7jub3ktlSe1244cThMK2wM9f09JRp5a8FlhYkw+3z
         iF0d15mOeD1LxF19Gx1i7etsp0vdbL1LTIFX+Vb6g0D+bpMVcK0TgfFEDVIctTKv/V7w
         0Q5o07a7veJjX9HFEhtako13Z+RzSa55Rr5yuQ7h1xBb7g2cyMNYQZqPLxtQZcPG3isA
         BzqGDmcOvZsJKDDCXuBrz00zi/ae/WweDy/13wLMri8psaiIS/ZrxMwBlqGijkV7+srH
         8fPnamW0bWImH5g2S/uuCj0o5QsFSuvCsmeG4U9u2aybgc+CKPZ/HeCpaDx+sk9veZqN
         3TuA==
X-Gm-Message-State: APjAAAX+fcufHiAwM+lmjBLbJCyKxWP+SvvXFAs2YE5IpxAYz+kiagSg
        ams9SbWj+kOga1YFWw9VipEI9dtk5Ug=
X-Google-Smtp-Source: APXvYqz9LEkKjn4ZLi8NNoffWw4epq4OhII6fa+SgO4ZkZKcki7tbUP4M9ulzVu1Gzq12ov0UvtlSA==
X-Received: by 2002:a05:620a:2043:: with SMTP id d3mr85420017qka.279.1578351101220;
        Mon, 06 Jan 2020 14:51:41 -0800 (PST)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com. [209.85.160.175])
        by smtp.gmail.com with ESMTPSA id b35sm24417702qtc.9.2020.01.06.14.51.40
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2020 14:51:40 -0800 (PST)
Received: by mail-qt1-f175.google.com with SMTP id k40so43798128qtk.8
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jan 2020 14:51:40 -0800 (PST)
X-Received: by 2002:ac8:678d:: with SMTP id b13mr67296866qtp.213.1578351099829;
 Mon, 06 Jan 2020 14:51:39 -0800 (PST)
MIME-Version: 1.0
References: <20191227174055.4923-1-sashal@kernel.org> <20191227174055.4923-8-sashal@kernel.org>
In-Reply-To: <20191227174055.4923-8-sashal@kernel.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 6 Jan 2020 14:51:28 -0800
X-Gmail-Original-Message-ID: <CA+ASDXM6UvVCDYGq7gMEai_v3d79Pi_ZH=UFs1gfw_pL_BLMJg@mail.gmail.com>
Message-ID: <CA+ASDXM6UvVCDYGq7gMEai_v3d79Pi_ZH=UFs1gfw_pL_BLMJg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.4 008/187] mwifiex: fix possible heap overflow
 in mwifiex_process_country_ie()
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        huangwen <huangwenabc@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Dec 27, 2019 at 9:59 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Ganapathi Bhat <gbhat@marvell.com>
>
> [ Upstream commit 3d94a4a8373bf5f45cf5f939e88b8354dbf2311b ]

FYI, this upstream commit has unbalanced locking. I've submitted a
followup here:

[PATCH] mwifiex: fix unbalanced locking in mwifiex_process_country_ie()
https://lkml.kernel.org/linux-wireless/20200106224212.189763-1-briannorris@chromium.org/T/#u
https://patchwork.kernel.org/patch/11320227/

I'd recommend holding off until that gets landed somewhere. (Same for
the AUTOSEL patches sent to other kernel branches.)

Regards,
Brian
