Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2F3C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 12:57:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68A2D2171F
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 12:57:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AYOYvSRr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbfCMM5J (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 08:57:09 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40207 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfCMM5J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 08:57:09 -0400
Received: by mail-ot1-f66.google.com with SMTP id x8so1608001otg.7
        for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2019 05:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=G1n+gw7lYfBog5JfwHvCqpr+1laq/l+wOLPfdIXYqLs=;
        b=AYOYvSRrBi7OF012H1b2y2Y6/iriB3CsK7nrpQh2dH+ixLjE0N4iZJwpBrOrnC9yt9
         Ktpava2khxnvClRuFpEvM8KDLijKwg/VHGQh+zqto/Ul3EQO12rt4bw3vd30Ot0rvTW6
         3yx/YYNKCopFp1u5otVxWzHT7ct98ihVJAMpZavTSiY0fXHaZFQa3RF0BGIEyPf53kiP
         Wj6Ep3mLTqZR3OIgeoQ17FODLcQxwN8Pd9IGeQvHe4vOLLqiRI8hICBdW2+YFnp7Hho/
         JHmg031xAyR0mKD44vbO4HkbTvKcnpj7tq4SRqwigfO0dTmZ6g/O3d3oWrr4dsWELnXi
         3xcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=G1n+gw7lYfBog5JfwHvCqpr+1laq/l+wOLPfdIXYqLs=;
        b=XuQMBDNlx2pf9x3Ye/8kuNRuhysjFXhfhNO4il0CogchvlYSgekLP4nSqlWiiTVGZa
         4oHtdKZAHrc8DDPS4FwG0fqfPX4jQlXVv+ebQZCKGm1XdYbODeqdMpdpNC5irsO5rg+n
         v2W+g7HVDkuptaQjEojbYCBVSrcYobfMM5pZfT+CUre5dRaZA/iePjBhighUY8QvPSFa
         lC3a8Th5CT/C/utj4qNGB/mIekcmEUujBBMaES6hcz4EtgNeATRIbtftaoL69fhrOkLU
         Foodfm7eimhNKopGwuTI1CTdPL6hK0d8JK0n3YasXJas5SFdko1ds7s2naNKr9oy0Qit
         6niA==
X-Gm-Message-State: APjAAAW4Q/fLNJWbv/qrbJeR7pW/9xyecK6DKNPSLdJHtAQeInCW9P9n
        nnwusrDwtqhwc1uY0KdsSbTE1lHpEun1DQps7xLfaQ==
X-Google-Smtp-Source: APXvYqxXpSCroPlT3Ev/t8XS691pwYCWEwcBG790nCw8fzGRYJYoSSFlrrZwSVKKMsmYcFXbRg9jw3i9NxoPZbDdGdk=
X-Received: by 2002:a9d:7d82:: with SMTP id j2mr6530254otn.270.1552481828460;
 Wed, 13 Mar 2019 05:57:08 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:6a97:0:0:0:0:0 with HTTP; Wed, 13 Mar 2019 05:57:08
 -0700 (PDT)
In-Reply-To: <87o96f1cya.fsf@codeaurora.org>
References: <1552417843-10935-1-git-send-email-pozega.tomislav@gmail.com>
 <1552417843-10935-2-git-send-email-pozega.tomislav@gmail.com> <87o96f1cya.fsf@codeaurora.org>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Wed, 13 Mar 2019 13:57:08 +0100
Message-ID: <CAKR_QVL+4f4Y8Edj_tVeDefa0YMJM6N5mrBnXUF6MnxEJ98=gQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath9k: drop redundant code in ar9003_hw_set_channel
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

locales problems during some system upgrades. can you fix it without
resending?thanks
