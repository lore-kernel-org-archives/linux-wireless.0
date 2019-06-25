Return-Path: <SRS0=pdv6=UY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3856DC48BD4
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 12:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10B8E215EA
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 12:47:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ifnx8WT2";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Y0X5/vkL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731786AbfFYMr7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Jun 2019 08:47:59 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53006 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731704AbfFYMr6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jun 2019 08:47:58 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9C2186070D; Tue, 25 Jun 2019 12:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561466877;
        bh=ZEqNswo8HmpKPjsJHs4+PSCICnHDAxC7vF20TMdW/io=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ifnx8WT2KRo83BzPPzdIxe80KGrnZr4Wc+mHdLSEqLeFLVKNbxCMAL92zMXITjMEP
         5btJkC+MJYl9nI4eSCmnvXCevSk3Rdzz7hAfU7oriaRcNBONMNAAWQ1y3lGgaYCnX7
         MZ6KDg88Y0WmSjoVWP42Q1CpR7BUGqR/CyoTZmr0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F1D09607DE;
        Tue, 25 Jun 2019 12:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561466877;
        bh=ZEqNswo8HmpKPjsJHs4+PSCICnHDAxC7vF20TMdW/io=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Y0X5/vkLkAUmFkM6BVnVcHxKqhdbdL6Kg2I31657NIvtjaG7Zua8DRpiB+opgCJMn
         UtDK8PuzLj9g7UEfGqSfUpbC4z7XCkLFlT3YJmvzKiEXPeI+uzHUr/KQM8o9jGPfed
         /1+CNqwzlWCV4vuUsM5gJ8NZl47vMuaEnv9zWByY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F1D09607DE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] ath10k: add inline wrapper for htt_h2t_aggr_cfg_msg
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190326162904.6737-1-erik.stromdahl@gmail.com>
References: <20190326162904.6737-1-erik.stromdahl@gmail.com>
To:     Erik Stromdahl <erik.stromdahl@gmail.com>
Cc:     kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org,
        Erik Stromdahl <erik.stromdahl@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190625124757.9C2186070D@smtp.codeaurora.org>
Date:   Tue, 25 Jun 2019 12:47:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Erik Stromdahl <erik.stromdahl@gmail.com> wrote:

> This is done in order to make the *htt_h2t_aggr_cfg_msg* op align better
> with the rest of the htt ops (whom all have inline wrappers).
> 
> It also adds support for the case when the op is missing (function
> pointer is NULL).
> 
> As a result of this, the name of the 32 bit implementation in htt_tx.c
> was changed and the function was made static.
> 
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

74ee5715991f ath10k: add inline wrapper for htt_h2t_aggr_cfg_msg
bc31c2cfecc7 ath10k: add htt_h2t_aggr_cfg_msg op for high latency devices

-- 
https://patchwork.kernel.org/patch/10871563/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

