Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD44C04EBF
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 13:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D803E20851
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 13:41:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sWUDT0ux"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D803E20851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbeLCNm6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 08:42:58 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:55736 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbeLCNm6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 08:42:58 -0500
Received: by mail-it1-f194.google.com with SMTP id o19so9202040itg.5;
        Mon, 03 Dec 2018 05:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L21jGM7u+iENlwfO2G9IKDDo03+MfxFYIzJXo8ANiSE=;
        b=sWUDT0ux9k5N4/qay9/wJg9liP1shOOphDkf262qV95m/TPEKxkB2Ee+u+YOXL2rDY
         z+djXzb4DylF5BsZrDxjVWX/1fQi5cYtlbbm7x2kGS+QadeguklyOH6Qqzgjh5dW0+fs
         4mSydj6zB2sKY6LPuAYkRY5C/q9lbitcvN67kibG6IScRknBCSkhqW7XmZHye9iajxaG
         PV3breW6JEsmb0ixHaedusQ1DQ9uqj76F368Ir+S8OlziUGwF1TGnzoeC//zp570NkYF
         ReoOfflzTexf/ZkMUTSEtZ3yLLzUPQWLdnnDOZFy8OX1Kp22wXuImSnVx+huLdgB2oAl
         9b7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L21jGM7u+iENlwfO2G9IKDDo03+MfxFYIzJXo8ANiSE=;
        b=N93H3Etu9oPtcDeqY6E0sIqSMCjfVy3oCDKEd7aHGmN85KgtO+tISWbLp+iRcgxxcZ
         r8ERZBVNE8jFxTxMK1BralyOIPcFZwOJASMgQWsvBLDWyxxDknTz/DaAgn8Kvr1sVgqn
         kK8yvxuv1UEGHnRg2dgr22HaFM5Fz/W+I8U3HSKCSyAHqKPeGeoj0cwl6QZkTaz2n+bg
         5om8VgGl2JpmQgGzJ18wb2jee/sqS2olMDxu4eQQ0GNkJuc7+O/i7fQRJuQHAhmfyT3P
         bwRyrnVDrH26wC2iq9PsGFWRVC1QmWlu0J0PAPVtkKZHXaImsWWhs12qKl6oStxrlEqt
         QQQg==
X-Gm-Message-State: AA+aEWb4c1GVpIVEePi19WdgYyiBALLpYEohtaZ0aQcB3/NRh1YPuBhg
        PIRJhSPW52D5MEiBwpaiH7xo5dcqAtYDj5YqPSc=
X-Google-Smtp-Source: AFSGD/WoUtbRHKVPCWKiK9ErtjPyyjiGCyRsKUQ/yV4MMumrvDFIkz34fW77WoVN93Fnge/AnQINOF07+9HkiA+bRxs=
X-Received: by 2002:a02:5184:: with SMTP id s126mr13789663jaa.12.1543844513117;
 Mon, 03 Dec 2018 05:41:53 -0800 (PST)
MIME-Version: 1.0
References: <20181202093047.11174-1-tiny.windzz@gmail.com> <87d0qig4hu.fsf@codeaurora.org>
In-Reply-To: <87d0qig4hu.fsf@codeaurora.org>
From:   Frank Lee <tiny.windzz@gmail.com>
Date:   Mon, 3 Dec 2018 21:41:30 +0800
Message-ID: <CAEExFWtWCteDgt2vr2TcdreZu3SROKjPmZhucwSggjopEgO3Wg@mail.gmail.com>
Subject: Re: [PATCH] wireless: convert to DEFINE_SHOW_ATTRIBUTE
To:     kvalo@codeaurora.org
Cc:     merez@codeaurora.org, davem@davemloft.net, kubakici@wp.pl,
        Solomon Peachy <pizza@shaftnet.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        lorenzo.bianconi@redhat.com, Felix Fietkau <nbd@nbd.name>,
        sgruszka@redhat.com, joe@perches.com,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Dec 3, 2018 at 8:49 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Yangtao Li <tiny.windzz@gmail.com> writes:
>
> > Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
> >
> > Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
> > ---
> >  drivers/net/wireless/ath/wil6210/debugfs.c    | 240 +++---------------
> >  .../wireless/mediatek/mt76/mt76x0/debugfs.c   |  20 +-
> >  .../wireless/mediatek/mt76/mt76x2/debugfs.c   |  38 +--
> >  .../net/wireless/mediatek/mt7601u/debugfs.c   |  40 +--
> >  drivers/net/wireless/st/cw1200/debug.c        |  32 +--
> >  5 files changed, 64 insertions(+), 306 deletions(-)
>
> This is rather large cleanup so please split these per driver (wil6210,
> mt76 and cw1200).
>
> --
> Kalle Valo
Has been divided into several small files.

Yours,
Yangtao
