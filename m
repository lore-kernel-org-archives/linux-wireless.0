Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 717DEC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 06:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32C6F2070D
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 06:52:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dSgHCsiL";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dSgHCsiL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfCMGwN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 02:52:13 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44046 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbfCMGwN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 02:52:13 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6E4FA6016D; Wed, 13 Mar 2019 06:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552459932;
        bh=ER5H59aT+gzgaFvGcnipDQX3ATbRLjp4awBysLkdZNc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dSgHCsiLVjImjzJzVumhBfKSEIDG3Gmx3VwgWAqF2wlh+A+8ylNssunVOXCwVJYFd
         cip2QVnv0i2WF+2h8QwmzMsvtn+Eqo34UAlCNbxE54nEBUORTEBSjuzECnbCIggUtF
         1HcWMkHt8bCJgNMSaNppSp86W0z9uI/UaNgBkr7M=
Received: from x230.qca.qualcomm.com (85-76-44-132-nat.elisa-mobile.fi [85.76.44.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3FD466028D;
        Wed, 13 Mar 2019 06:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552459932;
        bh=ER5H59aT+gzgaFvGcnipDQX3ATbRLjp4awBysLkdZNc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dSgHCsiLVjImjzJzVumhBfKSEIDG3Gmx3VwgWAqF2wlh+A+8ylNssunVOXCwVJYFd
         cip2QVnv0i2WF+2h8QwmzMsvtn+Eqo34UAlCNbxE54nEBUORTEBSjuzECnbCIggUtF
         1HcWMkHt8bCJgNMSaNppSp86W0z9uI/UaNgBkr7M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3FD466028D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath: drop duplicated include
References: <1552417843-10935-1-git-send-email-pozega.tomislav@gmail.com>
Date:   Wed, 13 Mar 2019 08:52:08 +0200
In-Reply-To: <1552417843-10935-1-git-send-email-pozega.tomislav@gmail.com>
        ("Tomislav \=\?utf-8\?Q\?Po\=C5\=BEega\=22's\?\= message of "Tue, 12 Mar 2019
 20:10:42 +0100")
Message-ID: <87sgvr1d2f.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tomislav Po=C5=BEega <pozega.tomislav@gmail.com> writes:

> Signed-off-by: Tomislav Po.ega <pozega.tomislav@gmail.com>

No empty commit logs, please.=20

> ---
>  drivers/net/wireless/ath/regd.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/regd.h b/drivers/net/wireless/ath/r=
egd.h
> index 75ddaef..8d5a16b 100644
> --- a/drivers/net/wireless/ath/regd.h
> +++ b/drivers/net/wireless/ath/regd.h
> @@ -28,7 +28,6 @@ enum ctl_group {
>  	CTL_ETSI =3D 0x30,
>  };
>=20=20
> -#define NO_CTL 0xff

The title is misleading, you are removing a duplicate define. Nothing to
do with includes.

--=20
Kalle Valo
