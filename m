Return-Path: <SRS0=Sl5Z=XU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2852C432C2
	for <linux-wireless@archiver.kernel.org>; Wed, 25 Sep 2019 16:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4D3421D79
	for <linux-wireless@archiver.kernel.org>; Wed, 25 Sep 2019 16:24:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="UbDWmBir"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732888AbfIYQYs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 25 Sep 2019 12:24:48 -0400
Received: from mail-qk1-f182.google.com ([209.85.222.182]:36408 "EHLO
        mail-qk1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729121AbfIYQYs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Sep 2019 12:24:48 -0400
Received: by mail-qk1-f182.google.com with SMTP id y189so5814257qkc.3
        for <linux-wireless@vger.kernel.org>; Wed, 25 Sep 2019 09:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qkxyjhi2a0KuOmRYHUNqRoOC/bUQwoxAl6LlxfpP+HA=;
        b=UbDWmBireQWYusQBJWZu1ioIOeJPd0oUdk5Nx5lDWRfxdavYL+Ve430sh6lDmMFqP2
         +xyE3v/jVy5+TU3/zEZsJ+/l1v/52EoBguLWY/XxAXmLSE+kYi8ZfWjCxJalgKVdRr+4
         MuOd8/Eoo+vs+/+vh4sGinMm1aQc73ACD2HRg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qkxyjhi2a0KuOmRYHUNqRoOC/bUQwoxAl6LlxfpP+HA=;
        b=NUvesUPIEZ5FbnAD42LXgzbNzlfnCAP4zk0W8dVq/C89RU+ARIcguZqdsn4mtXbSGD
         MuIGhdIqbbHor25eK7RzynvmVO09zOZlVLvDEDL1NuG9qNEmm48y/8m+k0rsKmNrVuKe
         Ahrr2Qg0StMsYYsnpCe8cCnGSTMKRY89DpUoqjoM9X7Yc4KjfOtukn6QU0DPU4QJvujQ
         nh0zIWalB7grdw90tjfTyMDBQrG6wEe1nqKx8FDThuWLO0qmkhhoZV5376p5w41k+Fcs
         DrnSdhWS3fsoDAo1sB3kIExz01685LpXdOhqGgOQ22ng6DAqK/QXa0f96e6D4VmEoBFe
         YoYQ==
X-Gm-Message-State: APjAAAUBpN+gDF1/Ma32wC4qhF/etxoU7/z3w0a7fvwixPWW9+sEKd0K
        fT9KvcMoUZgk/ghY6sygjo7tH6TThxM=
X-Google-Smtp-Source: APXvYqzHgtBLu8He3W73BdLidz0kNYqeLWqUFYIluIvInZMl4OQFBVMEm6mswRtr22MNOhurUOivvA==
X-Received: by 2002:a37:470f:: with SMTP id u15mr4534346qka.290.1569428687216;
        Wed, 25 Sep 2019 09:24:47 -0700 (PDT)
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com. [209.85.160.173])
        by smtp.gmail.com with ESMTPSA id a3sm6127qta.68.2019.09.25.09.24.46
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 09:24:47 -0700 (PDT)
Received: by mail-qt1-f173.google.com with SMTP id 3so47925qta.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Sep 2019 09:24:46 -0700 (PDT)
X-Received: by 2002:a0c:94fc:: with SMTP id k57mr185105qvk.210.1569428684992;
 Wed, 25 Sep 2019 09:24:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190925090856.6964-1-fedux@fedux.com.ar>
In-Reply-To: <20190925090856.6964-1-fedux@fedux.com.ar>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 25 Sep 2019 09:24:34 -0700
X-Gmail-Original-Message-ID: <CA+ASDXOCqZxbASdF4S3z1derWxJO44_hWfdTkjZS0FSoswRvxw@mail.gmail.com>
Message-ID: <CA+ASDXOCqZxbASdF4S3z1derWxJO44_hWfdTkjZS0FSoswRvxw@mail.gmail.com>
Subject: Re: ath10k: Poor performance with kernel 5.3 fixed
To:     Federico Cuello <fedux@fedux.com.ar>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Wen Gong <wgong@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Sep 25, 2019 at 2:16 AM Federico Cuello <fedux@fedux.com.ar> wrote:
> When upgrading to 5.3 my AP started to work really slow. I tracked the problem to 4504f0e5b5714d9d26b1a80bf1fc133c95830588 and fixed the issue.

For the record, that's:
4504f0e5b571 ath10k: sdio: workaround firmware UART pin configuration bug

> The attached patch fixes the issue when uart_print is false and uart_pin_workaround also false.

-ENOPATCH

Brian
