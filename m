Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 223AAC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 21:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3E3C213F2
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 21:02:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UAMVpjnc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfCSVCy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 17:02:54 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:32891 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbfCSVCx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 17:02:53 -0400
Received: by mail-oi1-f196.google.com with SMTP id e22so93037oiy.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2019 14:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=btJmV0Vlix+mVX/mKsKPiNQtoli5p2UkalUAhUDCYUM=;
        b=UAMVpjncJqpvJzCXNQhjwHox38N0rDOWuzkeIQGrDD9Tr5DREaFcm5DuDZJuIv7tT8
         w6JrqBXRTII1gUelfYUn1webKweGZSlUBKEzpLtYtLMWAc+o70iZqsTHEmbVzPxESffT
         u1CQYhEtCNX3mz8KsmOcEW2Y9UYob7P/YuzQclDsyuDQAS7ShFxfPilkUNSIP09fTuRS
         lulur7DcULLMVNFdW0D8YcI9QfFincRivEMWXZiZbG4V3+dcFPOov+E1jVkTAy1q2Cm4
         l9G9Ay9Nt0bhDvXcxkaJvmlbbEcBREwVpEwQkgQxAAs2qOgc2os/hMZ+0gytycaTUgic
         WpIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=btJmV0Vlix+mVX/mKsKPiNQtoli5p2UkalUAhUDCYUM=;
        b=mmgKbpBD8RV++76ciYtCztQ5NgQ07PvH0VF3c9aevTuSuDiygUpVZISaj/Sm0RR1Hb
         JyNSmA7AGuVLjvFYUwqZ7nKFMDsxtooOBG/y962U+6azODj7OuKD0luHRHox3Ugy/9qI
         Aznpl677PP+NJOHENc607ikc5C0Aefp40djvyqMNlwbtajiaALL97i0bLCkc4JP1rT4a
         yy5d9SDhH2G1kTfJYWM9DCbX9/VeSGWq2j+tdWvuNcs8BG+X/8fMEoqsNXNznDvKZ9dU
         mrvYIEHkiq804Tb58Q42YXoJAWc1uzOObYdcmp3rsa56r9M2syC+K5gNA6kfFr3zkn14
         RixQ==
X-Gm-Message-State: APjAAAUATKcVOoQXYUWmpmphF+qQRBYeMAfrBa/jEQyMsFy9ZDF5qa62
        AEkSWuMu1cmSfjMVnahAGMeXHbTB6b5xk6LnyHU=
X-Google-Smtp-Source: APXvYqySJ2a3tAxBbrlUtXoJ+rXbgaOe5qyXlRoD04spid75ZPuX6P7RrHqBKSevXwwAcShmMI5E4nU0B6Bt9U2Ymd4=
X-Received: by 2002:aca:52cc:: with SMTP id g195mr2939822oib.30.1553029373234;
 Tue, 19 Mar 2019 14:02:53 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:628c:0:0:0:0:0 with HTTP; Tue, 19 Mar 2019 14:02:52
 -0700 (PDT)
In-Reply-To: <0851502b-be6d-7947-ac7e-908065f2b330@bowerswilkins.com>
References: <1553025580-6118-1-git-send-email-pozega.tomislav@gmail.com> <0851502b-be6d-7947-ac7e-908065f2b330@bowerswilkins.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Tue, 19 Mar 2019 22:02:52 +0100
Message-ID: <CAKR_QVJZE==KsO=5CnN_drSnmXs+UNjh5vrHsTLbJMa4Kf30aA@mail.gmail.com>
Subject: Re: [PATCH] ath10k: Fix ASPM L1 state on QCA988X
To:     Peter Oh <peter.oh@bowerswilkins.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 19/03/2019, Peter Oh <peter.oh@bowerswilkins.com> wrote:
> On 03/19/2019 12:59 PM, Tomislav Po=C5=BEega wrote:
>
>> On some systems there are heavy crashes if the kernel config
>> option CONFIG_PCIEASPM_PERFORMANCE is not set. Patch provided by
>> Sujith for ath9k fixes
> ath10k?
>
> Peter
>

Original patch was for AR9462: https://patchwork.kernel.org/patch/2849305/
