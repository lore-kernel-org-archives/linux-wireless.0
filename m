Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB5FCC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 12:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 910C22147D
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 12:47:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hfbDIHGA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 910C22147D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbeKUXWF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 18:22:05 -0500
Received: from mail-lf1-f52.google.com ([209.85.167.52]:46338 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729176AbeKUXWF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 18:22:05 -0500
Received: by mail-lf1-f52.google.com with SMTP id f23so3865607lfc.13
        for <linux-wireless@vger.kernel.org>; Wed, 21 Nov 2018 04:47:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TG9uigtN8r+YEIO/skt7grlJjigLu/lajOwS45qiVHU=;
        b=hfbDIHGAd42VfjK6tWDTrs1mF+jtIyqTymHQDaIQiEwI8YU+B+YzxACVuFMDyomPaU
         vvvLeyNdjePcrxqjRmgv1nsGxeN4pFCggkl6XVqx+DzhGL9k+GIowG53lJrvRk3Li6mj
         EV9xIl/e1oavTMNeXpbWmYnLY8LMWOUP6r/uFvyMXekbpWJ8YosGfQti6zjRwuFS0Uga
         bidyvCC9FSxXnyILzVRUUDSXlxfjpsAFq/bPoF481NVpN29SZK9enu6UYxxi9LsmHo1D
         z7SzOo8UfuDTuBW/C8Xc9HfJTgxNqsBe+jGI0McLAnnXbdQAUO3IuWxQaLn5aC69m1Ks
         EuXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TG9uigtN8r+YEIO/skt7grlJjigLu/lajOwS45qiVHU=;
        b=QLJeBnROyybad8vfELMgte59vaG6QerpNREPIlNSQr2wCqeu9F3uRtMZORJ08lI3W9
         MdJUTKvq+I2QMxGoN8Bs2z4RN/WQ8ylIM6RySpGvW9+t6NL64LpD1xDRe5CfSofEP7Ns
         5BUMiJmkAsHxPrGm4Z9Wh6HXMF/zp9F+MalXUlOQLXtFj1tH0Y49VwH/yh6piFhjAUWo
         G1uaw6wGL4pN/QWkfnvbCnG/E5j9qQy3v1+q9yTROhxBxqpLlfQAw12DuYnjS/01ABHf
         k9ZpeUkjJhxeMPH5TzjT0NEufUsErVYwrl3HyN2H5LaRktziJNQKFu+EeIoxn9A6hoTS
         RXHQ==
X-Gm-Message-State: AGRZ1gKSMdegWY6eG8MNRh/9E8VaV2RmNm0z42aRlMi5C7Lo+kbLEqqe
        Jt/GTlVu9VNDnyS3hTcY2ON8Uxk4OpMyqmN+PVA=
X-Google-Smtp-Source: AJdET5cymEiqpde2ub0TI7avs1rWemPIQbDUFPLvVlXJGA8bDY50lOet/pr/kgR1MtiDtdF+GFwzJLBA+UJ7tHxxlwI=
X-Received: by 2002:a19:4cd5:: with SMTP id z204mr3553938lfa.37.1542804468856;
 Wed, 21 Nov 2018 04:47:48 -0800 (PST)
MIME-Version: 1.0
References: <CAK8U23bW5ov=FfD0xBnio7FwS9NTjoyewfHWZhHAmZNPsA16Jw@mail.gmail.com>
 <a88ba8b1e23b5e461f492f050cfd67c0222cf662.camel@sipsolutions.net>
 <CAK8U23Yi-wa0yT_K2eazTBEsVH3kmYHpZEeMmoDEAdyamdSTqA@mail.gmail.com> <7adcf11c634f31032eaac3c15f8d92b366f14477.camel@sipsolutions.net>
In-Reply-To: <7adcf11c634f31032eaac3c15f8d92b366f14477.camel@sipsolutions.net>
From:   Ramon Fontes <ramonreisfontes@gmail.com>
Date:   Wed, 21 Nov 2018 09:47:37 -0300
Message-ID: <CAK8U23a8CMgNboStufh7kVpKSE9URkniWkpeNXi2hr1D3GunZQ@mail.gmail.com>
Subject: Re: mac80211_hwsim: multiple antennas
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Okay! Thanks a lot.

Indeed, the maximum throughput when using only hwsim is in the order of Gbp=
/s.
Em qua, 21 de nov de 2018 =C3=A0s 09:30, Johannes Berg
<johannes@sipsolutions.net> escreveu:
>
> On Wed, 2018-11-21 at 09:26 -0300, Ramon Fontes wrote:
> > Sorry. I meant throughput.
>
> Yeah, well. There's no actual medium (access) simulation in hwsim, so
> the actual throughput you get only depends on the performance of your
> CPU. 33Mbps seems quite low, but of course I don't know where you're
> running this.
>
> Then again, you say you're using wmediumd, so perhaps that *does* have
> some sort of medium simulation these days? I didn't think it has it but
> I may very well be wrong on that.
>
> Try pure hwsim (no wmediumd) and see if you get gigabits, if not then
> your system is probably just too slow.
>
> And then I guess you'd have to look at wmediumd in more detail to see if
> it has some simulations here? I don't know.
>
> johannes
>
