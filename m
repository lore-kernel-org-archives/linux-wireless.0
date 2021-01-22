Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCAA5C433DB
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Jan 2021 23:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ED4D23AF8
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Jan 2021 23:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbhAVXAr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Jan 2021 18:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728525AbhAVXAg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Jan 2021 18:00:36 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B982C06174A
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2021 14:59:56 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id q205so7785461oig.13
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2021 14:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dIFHFPrKW7JpzLF/A1gkPwmI3yVQYT3DCosEgoesovY=;
        b=G71XFS8JNXxCwO7BXCPstGBCRP88249JZCwORgWKdY9+UnIrXiPhIJ+3tt3Xag4LMO
         w8B8XHQ1AFhElanql23zRZLuZxWO34QeGWIkVoB8CiNHKoFfxTwDW4u2fnUyELU9jRGz
         E8awpEb5z6YZSQTWN6m2PUb2ZReQKaJGDDCAY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dIFHFPrKW7JpzLF/A1gkPwmI3yVQYT3DCosEgoesovY=;
        b=so4stiMmCIr82+7UxMiJYClA9cSqE+4MkKjsJoLcr9RbupeH33MmGUkpP5lvU+ZEix
         C7tDOwFdzxvXbpQ+/f5cER65dPX+eSYMYlJpL5BWDrTknqsBFNdH9Uprw7uwTt+enWbr
         fNO+J0sPEIG2r8E5vbAiz9wFDAIRRNwHN+31rC1zc6oNi1hJ9/p/NH4EWwWL1tw+KFXn
         5+DbLu0RpHzNp43PcIDWq5maeGp5QyygsrVD9+T4Mhp4/8Dovha6Df1aUefklx/t9yJe
         ecw9iRYKXYLNx4jox2iSffvD+5vvBB+ZE8kxl/AdnszjJALe1eIrhjy7TxGhcIGUYahk
         KUjg==
X-Gm-Message-State: AOAM531KBvWlGknS5kldBUaGf/SvJAWwL2rfloZmXMyDtLd5uI7vDpPO
        HKS/+yILPd3umyRRbjg4QEzItPoDFk60tQ==
X-Google-Smtp-Source: ABdhPJxY9wyt8z71A7bmEhmw4VtH/3AxNkX+jWOHhRPhAItZ71pOmYtxKOVlcW661TWitApKOtfKtg==
X-Received: by 2002:aca:af58:: with SMTP id y85mr4751497oie.33.1611356395598;
        Fri, 22 Jan 2021 14:59:55 -0800 (PST)
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com. [209.85.167.181])
        by smtp.gmail.com with ESMTPSA id r204sm2040650oif.0.2021.01.22.14.59.54
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jan 2021 14:59:54 -0800 (PST)
Received: by mail-oi1-f181.google.com with SMTP id w124so7847688oia.6
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2021 14:59:54 -0800 (PST)
X-Received: by 2002:aca:f40c:: with SMTP id s12mr4653465oih.105.1611356394174;
 Fri, 22 Jan 2021 14:59:54 -0800 (PST)
MIME-Version: 1.0
References: <20210115092405.8081-1-pkshih@realtek.com> <20210115092405.8081-5-pkshih@realtek.com>
In-Reply-To: <20210115092405.8081-5-pkshih@realtek.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Fri, 22 Jan 2021 14:59:42 -0800
X-Gmail-Original-Message-ID: <CA+ASDXO3D6jRuYp6EzNYo0PuS3voPv-h6h7dBjn03HqAphD-pw@mail.gmail.com>
Message-ID: <CA+ASDXO3D6jRuYp6EzNYo0PuS3voPv-h6h7dBjn03HqAphD-pw@mail.gmail.com>
Subject: Re: [PATCH v4 4/8] rtw88: replace tx tasklet with work queue
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        phhuang@realtek.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Jan 15, 2021 at 1:26 AM Ping-Ke Shih <pkshih@realtek.com> wrote:
>
> From: Po-Hao Huang <phhuang@realtek.com>
>
> Replace tasklet so we can do tx scheduling in parallel. Since throughput
> is delay-sensitive in most cases, we allocate a dedicated, high priority
> wq for our needs.
>
> Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

For this (and the rest of the series, minus comments on patch 3):

Reviewed-by: Brian Norris <briannorris@chromium.org>
