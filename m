Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 089E5C10F14
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 10:34:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEFBF2084D
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 10:34:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RrBSE2Us"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbfDKKes (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 06:34:48 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39704 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfDKKer (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 06:34:47 -0400
Received: by mail-wm1-f68.google.com with SMTP id n25so5982227wmk.4;
        Thu, 11 Apr 2019 03:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ncP/XNUc6zUJMN6LMeRFfRBUv3h/NA4fn494LmOhRG8=;
        b=RrBSE2Usc9PBkc7LAnBazfFCMJYidCyT2Ku0n71GbZZKb23GkVn5nbFq2uwPbmzd7t
         M/Ai4p0mmF5+xoGCyQkOABae4LRxfhs0yKoDzVBSUb8i4hCnf4LQwEeer+ZSahHY+0RJ
         mUFwI/KaJ24zYnuLLWB4PHUU3MF0HEKnWCtgXNVUvyFLoMQnmAl25rBCxSRx5z6c/Qpe
         +jiinKtSMc5jEtzHYmdFniH1Ll45Na5yLFMyomvD9iTV7AmF9uFPeR0BO3fyroLcZcqX
         t4NMphRED/AS4doJLsvAkN56rtQ5CE5f5wfIv+UPz/2otXxaeCfPL88ku9Hf00UoIWuF
         yxhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ncP/XNUc6zUJMN6LMeRFfRBUv3h/NA4fn494LmOhRG8=;
        b=SeHNNUBS6SNr5JKjSvn6XTDAw9cgJAyCnRh0S3NyuB83ul5CGGfYEjF5O+rN6wtwye
         9zQTbSZ4GO9G4Tg6G+bufqYBXnN5Typqdq7yQri8f1G8URTzpO69x4SBOORG11j1gQ17
         VmnDKOoeOwcnz9vF8SixFhr3SGYh2RBXuBorigG5+Dk8ghQz8yptBuG4pW/zChERIxHg
         sQ6w2smtks+w33ehag5p3Ke3Gs09ElQgYs3m2sy3tpq5apSPeT5F1aS3v1R7kdlbTXBq
         Ftc6mJ1Ij/KIr+xRaAyNvtfJlixqx9m9VqELcOp7sYMzpxQzhY/BhTpafi+rnnXy6Wtd
         ZCJw==
X-Gm-Message-State: APjAAAUh5ibMIL7fujlY43TtlGS312KsR9859OmdcaVtzYg0UkKn5pLE
        qAtj87D9uBRkTt4kovxjYqUZBplj5+AxPjrI2Gs=
X-Google-Smtp-Source: APXvYqxxCXwjF9kqHwwwiWd9xsdmZosDQqKBbtF+8N3rXMyB3xLNbDAv48MMIJr2EQBnQEJJTjcA5IsgI+HX33M/TtA=
X-Received: by 2002:a1c:cc15:: with SMTP id h21mr6003355wmb.85.1554978885091;
 Thu, 11 Apr 2019 03:34:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190411101951.30223-1-megous@megous.com> <20190411101951.30223-4-megous@megous.com>
In-Reply-To: <20190411101951.30223-4-megous@megous.com>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Thu, 11 Apr 2019 20:34:33 +1000
Message-ID: <CAGRGNgUhPC+G+H_zYSi7KFx-K10uPOXRsPqPFcirGaWScw59dQ@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH v3 03/11] pinctrl: sunxi: Prepare for
 alternative bias voltage setting methods
To:     megous@megous.com
Cc:     linux-sunxi <linux-sunxi@googlegroups.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        devicetree <devicetree@vger.kernel.org>,
        "Mailing List, Arm" <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Ondrej

On Thu, Apr 11, 2019 at 8:19 PM megous via linux-sunxi
<linux-sunxi@googlegroups.com> wrote:
>
> From: Ondrej Jirman <megous@megous.com>
>
> H6 has a different I/O voltage bias setting method than A80. Prepare
> existing code for using alternative bias voltage setting methods.
>
> Signed-off-by: Ondrej Jirman <megous@megous.com>
> diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.h b/drivers/pinctrl/sunxi/pinctrl-sunxi.h
> index ee15ab067b5f..4bfc8a6d9dce 100644
> --- a/drivers/pinctrl/sunxi/pinctrl-sunxi.h
> +++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.h
> @@ -95,6 +95,13 @@
>  #define PINCTRL_SUN7I_A20      BIT(7)
>  #define PINCTRL_SUN8I_R40      BIT(8)
>
> +enum sunxi_desc_bias_voltage {
> +       BIAS_VOLTAGE_NONE,
> +       /* Bias voltage configuration is done through
> +        * Pn_GRP_CONFIG registers, as seen on A80 SoC. */
> +       BIAS_VOLTAGE_GRP_CONFIG,
> +};
> +
>  struct sunxi_desc_function {
>         unsigned long   variant;
>         const char      *name;
> @@ -117,7 +124,7 @@ struct sunxi_pinctrl_desc {
>         const unsigned int              *irq_bank_map;
>         bool                            irq_read_needs_mux;
>         bool                            disable_strict_mode;
> -       bool                            has_io_bias_cfg;
> +       int                             io_bias_cfg_variant;

Shouldn't we be defining this field using the enum rather than as an int?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
