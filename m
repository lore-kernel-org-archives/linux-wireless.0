Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B68CC28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1578C20835
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:28:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cbCUPP6y";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iidGhgiS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1578C20835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbeJNBGL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 21:06:11 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48980 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbeJNBGL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 21:06:11 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A856160B72; Sat, 13 Oct 2018 17:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539451690;
        bh=YXxlBEd/5bngA360d+gxMCtkWjR553XLNUqAfnIrHLE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=cbCUPP6yfYA99RAp4WCb/jtwe8ginadealRprv8eVaiYMDeoTFniruJh5kr2CL0mR
         6YHQwc9a5P0WOWTDBiDyXvefqnGiKoKteiyGcCh0ztmheGPoRPPUPezT/6MfCu1GjZ
         QQeL7tkof9zr2U6PiNuC0EeL0OO6dJUwVbhrmO7M=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3ED9660B72;
        Sat, 13 Oct 2018 17:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539451690;
        bh=YXxlBEd/5bngA360d+gxMCtkWjR553XLNUqAfnIrHLE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=iidGhgiSlr7OW48R0rhr7sGTkFo0D1AceDuUHrIdbOrvi6ZoPVQ/18QWPu3XxC4cZ
         PEHPXA9C1iUTCzgOvOkxLqhzzdDrt8zGpH9VzozFqGpi8tv5A2DK7qQdMXxyN0ZFX2
         pLFyhe4Q0WSA8nI3z8S4z2H1O0ejFYCNRsqu513Q=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3ED9660B72
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k: fix RX_STAT_INC() etc macros
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181009160351.680666-1-arnd@arndb.de>
References: <20181009160351.680666-1-arnd@arndb.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181013172810.A856160B72@smtp.codeaurora.org>
Date:   Sat, 13 Oct 2018 17:28:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:

> A couple of macros that deal with statistics in ath9k rely on the
> declaration of the 'sc' variable, which they dereference.
> 
> However, when the statistics are disabled, the new instance in
> ath_cmn_process_fft() causes a warning for an unused variable:
> 
> drivers/net/wireless/ath/ath9k/common-spectral.c: In function 'ath_cmn_process_fft':
> drivers/net/wireless/ath/ath9k/common-spectral.c:474:20: error: unused variable 'sc' [-Werror=unused-variable]
> 
> It's better if those macros only operate on their arguments instead of
> known variable names, and adding a cast to (void) kills off that warning.
> 
> Fixes: 03224678c013 ("ath9k: add counters for good and errorneous FFT/spectral frames")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

72569b7be461 ath9k: fix RX_STAT_INC() etc macros

-- 
https://patchwork.kernel.org/patch/10632911/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

