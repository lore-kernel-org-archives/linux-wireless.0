Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F4AC10F03
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 12:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C780120830
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 12:14:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OkyzyYBy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731088AbfCYMOc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 08:14:32 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45145 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730789AbfCYMOc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 08:14:32 -0400
Received: by mail-qt1-f194.google.com with SMTP id v20so9842948qtv.12
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2019 05:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=C9CDfFxMfUTYuuCikAQPPiVQlf5d82yQXi43V6hx7hw=;
        b=OkyzyYByVXzR9X8KH0yiAte6B+lcki9xwEFcjrFlIR/aj/7vZTDUFdfNaR9i0yXIuQ
         CnJ2XrQ4raiHBsRJblRZN+gOqzight8vRK+P9RkrOGZ6vyDI8terC5x2P5XEDW+7SMGN
         XXRJu1c3eWubX4S6ZsEdOeZWQzMGcms6JRd6tkQ5eSUkz1/VVOAXZLU8guB9hYlap58G
         LspknjDw9nz2R27pimF5ePfIKIkCOAw3PGTz7s8nCS2uVzvyXBoRhW8ErEgag3aVCKKs
         bxnO5Y6o4B4tprclD0odBTm9jtwdMImfSc8TI94RfSCySw1LlCajkghxj7MXikV/9jMM
         vv7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=C9CDfFxMfUTYuuCikAQPPiVQlf5d82yQXi43V6hx7hw=;
        b=hxwLiy00q4rO7g7i/ecPnXT39Cd3sVlrGll3hOF1YNlLetMi1UEhh1JJ8Cz4xQHZLu
         YOAbz01AaK1VsGZbLLMTxVb8zz7tSKCLe6lrzWcnOqcpP88nNZTFdHot1QgmXAmo3aBH
         OFav9pi4AkG1G5xnQKB60KTNU5PfMk35SHV20roci1avHR5i2ykNfE+EYCG2RzUocKtC
         85OOhEOtNXv2Hy1w5Cw9kq90TQJE0h0mtwMQMaP+KT67jv8NQqINR7iWK3UoA05LHLYa
         cx9iNedQKjck4uZybsyHzl9bdcTQndewFtqn1MJFHFg0SvS3FeoLDzXd1P63pMJ4p6wR
         xQYQ==
X-Gm-Message-State: APjAAAVZxOsS5HfzY6iRoAtP5VaRYGN3/mzLNlwT5fAdzDUtzNO6VrZa
        ASgjWPai+gbQN8mSunXxiLZ5Bot2k485U3KuW3E=
X-Google-Smtp-Source: APXvYqw/HhZf4Qp+0qIppSxD+ykqiZWbc36+fuG5jP/Zz9o6jvXDKQgfwrvsilJ0+D/LNgzgJCRl4HySzNb2Nz6/Umw=
X-Received: by 2002:ac8:266d:: with SMTP id v42mr19565660qtv.116.1553516071287;
 Mon, 25 Mar 2019 05:14:31 -0700 (PDT)
MIME-Version: 1.0
References: <1553281120-22139-1-git-send-email-pozega.tomislav@gmail.com>
 <3337086.qEUs9xMCTV@debian64> <fe853ec8-0dca-d931-8632-fbe4df5cfaf8@broadcom.com>
 <edc38f32-977a-53f5-babd-605775326a20@broadcom.com>
In-Reply-To: <edc38f32-977a-53f5-babd-605775326a20@broadcom.com>
From:   =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Date:   Mon, 25 Mar 2019 13:14:20 +0100
Message-ID: <CABvG-CUXHgJ1ZUfsZw6ajzR=4DjnRRNrPmF147mZsoWJBjp-jQ@mail.gmail.com>
Subject: Re: [PATCH] ath10k: reset chip after supported check
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        =?UTF-8?Q?Tomislav_Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        openwrt-devel@lists.openwrt.org, Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 23 Mar 2019 at 08:20, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
> * resending with corrected email address from Kalle
> --------------------------------------------------------------------
> + Micha=C5=82

Thanks!


> On 3/22/2019 8:25 PM, Christian Lamparter wrote:
>  > On Friday, March 22, 2019 7:58:40 PM CET Tomislav Po=C5=BEega wrote:
>  >> When chip reset is done before the chip is checked if supported
>  >> there will be crash. Previous behaviour caused bootloops on
>  >> Archer C7 v1 units, this patch allows clean device boot without
>  >> excluding ath10k driver.

Can you elaborate more a bit? What kind of crashes are you seeing?
What does the bootloop look like? Do you have uart connected to
diagnose?

Didn't C7 v1 have the old QCA9880 hw v1 which isn't really supported
by ath10k? I recall the v1 chip was really buggy and required
hammering registers sometimes to get things working.


[...]
> Looking at the commit subject makes me suspicious whether this is a
> proper fix.
[...]
> It seems to me the chip reset was done explicitly *before* reading the
> chipid for a reason.
>
> """
> ath10k: reset chip before reading chip_id in probe
> There are some very rare cases with some hardware
> configuration that the device doesn't init quickly
> enough in which case reading chip_id yielded 0.
> This caused driver to subsequently fail to setup
> the device.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> """

Good catch, Arend!


> Might be the ath10k_pci_chip_reset() function needs to be modified to
> work properly for Archer C7 v1 units.

When driver boots up hardware is in an unknown state. It could've been
power cycled or it could've remained powered via pcie aux while host
cpu went through a warm reset (eg. watchdog). For what it's worth it
could still be beaconing if that is what it was doing before host cpu
reset. Therefore the device can be in a messy state and it should be
reset before talking to it or else you risk reading garbage.

I don't recall details about this particular commit but given the
timeline of commits at the time this change suggests this was related
to supporting qca61x4. In other words your change risks breaking some
qca61x4 chips.


Micha=C5=82
