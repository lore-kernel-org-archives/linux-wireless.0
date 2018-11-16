Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7A66C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 07:56:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 906D0208E7
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 07:56:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IZfymoLH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 906D0208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbeKPSH4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 13:07:56 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44967 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727405AbeKPSHz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 13:07:55 -0500
Received: by mail-qk1-f196.google.com with SMTP id n12so36041722qkh.11
        for <linux-wireless@vger.kernel.org>; Thu, 15 Nov 2018 23:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eeuFkII67GkFjUWaUfcGHlwqG02iZ0q1NQjRvROMQro=;
        b=IZfymoLHmKMDbi6zPa/s9ICDQoU59egdbbQToRGqEWUMfDZDI+CUzRJvSpQ+wu4gJh
         DKvIFChd9ktFfOgQJtaaltyFG0U5Eov53YLZnxdLv1slabGqeUCBq/+ghEU7b7gb0qtP
         vZOkvHap6msSwQbBQSprLg9kos4rKq+1z4Okf2n7LLMtZf6E3pGJ/UaBGlsAjX3D6zR/
         Alza8SRBkNKEXvJAT+1K8/4flhv+uGn2Kk9osUeLEUZr8EZ86zhOvIKI7GP5Z/KGev5h
         UNcXXhiV2B3EjE4qslJH33h4z3vQyYqlF/rdr4XasIal057bxwm7p0BsrkFdF5tNuJMy
         SNXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eeuFkII67GkFjUWaUfcGHlwqG02iZ0q1NQjRvROMQro=;
        b=hT9E3fM0XVpMJYhfUzlwVdBOn7slKIzjPmJa2wiWHx6xtJ5qdL8C7roBwTTV9qNvcC
         R0Gx56Nul7OaQ5nB58wKSRGLl+r8CRV4hlBIGMyBqb0TDGXT0N/GOlrUo/+qcL6UcLjH
         OwoOS5Zfyx9mnzx5jCkDrd+ese50zZjExsdBjfpdVwkueZI6Ooh8odjUI0YHICxNrQub
         0B0zC/jcDgr3vfXHu9IAprhUqtrqq9gLf8xqinJiTHY+7VaPDQqaliS6Ho6RmBsZ+EyR
         Vjj08re9Hww36pU5riIyd40WBg+PisEU/L2uHR9kFxkS/pI0ig2uQKnUGjSZYHt/C1UO
         i8Mg==
X-Gm-Message-State: AGRZ1gLnhf0lXVP6bmAb8e/ry0PjWELCoWun/UFWjJF3uus3fzdrZYp6
        m8WipnoJMr9t2GcCe7vsZz/zsITVcLBTE8+HwYo=
X-Google-Smtp-Source: AJdET5eeE4RiQ3WES5ocIAMuFs4dF1Vz8R8fsAcdkLhrv41bPiyJpDFQp/35H2Z3I6GKltcWSXevvtXPPc1cUdVOGII=
X-Received: by 2002:aed:2c87:: with SMTP id g7mr8992018qtd.52.1542354999852;
 Thu, 15 Nov 2018 23:56:39 -0800 (PST)
MIME-Version: 1.0
References: <1542163848-837-1-git-send-email-wgong@codeaurora.org>
 <20181115002836.GA71934@google.com> <c94346b26a6d4b11a045a176ca854051@aptaiexm02f.ap.qualcomm.com>
 <20181115184333.GA87504@google.com> <87va4x8q2c.fsf@codeaurora.org>
In-Reply-To: <87va4x8q2c.fsf@codeaurora.org>
From:   =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Date:   Fri, 16 Nov 2018 08:56:27 +0100
Message-ID: <CABvG-CVAnwkiKVJik0PdsmRxF62kKv2N+aRKNq=nbopoExLvDA@mail.gmail.com>
Subject: Re: [PATCH] ath10k: support PCIe enter L1 state
To:     kvalo@codeaurora.org
Cc:     briannorris@chromium.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        wgong@qti.qualcomm.com, ath10k@lists.infradead.org,
        Wen Gong <wgong@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 16 Nov 2018 at 08:00, Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Brian Norris <briannorris@chromium.org> writes:
> > On Thu, Nov 15, 2018 at 06:38:25AM +0000, Wen Gong wrote:
> >> >
> >> > Is there some reason L1 was disabled in the first place? Was it know=
n to be
> >> > unreliable?
> >>
> >> Hi Brian,
> >> It is a BUG for power, and it is not considered this BUG before.
> >> So this change will fix the bug.
> >
> > I understand that the existing behavior is suboptimal for power, but on
> > the other hand, code that goes out of its way to *clear* the L1 flag
> > doesn't just pop up out of nowhere. Somebody clearly wrote that! If it
> > just meant "we didn't verify L1 at first", then maybe it's fine to
> > enable it unconditionally and see what happens, but if it meant "we
> > tried L1 on some old chip XXXX and it caused problems", then it would b=
e
> > nice to know what those problems were.
> >
> > Or maybe that is hard to figure out, given there's no public git histor=
y
> > tracking the original code, and we just need to try it out.
>
> Yeah, it seems L1 was disabled already on the first ath10k commit:
>
> 5e3dd157d7e70 (Kalle Valo                2013-06-12 20:52:10 +0300 2404) =
       pcie_config_flags &=3D ~PCIE_CONFIG_FLAG_ENABLE_L1;
>
> I don't remember anymore why but my guess is that the proprietary driver
> at the time didn't support it with QCA998X. Or maybe QCA988X doesn't
> even support L1? Michal, do you remember?

Proprietary driver has it ifdef-ed to enable/disable.

Older driver enabled it only for some station-only target/product so
by default QCA988X would build with L1 flag masked out. It made sense
to be conservative and change as little as possible to avoid random
bugs and breakage - so the logic was inherited minus the build-time
ifdef.

However 10.4 driver seems to enable it unconditionally. I'm not sure
if this depends on target firmware in any way or if some other host
driver or bus settings need to be pre-set before L1 can be expected to
work reliably.

I guess there's no way other than testing it out.


Micha=C5=82
