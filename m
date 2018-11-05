Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC53C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56CEC20825
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:11:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="khJ9jQfK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="E2jxovkz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56CEC20825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbeKEUaT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 15:30:19 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58804 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbeKEUaT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 15:30:19 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 231AA6053D; Mon,  5 Nov 2018 11:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541416269;
        bh=WVSzUZrsG27n1p74x+rH4/+oIJnVOr6/J8nIDwAONcs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=khJ9jQfK/t97KEjSlF034HbYWDihMr0fwVYaslVMX5ghJtyVDngcBMsnyaW6ZAScp
         Em48ZLyv9TfS3VouKy7LC1zK0kVOBvDsPZP5ee6XV6w35sNOannSnBeotxTczsfKZ3
         oQjxgJMQyXZ/QgEmpzvB+dK3qonJ06eMTs5fU7gA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6523360600;
        Mon,  5 Nov 2018 11:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541416268;
        bh=WVSzUZrsG27n1p74x+rH4/+oIJnVOr6/J8nIDwAONcs=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=E2jxovkzqOheS889tEpxawO9j0bh1IGXCM5yM4Fevo1BGPUt0rj7ICq+kvf/aO2d7
         aBNd4VFbNaBy9qflonpO47qLbGNanWm02Tt2RcYaOI9otgujmQuXGRbFTVbdG1IKlO
         oLnk88Crlc8hj9YlQcpNdaVzB/J5TB0rC1HPlr5g=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6523360600
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fixup extended per sta tx statistics
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181018073619.c2cxj74enkramhjr@kili.mountain>
References: <20181018073619.c2cxj74enkramhjr@kili.mountain>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Anilkumar Kolli <akolli@codeaurora.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181105111109.231AA6053D@smtp.codeaurora.org>
Date:   Mon,  5 Nov 2018 11:11:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> I had a couple concerns with this code.  First, we definitely need to
> set the error code if the kzalloc() fails.  Secondly, I was worried that
> if we didn't set "arsta->tx_stats" to NULL after freeing it, then it
> looks to me like it might lead to a use after free.  I can't test that,
> but it's harmless to set it to NULL so I did.
> 
> Fixes: a904417fc876 ("ath10k: add extended per sta tx statistics support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

539b44e70c5b ath10k: fixup extended per sta tx statistics

-- 
https://patchwork.kernel.org/patch/10646825/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

