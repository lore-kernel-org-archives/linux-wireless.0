Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36166C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 13:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFA7D214C4
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 13:10:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h+vmOv4I"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EFA7D214C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730291AbeKUXoT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 18:44:19 -0500
Received: from mail-lj1-f172.google.com ([209.85.208.172]:35917 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbeKUXoT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 18:44:19 -0500
Received: by mail-lj1-f172.google.com with SMTP id g11-v6so4792474ljk.3
        for <linux-wireless@vger.kernel.org>; Wed, 21 Nov 2018 05:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QtK7akEQux4+PJdisZ1q+/7rDOWdVt9qWaCBUdEdYJQ=;
        b=h+vmOv4I9Wk4R7YXiXWGGFSIoJhdiBCL57vPSMvJ/2Uh5S309vdMwzCAs5cqihPWMQ
         txzqn3XSVoOjISgLbEE88aSNb65fV2EYP7zu8QKGyXneF9OWvnyW9dd9FrWBLCsWHBVw
         z/E+bBiVjAts+TokWk3QuaVvgmqb7bJaeJWMcBpDBc8kfvgt6dpuUyhhNAchlVtyiRv6
         WYOUeFAkdx4OayAMDWo00OHzizoZzm2P+u7DH2QPa5E2cf24FqprCE+2mAkzxJD+uCgb
         DxJA/sXAlsmwkRXZGq2CtWGunqEO6cSpnkxVg732Jkq3I8It37Rr6hjVH/QXMufttQGV
         iMhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QtK7akEQux4+PJdisZ1q+/7rDOWdVt9qWaCBUdEdYJQ=;
        b=FiDkiz3i4JyDPkOlG1icwiyjRvVhlu37QgqVpGgwsvd02OkHt2AisUd92LIl4bLDT3
         ctqCV2uvWAoE54qDMWozlgOW1apqZl785EjIgOdp7WETc1BYrOXmAD7WHfYaU6HwlNSs
         qZLuOkPnWLs107RS7C53h80pCs4xPhEK7/nFNlWmUq8rZ/9xmk7zl+2+Oq0xPsGvQU/J
         4DpIKjWPyfEcErWzUe9dhW8xHlXFx00RGQLjTKSMkZ+91E3wuXRU2MzHa+2afly6kgKC
         GmkFTlNBcFxp4uJ5pLhk2AwCKjWnnd1pGVf++VaX330xGNZhpIsC6kVXFMTwILzVF/N4
         GXag==
X-Gm-Message-State: AA+aEWb6qgEZeOcG+SoU5ffpxWLMnHbKebz80lpZ3KGkVF9GIhhZRyno
        XPwOGo+iCWPVqlHI6BakKfMMcxxkH2ZesA3TCGs=
X-Google-Smtp-Source: AFSGD/UbF9p5escbixdUasJMmltTErY/jS61fNLH/RJzIi4bqxS6r8UWve+bzxY1OWc1BdhTqpggK5cQ8Q/fVWoMLkk=
X-Received: by 2002:a2e:9819:: with SMTP id a25-v6mr4395359ljj.6.1542805798677;
 Wed, 21 Nov 2018 05:09:58 -0800 (PST)
MIME-Version: 1.0
References: <CAK8U23bW5ov=FfD0xBnio7FwS9NTjoyewfHWZhHAmZNPsA16Jw@mail.gmail.com>
 <a88ba8b1e23b5e461f492f050cfd67c0222cf662.camel@sipsolutions.net>
 <CAK8U23Yi-wa0yT_K2eazTBEsVH3kmYHpZEeMmoDEAdyamdSTqA@mail.gmail.com>
 <7adcf11c634f31032eaac3c15f8d92b366f14477.camel@sipsolutions.net>
 <CAK8U23a8CMgNboStufh7kVpKSE9URkniWkpeNXi2hr1D3GunZQ@mail.gmail.com> <4fa8dc82a0c64bc5521fd0aacaa9bf951984d81e.camel@sipsolutions.net>
In-Reply-To: <4fa8dc82a0c64bc5521fd0aacaa9bf951984d81e.camel@sipsolutions.net>
From:   Ramon Fontes <ramonreisfontes@gmail.com>
Date:   Wed, 21 Nov 2018 10:09:46 -0300
Message-ID: <CAK8U23Y_xFK7ajBbTJ0kWKZnhdEkmRgd=9kmfcB1sztNyHxHEQ@mail.gmail.com>
Subject: Re: mac80211_hwsim: multiple antennas
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yes. I thought that it could be related to the number of antennas (or
something else) after seeing this result
(https://bobcopeland.com/blog/2014/09/wmediumd-speed-test/) provided
by wmediumd.
Em qua, 21 de nov de 2018 =C3=A0s 09:48, Johannes Berg
<johannes@sipsolutions.net> escreveu:
>
> On Wed, 2018-11-21 at 09:47 -0300, Ramon Fontes wrote:
> > Okay! Thanks a lot.
> >
> > Indeed, the maximum throughput when using only hwsim is in the order of=
 Gbp/s.
>
> So I guess the question is where it's going wrong - is it the wmediumd
> overhead (netlink), some air simulation in wmediumd, etc.
>
> johannes
>
