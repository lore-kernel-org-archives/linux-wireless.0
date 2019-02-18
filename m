Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7028C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 21:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7F532085A
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 21:49:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="Lr8Js8ff"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730930AbfBRVtv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 16:49:51 -0500
Received: from mail.skyhub.de ([5.9.137.197]:59900 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726955AbfBRVtu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 16:49:50 -0500
Received: from zn.tnic (p200300EC2BC7C7005C4C67E6EC0FFC5E.dip0.t-ipconnect.de [IPv6:2003:ec:2bc7:c700:5c4c:67e6:ec0f:fc5e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8C3991EC04F3;
        Mon, 18 Feb 2019 22:49:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1550526588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=uys+NyVWP2GvLyuFgTpEgdk6WtP+kp1DTy4+1DKVLVQ=;
        b=Lr8Js8ffE5Nze7xsrc3+Z3i07x783BhgCJwyJ+Tyk0D9aVC8l1qku3wnfmuVdj3beR5y4w
        hDEH7xoU3sse257OkNTRHHSc0AP2EkmifyeUEyJYeNYIY2V9cE+4Kg8V+5Ci3K76QMbqc1
        gqUCou8w/VG9eWowESXjI5P3p2WceY0=
Date:   Mon, 18 Feb 2019 22:49:40 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-wireless@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Felix Fietkau <nbd@nbd.name>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [PATCH 1/2] wireless: mt76: call hweight8() instead of
 __sw_hweight8()
Message-ID: <20190218214940.GI4265@zn.tnic>
References: <1550469571-25933-1-git-send-email-yamada.masahiro@socionext.com>
 <1550469571-25933-2-git-send-email-yamada.masahiro@socionext.com>
 <877edxt1f1.fsf@kamboji.qca.qualcomm.com>
 <87tvh0syq2.fsf@kamboji.qca.qualcomm.com>
 <87pnrosy29.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87pnrosy29.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Feb 18, 2019 at 09:20:46PM +0200, Kalle Valo wrote:
> So Masahiro, could you hold your x86 patch for a while until the mt76
> patch will be in Linus' tree? That should not take more than two weeks,
> I think.

No hurry - I won't take it into the x86 now and queue it for 5.1 because
it is not something urgent or fixing a bug or so. It is a cleanup and as
such it can surely wait for 5.2, I'd say. Unless there are other aspects
which I'm not thinking of right now...

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
