Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D427C10F13
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 17:27:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D461820870
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 17:27:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qpNmGu65"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfDHR1T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 13:27:19 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46935 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726625AbfDHR1S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 13:27:18 -0400
Received: by mail-qt1-f195.google.com with SMTP id z17so16344256qts.13
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2019 10:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=d8jn1YGlWhiuWBR3DvJWnW7WANKlxRYmrrj3SF62lZ8=;
        b=qpNmGu65AFRKlxeOxXz4Cly2PleOfGOo97Wi0efZQAruI8ISoTXnMoggMQm49yjXZb
         mQo3OP0rJYQIFWIRNRNjp3Gk8Yyd+L+yo86BEkBg4iT7TJe3f+Q2B1gD2NkwHM1F4s4o
         un5rPLmHEOJMqxfz5jOgizFdlf9ZSolB4MpdM+jOGcwsWFL9QLDdEmTPi62mZKx9zNwj
         Sn+khDkM9AodLOzOk+UEhOMkBrwyDsa+UDCtav3Z6iHWgTMOpt6LBIIBbXzA4WGGXoeG
         vuA9SxTxE93pSZQqXafR89JfC2B943FCsjT0cAhg/lsnJ/zLzGu8V3xOxT65q3JfQIoo
         IqZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=d8jn1YGlWhiuWBR3DvJWnW7WANKlxRYmrrj3SF62lZ8=;
        b=DqWcL9kLvpiThJ3Vu2ep+8DjYL0Nr9t0x3qqz0Yf2+54MfJ2NsjmCJoWk67H1aW4HW
         rzbl8fvH+T/KdMK3Li3TNshUuKpsQ9O+H0Ci2uXobAuHFdhWzdmK7zAyTiLb23LBwW9U
         zpwGAUgZomeZfHAzh971nCw5XBM33vPLjTjK/bpQt6aE2ES5YFQx0FD5BVN/8/TrR3ln
         lDJCvfFlrdpXhmjWv8KKu04fws9lEwruFQOjr7X8Q7rIWKveyCS3BNwJFoYhxV+irTuH
         Mo2mVhxnvVEQd8OPhwGUZF68B3ChGX3xf3OjpJHeHmLd9bLh2tWSua+oVBIZNzVsBRp9
         xdJg==
X-Gm-Message-State: APjAAAX9KnALPrX/mjsepEdqqk5ThyWSja3VG/6bFXdBL06+WL5bhbQd
        Q0HHoGRI+ep54ohPaqT60RI1sgIleW4Wnkb2wRM=
X-Google-Smtp-Source: APXvYqy2aauUmMP32rJ/BZqPE+YyWrjDh7D2BfKx1cDnm8oPtZD6Su5LgZFri1IZZGVnA0HPmXzCEr0QOsGEQi/KOxQ=
X-Received: by 2002:ac8:2843:: with SMTP id 3mr26523736qtr.327.1554744437871;
 Mon, 08 Apr 2019 10:27:17 -0700 (PDT)
MIME-Version: 1.0
References: <1542163824-795-1-git-send-email-wgong@codeaurora.org>
 <CABvG-CWg-VXAtoN8HZumW-ZdP6dX9cO_8fWJ58C22kD2yDcXdw@mail.gmail.com>
 <195f3bb0c88c43a6b1ca0ad336f947c0@aptaiexm02f.ap.qualcomm.com>
 <CABvG-CWAfB8jjCDW4ggjJ8_YC++CjttJOMOt4s24F3mymvNR9A@mail.gmail.com>
 <02904ba8682441e1a89668c1345cbec9@aptaiexm02f.ap.qualcomm.com> <54b4dab1191d41b8b329f3ceb7017626@aptaiexm02f.ap.qualcomm.com>
In-Reply-To: <54b4dab1191d41b8b329f3ceb7017626@aptaiexm02f.ap.qualcomm.com>
From:   =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Date:   Mon, 8 Apr 2019 19:27:06 +0200
Message-ID: <CABvG-CWz0rBCXfF7mX9L62=fmdcYhpOaO5JNLtvSE87o_XJFng@mail.gmail.com>
Subject: Re: [PATCH] ath10k: Remove ATH10K_STATE_RESTARTED in simulate fw crash
To:     Wen Gong <wgong@qti.qualcomm.com>
Cc:     Wen Gong <wgong@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 8 Apr 2019 at 12:20, Wen Gong <wgong@qti.qualcomm.com> wrote:
> > -----Original Message-----
> > From: Wen Gong
> > Sent: Monday, April 1, 2019 2:11 PM
> > To: 'Micha=C5=82 Kazior' <kazikcz@gmail.com>
> > Cc: Wen Gong <wgong@codeaurora.org>; linux-wireless <linux-
> > wireless@vger.kernel.org>; ath10k@lists.infradead.org
> > Subject: RE: [EXT] Re: [PATCH] ath10k: Remove ATH10K_STATE_RESTARTED in
> > simulate fw crash
> >
> > >
> > > If it's still bothering you then please consider a crash counter
> > > threshold so that, e.g. after 5 crash-while-restarting it's going to
> > > give up. However I doubt it's worth the effort. My experience tells m=
e
> > > firmware crashes during recovery are rarely, if at all, transient.
> > >
> > > The simulated fw crash is not representative here. It's a mere tool t=
o
> > > test driver code.
> > >
> > Hi Michal,
> > There have a stress test case for the simulate fw crash, it will simula=
te fw
> > crash
> > in a very short time for each test, this will trigger the stress test f=
ail.
> > The simulate fw crash process should not be run parallel, after this pa=
tch, the
> > Stress test case will pass.
> > >
>
> Hi Micha=C5=82,
> Do you have some new comments?

My original use case was to be able to exercise the driver's
robustness in handling nested fw crashes, IOW crash-within-a-crash.

Your test case, as far as I understand, intends to perform
consecutive, non-nested fw crash simulation stress test.

Both of these are mutually exclusive and your patch fixes your test
case at the expense of breaking my original case.

To satisfy both I would suggest you either expose ar->state via
debugfs and make your test procedure wait for that to get back into ON
state before simulating a crash again, or to extend the set of current
simulate_fw_crash commands (currently just: soft, hard, assert,
hw-restart) to something that allows expressing the intent whether
crash-in-crash prevention is intended (your case) or not (my original
case).

This could be for example something like this:
  echo soft wait-ready > simulate_fw_crash

The "wait-ready" extra keyword would imply crash-in-crash prevention.
This would keep existing tools working (both behavior and syntax) and
would allow your test case to be implemented.


Micha=C5=82
