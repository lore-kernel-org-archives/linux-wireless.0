Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49940C43444
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 11:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A25420657
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 11:44:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="IpqQvRpR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392403AbfAPLoH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 06:44:07 -0500
Received: from mail-ua1-f68.google.com ([209.85.222.68]:37204 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392240AbfAPLoG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 06:44:06 -0500
Received: by mail-ua1-f68.google.com with SMTP id u19so2047972uae.4
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jan 2019 03:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j5m7Be2T/PPjM3zgNtuPOH9oUYvNkNrEM9I9X8iH20U=;
        b=IpqQvRpRsEuqsnLdapnoOk4AedTdE1V4uQ5y8eJbBcs8giymwDaFom5WeMdFhXYCfV
         mCAeiV8smaw41D+gThTxi32cSbQbk3K/YOXomcogDD/tfMxdW/yW7N+S7aDI5xBHDg1Z
         Z8fBEdKwwJeMrfESH38Cy6nm+06OrlnP0STi8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j5m7Be2T/PPjM3zgNtuPOH9oUYvNkNrEM9I9X8iH20U=;
        b=KPmSCv2XLOWXSbWiJuLqUIdrmUigLYKtR2U1RvLBLuyyeDjjt+ELTawD5WMDavY7+l
         gx/6N0MaKFYga7GDaLuy9ZXVoWrGokJJdU0GqIeqQwc43/2XV5fcXuP99LfRIGsjlR2p
         D4GDfqoI8YGMOCSAsPjWoA1KiYJ5wyU0DnJOKYoam349iR6moAfPkpsDjD3Is8vfTrjQ
         vH7288DxX6pgI806Xq2uKggFslEfjwhMhGG0Ujc2w5Yv4a4GRJRluB1CxWcaLa3buhlq
         tSd/mytcQzoAdSgcMKZIhhNnSZEoJvYbvAoknm3jQfc9fhYCoP0vrBlKxVzk8PElEyhD
         zNKA==
X-Gm-Message-State: AJcUukcgmAM6JDviRAZm8xLBdZeRJOrmNjJJCoKiIUm9saZBV5sjMoF1
        bS9VXKVMSk7X9HZW49ew/5exx0ng0SQ5NkPJPyLUAw==
X-Google-Smtp-Source: ALg8bN7hqj+TXDNriBISFiv4mmvcKkn/uMxUQ9NyTXQH+61oss1fNAowO1nbaaXd7doAkcru93AnbczwWVn5/in8Uxk=
X-Received: by 2002:ab0:b83:: with SMTP id c3mr3265954uak.77.1547639045418;
 Wed, 16 Jan 2019 03:44:05 -0800 (PST)
MIME-Version: 1.0
References: <20190115150433.12558-1-ulf.hansson@linaro.org> <20190115185509.GJ5544@atomide.com>
In-Reply-To: <20190115185509.GJ5544@atomide.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 16 Jan 2019 12:43:28 +0100
Message-ID: <CAPDyKFpBY-urtSGpZtxmS79wgitgA46oFmeNk4w7tOjYW2PDLw@mail.gmail.com>
Subject: Re: [PATCH] wlcore: sdio: Fixup power on/off sequence
To:     Tony Lindgren <tony@atomide.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, Eyal Reizer <eyalr@ti.com>,
        linux-wireless@vger.kernel.org,
        Ricardo Salveti <rsalveti@rsalveti.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 15 Jan 2019 at 19:55, Tony Lindgren <tony@atomide.com> wrote:
>
> Hi,
>
> * Ulf Hansson <ulf.hansson@linaro.org> [190115 15:04]:
> > During "wlan-up", we are programming the FW into the WiFi-chip. However,
> > re-programming the FW doesn't work, unless a power cycle of the WiFi-chip
> > is made in-between the programmings.
> >
> > To conform to this requirement and to fix the regression in a simple way,
> > let's start by allowing that the SDIO card (WiFi-chip) may stay powered on
> > (runtime resumed) when wl12xx_sdio_power_off() returns. The intent with the
> > current code is to treat this scenario as an error, but unfortunate this
> > doesn't work as expected, so let's fix this.
> >
> > The other part is to guarantee that a power cycle of the SDIO card has been
> > completed when wl12xx_sdio_power_on() returns, as to allow the FW
> > programming to succeed. However, relying solely on runtime PM to deal with
> > this isn't sufficient. For example, userspace may prevent runtime suspend
> > via sysfs for the device that represents the SDIO card, leading to that the
> > mmc core also keeps it powered on. For this reason, let's instead do a
> > brute force power cycle in wl12xx_sdio_power_on().
>
> Thanks this looks good.. But looks like udelay 20000
> is needed with:

Thanks for testing!

>
> # while [ 1 ]; do ifconfig wlan0 down; usleep 20000; \
>   ifconfig wlan0 up; done
>
> Otherwise I get the following on warning pandaboard-es:
>
> WARNING: CPU: 0 PID: 1770 at drivers/bus/omap_l3_noc.c:147
> l3_interrupt_handler+0x2f8/0x388
> 44000000.ocp:L3 Custom Error: MASTER MPU TARGET L4PER2 (Read):
> Data Access in User mode during Functional access
>
> Meaning that we access registers while not clocked
> somewhere. I think that warning is different from the
> earlier errors though :) And we could add a msleep(50)
> to the end to mostly avoid it until we have a better
> fix available?

Well, that would paper over the problem, let's see if we can avoid it.

I realized that I have not invoked mmc_hw_reset() with the sdio host
claimed. This could be the reason and is fixed in a v2, please try and
see if that solves the "new" problem. If id doesn't, you could also
convert the pm_runtime_put() to a pm_runtime_put_sync() in
wl12xx_sdio_power_off() and see if that makes a difference.

Kind regards
Uffe
