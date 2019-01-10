Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F220C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 202CB206B6
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:40:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TS8BWdP4";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fUXpRP0B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbfAJLkR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 06:40:17 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:52490 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727938AbfAJLkR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 06:40:17 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 386626079B; Thu, 10 Jan 2019 11:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547120416;
        bh=kvwu/MmMbR9Ph0Ejm5JtWfP46K4tzwqYk9QI4vuLiG0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=TS8BWdP42eGz1Ndl/bGdc6GOU3KpWTIUWaa2vZEia20Fs3ix4Bfgy6IldE4RQPBzf
         LKSfkGL/9N3U7z/tzzk3Eo0pH92exv7rfmNJA9tAHaQWsVRqEO2bL9W2GnzdmKFT/1
         Sb5He8k9yCCFgC7nCiKSJy7iMlhXrJPEbQVXtydY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 033B26038E;
        Thu, 10 Jan 2019 11:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547120415;
        bh=kvwu/MmMbR9Ph0Ejm5JtWfP46K4tzwqYk9QI4vuLiG0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=fUXpRP0BD+Z+RYa6XMvnDjRxVN8jLrVHNg8e0btw5jKY31YOzCLP1GFT/0dbTo8Dz
         530yfHMmEGBjxtTxFkI+fPfcLlKLFUVvepHenO0D6XGsQKavdtGXF5P0z9M+vM7P1w
         qrasNTv1IrgwuriZlIplEtj5tvHvDpaRhnTOwHlQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 033B26038E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] bcma: keep a direct pointer to the struct device
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190101230002.18845-1-zajec5@gmail.com>
References: <20190101230002.18845-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190110114016.386626079B@smtp.codeaurora.org>
Date:   Thu, 10 Jan 2019 11:40:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Accessing struct device is pretty useful/common so having a direct
> pointer:
> 1) Simplifies some code
> 2) Makes bcma_bus_get_host_dev() unneeded
> 3) Allows further improvements like using dev_* printing helpers
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

2 patches applied to wireless-drivers-next.git, thanks.

5a1c18b761dd bcma: keep a direct pointer to the struct device
777bc4801a68 bcma: use dev_* printing functions

-- 
https://patchwork.kernel.org/patch/10746011/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

