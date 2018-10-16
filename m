Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1927BC5ACC6
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 21:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9DC721476
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 21:45:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="MqyXIG3s"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9DC721476
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbeJQFhh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 01:37:37 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:44450 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbeJQFhh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 01:37:37 -0400
Received: by mail-vs1-f66.google.com with SMTP id w194so19459189vsc.11
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2018 14:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3ekMAaEp2McKabeQAwCAYFuaTpwFQ6JUv1EQbJUTW7A=;
        b=MqyXIG3seo8UzBXsDpynJfzO8O/hSiJnU3XhzgIeGtgej0L+nw5ZfAh16vOA4bLiMH
         HS2CATlW6MqLaHvKBaWhB4bq24GpbaroyuzMrnmzJdk4auw7LmdQ4OpQvWaAAofl53zJ
         8TA4nrrvvlcC5l+TNf7aaJNaA0iBRH07LWsD0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3ekMAaEp2McKabeQAwCAYFuaTpwFQ6JUv1EQbJUTW7A=;
        b=BwQetJkBpT+vsYRBBJO4NTbDJj1JM0rLHhmK6qFlYwkWqohYYJZIpL6yXx8kwQ9JOJ
         buAl8rMEKM2j/zOGIqhQ40oWmYyMG88jwFCgcuB2dsgMKJgT7HEA4zqBIe1VsDduxXnw
         Qe4sQ/o6x2ZJTdpW7/8FHY9S4+NFf6y6Sb+49mpK5X3HJ8AVabvxYD5rJJ/Hmn48Spa8
         ULMcJKjNUPnkh4AP4hdGKRGmPk7FphsJqH4URXGyDWKTzKCSMiLbsKHMpAwgYv8R9cEb
         ZLicpQkiQoWJ1TexKXSaW/nXO0cBoNSvkNp07YkTEqf7dLjfYAAa/3N+4ZDna4JUK58k
         GIQg==
X-Gm-Message-State: ABuFfoiaeolMT7I/F5ybsyKl/ydBrrW9RxOnW5yU5nuI4eHcq8jQBvg4
        PaCEEhgfWTuS/uGKwDFX847G/IoCXkM=
X-Google-Smtp-Source: ACcGV6275eWwmH7BvT8g3m8evoTY0RGXoMsUYFVsKt52EOQ2iu+2NNRj6Wp14q1FDWr8V3n08sm+eg==
X-Received: by 2002:a67:b644:: with SMTP id e4mr9363247vsm.45.1539726315254;
        Tue, 16 Oct 2018 14:45:15 -0700 (PDT)
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com. [209.85.217.46])
        by smtp.gmail.com with ESMTPSA id l67sm2700503vsd.2.2018.10.16.14.45.13
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Oct 2018 14:45:14 -0700 (PDT)
Received: by mail-vs1-f46.google.com with SMTP id c205so19485097vsd.3
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2018 14:45:13 -0700 (PDT)
X-Received: by 2002:a67:1144:: with SMTP id 65mr1531744vsr.213.1539726313536;
 Tue, 16 Oct 2018 14:45:13 -0700 (PDT)
MIME-Version: 1.0
References: <1539172376-19269-1-git-send-email-govinds@codeaurora.org> <1539172376-19269-3-git-send-email-govinds@codeaurora.org>
In-Reply-To: <1539172376-19269-3-git-send-email-govinds@codeaurora.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Tue, 16 Oct 2018 14:45:01 -0700
X-Gmail-Original-Message-ID: <CAD=FV=WEJoGKXy_V0KRv-kR4EBFKns_6TDqBvKN5GBKNakPR3Q@mail.gmail.com>
Message-ID: <CAD=FV=WEJoGKXy_V0KRv-kR4EBFKns_6TDqBvKN5GBKNakPR3Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] dts: arm64/sdm845: Add WCN3990 WLAN module device node
To:     Govind Singh <govinds@codeaurora.org>
Cc:     devicetree@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <andy.gross@linaro.org>,
        "open list:ARM/QUALCOMM SUPPORT" <linux-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Wed, Oct 10, 2018 at 4:53 AM Govind Singh <govinds@codeaurora.org> wrote:
>
> Add device node for the ath10k SNOC platform driver probe
> and add resources required for WCN3990 on SDM845 soc.
>
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  arch/arm64/boot/dts/qcom/sdm845-mtp.dts |  8 ++++++++
>  arch/arm64/boot/dts/qcom/sdm845.dtsi    | 26 ++++++++++++++++++++++++++
>  2 files changed, 34 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/qcom/sdm845-mtp.dts b/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
> index eedfaf8..b89b8dd 100644
> --- a/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
> +++ b/arch/arm64/boot/dts/qcom/sdm845-mtp.dts

nit: it's usually considered nicer to split the patch into two: one
which adds the node to the SoC file and one which enables it in a
board file.


> +               wlan_msa_mem: reserved-memory@96700000 {

Everything else calls this "memory@", not "reserved-memory@".
Presumably someone (like Rob H?) thought that it should be "memory".
Please follow the pattern.


> +                       no-map;
> +                       reg = <0 0x96700000 0 0x100000>;

nit: though it doesn't really matter, it'd be nice to follow the
pattern and put "reg" above "no-map" like all the other nodes in this
section.


> +               };
>         };
>
>         cpus {
> @@ -1403,5 +1408,26 @@
>                                 status = "disabled";
>                         };
>                 };
> +
> +               wifi: wifi@18800000 {
> +                       compatible = "qcom,wcn3990-wifi";
> +                       status = "disabled";
> +                       reg = <0x18800000 0x800000>;
> +                       reg-names = "membase";
> +                       memory-region = <&wlan_msa_mem>;
> +                       interrupts =
> +                               <0 413 0 /* CE0 */ >,
> +                               <0 414 0 /* CE1 */ >,
> +                               <0 415 0 /* CE2 */ >,
> +                               <0 416 0 /* CE3 */ >,
> +                               <0 417 0 /* CE4 */ >,
> +                               <0 418 0 /* CE5 */ >,
> +                               <0 420 0 /* CE6 */ >,
> +                               <0 421 0 /* CE7 */ >,
> +                               <0 422 0 /* CE8 */ >,
> +                               <0 423 0 /* CE9 */ >,
> +                               <0 424 0 /* CE10 */ >,
> +                               <0 425 0 /* CE11 */ >;

Please change all the above to look like:

<GIC_SPI num IRQ_TYPE_LEVEL_HIGH>

...specifically:
* GIC_SPI is 0, but GIC_SPI is more documenting.
* having 0 for the final element means 'IRQ_TYPE_NONE'.  On newer
kernels commit 6ef6386ef7c1 ("irqchip/gic-v3: Loudly complain about
the use of IRQ_TYPE_NONE") will cause loud yells if you do this.
* I don't see what the comments about "/* CE# */ buy you.  Remove them.


-Doug
