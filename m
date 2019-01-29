Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B8AC169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 18:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA46920857
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 18:12:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mDIgoHXq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfA2SM6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 13:12:58 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44988 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfA2SM5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 13:12:57 -0500
Received: by mail-ed1-f65.google.com with SMTP id y56so16738552edd.11
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2019 10:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UsAhECMj10QdAL6nwZdmLzUjaI9BPskrN5id+O3vRUw=;
        b=mDIgoHXq1S95iWRCrKqHcDEavERowWJDyzpyz7P5Gi60Wbkv3UFpLrIOQEfpVnpbe3
         6eKgZUIIoJjkZtwHZublWMQLrYR69IV785IMFY3+KAl7C0569mDdeb3hlHkT4W7i4An3
         /2Hrxxc/sMkBUpg/4L/FWNCTu85VEMn1WViz8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UsAhECMj10QdAL6nwZdmLzUjaI9BPskrN5id+O3vRUw=;
        b=mFVFjYCRpw/QSR1NoPvfehMC1lnFHlWdtSz1IUAs/SYFPRfCM2W7ZsRC4dt8b0IMA/
         wmuSEGZCFIkY7AB/CNIwubqoBm7SGUPIa8xq0+ddJsFQitd7gWG7wbuyAjPEvNK7MbZK
         CUU8JxWxaRBsSsWFvEDDr09Z9Xp717dAgCosUzeD5xqWgdx6FDICQH7AkNf4xzCW6zrS
         eS/01GQR0G8mw3LgHQlqB25bcuBo2uBTc5i5vQXy9nAuVJP19VP0wzEaU8FWnMZMNegK
         1FZzQw/3u5uG/JD6bQW4atZ+Xt0yDd8W1s/mXLZ4fG6Jlb+3jvT/CLrf+3/ozZSmJrsk
         iAKw==
X-Gm-Message-State: AJcUukfDybxh4mOJzSm0qhxXSevM79Yu+1Qx7ZmaQaV4JnEZHrngRZZt
        6vud+97+hCO7uMQyhb0m45pMq7UiDaI=
X-Google-Smtp-Source: ALg8bN4G3giCL0knKG01DCe7gh67VQJTA3N18xIOuKbT4xgj9JFHl0uEaC1wbsCWf8ywrLRuf3OsSA==
X-Received: by 2002:a17:906:a48f:: with SMTP id m15mr4528783ejz.234.1548785575377;
        Tue, 29 Jan 2019 10:12:55 -0800 (PST)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id d15sm14337126edv.20.2019.01.29.10.12.53
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 10:12:54 -0800 (PST)
Received: by mail-ed1-f51.google.com with SMTP id h15so16765245edb.4
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2019 10:12:53 -0800 (PST)
X-Received: by 2002:a50:d2d6:: with SMTP id q22mr26954280edg.121.1548785573402;
 Tue, 29 Jan 2019 10:12:53 -0800 (PST)
MIME-Version: 1.0
References: <1536200965-121172-1-git-send-email-yuehaibing@huawei.com> <4b16caf3-9a25-99d0-5b35-f27d6e5a5c65@huawei.com>
In-Reply-To: <4b16caf3-9a25-99d0-5b35-f27d6e5a5c65@huawei.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 29 Jan 2019 10:12:42 -0800
X-Gmail-Original-Message-ID: <CA+ASDXMQto_dqPOuUEX9vqqbWmor8qvpwxBVTg6tSnHkfsCzpw@mail.gmail.com>
Message-ID: <CA+ASDXMQto_dqPOuUEX9vqqbWmor8qvpwxBVTg6tSnHkfsCzpw@mail.gmail.com>
Subject: Re: [PATCH] ath10k: snoc: remove set but not used variable 'ar_snoc'
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jan 28, 2019 at 9:53 PM YueHaibing <yuehaibing@huawei.com> wrote:
>
> ping...

For some reason, your patch shows up as Deferred in patchwork:

https://patchwork.kernel.org/patch/10589789/

So the maintainers have accidentally (?) ignored it. I'm not what the
official suggestion is for that, but you might just resend.

In any case...

> On 2018/9/6 10:29, YueHaibing wrote:
> > From: Yue Haibing <yuehaibing@huawei.com>
> >
> > Fixes gcc '-Wunused-but-set-variable' warning:
> >
> > drivers/net/wireless/ath/ath10k/snoc.c: In function 'ath10k_snoc_tx_pipe_cleanup':
> > drivers/net/wireless/ath/ath10k/snoc.c:681:22: warning:
> >  variable 'ar_snoc' set but not used [-Wunused-but-set-variable]
> >
> > Signed-off-by: Yue Haibing <yuehaibing@huawei.com>

...patch looks fine to me:

Reviewed-by: Brian Norris <briannorris@chromium.org>
