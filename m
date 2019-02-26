Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B913FC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 886E92087C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:02:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PNYA++vr";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HInes/I2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbfBZNCx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 08:02:53 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43116 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfBZNCx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 08:02:53 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7BB6E615E8; Tue, 26 Feb 2019 13:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551186172;
        bh=2jrm0SzKZhzFs9WUw9Evsqs7LTYUoOtdFUerNTlIft8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=PNYA++vre7BosT/OdYXhBTnWOEXWCtiOOuv5XkwwaZDrStV39VPM4GFMSk36nQinY
         rOs9kUAim7lm7xlAWw5J7AV1J/UITWrB7hM4bRJIopQhrmvJJcpxofQEVhezXlN7Jg
         c6LPVr2+la9qZvVGn9izPulAtfZqhBsVw8cMHrsQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 55D59615E8;
        Tue, 26 Feb 2019 13:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551186170;
        bh=2jrm0SzKZhzFs9WUw9Evsqs7LTYUoOtdFUerNTlIft8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=HInes/I2iNUFAMyYnADEdhbaOhYiJGqCykJm7XVAdV9q83LYAKeeGcFsxNlrmcVd0
         nfw1y00LJrX2E5BMkU9jfsVyykWDpZCRajRwUajwvoKqty3EhgiivxZvI8EPzvWggg
         XYL9vhfs4NMUI5I4UZvoVsiiGcMpcnkKE1hRO/Pk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 55D59615E8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/4] ath10k: sdio: set hi_acs_flags
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1550766118-31703-2-git-send-email-kvalo@codeaurora.org>
References: <1550766118-31703-2-git-send-email-kvalo@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Alagu Sankar <alagusankar@silex-india.com>,
        Wen Gong <wgong@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190226130252.7BB6E615E8@smtp.codeaurora.org>
Date:   Tue, 26 Feb 2019 13:02:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> wrote:

> The SDIO firmware does not allow transmitting packets with the
> reduced tx completion HI_ACS option. SDIO firmware uses 1544 as
> alternate credit size, which is not big enough for the maximum sized
> mac80211 frames. Disable both these HI_ACS flags for SDIO.
> 
> Co-developed-by: Wen Gong <wgong@codeaurora.org>
> Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
> Signed-off-by: Wen Gong <wgong@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

4 patches applied to ath-next branch of ath.git, thanks.

bf1f0a1a4da1 ath10k: sdio: set hi_acs_flags
6cd70c65647b ath10k: sdio: disable fwlog prints
55545b087012 ath10k: sdio: reset chip on power_down()
7d4445223031 ath10k: don't report unset rssi values to mac80211

-- 
https://patchwork.kernel.org/patch/10824323/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

