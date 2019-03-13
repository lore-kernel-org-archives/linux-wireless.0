Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15969C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 06:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDBD02070D
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 06:54:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="H5wpSldj";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QqKPGr44"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbfCMGym (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 02:54:42 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45120 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfCMGyl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 02:54:41 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 421D26016D; Wed, 13 Mar 2019 06:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552460081;
        bh=yK+4R+EBLxM+zH1hrpxCVpaTBPMXtmvFEj1lppR4D7k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=H5wpSldjbWHAtGBPMb7V6fQn3cioCltyovwHZTBPwwkxrn9lP5ykhIoq8ZbYV7Nhl
         EP8YGIBD154XOxwWOm6k7La47nhLPXhtrHy8UY2b4ywW6g72gKlwus2ql2zzlr6UYO
         BgQTKbpPIo51SuyAqOEsgAIs/Z24E6+US5iccGjw=
Received: from x230.qca.qualcomm.com (85-76-44-132-nat.elisa-mobile.fi [85.76.44.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0CCA66016D;
        Wed, 13 Mar 2019 06:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552460080;
        bh=yK+4R+EBLxM+zH1hrpxCVpaTBPMXtmvFEj1lppR4D7k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=QqKPGr44HHVbQeYJUKYbutYFoRr3csleX5qJHRSdAERvfRWK42aJHFfyR7dqVfphV
         fnJd1XGaDjcQSizmlJOb8WOAH1pkU5G4WiKXNJ/bKs2NThzpcdhaR7G5JcMYaYpDwZ
         CmvcF9zVHQgCUePoI/XYgPYRayzEtWACpCtm/X58=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0CCA66016D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k: drop redundant code in ar9003_hw_set_channel
References: <1552417843-10935-1-git-send-email-pozega.tomislav@gmail.com>
        <1552417843-10935-2-git-send-email-pozega.tomislav@gmail.com>
Date:   Wed, 13 Mar 2019 08:54:37 +0200
In-Reply-To: <1552417843-10935-2-git-send-email-pozega.tomislav@gmail.com>
        ("Tomislav \=\?utf-8\?Q\?Po\=C5\=BEega\=22's\?\= message of "Tue, 12 Mar 2019
 20:10:43 +0100")
Message-ID: <87o96f1cya.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tomislav Po=C5=BEega <pozega.tomislav@gmail.com> writes:

> AR9330, AR9485, AR9531, AR9550, AR9561 and AR9565 all use same
> channel set register configuration which allows for small code
> size reduction.
>
> Signed-off-by: Tomislav Po\270ega <pozega.tomislav@gmail.com>

At least Gnus complains about character \270 in the Signed-off-by line.
Is your charset in order? The From line looks to be ok, though.

--=20
Kalle Valo
