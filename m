Return-Path: <SRS0=QiZU=RR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D0ABC10F06
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 14:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6229E2070D
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 14:02:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PQgeYpo0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbfCNOCQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Mar 2019 10:02:16 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39612 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727739AbfCNOCQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Mar 2019 10:02:16 -0400
Received: by mail-ot1-f65.google.com with SMTP id e15so5181031otk.6
        for <linux-wireless@vger.kernel.org>; Thu, 14 Mar 2019 07:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=MHP1SZor194V0kCI+jE0/Ee6nEZn6VNuv1Gr6BdyO2A=;
        b=PQgeYpo0mOWKdDy6iNXjp0A4gfhf57NHJZbWJYtwsQmkVI2L6iaXREycCjgg8RySlo
         6iauDqJPkKxeAG13QtC/RzcnvHCCywDvwIlsB8qG8WdB7Lx6MIXcfxK25bTWnlj6a5Qj
         XiE3bnjieIzAY9rCdu74FP4AR5yoF41Jr+b/5yySY3Qh9ssJDnVkZU22JgvtbONygOey
         jd9l8KbUg0lGg54m6U8lNGVI+7y5ZKt023c/8AT5uaAlH3FHCW1A1Cch2LCIRdbrOggD
         hcQZUG3i150ulHk8JqdghlzNLsLyvFT8qbaPmYyZhfMDSB32T6wYRmzBcKuGyXRara5N
         D/qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=MHP1SZor194V0kCI+jE0/Ee6nEZn6VNuv1Gr6BdyO2A=;
        b=quKMwePY0ErrraW0mc3Nmmyi3HcVVYW2ec43Mjmsy6Kl2iWmcfqsjxXw5EpncuEDVC
         JzFSG2n+cF2ZsYfJyOjU2G9WBF1PssOS3eZhKbpYCYjCQphpWnUvzfx8wsvDp4E4qsjU
         ZeYBdoC9dAI3O/i8LDWu6o4N2e2J0SBhskKiUqo8rhCumQ+zBbTmtiv48OuJWNzFFIKq
         KWSuRiyu5Ysm+BTEPfbD0LUduda1fDXxj+jcteikd3jVUTfJ/uhIZxiVa8bByA7/SeDs
         GtKUFKJ7P2XJ3VGqItD04xFipRz6z8qBqlcGsSqV43ZpqsegYFJPaAfo33Qr5UR6fYnm
         /3xA==
X-Gm-Message-State: APjAAAX91/lte5idFnBeXPUu7ipQv9i2C4515MCKocdc7Ik5PQwKsVHj
        1BWum6NyLJGcp2067GIg+Y3HKVau5wruCz6rDF0=
X-Google-Smtp-Source: APXvYqyuIxfU4Ov0wia4vXRGWjhtR9OpwYisYg7fnEVaDhDIYx9LgKJnXT/LWXJKa2laTBCH9+RbegO676g+kv5tvt0=
X-Received: by 2002:a9d:7515:: with SMTP id r21mr6981388otk.322.1552572134968;
 Thu, 14 Mar 2019 07:02:14 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:6a97:0:0:0:0:0 with HTTP; Thu, 14 Mar 2019 07:02:14
 -0700 (PDT)
In-Reply-To: <20190313155028.GB5302@redhat.com>
References: <1552417902-11040-1-git-send-email-pozega.tomislav@gmail.com>
 <1552417902-11040-2-git-send-email-pozega.tomislav@gmail.com>
 <20190313091252.GB2663@redhat.com> <CAKR_QV+sFc6J97f5dtW9OtxGoEj5udB=fY5qAb3_QgF4jfqEVA@mail.gmail.com>
 <20190313130910.GD2003@redhat.com> <CAKR_QVLB9k0bGiRW9ON3PeQR1ZoMfWbrXg3W+Bg4N4G+9pAsZg@mail.gmail.com>
 <20190313140607.GE2003@redhat.com> <CAKR_QV+gEJEE2+hwfE1wsF5mdEZVDGtNskivcpFUutGEbwKyKg@mail.gmail.com>
 <20190313155028.GB5302@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Thu, 14 Mar 2019 15:02:14 +0100
Message-ID: <CAKR_QV+=i_Sp26zCkTC9cAHrhVLq4w0FoxLVmD-T3wFyd-ruEQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] rt2x00: enable experimental MFP with HW crypt
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        daniel@makrotopia.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 13/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:

>
> There should be no difference between enabling MFP with nohwcrypt and
> without nohwcrypt,

well there is. do you still want me to resend this with MFP enabled
unconditionally for all chips?
