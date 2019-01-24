Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C3DC282C5
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 08:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58B44218A4
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 08:26:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="G75tBIm8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfAXI0L (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 03:26:11 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:35118 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbfAXI0L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 03:26:11 -0500
Received: by mail-vs1-f66.google.com with SMTP id e7so3036161vsc.2
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2019 00:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gUndCR9EZLRKT47oazL+YNDsX9+nAEw4+cyaNSj4UoA=;
        b=G75tBIm8PaM8u+qgJDv9dbSdC1qeLPIgVZDEsHb3RhAGxdbsOjtQ8ESDvCWdu3TQiM
         y9ablAVcz5Gw1rhD97Mz7Tn+YxKtSkQO6caYJDv94AiWwTA1ML3HYz0D8ub2BBxZFHtI
         bpm4RA0WZZdJtepznrsd9Ev3pA53gFRmROiuQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gUndCR9EZLRKT47oazL+YNDsX9+nAEw4+cyaNSj4UoA=;
        b=YFmadPl9cVQfLQDA5QSGpbgPI5RNUmhhwYTMyFz9JkkTCOuVLoCuaRSIRBrHEyEHqH
         6seG/NoVuHjKbhumHr33mzTEeKthrFH/aCcfj6AZvyyoGOgTbAyGoHM4+nB/VAHwGvxv
         ZVmPZFXIQT2cc3Z98tsKWrTXNzniGaTfLGrdVW8Ss3FuLcV6jmXduh+cYhq6a0QOqZgf
         HVt3j7WxobgEnWAvxq9pHcCexcTfsddMxezGmO3q2JrK0vFwzjSUOBx8nqTR6x9UbDfI
         YEmt0RPLFTAkXmeeHrKCaFvyHGLBYEKYbsIEvnWK6n3LVSfvVyB6Nc83JGJwoP4GbXOq
         S8Lg==
X-Gm-Message-State: AJcUukfbZqwayvyz3tsakkq3V/SG5916vtIW4v4DNwCo4O05IQYKczew
        0EbzRA8Ko5h/GeVSEqGCVdiunmkwEDzntuY690BblQ==
X-Google-Smtp-Source: ALg8bN7dIdPbFKBu3e0LeDv6hFYFe1Om2LsFra3RmCINI6E3/BHKo0irgUjBsZxP/pW+oYCrkt0t43MaHGNGlgCcrqU=
X-Received: by 2002:a67:d00f:: with SMTP id r15mr2323525vsi.191.1548318369865;
 Thu, 24 Jan 2019 00:26:09 -0800 (PST)
MIME-Version: 1.0
References: <5eace97d-1b6f-60eb-98da-588a485fce18@web.de>
In-Reply-To: <5eace97d-1b6f-60eb-98da-588a485fce18@web.de>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 24 Jan 2019 09:25:32 +0100
Message-ID: <CAPDyKFrp=LQmT-AsScnbf+ULkw80U1U3QzWCa1UuWPTYCDuw3w@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: zcu100-revC: Give wifi some time after power-on
To:     Jan Kiszka <jan.kiszka@web.de>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Wei Xu <xuwei5@hisilicon.com>, Ryan Grachek <ryan@edited.us>,
        John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, "Reizer, Eyal" <eyalr@ti.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Michal Simek <michal.simek@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 24 Jan 2019 at 08:54, Jan Kiszka <jan.kiszka@web.de> wrote:
>
> From: Jan Kiszka <jan.kiszka@siemens.com>
>
> Somewhere along recent changes to power control of the wl1835, power-on
> became very unreliable on the hikey, failing like this:
>
> wl1271_sdio: probe of mmc2:0001:1 failed with error -16
> wl1271_sdio: probe of mmc2:0001:2 failed with error -16
>
> After playing with some dt parameters and comparing to other users of
> this chip, it turned out we need some power-on delay to make things
> stable again. In contrast to those other users which define 200 ms,
> Ultra96 is already happy with 10 ms.

This changelog is talking about Hikey, while you do a fix a for the
zynqmp platform. Please rewords this accordingly.

>
> Fixes: ea452678734e ("arm64: dts: hikey: Fix WiFi support")

This is not the correct commit. Please change to:

Fixes: 5869ba0653b9 ("arm64: zynqmp: Add support for Xilinx zcu100-revC")

> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---
>  arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dts | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dts b/arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dts
> index 13a0a028df98..e5699d0d91e4 100644
> --- a/arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dts
> +++ b/arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dts
> @@ -101,6 +101,7 @@
>         sdio_pwrseq: sdio-pwrseq {
>                 compatible = "mmc-pwrseq-simple";
>                 reset-gpios = <&gpio 7 GPIO_ACTIVE_LOW>; /* WIFI_EN */
> +               post-power-on-delay-ms = <10>;
>         };
>  };

Kind regards
Uffe
