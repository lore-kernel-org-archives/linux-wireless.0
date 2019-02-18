Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 480B3C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 06:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 060FD218B0
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 06:07:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="R81ueSNd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbfBRGHF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 01:07:05 -0500
Received: from condef-03.nifty.com ([202.248.20.68]:50335 "EHLO
        condef-03.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbfBRGHF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 01:07:05 -0500
Received: from conuserg-07.nifty.com ([10.126.8.70])by condef-03.nifty.com with ESMTP id x1I63Eca025123
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2019 15:03:20 +0900
Received: from pug.e01.socionext.com (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-07.nifty.com with ESMTP id x1I617hP006910;
        Mon, 18 Feb 2019 15:01:07 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-07.nifty.com x1I617hP006910
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1550469668;
        bh=NxLW51joWyvnJN1RnKNbaCQPsjav24QXUL7FZQbjRU0=;
        h=From:To:Cc:Subject:Date:From;
        b=R81ueSNdiAOMm8788ckrvP8r9ErabEmk5m+otXRzuz1n03mpjh4VN8EnOnqFC7lZb
         rwYgt2hpW+j1yBo026+MPCTjDyfNb/e494jiJc7GIIht5ePf/LYcpA5I1KybzYdyxK
         VltDqvGWePalbRuSiZhB0vcBdKmOHEFBhZU7eMXR9flrlaPLDY27IjagBAAWB8878u
         XZZiC1rp/F+4vo86Cq41tdoY5NXn3jVcnAQcODYcX6kaycLn7pnVXnFSVDXluwy8JA
         eaoIUGJpeNn2RhxYjWCkb2URNZXrhxjYUOmLW/U7r1zdfLRQpVftSaahLEfbyp9wxd
         z5AG2TANZMfCA==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Felix Fietkau <nbd@nbd.name>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 0/2] x86: turn off wrongly enabled CONFIG_GENERIC_HWEIGHT
Date:   Mon, 18 Feb 2019 14:59:29 +0900
Message-Id: <1550469571-25933-1-git-send-email-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


x86 should not enable CONFIG_GENERIC_HWEIGHT
because lib/hweight.c is not used by x86.

The only user is drivers/net/wireless/mediatek/mt76/mac80211.c

Of course, this driver is wrong since drivers should use the
generic API, hweight8().

After fixing it, x86 does not need to compile lib/hweight.c at all.

The real implementation is located in arch/x86/lib/hweight.S



Masahiro Yamada (2):
  wireless: mt76: call hweight8() instead of __sw_hweight8()
  x86: disable CONFIG_GENERIC_HWEIGHT and remove __HAVE_ARCH_SW_HWEIGHT

 arch/x86/Kconfig                              | 3 ---
 arch/x86/include/asm/arch_hweight.h           | 2 --
 drivers/net/wireless/mediatek/mt76/mac80211.c | 2 +-
 lib/hweight.c                                 | 4 ----
 4 files changed, 1 insertion(+), 10 deletions(-)

-- 
2.7.4

