Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 041F6C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 11:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFA5E2086C
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 11:09:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="orKSZg04";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="orKSZg04"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFA5E2086C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387839AbeKOVQo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 16:16:44 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:47308 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbeKOVQo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 16:16:44 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E84A16074C; Thu, 15 Nov 2018 11:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542280160;
        bh=4IX02k814g0S5SB8mgcMOt5wAAb/6ikhwZhQtgMHV5s=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=orKSZg046kqzSzETNp400EjEr8dSPkMhtz6lMe5px40+wgy6BwrLbJY+pxqoOmP1L
         Rau9fmf93iW+VRt19xElZuoqd//QjbcL0YojAsFzpykKQh5EYRhphxQbUtnwCN1PZh
         e1wRCRpkJRjNlWneKNzd3WkRVveCcZIMWRzWliIY=
Received: from x230.qca.qualcomm.com (87-95-226-75.bb.dnainternet.fi [87.95.226.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 63B556024C;
        Thu, 15 Nov 2018 11:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542280160;
        bh=4IX02k814g0S5SB8mgcMOt5wAAb/6ikhwZhQtgMHV5s=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=orKSZg046kqzSzETNp400EjEr8dSPkMhtz6lMe5px40+wgy6BwrLbJY+pxqoOmP1L
         Rau9fmf93iW+VRt19xElZuoqd//QjbcL0YojAsFzpykKQh5EYRhphxQbUtnwCN1PZh
         e1wRCRpkJRjNlWneKNzd3WkRVveCcZIMWRzWliIY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 63B556024C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Priit Laes <plaes@plaes.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Colin Ian King <colin.king@canonical.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] wireless: Use common cordic algorithm for b43 driver
References: <cover.c0b1738f3f06bbf87f4ad3200ece93322a5f135f.1542219596.git-series.plaes@plaes.org>
Date:   Thu, 15 Nov 2018 13:09:14 +0200
In-Reply-To: <cover.c0b1738f3f06bbf87f4ad3200ece93322a5f135f.1542219596.git-series.plaes@plaes.org>
        (Priit Laes's message of "Wed, 14 Nov 2018 20:27:49 +0200")
Message-ID: <87a7mad2cl.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Priit Laes <plaes@plaes.org> writes:

> b43 wireless driver includes an internal implementation of
> cordic algorithm, although there's a common cordic library
> which was split out from brcmsmac driver. Use that and drop
> internal implementation.
>
> During the process, cordic-algorithm related macros in
> brcmfmac driver were also removed and use general macros.
>
> Please note that this series is only compile-tested, as I
> do not have access to the hardware.

Thanks, this time all patches made it to patchwork:

https://patchwork.kernel.org/project/linux-wireless/list/?series=43097

I'll now wait for the review comments.

-- 
Kalle Valo
