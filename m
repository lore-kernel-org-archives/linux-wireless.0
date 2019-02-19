Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDAA9C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A813D20859
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:06:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZLZWq4An";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HGVN+A92"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbfBSPGZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:06:25 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33862 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbfBSPGY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:06:24 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 04E1C608FB; Tue, 19 Feb 2019 15:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550588784;
        bh=aYljjEYhdBVlw/ys1M81Q+MXKYzEpYlv+5ESK5ZmLo4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ZLZWq4AnvfSu79ZgqZ4mN0MYREOOdv+OyOuEYPb8aw4+Y9qznUPnR5qkjCBKehTSE
         e3HxDXH/QHoMqGT3z81z4aOmsg/vqhBTG/mjItr0gt080DN4RWNE7gYVHoW6DQDn2f
         IBvMuM1VZQ+sCgyLDWOZbaZPQIUogMX8s6r8aFL8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C27CB60779;
        Tue, 19 Feb 2019 15:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550588782;
        bh=aYljjEYhdBVlw/ys1M81Q+MXKYzEpYlv+5ESK5ZmLo4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=HGVN+A92s6/O2UoQZsvIbNaFjVF6KcqXYgVZ8N1IC+UgAc8S3isxszhUE1PEXL+vU
         0bbn+eaJrMOmC7HrgidvtJdr+ZRPVa0BR7greR4kiBwf2Dcb0EwtsNy8u4GNcIeWuo
         lVZUdkP54KcXqv1/zKh8YdEHWr8+0VBNoWQIFNxE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C27CB60779
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] brcmfmac: print firmware reported ring status errors
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190208142439.21479-1-zajec5@gmail.com>
References: <20190208142439.21479-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190219150624.04E1C608FB@smtp.codeaurora.org>
Date:   Tue, 19 Feb 2019 15:06:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Firmware is capable of reporting ring status. It's used e.g. to signal
> some problem with a specific ring setup. This patch adds support for
> printing ring & error number which may be useful for debugging setup
> issues.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Patch applied to wireless-drivers-next.git, thanks.

c988b78244df brcmfmac: print firmware reported ring status errors

-- 
https://patchwork.kernel.org/patch/10803203/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

