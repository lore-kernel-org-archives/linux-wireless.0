Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD77C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 16:34:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 977532075D
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 16:34:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="l/H6o8fZ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Or4M+emv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbfBKQec (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 11:34:32 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43854 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbfBKQec (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 11:34:32 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5D314616B6; Mon, 11 Feb 2019 16:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549902871;
        bh=M6zZ3nHrXFZou0kIliTz2ZuvrZxp1eCwNBq4pVtRFYU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=l/H6o8fZgFd0xqPRbkRKaxsuLuwR0oeuMZlNTvZmNR/HSRvdCcCQ/YUxayn7syS0I
         yTZuzWOZMuCI6sAHxrUgQA+eSno3qK5pq/sR7/hD82FtSeyASs5hZ2csUg+sClvWsY
         v/4AZ6fEdrFmbDe3tDA2q/gR49ocgeYDtaXMm2Eo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9191860CDF;
        Mon, 11 Feb 2019 16:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549902870;
        bh=M6zZ3nHrXFZou0kIliTz2ZuvrZxp1eCwNBq4pVtRFYU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Or4M+emvXUB5S70YQ5l8mL7RpHJ8CefNpcA1r3jK1sZjSgx2LavORfB/CfCH1nw3x
         hXHkeLuzWj+uqK/eCv+GyMu/w5bDCeAwcB6SDZlAKnHjotgx4c71/Tqmd4Rzo0KVjf
         /aZdqdFGqpcJU1j0aKFpBMtPw3veIhjvdilUWfTg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9191860CDF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Enable Factory Test Mode for WCN3990
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1535526038-4299-1-git-send-email-pillair@codeaurora.org>
References: <1535526038-4299-1-git-send-email-pillair@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190211163431.5D314616B6@smtp.codeaurora.org>
Date:   Mon, 11 Feb 2019 16:34:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rakesh Pillai <pillair@codeaurora.org> wrote:

> The support to put WCN3990 firmware into Factory
> test mode is not present currently. The WCN3990
> firmware can operate in Factory test mode based
> on the mode it receives in the wlan enable message
> from the host driver.
> 
> When the host driver is started in testmode send
> the operating mode as UTF mode, to the WCN3990
> firmware, in the wlan enable message to start the
> firmware in Factory test mode.
> 
> Tested on: WCN3990
> Tested FW: WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1.
> 
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

3c545a25939c ath10k: enable Factory Test Mode for WCN3990

-- 
https://patchwork.kernel.org/patch/10579559/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

