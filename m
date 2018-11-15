Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 302F9C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 14:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8E2C2086B
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 14:03:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WBI+Ko8m";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WBI+Ko8m"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8E2C2086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733254AbeKPALa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 19:11:30 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:52156 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbeKPALa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 19:11:30 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E0F1A606DD; Thu, 15 Nov 2018 14:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542290611;
        bh=J36G9FCgASsIT4OrB+1G9FBVWLaqQBT8jycDMI2H9QQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WBI+Ko8mI9EcHIaQRiX2nBql+CrZuwLy52wEiMZUxUq2h1PXWAHG9FE6chnlSIB1x
         cA4LfIVVQ57k/WEB7rsBAR2m1ZoGDvUEUvI27dtCrAZsFPFAwxEMsR+vixTT0KwNjt
         OaprwsttLgqUU/N33pY7d8wotD0T0zD18a0Px48E=
Received: from x230.qca.qualcomm.com (87-95-226-75.bb.dnainternet.fi [87.95.226.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C5941601D4;
        Thu, 15 Nov 2018 14:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542290611;
        bh=J36G9FCgASsIT4OrB+1G9FBVWLaqQBT8jycDMI2H9QQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WBI+Ko8mI9EcHIaQRiX2nBql+CrZuwLy52wEiMZUxUq2h1PXWAHG9FE6chnlSIB1x
         cA4LfIVVQ57k/WEB7rsBAR2m1ZoGDvUEUvI27dtCrAZsFPFAwxEMsR+vixTT0KwNjt
         OaprwsttLgqUU/N33pY7d8wotD0T0zD18a0Px48E=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C5941601D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        Adrian Chadd <adrian@freebsd.org>
Subject: Re: [EXTERNAL] [PATCH] ath9k_htc: add fw 1.4.1
References: <1536098037-3000-1-git-send-email-pozega.tomislav@gmail.com>
        <8736um7ibj.fsf@kamboji.qca.qualcomm.com>
        <CAKR_QVKhAkOq7DydJ2sXBNZOpwmY=6WibOikN5xvehFBVQMMrQ@mail.gmail.com>
Date:   Thu, 15 Nov 2018 16:03:27 +0200
In-Reply-To: <CAKR_QVKhAkOq7DydJ2sXBNZOpwmY=6WibOikN5xvehFBVQMMrQ@mail.gmail.com>
        (Tom Psyborg's message of "Thu, 6 Sep 2018 19:32:41 +0200")
Message-ID: <87h8gibfps.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

(fixing quotation, PLEASE don't top post)

Tom Psyborg <pozega.tomislav@gmail.com> writes:

>> On 6 September 2018 at 17:32, Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>>     Tomislav Po=C5=BEega <pozega.tomislav@gmail.com> writes:
>>=20=20=20=20=20
>>     > Add firmware v1.4.1 that supports up to 8 virtual APs and up
>>     > to 16 (current limit, at least on AR9271) client interfaces.
>>     > (1 AP + 15 STA, 4 AP + 12 STA etc)
>>     >
>>     > Signed-off-by: Tomislav Po=C5=BEega <pozega.tomislav@gmail.com>
>>     > ---
>>     > ath9k_htc/htc_7010-1.4.1.fw | Bin 0 -> 72812 bytes
>>     > ath9k_htc/htc_9271-1.4.1.fw | Bin 0 -> 51008 bytes
>>     > 2 files changed, 0 insertions(+), 0 deletions(-)
>>     > create mode 100644 ath9k_htc/htc_7010-1.4.1.fw
>>     > create mode 100644 ath9k_htc/htc_9271-1.4.1.fw
>>=20=20=20=20=20
>>     Is this is an official release from the open-ath9k-htc-firmware
>>     project
>>     or just some custom build of yours? I'm asking because I don't see
>>     anything in the master branch since January:
>>=20=20=20=20=20
>>     https://github.com/qca/open-ath9k-htc-firmware/commits/master
>>=20=20=20=20=20
>>     IMHO Adrian Chadd (CCed) should be the one pushing the ath9k_htc
>>     firmware image to linux-firmware, unless the maintainer has
>>     changed of
>>     course.
>
> I was not sure if the fw images from open-ath9k-htc-firmware project
> are still being pulled into linux-firmware tree, so I created this
> build myself to meet the requirements for one of the patches I sent to
> linux-wireless list.

As ath9k_htc firmere is open it's easy to create backdoors etc and this
is why I think that linux-firmware should not take ath9k_htc firmware
binaries just from anyone, only from maintainers of
open-ath9k-htc-firmware project.

> Adrian, can you push the new fw version via official channel?

Adrian, can you help here?

--=20
Kalle Valo
