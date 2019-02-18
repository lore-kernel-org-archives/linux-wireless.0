Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A266FC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 18:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7650721736
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 18:08:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dDmdOEhY";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dDmdOEhY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390095AbfBRSI0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 13:08:26 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42446 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387806AbfBRSI0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 13:08:26 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E4C82608CF; Mon, 18 Feb 2019 18:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550513305;
        bh=xCjBUogtWIOqJZsdmRtXiOBmgDLvp893h57ZpPCX8xw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dDmdOEhYTB4RXWskygVmUXPMZ/rPdDYnOA2nlpyw3yQmLZ/zOgW3+9KLRub13wxR4
         Wkc8atuV3wEHk7OO37OzpZEgujivVZ/qedzl2jkAGR1waUU/dm2pIsqagd5u9WRYwI
         b5/8cGWxRbLAHA92ZO7C/N78Km9Z676Hyyv42Ewk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 83FD560388;
        Mon, 18 Feb 2019 18:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550513305;
        bh=xCjBUogtWIOqJZsdmRtXiOBmgDLvp893h57ZpPCX8xw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dDmdOEhYTB4RXWskygVmUXPMZ/rPdDYnOA2nlpyw3yQmLZ/zOgW3+9KLRub13wxR4
         Wkc8atuV3wEHk7OO37OzpZEgujivVZ/qedzl2jkAGR1waUU/dm2pIsqagd5u9WRYwI
         b5/8cGWxRbLAHA92ZO7C/N78Km9Z676Hyyv42Ewk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 83FD560388
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-wireless@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Felix Fietkau <nbd@nbd.name>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [PATCH 1/2] wireless: mt76: call hweight8() instead of __sw_hweight8()
References: <1550469571-25933-1-git-send-email-yamada.masahiro@socionext.com>
        <1550469571-25933-2-git-send-email-yamada.masahiro@socionext.com>
Date:   Mon, 18 Feb 2019 20:08:18 +0200
In-Reply-To: <1550469571-25933-2-git-send-email-yamada.masahiro@socionext.com>
        (Masahiro Yamada's message of "Mon, 18 Feb 2019 14:59:30 +0900")
Message-ID: <877edxt1f1.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Masahiro Yamada <yamada.masahiro@socionext.com> writes:

> __sw_hweight8() is just internal implementation.
>
> Drivers should use the common API, hweight8().
>
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>

Acked-by: Kalle Valo <kvalo@codeaurora.org>

> This patch should go to x86 tree along with 2/2.
>
> Otherwise, all{yes,mod}config of x86 would be broken.
>
> This patch is trivial enough.
> I want ACK from the net/wireless maintainer
> so that this can go in via x86 tree.

Sounds good to me, feel free to push via the x86 tree.

-- 
Kalle Valo
