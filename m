Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9EE7C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 920932085B
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:43:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AmfRL3Gt";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="izhDImmS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 920932085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389210AbeKGCJw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:09:52 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54232 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388907AbeKGCJw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:09:52 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C66C5601DA; Tue,  6 Nov 2018 16:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541522629;
        bh=f51Jr0Gqwgp8Zufg3SJhUz6gQUiBu1Jk+OPfkkiVqiY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=AmfRL3GtWhjA6IECXBLPbktDSzPcKM3w6Ja+aIOG9yf0EId1n6rX+3FagQkeOeDV2
         u8m0v2txjCUiGNLLvuWYFmGi/lgNLA48KH8nGF2UPHq+ycAYsVkF8mg6hmcFUQsBPJ
         +W2pTIamCtDYBOuOkqIcqfKr0My4IZXcmzbp4V9c=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 53F3A6038E;
        Tue,  6 Nov 2018 16:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541522629;
        bh=f51Jr0Gqwgp8Zufg3SJhUz6gQUiBu1Jk+OPfkkiVqiY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=izhDImmSWGKA54yfKbtgcrE0cFCh1ckR/2JxjkaPpkX6oC+LOy47P1fY/9Vm7B37p
         J2jBPZTXF7vUEeZBtc1faaoSH42GDMV1CRDoCBZD/3ioryfrPPxW/3ZCWLtIzcII/b
         pgErf6mnppUfklhnAhu23aNAJfdTJDRWg8xZlAw8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 53F3A6038E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k: Fix a locking bug in ath9k_add_interface()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181019200842.7qclbjs547sm7mbn@kili.mountain>
References: <20181019200842.7qclbjs547sm7mbn@kili.mountain>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106164349.C66C5601DA@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 16:43:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> We tried to revert commit d9c52fd17cb4 ("ath9k: fix tx99 with monitor
> mode interface") but accidentally missed part of the locking change.
> 
> The lock has to be held earlier so that we're holding it when we do
> "sc->tx99_vif = vif;" and also there in the current code there is a
> stray unlock before we have taken the lock.
> 
> Fixes: 6df0580be8bc ("ath9k: add back support for using active monitor interfaces for tx99")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Patch applied to wireless-drivers.git, thanks.

461cf0360574 ath9k: Fix a locking bug in ath9k_add_interface()

-- 
https://patchwork.kernel.org/patch/10650123/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

