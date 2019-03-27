Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA956C10F00
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 19:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CB992064A
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 19:16:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jbkrirWU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388710AbfC0TQw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 15:16:52 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:45536 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388468AbfC0SJA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 14:09:00 -0400
Received: by mail-lf1-f65.google.com with SMTP id 5so12050997lft.12
        for <linux-wireless@vger.kernel.org>; Wed, 27 Mar 2019 11:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Npju4SxUJ0U47mgz38YlqnxeUTW5KvOkHejF21m5IVY=;
        b=jbkrirWUy7gUKHB/nLOWdxyCTyJdtE65evx3Fea+5F7BPDzM+pLlNzRTTidrlkDkyo
         3wbkddSyt+sJ74dQkDCVC9bmMeFRsetnq+S5IOoKRU4Pb7EjN5ED+4fT4dHx65q3xOUX
         hQVmTy4mAip0bqlUmfGy8g+0iV5jwUD2bmhMo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Npju4SxUJ0U47mgz38YlqnxeUTW5KvOkHejF21m5IVY=;
        b=HcCVDylbq1HoDpun8aLvFrozvpsBEaBMGunOqvnLeMxbD300e/dYhlVwvd0rF4DE2p
         vj8LC8gJPorvS1XRf6xE2vNEYCMRhlH4rPftJMZlxCIWXHvrTyoFLqX/CoAM44ZWiRsc
         hCLM2SuE0bWdW+0YS4QfymxT6pptTrsrdEdohdmzvRgeoOyeBXjesWX2QHy5/v0zjYAU
         ZOCKnGRGQ/3A6I1Wls1ZddLNi15xW8xviM0xQhz/c+jZjlHJaP5Xpze98Sa6RCuRprnt
         Iyq1CqFw9JY98msnsmoJ7+1hdFpfb3xHEyZpMd9SkO33C+wynimpK6b97Z3ujAKRmmAs
         5n+Q==
X-Gm-Message-State: APjAAAVWppCzi+YftYOPCeRLWULvq70k8NPoewfUsKwyvMLl5ILUeIrC
        DHWVwSPhhCx1gbwEYTn7T7f/K+Qr3gM=
X-Google-Smtp-Source: APXvYqxPAnZBYfsrceZ3q3VYAHkkoRZYnMKLXhO5j2X0iRVGibdi26azdTq8TuyhVPTWvDBu31mnnA==
X-Received: by 2002:ac2:4563:: with SMTP id k3mr18997399lfm.101.1553710137558;
        Wed, 27 Mar 2019 11:08:57 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id s26sm4844862ljj.52.2019.03.27.11.08.55
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Mar 2019 11:08:57 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id d18so12066315lfn.3
        for <linux-wireless@vger.kernel.org>; Wed, 27 Mar 2019 11:08:55 -0700 (PDT)
X-Received: by 2002:ac2:569b:: with SMTP id 27mr20621267lfr.24.1553710135430;
 Wed, 27 Mar 2019 11:08:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190327180158.10245-1-sashal@kernel.org> <20190327180158.10245-116-sashal@kernel.org>
In-Reply-To: <20190327180158.10245-116-sashal@kernel.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 27 Mar 2019 11:08:43 -0700
X-Gmail-Original-Message-ID: <CA+ASDXM751is4yQvH=2Ti=YJH7Za6SzswZQ5k7bEV4PnqQQmqQ@mail.gmail.com>
Message-ID: <CA+ASDXM751is4yQvH=2Ti=YJH7Za6SzswZQ5k7bEV4PnqQQmqQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.0 116/262] mwifiex: don't advertise IBSS
 features without FW support
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Mar 27, 2019 at 11:05 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Brian Norris <briannorris@chromium.org>
>
> [ Upstream commit 6f21ab30469d670de620f758330aca9f3433f693 ]
>
> As it is, doing something like
>
>   # iw phy phy0 interface add foobar type ibss
>
> on a firmware that doesn't have ad-hoc support just yields failures of
> HostCmd_CMD_SET_BSS_MODE, which happened to return a '-1' error code
> (-EPERM? not really right...) and sometimes may even crash the firmware
> along the way.
>
> Let's parse the firmware capability flag while registering the wiphy, so
> we don't allow attempting IBSS at all, and we get a proper -EOPNOTSUPP
> from nl80211 instead.
>
> Fixes: e267e71e68ae ("mwifiex: Disable adhoc feature based on firmware capability")
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

The backport seems valid and useful:

Reviewed-by: Brian Norris <briannorris@chromium.org>
