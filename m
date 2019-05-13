Return-Path: <SRS0=GdFy=TN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4675BC04AA7
	for <linux-wireless@archiver.kernel.org>; Mon, 13 May 2019 19:46:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15B0D20873
	for <linux-wireless@archiver.kernel.org>; Mon, 13 May 2019 19:46:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kdf5XvSe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfEMTqn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 13 May 2019 15:46:43 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43445 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfEMTqn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 May 2019 15:46:43 -0400
Received: by mail-wr1-f66.google.com with SMTP id r4so16593637wro.10
        for <linux-wireless@vger.kernel.org>; Mon, 13 May 2019 12:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=Bh7/Cp4HTA07jQMfA3jNUPz8gtLY1xgAbfjysY3NW8Q=;
        b=kdf5XvSehlwDU216QTJAwA/+u8M5VM9DU/WJVZTlTo3lEM8VDZZYlVynTcza4YS23c
         SGAZBgNXr6jJE7gKmds3myE4ZU7DdORSgxujWD9QL4tvVon2ICqSsVsjkMMGgA5QjMt5
         BOq637sEX1knoFO/k8sJs9dVHkIKl+uFTkbwYbnfc+VrNPTPT9NNBRdncyS04GhPPmIh
         nsc6UJQRDuPOYTMSo3O17qhWgkkIZXs4UpleXxzQdRfskaZ4EiYBXofhl2pJfw5jmZ4X
         deISew27UHRpzeCO6UlLOH7Gyg94AfbaXgTv79tCemJUGb+FonOdPNk1K2RfkerxJcUL
         33Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=Bh7/Cp4HTA07jQMfA3jNUPz8gtLY1xgAbfjysY3NW8Q=;
        b=AufGZXPCWzRI8V88Gkfx3Kaz/U3bt5kdzMaizGq+Gr1DJB9OSGYfX3JfeWsw5fo8k4
         UKq9/i5KICGAlzyty3VKDM77gDt+ihfolfQPFrwynYllYezSR6s8kx5/VPVUVzCLM5Br
         sjzyLVKoLyly91KJ+AFbZdCOv0chIqyHKOT0cusJqdQ6ZRWprgwsmIEdnA3KoynqakMh
         i39HieBibLOPsCi0/suThblGQ2N432Ip4rM+KKg394poO1Xk2rf6CkVKDFYhFGcIGVYe
         pcxKn19NlW54cVVithFx3t+MtZF9FJ/7oc1s1yJT+2VwL3Yb4Gy8mxh/1mrDqYEV9Bm5
         bF7A==
X-Gm-Message-State: APjAAAXb55sJRYYgEEYCyPq9T0E3XvvU8KLzahz5KU5RU1FgmdRoGjHu
        hshvvL4PW9qFFCh+1fp2Mb/ihfDTtZvldL2B5zI=
X-Google-Smtp-Source: APXvYqx5F5iy5/YYEh79h2rJPNvjbHn8yneZdgKuXWRi2e8tS12GZqmtasGGkS+Wj7r+X8SXDtVuA4TfjuZfuu65ngU=
X-Received: by 2002:a5d:4692:: with SMTP id u18mr6813840wrq.285.1557776801173;
 Mon, 13 May 2019 12:46:41 -0700 (PDT)
MIME-Version: 1.0
References: <154e3e74-38b5-850b-5993-295f9db8fe3c@intel.com>
 <CA+icZUWhBeup95PTP_k58xs8Lf2Ofqb0S_gkdBfbuc0-wdpF-w@mail.gmail.com>
 <06fbacb5-7739-1ca1-3bf4-8049a3ef019b@intel.com> <CA+icZUWJ0kZSqogg18LdP2YkNXk=_SNnT7-ufkd_Xp1ak7uchg@mail.gmail.com>
 <20190513095059.GN9224@smile.fi.intel.com> <CA+icZUWXSup0BfXNZXxcrAAbu-b9KCiBU++OkC+eFqacMrTwRg@mail.gmail.com>
 <20190513105745.GR9224@smile.fi.intel.com> <CA+icZUVDTx_ZUuOgHVDmg5_a4tgrRkPp880+0KPaRJ1d=zF5VQ@mail.gmail.com>
 <20190513124049.GT9224@smile.fi.intel.com> <CA+icZUWU2OQszOYi1Jzp7yW+gB-TmhkBfmqaLAvy3WEOn9Rh8g@mail.gmail.com>
 <20190513141128.GY9224@smile.fi.intel.com>
In-Reply-To: <20190513141128.GY9224@smile.fi.intel.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 13 May 2019 21:46:29 +0200
Message-ID: <CA+icZUUsutHt1NXLNFd17J3QK-LtFCuUUEw4qqp9urJ++dDaKA@mail.gmail.com>
Subject: Re: [linux-nfc] ThinkPad T470 and NXP PN5xx (PN547 or PN548)
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Oleg Zhurakivskyy <oleg.zhurakivskyy@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, May 13, 2019 at 4:11 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Mon, May 13, 2019 at 03:32:52PM +0200, Sedat Dilek wrote:
> > BTW, which Linux Kconfig setting are minimum?
> >
> > scripts/config -m NFC_NCI -m NFC_NXP_NCI -m NFC_NXP_NCI_I2C
> >
> > What about?
> >
> > scripts/config -m NFC_NCI_SPI -m NFC_NCI_UART -m I2C_GPIO -m SPI_GPIO
> >
> > Required?
> > Not needed?
>
> I2C_GPIO and SPI_GPIO has nothing to do with all this. What indeed is needed is
> the pin control of the actual Intel SoC (unfortunately I don't know what
> exactly you have, so, you better to check yourself), something like
> CONFIG_PINCTRL_SKYLAKE=y.
>

I played a bit with the Kconfigs...

scripts/config -m NFC_NCI -m NFC_NXP_NCI -m NFC_NXP_NCI_I2C

...is sufficient.

I don't know which CONFIG_PINCTRL_XXX is needed.

- Sedat -
