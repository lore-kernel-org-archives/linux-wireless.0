Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C7A0C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 14:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCD892147C
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 14:11:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SQB0BHs5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfCMOLk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 10:11:40 -0400
Received: from mail-oi1-f176.google.com ([209.85.167.176]:35427 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfCMOLk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 10:11:40 -0400
Received: by mail-oi1-f176.google.com with SMTP id u128so1526539oie.2
        for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2019 07:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=2Ujte/Tyb/sVxutv8zMgcjKvUjXsIDzef5HuiAXzwps=;
        b=SQB0BHs5KkiljviPGcFw1ttVzydMeybLsnAKtGKYQpGAGViT2Gz+N7MfcESBAdfFq1
         XJEtlHnytU1as3djqDd0Srt54nXJ70k3pAh96rbf/W1O8w1n7xSskBtYzdfCt+SRngWy
         qlDXqxBu/XvP1Hs+Nob1QXOBbG474UpUfJP4W2aq2xxA7pomHYfp04N9jPdm7yRs+hI5
         s2VL9iJGFlsR81XVHV/8yCfi6UGdXNqIj1NGpIDUl68zhB0cERCwIO0RGQ2B6aX1B6lW
         pZUXOCUmqZ+07VII9cMAH8ClYlTuIaSYhQv76R4JnBdiQTdXAh6+gy9lbrbTGASj8ECu
         3+Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=2Ujte/Tyb/sVxutv8zMgcjKvUjXsIDzef5HuiAXzwps=;
        b=GfJbuTeep5qeOv7iMntvSnFufDeKeJU0Gcr9ZnaCKLVhfvvTE43RlxmMpXT4TmgSpe
         3HfLNU9/ny9gwUg3lKOJHqQPi7uMCvyFtOkJnSrYSQaLFtQIFtuVGWpTCsyZ43KdgPiL
         uFqTY9SHMEaVekr0O7d3kG6ctudnVs6DuRIAHGct3gcu9btzcojmV5o+jktpAwP4v/1U
         X5deikow48chJBW6HsPSgPc3IWLEaEMzNepUj30pDag0IXj0zXZSHP9/xROrwpReXrBc
         Y8rW8/VItoEEHoVmNzfLMV9t8J2JrgznXzv8MMVwE0lUKb+zhrPJ7nHP791bmVmkOnl7
         y5OA==
X-Gm-Message-State: APjAAAXJBFyQEroFnUJFBqD9GttkI+GCEkwYbSmPOLWUIArDvsDcMmyu
        54/Uz78fsIlx30bu70VgnQ7iW4wyHdQTISSO1hA=
X-Google-Smtp-Source: APXvYqzVX6sZBei+u0GvcgE0ATl4P7oH0j00gU1jvGlBN22q82iW/4nndD6JG0GS9mjhiPkIKmmX1I985fs6T088rLc=
X-Received: by 2002:aca:dd0b:: with SMTP id u11mr1853751oig.24.1552486299779;
 Wed, 13 Mar 2019 07:11:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:6a97:0:0:0:0:0 with HTTP; Wed, 13 Mar 2019 07:11:39
 -0700 (PDT)
In-Reply-To: <795dd253-53db-d837-4da6-6016a096cdc7@nbd.name>
References: <1552484061-4647-1-git-send-email-sgruszka@redhat.com> <795dd253-53db-d837-4da6-6016a096cdc7@nbd.name>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Wed, 13 Mar 2019 15:11:39 +0100
Message-ID: <CAKR_QV+Tmm1BdZ2rzpkg6OGnK74ie7TOPgf0FrjnOu7EqV_NnQ@mail.gmail.com>
Subject: Re: [RFC] mt76: add 3dBm for reporting txpower also for 1x1
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 13/03/2019, Felix Fietkau <nbd@nbd.name> wrote:

> The reason why we add 3dBm is because using two chains to transmit in
> the worst case (from regulatory point of view) doubles the transmit
> power (= +3dBm).

An absurd idea that probably came from some misinformed regulatory
boys. There is no way to have 3dBm higher output power just because an
additional antenna exist. Even with 3x3 case it already proves as
inconsistent since there is no 6dB decrease but 5dB.
If this were to continue it would render 8x8 wifi AP useless.
