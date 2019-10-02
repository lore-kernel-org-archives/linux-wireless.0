Return-Path: <SRS0=/cM4=X3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B4AC352AA
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Oct 2019 04:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F79220842
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Oct 2019 04:35:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OvuY6lAU";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="k/+0w9Nt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfJBEfJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 2 Oct 2019 00:35:09 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48448 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfJBEfJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Oct 2019 00:35:09 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7A7B0602F2; Wed,  2 Oct 2019 04:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569990908;
        bh=7ndceZwGJGZn3+blsNwlshv01/yOiU20bu96GYOS07w=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=OvuY6lAU+fgPRvlQPcJStaJu+eIYAHcLtyUJZCEUTGO90I3/7MGNyfyOhiYKPL1Xi
         AL9aWgVs2AzXqUHnAqcq6VPWk2F+cSn1LOGgKZUO4L8CUsRXfNKpxgJCwnWi0f10T+
         yV/i1CLRcEvXReyK/7gcvYAvPMMWFaD0emV5DXwg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 293CB608CE;
        Wed,  2 Oct 2019 04:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569990908;
        bh=7ndceZwGJGZn3+blsNwlshv01/yOiU20bu96GYOS07w=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=k/+0w9NtRnFLmySoQZbPxcsXea0+RRF+grQEWfY+8lGF7d7wPCW6XK/5kVOOMPfdw
         oyatZ0iLMIvbv0Q9AAO9KfrIzE9Q/+Ib7QjwqSep/PrmsHw1e5/6gYWoQK+XjYSWZW
         5uW/fCODnQbdYv69einf3wmfpc6fd7ikyTR0Swuc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 293CB608CE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] cw1200: Fix a signedness bug in cw1200_load_firmware()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191001114501.GA6550@mwanda>
References: <20191001114501.GA6550@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Solomon Peachy <pizza@shaftnet.org>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191002043508.7A7B0602F2@smtp.codeaurora.org>
Date:   Wed,  2 Oct 2019 04:35:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> The "priv->hw_type" is an enum and in this context GCC will treat it
> as an unsigned int so the error handling will never trigger.
> 
> Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Patch applied to wireless-drivers-next.git, thanks.

4a50d454502f cw1200: Fix a signedness bug in cw1200_load_firmware()

-- 
https://patchwork.kernel.org/patch/11168561/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

