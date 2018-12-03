Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE42C65BAE
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 08:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 932552081C
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 08:41:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XBdTJm5D";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RJvmz7dU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 932552081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbeLCIlP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 03:41:15 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:48792 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbeLCIlO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 03:41:14 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DB00E613E4; Mon,  3 Dec 2018 08:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543826471;
        bh=rVEyTOsXON7EKyJ3o5uvdPuR1hfVnm+l5KmuOynFv4U=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=XBdTJm5D4CpbZfFHHlvPCHI2+ImjOT9CPQWqtVmDp2Eq7e5eGxOeSuGj64r1IKJjM
         rxMOMKfTYi4dfTpriAxL/2czmKmOMjY2inYdqBc82NIcFI7EBPRMe0SL/cmjwfk4/p
         7TKPvqrHD/wLUN95Fh5H2ngmxtIgDIegVEt4pW78=
Received: from x230.qca.qualcomm.com (37-33-92-201.bb.dnainternet.fi [37.33.92.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3923561342;
        Mon,  3 Dec 2018 08:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543826467;
        bh=rVEyTOsXON7EKyJ3o5uvdPuR1hfVnm+l5KmuOynFv4U=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RJvmz7dUtfMSh87MI3Dr7mVMJYpDZ5jiKo/P4Uj/d0RWQHs4TqWCFsaD85g75C6e/
         uK1LrUXVnadfEpFc4DnIr0zie+PlafMBjzeBlgUdaAnmLXaWSmRfZ3y4/aUpeqioYy
         lYXBhQLx8RYToZRZL9lvB+GRFJH4KjuNjwYK+/8I=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3923561342
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kyle Roeschley <kyle.roeschley@ni.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath6kl: Only use match sets when firmware supports it
References: <20181108163659.19535-1-kyle.roeschley@ni.com>
        <20181130201646.GA16998@senary>
Date:   Mon, 03 Dec 2018 10:41:02 +0200
In-Reply-To: <20181130201646.GA16998@senary> (Kyle Roeschley's message of
        "Fri, 30 Nov 2018 20:16:48 +0000")
Message-ID: <87pnujf1ep.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kyle Roeschley <kyle.roeschley@ni.com> writes:

> Have you had a chance to check out these patches yet?

Not yet, I have been busy with something else. BTW, you can check the
status from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#checking_state_of_patches_from_patchwork

-- 
Kalle Valo
