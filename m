Return-Path: <SRS0=SE/f=NZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE16C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 14:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B595F2086B
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 14:17:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VTZIxPaZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B595F2086B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732923AbeKOAU7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Nov 2018 19:20:59 -0500
Received: from mail-ed1-f43.google.com ([209.85.208.43]:35784 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbeKOAU6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Nov 2018 19:20:58 -0500
Received: by mail-ed1-f43.google.com with SMTP id x30so9071759edx.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2018 06:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=tizECldM+CLlvuX/5aVGuHjtcB+dUk0sBF4VU4Zlnc4=;
        b=VTZIxPaZGh2Swy3D9BkWwJblO6ZYXQP+hDv6PQvgbkxycpZH24D/5tt6GABotrG08k
         qA1C6BtnGnhukcIy4viNut4NX6V33f2+W2zMvka0cuIoTVOzmT3bB2k98/FOjCFn4eHr
         dUCFUDFI+ih6jGiX/JGrxwXbOJZrD744nJTaT8JgT1i+qRvw9OVG25mcL0+9ZZ/j7fyb
         feOpC6bwrFMDmfJ4csGGs/EB5AffXH/f89Fp9Sfsv0ThjhURUPNAHDrqYZyogKaOe3ez
         uA4cJTE8l6PUkn44lt+haOjM2I6WTbpq07qZtxQgO5xzTrreqOyakMtbKmjLAIlriTrW
         RqRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=tizECldM+CLlvuX/5aVGuHjtcB+dUk0sBF4VU4Zlnc4=;
        b=FPZpSz27v27y9woTUzP5UOMiMZAcqthUJ0xh2GTAi4QE86Wwu+l3NkeagPSBZqwlRo
         G7s5fzotLYukxK913DaGST3PiZ//aucdSVGOLVobdrgIr2kcrvp6kozlAO3NHEvoIwxe
         5UikuvPEQWRo1gaFCuZ3GNpsgst2n4HlawUDmd6vLwyYpZ1GOLz70ULj8Gi2/hg1szyZ
         uSlCpGdSKMyYa1fgoDfqiilNrZdLjp+PN48PFSek6LNxP6NHBQChhKRykSLsWFBgYR9m
         /iSwnZQmpM/QS5gJAPDuUko0NRyin8fjle93ewz0I9tF+ZklbdhfgdmMO4hzSiv9hdkq
         a1TQ==
X-Gm-Message-State: AGRZ1gLxpqWTeYLCgKtIPriSJc11kROMmhqUtAlpv/P8nMvNQm5Q3V8x
        U0rKMEDiZebyLibjdh1DT7ZHGg6qKKjFsOlgvFhyKWIjbxE=
X-Google-Smtp-Source: AJdET5f8jtS+ICmRHULDKE9fYf9SXHFSzT1zZZvTor5qaTRcZ9NlgDN3JrOPe/gcIXYvN7Q9K3JtZVx2e+uxnv3qxzg=
X-Received: by 2002:a50:b83d:: with SMTP id j58mr2409860ede.72.1542205051474;
 Wed, 14 Nov 2018 06:17:31 -0800 (PST)
MIME-Version: 1.0
From:   "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>
Date:   Wed, 14 Nov 2018 15:17:19 +0100
Message-ID: <CAE4vF2cgW41nX_PyZ_SG0ceStaLzjhY-fR35zHyTyU4V25EBkg@mail.gmail.com>
Subject: iw dev <devname> twpoxer limit in mBm or not
To:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

hi.

On ubuntu 18.10 using kernel 4.18.0-10-generic and iw-4.14 on a
Broadcom Corp. BCM43142 wifi interface using wl driver, i run

 sudo iw dev wlp2s0 set txpower limit 21

and iw dev reports back a txpower of 21 dBm

But the doc at https://wireless.wiki.kernel.org/en/users/documentation/iw#setting_tx_power
and the output of `iw dev help` states that the txpower is to be
expressed in mDm not dBm.

So I am confused.

Can I use
suod iw dev wlp2s0 set txpower limit 2100
wihtout frying my card ?

Moreover, how is that even possible given that I have set the regdom
to FR and that max output power is supposed to be 20dBm in Europe ?

Thanks
