Return-Path: <SRS0=bMqq=5G=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C670CC4332E
	for <linux-wireless@archiver.kernel.org>; Sat, 21 Mar 2020 11:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CD9A2077D
	for <linux-wireless@archiver.kernel.org>; Sat, 21 Mar 2020 11:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584789893;
	bh=CC3xOqOiOw/KfVSwNgtZdj47dfsfwOj+jNh3hAafy6c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=akZmTt6FM+qrJOafADwv4NOrk58gMwioTFi1kliYrHGF6E0h8ZSvl2c+Wso0X3vE9
	 y7UbLmjgVHRL8J6YuYwJTRpXniPjNDdAy+3MHZl73Rnzn26jrXLcSOnhdYYW0BkqGk
	 jeIzKUPvrZ470Gl1VPQSJMJjzBJcmfEC0EKDfgdE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgCULYs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 21 Mar 2020 07:24:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbgCULYs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 21 Mar 2020 07:24:48 -0400
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4582120781;
        Sat, 21 Mar 2020 11:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584789887;
        bh=CC3xOqOiOw/KfVSwNgtZdj47dfsfwOj+jNh3hAafy6c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lDApgz56lPs8ToQFcVEV8+EAX/cT7ThAz8oOMnFXG8qYrmNZ5gW9RuxrD3cdYMP+d
         EpFlQOtu+zsTlEW62aFEcbsjVO524POgi7mDnhK9rdBsngAYtCCQspKslzDLNakkr5
         d/tt/FiudZbBtX1px0ShZU4kWAH25eldMhL1gJJY=
Received: by mail-lj1-f170.google.com with SMTP id s13so9322749ljm.1;
        Sat, 21 Mar 2020 04:24:47 -0700 (PDT)
X-Gm-Message-State: ANhLgQ10woSUGrDYANPeWdTcxECTfnh+db2nPFnRxyhepZ9bb9z8/0Xa
        xOM+J5j+X3+LBCHNrgemeV07c9Rb4U7/Qv7xyCU=
X-Google-Smtp-Source: ADFU+vs0LzUeDMqhkyCRijtr/5jU1zll2VnT5GvJNspUkA5NWoImJ8IywkeIYEIKk4vGhOkK87FxiOUyuzZGlcUMAFM=
X-Received: by 2002:a2e:3818:: with SMTP id f24mr8239133lja.53.1584789885358;
 Sat, 21 Mar 2020 04:24:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200318204408.010461877@linutronix.de> <20200320094856.3453859-1-bigeasy@linutronix.de>
 <20200320094856.3453859-3-bigeasy@linutronix.de>
In-Reply-To: <20200320094856.3453859-3-bigeasy@linutronix.de>
From:   Guo Ren <guoren@kernel.org>
Date:   Sat, 21 Mar 2020 19:24:34 +0800
X-Gmail-Original-Message-ID: <CAJF2gTQDvmSdJB3R0By0Q6d9ganVBV1FBm3urL8Jf1fyiEi+1A@mail.gmail.com>
Message-ID: <CAJF2gTQDvmSdJB3R0By0Q6d9ganVBV1FBm3urL8Jf1fyiEi+1A@mail.gmail.com>
Subject: Re: [PATCH 2/5] csky: Remove mm.h from asm/uaccess.h
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, balbi@kernel.org,
        bhelgaas@google.com, dave@stgolabs.net,
        David Miller <davem@davemloft.net>, gregkh@linuxfoundation.org,
        joel@joelfernandes.org, kurt.schwemmer@microsemi.com,
        kvalo@codeaurora.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        logang@deltatee.com, mingo@kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org,
        oleg@redhat.com, paulmck@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        torvalds@linux-foundation.org, Will Deacon <will@kernel.org>,
        linux-csky@vger.kernel.org, kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tested and Acked by me.

Queued for next pull request, thx

On Fri, Mar 20, 2020 at 5:49 PM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> The defconfig compiles without linux/mm.h. With mm.h included the
> include chain leands to:
> |   CC      kernel/locking/percpu-rwsem.o
> | In file included from include/linux/huge_mm.h:8,
> |                  from include/linux/mm.h:567,
> |                  from arch/csky/include/asm/uaccess.h:,
> |                  from include/linux/uaccess.h:11,
> |                  from include/linux/sched/task.h:11,
> |                  from include/linux/sched/signal.h:9,
> |                  from include/linux/rcuwait.h:6,
> |                  from include/linux/percpu-rwsem.h:8,
> |                  from kernel/locking/percpu-rwsem.c:6:
> | include/linux/fs.h:1422:29: error: array type has incomplete element type 'struct percpu_rw_semaphore'
> |  1422 |  struct percpu_rw_semaphore rw_sem[SB_FREEZE_LEVELS];
>
> once rcuwait.h includes linux/sched/signal.h.
>
> Remove the linux/mm.h include.
>
> Cc: Guo Ren <guoren@kernel.org>
> Cc: linux-csky@vger.kernel.org
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  arch/csky/include/asm/uaccess.h | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/csky/include/asm/uaccess.h b/arch/csky/include/asm/uaccess.h
> index eaa1c3403a424..abefa125b93cf 100644
> --- a/arch/csky/include/asm/uaccess.h
> +++ b/arch/csky/include/asm/uaccess.h
> @@ -11,7 +11,6 @@
>  #include <linux/errno.h>
>  #include <linux/types.h>
>  #include <linux/sched.h>
> -#include <linux/mm.h>
>  #include <linux/string.h>
>  #include <linux/version.h>
>  #include <asm/segment.h>
> --
> 2.26.0.rc2
>


-- 
Best Regards
 Guo Ren

ML: https://lore.kernel.org/linux-csky/
