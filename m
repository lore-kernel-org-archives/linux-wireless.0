Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9BC6C46475
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 13:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CAB520819
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 13:04:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jgGb5QqM";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ODWpg/8h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8CAB520819
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbeKEWXn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 17:23:43 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56086 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728947AbeKEWXn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 17:23:43 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B2BEB60A9B; Mon,  5 Nov 2018 13:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541423043;
        bh=QGWrXapZwbXXg2Kid/RGYWzhZ0Ud3t3dvZtwLIfpFWc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jgGb5QqMSY9yKW6OUGoQO/wKBeUwULewkz+8O6fXbptoWAHE8Q4sp+/go/q4lw1kK
         mQuYWp+uWc3oSFj0uz2T2Ky77wBUSX6LAISpOp5BhtiH5o6+r4Ue0VY2JU1Pqib5Lb
         3o9/i5ZUwISLK0EvzaNUrh95YyuaDluoknVxM1hM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5A4EB60316;
        Mon,  5 Nov 2018 13:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541423043;
        bh=QGWrXapZwbXXg2Kid/RGYWzhZ0Ud3t3dvZtwLIfpFWc=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ODWpg/8haxwsRvn/nqPXphXn5CFRWEWoFEGwjGZ/AIpmLXbSCBLNZSa6yJD8OdF8H
         p7z9O6rpOp6xQw1dP6rpWSH/TY0Ijf0OK0EstSX6UiNiVz9cyZmhTsStS3EMTcelLN
         jhZ2a0l2rOOWWM1k5FP2ZaCZb77lkVVEUndKMsoE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5A4EB60316
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/4] ath10k: snoc: remove 'wcn3990' from generic resource
 handling
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181013005504.46399-1-briannorris@chromium.org>
References: <20181013005504.46399-1-briannorris@chromium.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181105130403.B2BEB60A9B@smtp.codeaurora.org>
Date:   Mon,  5 Nov 2018 13:04:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

> ath10k_wcn3990_clk_info and ath10k_wcn3990_vreg_info are not
> WCN3990-specific structures. They hold generic data. So don't name them
> with wcn3990 specifics.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Reviewed-by: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

This patchset (I think it was with the first patch, but not sure) had some
conflicts but 3-way merge was able to automatically solve them. Please check
the end result anyway:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=77adda81e264e0c93af9570ac4ada82a5d0f5d99

-- 
https://patchwork.kernel.org/patch/10639795/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

