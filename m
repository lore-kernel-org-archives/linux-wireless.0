Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB1FAC43387
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 03:44:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BFF12086D
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 03:44:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C2JmcaI8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbeLODoK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 22:44:10 -0500
Received: from mail-it1-f181.google.com ([209.85.166.181]:51896 "EHLO
        mail-it1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728260AbeLODoJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 22:44:09 -0500
Received: by mail-it1-f181.google.com with SMTP id x19so11876585itl.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Dec 2018 19:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4bu4mZb2rWCgK+FZ5E3yG79w2CM1UaZbqcg6shooIKk=;
        b=C2JmcaI8uTqWU39PZ6cOLfglQae2KBMhOCavZNT1Uepq6nvPMlm/KkP+jhwRR5uwld
         d9CqfT2Ubc6Eboj4bVEDSUhmPZzQJ3wb24dWAkRj2xHQ3WOGxDOTcw0O+u99AIvHUAW3
         1Kcbv9CnAfw1i9GycbvftKQxy+QwPCcmXlVU9PHalzDPPihyvT8pw6N0WOnKrNGpj05E
         mr2ZRdaiht+ulxOpWV2BUL056FRd1/ZrVVqqvtZuKMl5Zz3Gd7hZI46Gbw6jeQJSDZs/
         MNEh4D3JsHuE+i9vCDoQiiIgVHWpm+p6NEtIWv+JKyFQCZeS+6ULbcgirMRhXgCwouNI
         sFXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4bu4mZb2rWCgK+FZ5E3yG79w2CM1UaZbqcg6shooIKk=;
        b=MtBWGeKJGdG3yZ0NIifMC+TY/Z7dfiXESyjS2sFfI6dfqWm60/ruYQi4WV6Z7c4Lx5
         oRogaVASY0/rIORbrnE82Vjca+ysrGinPgLN04BZ5xHLm2rB1MvVolYGqNk+gddFYQmp
         z+GZiR0zTJs+PM3EezY9okGiBUDmxX9DaSCr7efq3RFxea8W7VDBONHMTFhS7JepHBUc
         yQg6/m2uZypudLGv+A2vKY6qxyfX6ULZWADKW1o7O9VqBkvDuSoWOYLOmwM6EMfyO+ly
         AhuA7F6lO+d2gFxzO6oyHXq46C1NNyyahYzZY79ugDN9nJuKrTFeaIhnvBPLm0+EsVcb
         WK6A==
X-Gm-Message-State: AA+aEWYrLc1Oc4oRNBFMVMxJHjxdw6o7+BBs/NEvBPUVD2Bg7zTwA0GB
        f6U61BcVEAYJAlzqUKjJ29FYqRQSar9tV23O8hQ=
X-Google-Smtp-Source: AFSGD/VF3yEof1mMS4NcAt1PpP2wmWmFNoklqZwdh+Ka9cx/M5REaR10L2m+xeKKHpMLk0pNQ0wV50k8euLu0n9s5kY=
X-Received: by 2002:a24:6c12:: with SMTP id w18mr6067429itb.14.1544845448750;
 Fri, 14 Dec 2018 19:44:08 -0800 (PST)
MIME-Version: 1.0
References: <CAM0KTbBUXJsBfO0=hQgeTGVteym6iuObdyNynWumQnnGY0L3wg@mail.gmail.com>
 <20181213143947.GA11947@localhost.localdomain>
In-Reply-To: <20181213143947.GA11947@localhost.localdomain>
From:   Sid Hayn <sidhayn@gmail.com>
Date:   Fri, 14 Dec 2018 22:43:59 -0500
Message-ID: <CAM0KTbCMrcXNFHUFEmoHg+nseN1GkegqAM0GSuWBDHP=gVgi=w@mail.gmail.com>
Subject: Re: mt76x[02]u 802.11w support
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        sgruszka@redhat.com, linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Dec 13, 2018 at 9:39 AM Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
>
> > Per a conversation with Lorenzo, it seems that 802.11w for mt76x[02]u
> > has only been fixed in 4.20.  As 4.19 is a LTS kernel, I'd like to
> > request that work be backported.  While the improvements in 4.20 and
> > 4.21 are already fairly obvious, a lot of people will be running 4.19
> > for years to come.  This is good hardware, with a working driver
> > (thanks team) but in the next few months excitement is going to turn
> > toward WPA3 which requires working 802.11w.
> >
> > Pretty please backport 802.11w support to 4.19
>
> IIRC the isse is just on mt76x0u, mt76x2u should work

I can confirm that it does work on mt76x2u on 4.19.5; so my request is
to backport 802.11w (software crypto I believe) support for mt76x0u to
4.19 LTS.  Pretty please :-)

Just in case it helps to confirm what is needed, here is the error
from wpa_supplicant when trying to connect to an 802.11w AP
wlan0: WPA: Failed to configure IGTK to the driver
wlan0: RSN: Failed to configure IGTK

thanks,
Zero

>
> Regards,
> Lorenzo
>
> >
> > Thanks,
> > Zero
