Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416A6C43143
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 04:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0686320684
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 04:50:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IHAYcYYA";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="F12L0JXM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0686320684
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbeJBLbs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 07:31:48 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34612 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbeJBLbs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 07:31:48 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 40FD46060A; Tue,  2 Oct 2018 04:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538455832;
        bh=N16BbFICYOniwUZQ1lW6viW0ornZ1mOZ9c1cb0toeow=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=IHAYcYYALOoD76AghBSpQOSKatMj6/PchbPeMFBrBlHQm1I1O87W+C9LKl3PaGy9W
         On0WTuJeIp0XjabypRbFAVxzbNls5XXp1iFPm62rtEFDzRvq4jNHgv6sokSFKaOetw
         nwneDsxs6qK/e/qNnw3FRsr1NvU2k2mJAQaa4l0w=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 88C176060A;
        Tue,  2 Oct 2018 04:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538455831;
        bh=N16BbFICYOniwUZQ1lW6viW0ornZ1mOZ9c1cb0toeow=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=F12L0JXMMisIAQcXqEeVuqWn+UhxEqeBPlUs6eA013cliNGpzGAXu8fELtN5DjLGO
         VXZtJsXVNcHkz/nLZcpSidOUd2PztnTK6KPbYyA/paDOcEV4HIhJ6uVGIqPZDywIIP
         PfOgHAj2rNM1zfw6Wwg/kQj3a/LuvLRTbW9Ov5yM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 88C176060A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: add missing sanity check on diag download
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180921204241.34316-1-briannorris@chromium.org>
References: <20180921204241.34316-1-briannorris@chromium.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Carl Huang <cjhuang@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181002045032.40FD46060A@smtp.codeaurora.org>
Date:   Tue,  2 Oct 2018 04:50:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

> ath10k_hw_diag_fast_download() generally has good boundary checking, but
> it misses verifying that the next metadata header actually fits in the
> remaining buffer space. Add such a check.
> 
> Fixes: 39501ea64116 ("ath10k: download firmware via diag Copy Engine for QCA6174 and QCA9377.")
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

e720ba1dcc33 ath10k: add missing sanity check on diag download

-- 
https://patchwork.kernel.org/patch/10610975/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

