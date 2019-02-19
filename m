Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A87A2C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7467620859
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:05:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CvHj2iuh";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="m7OXir0U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbfBSPFy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:05:54 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33712 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbfBSPFy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:05:54 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D97256071A; Tue, 19 Feb 2019 15:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550588753;
        bh=niQY2pvkOIBj/NZVDQk1rZxhitHsILz+z3II9RB5HE4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=CvHj2iuhNlhDNk0WuHXnxXWM7ahMsfHwaWWiUjY7iFKKiJZ9XHHZvhYx8W7RVVJSD
         Ac4ahczApU1aVnruxssWIqxNVjfp1N3U01/nV6Mfsn31CdGTirTUIFlZwx+AdB65/K
         Ezp/mL8yAjMWy2qXo5x7d+kjAo92O37vkYHcSdw0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B872B6071A;
        Tue, 19 Feb 2019 15:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550588753;
        bh=niQY2pvkOIBj/NZVDQk1rZxhitHsILz+z3II9RB5HE4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=m7OXir0UV6HQP+8pGdUI1uhk23GYZ+XceWgZtj75EJF+UGdhWsAwt8aslF2BpTa8b
         WoOHCMG9TtD6BmPAqGblo4TkFkVmqYK8Li6NrbiexW5aV0g3YTlzBUgelbJ/xrgfwf
         YcZGscx6Y9C9W47+LdYw/uxiJFqSBpC+7rOjHEew=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B872B6071A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/6] brcmfmac: assure SSID length from firmware is limited
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1550148232-4309-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1550148232-4309-2-git-send-email-arend.vanspriel@broadcom.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190219150553.D97256071A@smtp.codeaurora.org>
Date:   Tue, 19 Feb 2019 15:05:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Arend van Spriel <arend.vanspriel@broadcom.com> wrote:

> The SSID length as received from firmware should not exceed
> IEEE80211_MAX_SSID_LEN as that would result in heap overflow.
> 
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

6 patches applied to wireless-drivers-next.git, thanks.

1b5e2423164b brcmfmac: assure SSID length from firmware is limited
a4176ec356c7 brcmfmac: add subtype check for event handling in data path
aaf6a5e86e36 brcmfmac: create debugfs files for bus-specific layer
92d3b88b1029 brcmfmac: disable MBSS feature for bcm4330 device
4ab2cf03da91 brcmfmac: check and dump trap info during sdio probe
a250c91c1762 brcmfmac: use chipname in brcmf_fw_alloc_request() for error path as well

-- 
https://patchwork.kernel.org/patch/10812617/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

