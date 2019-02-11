Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2FD3C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 09:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8118D20863
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 09:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EqvrERqU";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EqvrERqU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbfBKJTf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 04:19:35 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43590 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfBKJTe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 04:19:34 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B8E56607DF; Mon, 11 Feb 2019 09:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549876773;
        bh=w7vNofABHkmV2IriZIaKXGIVjSCa9cvWKSQNtMH07no=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=EqvrERqUB688WWSutDbadKvSu++wyGb4+sPDQStsU6HuduARpusWMuarXttCRR/3y
         SULwJSFU8XNeRpVjhqDg+k+0lz5BZsnMdhVzJBZ/37Yqc/BZl+mhRlUUVw2xtA27rq
         QN+OYWpWZWox9GLz8lAo3sxOxD4Ga+BrlxWVp/CA=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 15F0A601CF;
        Mon, 11 Feb 2019 09:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549876773;
        bh=w7vNofABHkmV2IriZIaKXGIVjSCa9cvWKSQNtMH07no=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=EqvrERqUB688WWSutDbadKvSu++wyGb4+sPDQStsU6HuduARpusWMuarXttCRR/3y
         SULwJSFU8XNeRpVjhqDg+k+0lz5BZsnMdhVzJBZ/37Yqc/BZl+mhRlUUVw2xtA27rq
         QN+OYWpWZWox9GLz8lAo3sxOxD4Ga+BrlxWVp/CA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 15F0A601CF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ryder Lee <ryder.lee@mediatek.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, Roy Luo <roychl666@gmail.com>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
Subject: Re: [Resend PATCH] mt76: change the return type of mt76_dma_attach()
References: <228fdddb9ca96e8ce861e324eb9039722cf18f49.1549850911.git.ryder.lee@mediatek.com>
Date:   Mon, 11 Feb 2019 11:19:28 +0200
In-Reply-To: <228fdddb9ca96e8ce861e324eb9039722cf18f49.1549850911.git.ryder.lee@mediatek.com>
        (Ryder Lee's message of "Mon, 11 Feb 2019 16:48:29 +0800")
Message-ID: <87lg2m3cnz.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ryder Lee <ryder.lee@mediatek.com> writes:

> There is no need to return 0 in mt76_dma_attach(), so switch it to void.
>
> Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>

When you send a new version mark it as v2:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#patch_version_missing

And add a changelog:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing

No need to resend because of this, but please do remember this in the
future.

-- 
Kalle Valo
