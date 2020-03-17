Return-Path: <SRS0=6JIn=5C=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4CE4C1975A
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Mar 2020 17:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7119C20724
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Mar 2020 17:34:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CHwplsTp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgCQReD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 17 Mar 2020 13:34:03 -0400
Received: from mail-lj1-f181.google.com ([209.85.208.181]:33087 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgCQReD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Mar 2020 13:34:03 -0400
Received: by mail-lj1-f181.google.com with SMTP id f13so23913785ljp.0
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2020 10:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kqsxGBu7vnlJqdIewMPUB2U9Yeu9F8tzYUHTHQJYpko=;
        b=CHwplsTpENT+WpQzzqVxqGIKVYKXOkeddYShp1dYeQaL3aluOrvXDG7N4LtqZVMchp
         EsemGRcrykubwC8g8sOvU05NNuTydmN+juWS7dGFmomhptkVyCOOXj3LbbQApCMiKkL8
         hnXGXxX89tFfVmQRJelCgl59pk40ThF1ctmJ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kqsxGBu7vnlJqdIewMPUB2U9Yeu9F8tzYUHTHQJYpko=;
        b=XwgmwFyNiSo5zDrakpXYcHuFQaAbVFjK7e8XrLgmwPaJahWHzNVKM8ATSLOPnFmDuH
         xpObQP/2PwoB7CUO/YVm/d592APLxgimTC3fbqoYp9TKPc4lMNsQQeLIfm6EVjajTB/i
         QtkVO/n1kDVHSK65Glx7cgUspgToNnbBtIsfurMLTVJnuT8jy4X4Nl6yaipiFQOG8OUT
         b1fWB5xo8vxfuTn+omeEGIqWiCz+5TrVU2VRoEd56HKmkxIVVS315rBjxZ+xb8mR8DFo
         k6XPoZ1pSi6CXtnNbtAE/8YR4AOhA6OqSJH+VpmYXEsJiT75ZqiNlY/jnH0Aubq6IsuV
         TR0g==
X-Gm-Message-State: ANhLgQ1/0X5AtGdqxGv0iJzZnI1aDDBuTJlwzw3BwF3msU/2LhLYyg3x
        ftWkdWuYVMqcVVQKLw+JhETnKIaTv8g=
X-Google-Smtp-Source: ADFU+vvftUm+h6ofiL3WEdPYfIebSls6huIQhua91xUImMihXoViLCsEY6eEtTymRI002zQEfgPhIQ==
X-Received: by 2002:a2e:9797:: with SMTP id y23mr3498874lji.183.1584466440639;
        Tue, 17 Mar 2020 10:34:00 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id a22sm2822425ljp.96.2020.03.17.10.33.59
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2020 10:33:59 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id w1so23912857ljh.5
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2020 10:33:59 -0700 (PDT)
X-Received: by 2002:a05:651c:204:: with SMTP id y4mr3382199ljn.280.1584466439036;
 Tue, 17 Mar 2020 10:33:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200317091837.GA18001@mwanda>
In-Reply-To: <20200317091837.GA18001@mwanda>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 17 Mar 2020 10:33:48 -0700
X-Gmail-Original-Message-ID: <CA+ASDXP80wMrWyc+WZNoGt=DK0EjFjNSjqCi4NGpJgc1mGK3sg@mail.gmail.com>
Message-ID: <CA+ASDXP80wMrWyc+WZNoGt=DK0EjFjNSjqCi4NGpJgc1mGK3sg@mail.gmail.com>
Subject: Re: [bug report] wireless: mwifiex: initial commit for Marvell
 mwifiex driver
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Mar 17, 2020 at 2:18 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> [ This is old, but maybe the driver is still really actively maintained
>   so maybe someone knows the answer.  - dan ]

I'm not sure what your definition of "active" is :) I also don't claim
to know "the" answer, but I'll provide one:

>    499              mwifiex_is_tx_ba_stream_ptr_valid(priv, tx_ba_tsr_tbl))
>                                                             ^^^^^^^^^^^^^
> Which is passed to here.  So maybe the NULL check is reversed?

Maybe, but it also looks like this validity check has always been dead
code, and only serves a redundant purpose (to check that the list
entry is *really* part of the list that we're trying to delete from?).
That sounds like we should just delete
mwifiex_is_tx_ba_stream_ptr_valid().

Brian
