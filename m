Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF66C282CE
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 07:28:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C67620870
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 07:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfDHH2l (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 03:28:41 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39728 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfDHH2l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 03:28:41 -0400
Received: by mail-ed1-f68.google.com with SMTP id n9so1811579edt.6;
        Mon, 08 Apr 2019 00:28:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V/BKj4ipuubqegbqcSMy/c7ClQEvZu9gkbw7asMxzx4=;
        b=NCFuQAGjzruK9R6WwYYHNhRAmpm3+p+/N/bTTsQR+pwb69LleNfzGSG1jrhNwr5Fye
         nVU2f9ku/5RKIECUqOXEQA88Z9fKOa0UAPnvqLktzfqX9y1d+MAu/LZnNOJHZTe0wXJ0
         ADUFsDQZfr/NE3ubrsc2T2RY7VJP77k4Tsuvl1BB85e44t7zRV2ZYCUuAeiE40kFEdis
         GV7ph80ayEsfUnEYfrxSV72xp3npP8kg0x9h5bLQ05FYUn8Nql590Pu7Csfub4ctH5VQ
         3SkmZLryJLFR5qTzH6VSTkd1aXStKT8IpmCu5GxkbSRP4/IvQnD+rsQ7s3HC5O+NnUVM
         pVnA==
X-Gm-Message-State: APjAAAXzP3Y8e24dAB+IJvwvEyDwXAKLmokW8uBYReSTGfXAidxy+iPn
        Hbz0ifaoNmIRmKdO+09pukgNGKoHHYU=
X-Google-Smtp-Source: APXvYqydpCYDSq2kybwGBLnDYZUta3Avt9HPnmoeiFkeGzkXYNlNxTYq53JdHiqJiCAGoCttJIjSzg==
X-Received: by 2002:a17:906:3619:: with SMTP id q25mr15648982ejb.239.1554708518502;
        Mon, 08 Apr 2019 00:28:38 -0700 (PDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com. [209.85.221.48])
        by smtp.gmail.com with ESMTPSA id s44sm5032272edd.49.2019.04.08.00.28.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Apr 2019 00:28:37 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id r4so14987023wrq.8;
        Mon, 08 Apr 2019 00:28:36 -0700 (PDT)
X-Received: by 2002:adf:dc4a:: with SMTP id m10mr17029045wrj.0.1554708516284;
 Mon, 08 Apr 2019 00:28:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190405234514.6183-1-megous@megous.com> <20190405234514.6183-3-megous@megous.com>
 <20190408072338.3urcotemju3qi2un@flea>
In-Reply-To: <20190408072338.3urcotemju3qi2un@flea>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Mon, 8 Apr 2019 15:28:24 +0800
X-Gmail-Original-Message-ID: <CAGb2v65W_H5HrnY9+DuW-noshXLHgErJhEpHHhzcG15n1u=8iw@mail.gmail.com>
Message-ID: <CAGb2v65W_H5HrnY9+DuW-noshXLHgErJhEpHHhzcG15n1u=8iw@mail.gmail.com>
Subject: Re: [linux-sunxi] Re: [PATCH 02/12] drm: sun4i: Add support for
 enabling DDC I2C bus to dw_hdmi glue
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     =?UTF-8?Q?Ond=C5=99ej_Jirman?= <megous@megous.com>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Rob Herring <robh+dt@kernel.org>,
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
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Apr 8, 2019 at 3:23 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> On Sat, Apr 06, 2019 at 01:45:04AM +0200, megous@megous.com wrote:
> > From: Ondrej Jirman <megous@megous.com>
> >
> > Orange Pi 3 board requires enabling DDC I2C bus via some GPIO connected
> > transistors, before it can be used. Model this as a power supply for DDC
> > (via regulator framework).
> >
> > Signed-off-by: Ondrej Jirman <megous@megous.com>
>
> The DDC bus itself is usually attached to the HDMI connector, so it
> would make sense to make the supply also a property of the connector.

I believe these are separate things. What this patch covers is power for
a voltage shifter between the SoC and HDMI DDC pins. The HDMI connector's
5V supply to power the remote DDC chip is something else. And on the
Orange Pi 3 they are indeed separate supplies.

ChenYu
