Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46D0FC282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 15:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E1A021904
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 15:03:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OuMjxUWb";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZEHBvCc0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfBGPDb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 10:03:31 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37388 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfBGPDb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 10:03:31 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 41DEA60247; Thu,  7 Feb 2019 15:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549551810;
        bh=LJS9EHqX/sqy+1DUgxAdhkO+wX01b0bMADSPX4rUpsY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=OuMjxUWbXDdIL+3ZwZ50Hu5ixvqjohiVMDajYPh08vBLE3fDNFX2waEc69se52OmL
         wRkvNHatwBralj7kdb6jkD+/VkSzQ2Sf475nci/araudeCHmXs8GdB8TaRQZSyhwCv
         joqwNH0RwYQC+/N5gU4zpipkSr/EboAU2hifYlQE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F1723602B8;
        Thu,  7 Feb 2019 15:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549551809;
        bh=LJS9EHqX/sqy+1DUgxAdhkO+wX01b0bMADSPX4rUpsY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ZEHBvCc0O1utUQTE+C9kltH1UiC1JV+IqxkHj9FnuxnXr8GzkJZlRkwcMKVxuhftS
         f47qxmgFcxDr5/U14QMp5S592BKmkMEBTAc5i2HtD3I2gCU4M2KGpRBuoMu8cRIXTo
         x8kYh6c4csqLXHn1T6zW9/OO33FgALcQfmYJRbNY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F1723602B8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath: regd: add extra US coutry codes
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190126163019.10590-1-chunkeey@gmail.com>
References: <20190126163019.10590-1-chunkeey@gmail.com>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Oever Gonzalez <notengobattery@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190207150330.41DEA60247@smtp.codeaurora.org>
Date:   Thu,  7 Feb 2019 15:03:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Christian Lamparter <chunkeey@gmail.com> wrote:

> This patch adds several country codes to the regd.h and regd_common.h
> files in order to support devices like the Linksys EA6350v3, whose
> country codes are not present in the original list. Without this patch,
> all devices whose manufacturer programmed any of these code in their
> EEPROM will not work.
> 
> The values for CTRY_UNITED_STATES2 and CTRY_UNITED_STATES3 were taken
> from a post by Sven Eckelmann <sven.eckelmann@openmesh.com>:
> <http://lists.infradead.org/pipermail/ath10k/2017-August/010014.html>
> 
> Signed-off-by: Oever Gonzalez <notengobattery@gmail.com>
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

62a2c1355c15 ath: regd: add extra US coutry codes

-- 
https://patchwork.kernel.org/patch/10782507/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

