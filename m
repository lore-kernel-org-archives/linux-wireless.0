Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C17C5C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 18:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9096B2190B
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 18:46:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jQKlsYyE";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="I5arnXSY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732087AbfBLSqv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 13:46:51 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40426 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732076AbfBLSqr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 13:46:47 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 84256607DF; Tue, 12 Feb 2019 18:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549997207;
        bh=LBLJRWGMAU+nCQPR5v9Y0U3VorbGYMQ0LDGYtqKQzUI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jQKlsYyEApg9VR2hN/1CS118YQnPagViasqrKMBcUNeqZO3JMy3IiW7K03Tli3xoW
         6KA9ogDrW7XZH+JduAStqSrRFdA8S/xvm4eib9E+juebyxaWSwbWX5s1qEmM/oXUTo
         UtNeEiqooCgvyyViRRosdj+OnkzzhgVI0M8dg2KU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E12706030D;
        Tue, 12 Feb 2019 18:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549997206;
        bh=LBLJRWGMAU+nCQPR5v9Y0U3VorbGYMQ0LDGYtqKQzUI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=I5arnXSYFPaELwqSmpXfVXqpvHLj987Zx1PDpFSaJAL1p5lMEih/akZ1JX5BXlOVP
         tg2PFCh3Rms8iIGWfC1+mEQ89XL0i/dvNrojthrBFpG+8f6wO4Xge1sLy80X5qNIM/
         /99Vz+QWhzxBHlY/98x/4vDPSuQu/ULcPfj2UnpE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E12706030D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Add support to configure ftm responder role
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1549439910-9315-1-git-send-email-pradeepc@codeaurora.org>
References: <1549439910-9315-1-git-send-email-pradeepc@codeaurora.org>
To:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190212184647.84256607DF@smtp.codeaurora.org>
Date:   Tue, 12 Feb 2019 18:46:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Pradeep Kumar Chitrapu <pradeepc@codeaurora.org> wrote:

> Configure fine timing measurement (FTM) responder role from the
> ftm_responder bss param sent by mac80211. With FTM functionality offloaded
> to firmware, adding the interface allows userspace to enable or disable
> FTM responder functionality. ath10k disables it at the time of interface
> creation.
> 
> Supported FW: 10.4
> 
> Tested on IPQ4019 with firmware: 10.4-3.2.1.1-00022
> 
> Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

059104bff312 ath10k: add support to configure ftm responder role

-- 
https://patchwork.kernel.org/patch/10798883/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

