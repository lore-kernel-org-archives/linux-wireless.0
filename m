Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67108C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 10:10:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33F3121B1A
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 10:10:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C+QFfdIj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbfBOKKs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 05:10:48 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:41651 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728633AbfBOKKr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 05:10:47 -0500
Received: by mail-yw1-f67.google.com with SMTP id q128so3486979ywg.8
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2019 02:10:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UTQfL11dbdU+NE+1BvBUj+IVMaczSy5EV5MR6oYIOLs=;
        b=C+QFfdIjagUiPLuxOZ+0v5Ogcnk2VQskEYU1QdsP5+IGs42JjMYmonMyN2c5/bMckr
         zR0Wd/ZLv9/Ck3YfNmW/ZCXv7WP1h0EjA79oyB/RDb1qkFOGeJODFj1wtqO97WwE7qw4
         reJOCgpCeAABj9vh5v1eFgScVz+0ycUBmYtqloNi6XeZlx3D4xc4WCfwy5VNDzFQJbMD
         OUqh7vHDZ7HCTk0ZC5oqixf8/MZkUdpN9Uc91/I80W493AAu7T7fMD0eFz1crESJWy8K
         DghJF3lqealJJ1DFpyM7yxLROVgvqyBqn9hNbukGC5pKbzyDDDoOJCn7CAF5jZaMBGjB
         R4Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UTQfL11dbdU+NE+1BvBUj+IVMaczSy5EV5MR6oYIOLs=;
        b=mANZ63dWwBG+KDBwETwA63Wjso5jFNw6b7m/A3i2zGD+5Zv9p18BXRgDEVnp0kL9jR
         fLLqQ+wohJvxWXSCzBbVWe/AjZV7jbj/LHlM3Z2iqpqKoHS3nSlDGXAlVqad76m95VcK
         EdUS9kOkUBcuGfWNhRYGTaEtGfVTwN9spC22eWdp8WNlY1YqCksJE4ZVK8mbd8aIrg5C
         CtuCDotZRMP9/urlvbLct71w0pW4Vizq0sP2uP9Nf4opys4GwFPuWymRdSy1hOk5uRN0
         ZJbXlyW08Dtnmd8KWOf71xyxU+AGz9I8WtA0nuFokn54wQwuWx0P1rI3P995rhGcWk8r
         RbUA==
X-Gm-Message-State: AHQUAuaaESH+JA59e/kg+2B/XBw/1zanYffMpba8wKwu0HqRL+cn70DF
        uLULF1vMsA6f3zmKp95durUc1pQRJtjJacnRIms=
X-Google-Smtp-Source: AHgI3Iak7NgBNJHnxRi4YMlJ4bR9rpi76cL1OyI+pvLTrsBjdu+EBw6hhcVcGBTeAcovvN/WFZ29pZ2q5bPbwhtym7A=
X-Received: by 2002:a81:24c2:: with SMTP id k185mr7247315ywk.179.1550225446736;
 Fri, 15 Feb 2019 02:10:46 -0800 (PST)
MIME-Version: 1.0
References: <20190214125758.11943-1-zajec5@gmail.com> <20190215064345.11946-1-zajec5@gmail.com>
In-Reply-To: <20190215064345.11946-1-zajec5@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Fri, 15 Feb 2019 11:10:35 +0100
Message-ID: <CACna6ry=mPipNw0u16Um6vij_DV5A-M0G++16WAAO3bZh_qjuA@mail.gmail.com>
Subject: Re: [PATCH V3] brcmfmac: use bphy_err() in all wiphy-related code
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        <brcm80211-dev-list.pdl@broadcom.com>," 
        <brcm80211-dev-list@cypress.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 15 Feb 2019 at 07:43, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wr=
ote:
> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> This recently added macro provides more meaningful error messages thanks
> to identifying a specific wiphy. It's especially important on systems
> with few cards supported by the same (brcmfmac) driver.
>
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
> V2: Fix one line over 80 chars
> V3: Pass drvr to the brcmf_fweh_call_event_handler() to make getting
>     wiphy 100% reliable

Kalle: please kindly hold on with this patch until we're done
discussing bphy_err(). Mark it as deferred maybe?
