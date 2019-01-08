Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF864C43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 17:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0BD420883
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 17:28:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ARuEOSt/";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="I+WYWXpn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbfAHR2F (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 12:28:05 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46348 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbfAHR2F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 12:28:05 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2E23C6089D; Tue,  8 Jan 2019 17:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546968484;
        bh=IcB9O/UziZNCHaA5vWJotzNGqU1gbZezZBS8BHEzx+Y=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ARuEOSt/GE92TJgBrxPRXOXk8q2Hp9km29YHgllGIVNYwj9QwHumFpIj5EwUtnFWO
         bBjGIcCFd9ttNhFdc24d4ZHLKa/HBulnui1DG7XTZdwNcfXDgcBBt30Fbiqgh5lzRd
         GBI5fAgBj9QSFoZtq3JgMfFbUMBcOMhd5PCBUKMI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 99CFB60132;
        Tue,  8 Jan 2019 17:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546968483;
        bh=IcB9O/UziZNCHaA5vWJotzNGqU1gbZezZBS8BHEzx+Y=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=I+WYWXpnA6Tp7GrxDMGHGFa2f9ZcWOWFuh8+4WjGTzE9YfPMMLuyfnBGnqtfFRe4m
         YCzRY8HVkyc5HBuELDjJdByIzd4IKw91CDC4f+aG7igYf5L22hAMnPUjsGRhCksLPx
         SxeQBrQE2IsxJuKDRO2/KSkUEk4DOgDt6VeV4lP8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 99CFB60132
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 1/4] rtl8723ae: Take the FW LPS mode handling out
References: <DB7PR07MB535316A20C8447096DBC822DE4880@DB7PR07MB5353.eurprd07.prod.outlook.com>
Date:   Tue, 08 Jan 2019 19:27:59 +0200
In-Reply-To: <DB7PR07MB535316A20C8447096DBC822DE4880@DB7PR07MB5353.eurprd07.prod.outlook.com>
        (Bernd Edlinger's message of "Sun, 6 Jan 2019 00:02:18 +0000")
Message-ID: <875zuzqctc.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> This appears to trigger a firmware bug and causes severe
> problems with rtl8723ae PCI devices.
>
> When the power save mode is activated for longer periods
> of time the firmware stops to receive any packets.
>
> This problem was exposed by commit 873ffe154ae0 ("rtlwifi:
> Fix logic error in enter/exit power-save mode").
>
> Previously the power save mode was only active rarely and
> only for a short time so that the problem was not noticeable.
>
> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
> ---
> v2: Adjust the defaults of swlps and fwlps module
> parameters to match the firmware capabilities instead of removing
> the whole code, so it can be easily re-activated once a firmware
> update is available.
>
> v3: Make the title fit in one line.

hotmail.de made me suspicious and indeed my Spidey sense was right:

Applying: rtl8723ae: Take the FW LPS mode handling out
Using index info to reconstruct a base tree...
.git/rebase-apply/patch:22: trailing whitespace.
        .swctrl_lps = true,
.git/rebase-apply/patch:23: trailing whitespace.
        .fwctrl_lps = false,
.git/rebase-apply/patch:33: trailing whitespace.
MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 1)\n");
.git/rebase-apply/patch:34: trailing whitespace.
MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 0)\n");
error: patch failed: drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c:266
error: drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c: patch does not apply
error: Did you hand edit your patch?
It does not apply to blobs recorded in its index.
Patch failed at 0001 rtl8723ae: Take the FW LPS mode handling out

Did you use Outlook to send this patch or what? Anyway, it's strongly
suggested to use git to submit the patches (and not use Outlook servers
either as they are notorious in breaking our patches):

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#format_issues

-- 
Kalle Valo
