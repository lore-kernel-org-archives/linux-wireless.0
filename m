Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819F7C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 11:51:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 370C820868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 11:51:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YuhGY94i"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 370C820868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbeJLTXG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 15:23:06 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:43675 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727816AbeJLTXG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 15:23:06 -0400
Received: by mail-oi1-f195.google.com with SMTP id s69-v6so9619204oie.10
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 04:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=SK3ERz6Oguwej6LJUTBUsD3xJkbO9a8jShuAT9SaDpo=;
        b=YuhGY94io2WoZXCYgXx04F16e7NDEEhNynYnbM22MVAJVThNTMoqcBXdltB/SYONHi
         tDnodUX1GKAGZm6My4FCi51eerT9grQ3e2pOhvLeEunDSxjvCKWE3vr6bFqB9rDMujiJ
         M2rsEvysupwXBe5vNPWr+qbsiPPGj21O+i7x+eY2/zeW3Y+VzC0dlfSMYZupmWSXMG6R
         x7X+4hHiVQ021cOX3vesP3ABkqPaKhGdkFGRNEimy8CEXP63Le9mRlQ1q9t948ZL+BO5
         Wu2zAtvEzHhCDfMsHo04tnIQlQwglWtH4PdwdEMMvqrQVxLppihhYa5wZz04Me2ycBKj
         RUKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=SK3ERz6Oguwej6LJUTBUsD3xJkbO9a8jShuAT9SaDpo=;
        b=A0m13n55tW6edwTftGRFiyCDwted6Mq9onhnb0uTPYFp4FKjnnuNQpMPnuQhbzXSGx
         1/D9tnzZV2Nt2kU9RlSe80T7GRmju9q8lXZMEx9H6suf7w766v3JyFSwsEM7HdGvrHK3
         RCDd5O2zAJG1TIRIHsbzpbkNTLQZ8kmkmwq64i7oi5Ol0yShBvxe2fPFBFKZ2BbsgnVE
         wYp+xSwcpLX6sn1gfuwFE+48/kDUfFa9T/ovFBqPLB0vHqNytRa1SNpSDqLoCawDbKKc
         cjA53JsL0ErPILwpu7fbaGvgVP7nf8+KiPENSvbTrivyz2ORoL+g0tzUNEnlpCZmopEk
         9z+w==
X-Gm-Message-State: ABuFfohA0wAzuhwbF1OdJArGru4jz4zXXLFYANW0O+6nm80Lsz7Mg1Sq
        L2dYP1A13CHjB3/IVjwSuViwKe4uJJeEbme4Uhk=
X-Google-Smtp-Source: ACcGV63qmEGjKSbSS2/GaOUo2fXqJppCD1CADIIuPtn2eIJr5a0Hyp9T5lKdXIftWNRO/7aJr6/YysekCDt1jZ9KRVc=
X-Received: by 2002:aca:d9c5:: with SMTP id q188-v6mr2890296oig.212.1539345061209;
 Fri, 12 Oct 2018 04:51:01 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2eab:0:0:0:0:0 with HTTP; Fri, 12 Oct 2018 04:51:00
 -0700 (PDT)
In-Reply-To: <20181012113656.GB2118@redhat.com>
References: <1539334591-9965-1-git-send-email-sgruszka@redhat.com>
 <1539334591-9965-5-git-send-email-sgruszka@redhat.com> <CAKR_QVJ60VTDjyC59BEDsRKrKR495xjGwob0QqvX333L+L+=Zg@mail.gmail.com>
 <20181012113656.GB2118@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Fri, 12 Oct 2018 13:51:00 +0200
Message-ID: <CAKR_QVKU8ZFs6SC0Bm8VFKv82uNah+mZMKfCqCB+PRe6Ew2pcA@mail.gmail.com>
Subject: Re: [PATCH v4 4/8] rt2800: fix registers init for MT7620
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

it will cause regression on other devices

On 12/10/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Fri, Oct 12, 2018 at 12:48:07PM +0200, Tom Psyborg wrote:
>> chip version support exist in daniel's tree since a long time ago. so
>> don't disable registers initialization but try to upstream his
>> changes.
>
> I do not see reason for for blocking this change because some other
> changes are not unstreamed yet. When chip version support will
> be unstreamed, the register initialization will be unblocked.
>
> Regards.
> Stanislaw
>
