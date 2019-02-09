Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE2D7C282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 12:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAF70218D2
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 12:28:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZtQXPBdB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfBIM2d (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 07:28:33 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40005 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbfBIM2d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 07:28:33 -0500
Received: by mail-ot1-f66.google.com with SMTP id s5so10393538oth.7
        for <linux-wireless@vger.kernel.org>; Sat, 09 Feb 2019 04:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=oyum7+BTPKcakqSAz0WIvlIRDvcgczBnqFLGaAWN/Fs=;
        b=ZtQXPBdBTmZT8j6ZKTZr2ILdVyIHTWIvk8zxwOSi7d1+59hTcOe4FLC45WZq0E33bV
         vwDSizgTpNJcF4PZwsryFxHNwz3JCaT2xGoCUThiu2Qg5CGmH/KowbIywlbv9I9SpFVg
         MU+9G/v7v8sG261TRt3UxozxjFOGykajVpFhLSBHdn6ZJFn3F1D2kv+iEHAz7Fdd18Fd
         PFF149IJ86DpxbDfTUVoTxxFFgJN16vrsUdsoAwAgYEr5BfloHGuo2Y4ANzgal+5dEwn
         JSZUK2SJXbYUwCQFYivYPSV2ZTIEgobd9P5nlwVhEKXxuIOPkvbX3RlTJmIxgBjuu2bk
         /xiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=oyum7+BTPKcakqSAz0WIvlIRDvcgczBnqFLGaAWN/Fs=;
        b=olON2bS+UVCgqhqhge3SQ19Ri6aUzixeyH4Qzv5D16B5kuSxxDhGdDs0C2h98DUzVC
         lPh/o9Xq6S4EYubtcMvwo7nWRf1NrCUQkWyzW+G4wi3jsctyYJGoftBw+8AdccUpjW+e
         Vtbz6KtqXy+9gyGIhDpZ3UfUo88tS67fcf6a8i+iF1Y5HxI/sgaeWP4V9DSlcZbNVl8+
         deCbJudSAkLTDWV5Au4VMXnbtQlSMq62+82Fogiuj89huvlUBIqoqLhLwuav1l2CdaoS
         JtBV3N0UnmxRdUzzLvDpM3lSIud0ISiRUKRO4DTTkorGVkHVFKrOEYbPSzI0IBgAoYRf
         QWRQ==
X-Gm-Message-State: AHQUAuYkVid1pWgeekpfws1NF8hNG1DwLTDseNO41ucR3EyXYfhEBaWT
        HDG0r2XqIEHL4mJUAz9cCSFLD9y60f1Ue9mdKFPbg1qiiFs=
X-Google-Smtp-Source: AHgI3IZToOgNmLy89znKR6sJdoGyZBh7zTKK2oDRJ1AGaF/xvhebQyARH8h+G6ec3YJ5QpG6Rnl4L1ZTIQHnFHxG+YY=
X-Received: by 2002:a9d:63d0:: with SMTP id e16mr15075176otl.322.1549715312741;
 Sat, 09 Feb 2019 04:28:32 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9d:4b14:0:0:0:0:0 with HTTP; Sat, 9 Feb 2019 04:28:32 -0800 (PST)
In-Reply-To: <20190209115628.GA16082@redhat.com>
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
 <1545318971-28351-3-git-send-email-sgruszka@redhat.com> <CAKR_QVJeteexpQX=pJm17WrrarmihYw56hKuTbsNagbcA6U96A@mail.gmail.com>
 <20181221095938.GA29536@redhat.com> <CAKR_QVKQMcGGpY_3ur9kFjuYpaKgca=YfUJxjSjLEfP1HELuJw@mail.gmail.com>
 <20181227102535.GA25885@redhat.com> <CAKR_QVK_2j6a9YiwUEKuWF+ss0-pr808Sr=AUrX4a6L3Zw=F0w@mail.gmail.com>
 <20190102081934.GA5300@redhat.com> <20190209110259.GA14900@redhat.com>
 <CAKR_QVK7N_NGFR+_2+6fP5iZ0j3dDbvdxJOQt3Yjwn7DMBUfYA@mail.gmail.com> <20190209115628.GA16082@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Sat, 9 Feb 2019 13:28:32 +0100
Message-ID: <CAKR_QVJtQdRcbRMV+WDKw=N2CxLhUSo6hE8mUME2orD6JEMAmQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] rt2x00: do not print error when queue is full
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 09/02/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Sat, Feb 09, 2019 at 12:11:03PM +0100, Tom Psyborg wrote:
>> Can you reproduce interface freeze with this patch if you enable debug
>> options to print all dbg messages?
>
> Haven't tried that, but I expect enabling debug messages will
> cause troubles at hardware where printk make CPU hog.
>
> Stanislaw
>

Take a look at my comment from 23.01.2019. on this link:
https://bugs.openwrt.org/index.php?do=details&task_id=2018
There might be a chance dbg printks do not cause problems.
