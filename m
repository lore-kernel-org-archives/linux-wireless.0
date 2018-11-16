Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B676C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 20:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA4AB2086C
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 20:38:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XgSKLYRh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA4AB2086C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbeKQGwT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 17 Nov 2018 01:52:19 -0500
Received: from mail-ot1-f50.google.com ([209.85.210.50]:39333 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbeKQGwT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Nov 2018 01:52:19 -0500
Received: by mail-ot1-f50.google.com with SMTP id g27so22519539oth.6
        for <linux-wireless@vger.kernel.org>; Fri, 16 Nov 2018 12:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=SButerDLCsQDGPeEVESaZYRRpIEf4pP6XpvGnqv0994=;
        b=XgSKLYRhGNZjV9Y4qOcei4UKarn3aSKfW/9Z7AyKJZ63Q30gRJt3JPJUTCvCpnjwz1
         Mpu/uD//otBJqPVn2c0fp98pB/UMEc9G/2SDItladZHK7og08m2eXHN04WwKnhgGQhF2
         RjXVvE9+BSg0ZAw4nuVarZrJW1zKzlicwxZ46PU+HiAw7n2nZGlwYfIyhr7eMgJ+6Kgs
         dqtqo0GEP0/+DJmOsyETh8l5c7ZPS8t+NGSqELghztnTcygSlia6Lz/lN2wZ3NJMG17H
         6qiRwHqt+gHe3n441D73didOfeS0N63vM65aILfV28SFiC+YsU9Ak4ctQ2GKQvJ0h9du
         Y/6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=SButerDLCsQDGPeEVESaZYRRpIEf4pP6XpvGnqv0994=;
        b=UG3u9BSU8efyK67JwowyA173j/a55HmQB1JqGedm2Muk5Prvclv375UyfTp75a5PD6
         lVD8soh1UP47lCz32yy7Hdp6VDq+8AY+uvTYUQNUND2GB8c3AHBXSF9kbV2f0IgjkdVh
         8mxt6ReHay6/uFbK5uybz55ulYmWkHCZk5OhoDCUBXSKINAc3psd1ia7OkugafQvLkRF
         KK8irqVGTEspcNZhzcnRf15bx9nvwIy3uUQOw19mOUj1QZjiJRL0ZhyjsfUwdQRAf3Jo
         TzRqK17XEa5l96s5a/LMY8qYCzvUlK7/66monBQDhAyTBIyLEqVTxrlXDizTtdFV77vJ
         R9pA==
X-Gm-Message-State: AGRZ1gKYDAcG/NilvXr5cWDE/1vcJfN777pkEXwgboqJBxIPSxpw3PSB
        Zm2FsOnZQH2iZFSw7XPECOuBlcgHThUtkUcW4Bw=
X-Google-Smtp-Source: AJdET5ek4YKt7D0POSyXoyNRXZArNyPCOqv8Xs51UpTxl+lGRueqHVcb5YeCFUW77hOuT6e1DEEQNTupcSTGh1Wtbrw=
X-Received: by 2002:a9d:620f:: with SMTP id g15mr6854893otj.296.1542400704228;
 Fri, 16 Nov 2018 12:38:24 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9d:2ea6:0:0:0:0:0 with HTTP; Fri, 16 Nov 2018 12:38:23
 -0800 (PST)
In-Reply-To: <87h8gibfps.fsf@codeaurora.org>
References: <1536098037-3000-1-git-send-email-pozega.tomislav@gmail.com>
 <8736um7ibj.fsf@kamboji.qca.qualcomm.com> <CAKR_QVKhAkOq7DydJ2sXBNZOpwmY=6WibOikN5xvehFBVQMMrQ@mail.gmail.com>
 <87h8gibfps.fsf@codeaurora.org>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Fri, 16 Nov 2018 21:38:23 +0100
Message-ID: <CAKR_QVKhUh6wXm=AFJTKZSOUDsw2No2S_ry_kWCuQHTVAcU9Fg@mail.gmail.com>
Subject: Re: [EXTERNAL] [PATCH] ath9k_htc: add fw 1.4.1
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        Adrian Chadd <adrian@freebsd.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Every build attempt of the firmware without modifying the code results
in same checksum of the built file. So I guess this should be easy to
verify.
