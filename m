Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6CAEC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 12:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEA8D2086A
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 12:20:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZXFz7esG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AEA8D2086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728472AbeJLTwU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 15:52:20 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37614 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728145AbeJLTwU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 15:52:20 -0400
Received: by mail-ot1-f66.google.com with SMTP id o14so12185508oth.4
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 05:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=CK33Xxm1OoIziIrCsvEKboNbOeFakhxUI+vGl4cMUZg=;
        b=ZXFz7esG8vyIA6aFFjvILU7ajeIr15ksAqhyLYj7Asi/EEMysaehdJzkQp0CRrnco+
         DRBl57CUH8lPK9IsfftMrN+pa6JU6HtNP6ZfFA6Ylv8/4KiPBeRv10kbF91BugZ4ZLQ2
         aA6QNCv0LjVBM3jzNG6XDJ8e/TSLZ+UX8Ch0jTX3Il/grsd75GJcHr5fwcZCSeyWMxGu
         DaEH6bN8eLjT3TcehO86F9ISjajj0/qglx73gEpS/5Ce4lUdscZC6z7jI3rurYaUhmHg
         hEH4SzWsK9Vo5TaXG/bZzoAsYL3GlvJ+03GqsVWG/t5Q+25HxZchpA9Sz9mQkGzm+tdt
         x0Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=CK33Xxm1OoIziIrCsvEKboNbOeFakhxUI+vGl4cMUZg=;
        b=a/zJlNg7cOLVhn2Ljp9N3RKwo0h3GsMWIBPLGAE5cDMWAuZXX2csyTFEHfGy5cUhIO
         8IaGgxFHkKZKR8yGnIMbXXGnB6Z3x+W6NFTzNF1cs4g9Z8+Ag8kP67LLA/dT421i0qzZ
         Yw3Th77t+P3xwj9d5X8Y6gn43qB0pXTc0wO247hQPH39Gt1XKOJKfV3i2D78aSWjKmdr
         mWZuLMda0MJHgxrrbMgiFWkEmd6AAx7CHS7PU/kMkZiLOSmI0rN4BX0OiN94kmZcRRtn
         S0cEr4DuzZJFQhFlTivGLEUmijb9yv3nF6Wmjhj1C929cSfM8NQ2U7jqikTISDCA+WaP
         bYwA==
X-Gm-Message-State: ABuFfogBcdSpCcm0bwkQMSnqf85XgKFK6TbYgs94jPe4LXw+ThRaY5LF
        SGZgz5ewkNuK4K7HDIlK80QJl7+OG+TLrsjX/KyXkQ==
X-Google-Smtp-Source: ACcGV61JKPHWTnpfoy5wb/uEil1N68Mk7oXXupYhUe6QA6sNLo18u3bq1WtI+69N3nseCFRTaCht/gj0S1BUh7p2OMA=
X-Received: by 2002:a9d:7455:: with SMTP id p21mr3380864otk.247.1539346807612;
 Fri, 12 Oct 2018 05:20:07 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2eab:0:0:0:0:0 with HTTP; Fri, 12 Oct 2018 05:20:07
 -0700 (PDT)
In-Reply-To: <20181012120329.GD2118@redhat.com>
References: <1539334591-9965-1-git-send-email-sgruszka@redhat.com>
 <1539334591-9965-5-git-send-email-sgruszka@redhat.com> <CAKR_QVJ60VTDjyC59BEDsRKrKR495xjGwob0QqvX333L+L+=Zg@mail.gmail.com>
 <20181012113656.GB2118@redhat.com> <CAKR_QVKU8ZFs6SC0Bm8VFKv82uNah+mZMKfCqCB+PRe6Ew2pcA@mail.gmail.com>
 <20181012120329.GD2118@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Fri, 12 Oct 2018 14:20:07 +0200
Message-ID: <CAKR_QVKKiRFASfB=Rs7eUXKNt-Sqm7dTp2tBikOBatJxKvkJ0w@mail.gmail.com>
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

On 12/10/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Please stop top-posting.
>
> On Fri, Oct 12, 2018 at 01:51:00PM +0200, Tom Psyborg wrote:
>> it will cause regression on other devices
>
> How exactly ?

the same way your wifi works without TX_SW_CFG entries and mine
doesn't, while both are RT6352

> On upstream tree where this patch is intended
> additional registers where never programmed as proper branch
> were never used, because of additional check in RT5390 branch.
>

on my hardware additional registers were programmed in regardless of
redundant check. that why i opened whole thread on forum since i
couldn't understand how's that happening

> Patch does only change TX_SW_CFG* regs values for RT6352.
>

i'd still prefer that we include CONFIG_RT2800SOC, and if required
move rest of the registers to that check, because at least on my
hardware driver would still recognize chip as RT5390 despite the
RT6352 defines
