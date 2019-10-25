Return-Path: <SRS0=+qZr=YS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA00DCA9EA0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Oct 2019 07:46:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F4202070B
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Oct 2019 07:46:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VeVgsXY7";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VeVgsXY7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437126AbfJYHq2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Oct 2019 03:46:28 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53400 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731944AbfJYHq2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Oct 2019 03:46:28 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A36D560EC7; Fri, 25 Oct 2019 07:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571989587;
        bh=y4t9kuUopvtOpXXzoO20Dzjsef1PGc2a/2MHFr0tyho=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VeVgsXY7oJ0oUjsy4NdkSKBMv0JcNMrFaTDqWiSuHFgklaxR2G2I4nlOa3fS7FZbq
         wesZviD/Q8bt8mGqqNF39gXzbcRq2SYPSOZ9T8j4GwwbFwPfRhOa0ypatVNsBkOcyS
         yw/QwQPjy0vF0GZieKM8Us0pD/Rk0gH4AEpE9csI=
Received: from potku.adurom.net (unknown [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6B2BF60ECE;
        Fri, 25 Oct 2019 07:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571989587;
        bh=y4t9kuUopvtOpXXzoO20Dzjsef1PGc2a/2MHFr0tyho=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VeVgsXY7oJ0oUjsy4NdkSKBMv0JcNMrFaTDqWiSuHFgklaxR2G2I4nlOa3fS7FZbq
         wesZviD/Q8bt8mGqqNF39gXzbcRq2SYPSOZ9T8j4GwwbFwPfRhOa0ypatVNsBkOcyS
         yw/QwQPjy0vF0GZieKM8Us0pD/Rk0gH4AEpE9csI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6B2BF60ECE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH 03/12] iwlwifi: nvm: update iwl_uhb_nvm_channels
References: <20191019093902.29823-1-luca@coelho.fi>
        <20191019093902.29823-2-luca@coelho.fi>
Date:   Fri, 25 Oct 2019 10:46:24 +0300
In-Reply-To: <20191019093902.29823-2-luca@coelho.fi> (Luca Coelho's message of
        "Sat, 19 Oct 2019 12:38:53 +0300")
Message-ID: <87v9sdp8rz.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> From: Tova Mussai <tova.mussai@intel.com>
>
> Update uhb channels numbers to start from 1
>
> Signed-off-by: Tova Mussai <tova.mussai@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Why?

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
