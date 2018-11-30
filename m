Return-Path: <SRS0=8CYu=OJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D5D1C04EB8
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 13:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08DE520867
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 13:16:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hu1X4AN7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08DE520867
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbeLAAZw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 30 Nov 2018 19:25:52 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:40072 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbeLAAZw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Nov 2018 19:25:52 -0500
Received: by mail-it1-f195.google.com with SMTP id h193so9088098ita.5;
        Fri, 30 Nov 2018 05:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SQXqkKuH1vvjbmOsQwjpBXCt/ClRvt3Fpcz+bHGR8As=;
        b=hu1X4AN7i5rSMzYkyRxI1vyTOhlciFWN6qKrGXwUKrqYfc71Hp35jWcSPfL1ZauBOW
         Q0yIQcGAvBZ/nZMy2e4gx2YFTyJ7bBeSVhWabuSuBFYE/aik1T5xyD1YVRiEGfyqL7In
         DJo0+18v/Nn6/Khblh0qsTYRr8xRoRf1PyRvzqEjLWeywjg0P+ztcNfLCqqjiexb6AYk
         Bc6fShLUCZhkDpIB6fmnVbX9O3TmNNIlV79WDa5SL5kn3DurmlNmioKuO73rO1tPY4vb
         4AXYnxZP8q94t1Es7wnly5jAY4zkk/Mar9ReaWW8a3Q1qcCrmErmIQeUEg1AgThpKg0Z
         7+5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SQXqkKuH1vvjbmOsQwjpBXCt/ClRvt3Fpcz+bHGR8As=;
        b=P6SP8Ybzo4Z92Udm/Vs3igASTLL1dFZ9mmh5A0pUBAFBBWOeD4ObexZHx+euR1dc09
         MQ8HGbW2iEVErUIsH2j3LEbrGk2ycHvEwvJC20Jm4YD2vWEhlf/jES4dlXokkE5f3Ivn
         qkfA3yh/+nxlyhyksp7cpPPZjyF+oFtIiK5cmku+C3oBrnuaLtcKx7lzTKZ6UNUxoLcU
         QCs9cQNw86cAkebcLgL7MOlJV4oQ7Iag03cM64IokdUHGjAjyxjoo4AYx7hFk7rtXEii
         XDESfzSJuHmEUu4bXDplEO/tl87ZImsy6w+6hgn8DCg8D1DASD+aWBDNhrz95OsbTxuB
         6X+Q==
X-Gm-Message-State: AA+aEWZs0sy2wuiS6iAqo+cd4YgSX1ZodffLMzU5Pi0gwLllODIbqKKm
        0HeJOH9fM4vmFHUpFFeCa+fKKpaoQPxrR2AXgfY=
X-Google-Smtp-Source: AFSGD/X+qVdBBza0U+hKv9TAzV//s1lQC0Q85AvFpx7XndLCb581nCtiREYQo2/Hx3qAM1JphSKxTvulcYzTLkjIB8g=
X-Received: by 2002:a02:5944:: with SMTP id p65mr4919912jab.3.1543583795333;
 Fri, 30 Nov 2018 05:16:35 -0800 (PST)
MIME-Version: 1.0
References: <20181001213805.86511-1-tony@atomide.com> <20181005083324.D2D5160818@smtp.codeaurora.org>
In-Reply-To: <20181005083324.D2D5160818@smtp.codeaurora.org>
From:   Adam Ford <aford173@gmail.com>
Date:   Fri, 30 Nov 2018 07:16:23 -0600
Message-ID: <CAHCN7xKiCrrG=YLMX4gTtgfEQ3zG3P++OpG5aaQ3uoFO9A5RSA@mail.gmail.com>
Subject: Re: [PATCH] wlcore: Fix BUG with clear completion on timeout
To:     kvalo@codeaurora.org
Cc:     Tony Lindgren <tony@atomide.com>, "Reizer, Eyal" <eyalr@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, guym@ti.com,
        luciano.coelho@intel.com, maitalm@ti.com, maxim.altshul@ti.com,
        shaharp@ti.com, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Oct 5, 2018 at 3:33 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Tony Lindgren <tony@atomide.com> wrote:
>
> > We do not currently clear wl->elp_compl on ELP timeout and we have bogus
> > lingering pointer that wlcore_irq then will try to access after recovery
> > is done:
> >
> > BUG: spinlock bad magic on CPU#1, irq/255-wl12xx/580
> > ...
> > (spin_dump) from [<c01b9344>] (do_raw_spin_lock+0xc8/0x124)
> > (do_raw_spin_lock) from [<c09b3970>] (_raw_spin_lock_irqsave+0x68/0x74)
> > (_raw_spin_lock_irqsave) from [<c01a02f0>] (complete+0x24/0x58)
> > (complete) from [<bf572610>] (wlcore_irq+0x48/0x17c [wlcore])
> > (wlcore_irq [wlcore]) from [<c01c5efc>] (irq_thread_fn+0x2c/0x64)
> > (irq_thread_fn) from [<c01c623c>] (irq_thread+0x148/0x290)
> > (irq_thread) from [<c016b4b0>] (kthread+0x160/0x17c)
> > (kthread) from [<c01010b4>] (ret_from_fork+0x14/0x20)
> > ...
> >
> > After that the system will hang. Let's fix this by adding a flag for
> > recovery and moving the recovery work call to to the error handling
> > section.
> >
> > And we want to set WL1271_FLAG_INTENDED_FW_RECOVERY and actually clear
> > it too in wl1271_recovery_work() and just downgrade the error to a
> > warning to prevent overly verbose output.
> >

Do we know how far back this bug goes and which versions need this
patch applied to it?  I have seen something similar on 4.19, but I
haven't tried this patch to fix it.  It wasn't clear to me if this is
linux-next or 4.19 or something different.

thanks

adam
> > Cc: Eyal Reizer <eyalr@ti.com>
> > Signed-off-by: Tony Lindgren <tony@atomide.com>
>
> Patch applied to wireless-drivers-next.git, thanks.
>
> 4e651bad8489 wlcore: Fix BUG with clear completion on timeout
>
> --
> https://patchwork.kernel.org/patch/10622767/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
>
