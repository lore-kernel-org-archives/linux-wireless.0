Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D0E5C48BDF
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jun 2021 10:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD9E661443
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jun 2021 10:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhFOK3Z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jun 2021 06:29:25 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:60870 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbhFOK3U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jun 2021 06:29:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623752836; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Gf5Li8EDKHNYJCLqky7WwRi6db9pnqeeN2/vQ5NDl3g=;
 b=fRwzru7di5MPP5S68AJIkLUjkHTfDDTsj83CHUy8Gi/e3qwntB23tlyMR7TTWBdumIT2aZva
 Bst+db8Shf8iXbHtJJvc89Q9WcOfrAIF0WD4Acr6DYmHT8qczekY7uLTKADKFF9mmejuNmKL
 GjoxQL3zOokD+q7WPp1Hda58kq0=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 60c88071e27c0cc77f1b6fe2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 10:26:57
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F3DB7C43147; Tue, 15 Jun 2021 10:26:56 +0000 (UTC)
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 517B9C4338A;
        Tue, 15 Jun 2021 10:26:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 517B9C4338A
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: fix a loop exit condition
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <YIKzmoMiTdToaIyP@mwanda>
References: <YIKzmoMiTdToaIyP@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Hans deGoede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        kernel-janitors@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210615102656.F3DB7C43147@smtp.codeaurora.org>
Date:   Tue, 15 Jun 2021 10:26:56 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> This code is supposed to loop over the whole board_type[] string.  The
> current code kind of works just because ascii values start 97 and the
> string is likely shorter than that so it will break when we hit the NUL
> terminator.  But really the condition should be "i < len" instead of
> "i < board_type[i]".
> 
> Fixes: 29e354ebeeec ("brcmfmac: Transform compatible string for FW loading")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Matthias Brugger <mbrugger@suse.com>

There was talk about v2, but I don't see it in the patchwork.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/YIKzmoMiTdToaIyP@mwanda/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

