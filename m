Return-Path: <SRS0=pJT4=WB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A19BC0650F
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Aug 2019 11:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DC3020B1F
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Aug 2019 11:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbfHELIC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Aug 2019 07:08:02 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37017 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728409AbfHELIC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Aug 2019 07:08:02 -0400
Received: by mail-io1-f65.google.com with SMTP id q22so46595092iog.4
        for <linux-wireless@vger.kernel.org>; Mon, 05 Aug 2019 04:08:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TZB0uogDoHJIhRJJwV4GPWcjJapLBStlrW5ICDGREH0=;
        b=ZuQv3ut4oGRk44DuEKfDaO/mBSSF13MbguvpFo5pGGyVgKF7SyoiBBK3XaA2uBCJyr
         mcBJMGzwz3OLCWXoeK8I5f5NF5cWysqD2/LzKrpOzZAH4v0bVajmooblLGKZc01kzGqH
         50NJdxUENU5DI23m3p0ZiNkVcwobEXlwFmX85Pj/20JMJONeB9mOhDbmvSkSdqwjEr6R
         8i2rxqBqjFP40DC2t47nOfYIGusoOdZ1iwH+JyhT7l0iOZHg4A7PoDWl9qp6OMuGZFIh
         H59MuqoFzgIIwV4m1rKg41mwYaPEGvbDPxCGT/zvkZj9Eh8TgXinIgFho9CmjqmVNbDt
         ESLg==
X-Gm-Message-State: APjAAAWp1GycNljFecUXq8GgqSleo0ga5mexuTtPS2Mn4waaZyKHV6jJ
        TloaGh1D/cFnJ9UFk6GVx/rZQKUU4ao9QjgVK57h2Q==
X-Google-Smtp-Source: APXvYqxj0Ecz61wHCiyaZblhJYg+XenvTCtTKRX22tvBhGCzurVay8o2BtpaYuq5xeKt3JEbg6l/FxDCMB1R5Gk8rrQ=
X-Received: by 2002:a5d:8702:: with SMTP id u2mr121814152iom.228.1565003281741;
 Mon, 05 Aug 2019 04:08:01 -0700 (PDT)
MIME-Version: 1.0
References: <3edec94719a37a58576d530bba05dc629dfef2e0.1564750297.git.lorenzo@kernel.org>
 <20190805100947.GB17889@redhat.com>
In-Reply-To: <20190805100947.GB17889@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Mon, 5 Aug 2019 13:08:15 +0200
Message-ID: <CAJ0CqmVXC1-o3rXuho8rBqfa4Xip3WcxSTsQa=POdzXRZMaETg@mail.gmail.com>
Subject: Re: [PATCH] mt76: mt76x02u: enable multi-vif support
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> On Fri, Aug 02, 2019 at 04:36:20PM +0200, Lorenzo Bianconi wrote:
> > Enable multi-interface support for mt76x02u driver. For the moment
> > allow max two concurrent interfaces in order to preserve enough room
> > for ps traffic since we are using beacon slots for it.
> > I have successfully tested the following configuration:
> > - AP + STA
> > - AP0 + AP1
>
> The combination that did not work in my testing was STA + STA .
> This should be fixed or disabled.
>

Hi Stanislaw,

I have just tested STA/STA configuration and it works in my setup.

Regards,
Lorenzo

> Stanislaw
>
