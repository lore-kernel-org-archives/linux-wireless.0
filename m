Return-Path: <SRS0=0mSa=WC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7CF7C433FF
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Aug 2019 12:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67F7C20818
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Aug 2019 12:43:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AnboDzQL";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="In2ZqeL/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbfHFMnO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Aug 2019 08:43:14 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35818 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfHFMnO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Aug 2019 08:43:14 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 933CC6074F; Tue,  6 Aug 2019 12:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565095393;
        bh=wlR/lDs00ZOLRFeCUJ5ZTMuowWm0lkgkezx/fcUbV78=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=AnboDzQLQn/JW3obHRfuetPFI2MZQ/HVZnmXSfMJjpITVjH9RxzS2xGHIir/2Rr4S
         bigEDNsULr0mxnZBGUfgYH3Z1VaFIU+52LelUk/+VMy2wS/Sxlupvxn4cnqxh9w63p
         BXLZ1umC7YhMp636MmSrYzDMybyCiTziqmeQGkas=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4DFCB6038E;
        Tue,  6 Aug 2019 12:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565095393;
        bh=wlR/lDs00ZOLRFeCUJ5ZTMuowWm0lkgkezx/fcUbV78=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=In2ZqeL/ypKaYNemnvPbVUEZvZhg578PBkV7tCT5QzdWFlcr2BZPGWwBPcsrnfc6n
         pFTbZcYDok5G2fvVdcaXW4IZ0UefMdiYA5Vu+RS+hhhpOlKGMFZ1u6cOWfSUZXLWHx
         N6uKD2OxgJHwsJ7fxBXQK8kWYFoVgPrtwg/dZjc8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4DFCB6038E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/4] rtlwifi: rtl8192ce: Remove unused GET_XXX and SET_XXX
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190802012102.7945-2-Larry.Finger@lwfinger.net>
References: <20190802012102.7945-2-Larry.Finger@lwfinger.net>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190806124313.933CC6074F@smtp.codeaurora.org>
Date:   Tue,  6 Aug 2019 12:43:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> As the first step in converting from macros that get/set information
> in the RX and TX descriptors, unused macros are being removed.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

4 patches applied to wireless-drivers-next.git, thanks.

49a52d05a3c7 rtlwifi: rtl8192ce: Remove unused GET_XXX and SET_XXX
a246b9291433 rtlwifi: rtl8192ce: Replace local bit manipulation macros
98fd8db59a00 rtlwifi: rtl8192ce: Convert macros that set descriptor
c85a63766738 rtlwifi: rtl8192ce: Convert inline routines to little-endian words

-- 
https://patchwork.kernel.org/patch/11071637/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

