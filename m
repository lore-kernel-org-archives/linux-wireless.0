Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D568C4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0B88205C9
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:00:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dWbNUsg1";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kGZDLK46"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbfDDKA6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 06:00:58 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54506 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbfDDKA6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 06:00:58 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DD15A614B6; Thu,  4 Apr 2019 10:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554372057;
        bh=3aDw+agKFwnTuoAabT7cg7JJG4hjIlqLs1mIcLZWzNs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=dWbNUsg11N679Dy4DX8fe2rl9wTVYISKIVQpTfqEJwFtdzW/ptEL3Qp3GP0j+dHNA
         pPdlAxM0sIqApQOnuj54xBXLLvVUw5S3nJCbjcYfxIck+x4ieN4nyzs3NaVlER/wi1
         gzWeHvlGfiAWW4Jh2BzM/cL3uUegXxa39t1rBNX8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 25D7F60850;
        Thu,  4 Apr 2019 10:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554372055;
        bh=3aDw+agKFwnTuoAabT7cg7JJG4hjIlqLs1mIcLZWzNs=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=kGZDLK46vMMmZrNH+G1VY+AlCAisVqi9WPssa2A7LqYYLFM2mcjL/JHU7XTtyG9QU
         KceRoDDdAcPKP5Dv69fXi15k11EwhHF190+4/olXBkgWsegNKGzVWIMGXwYtNVzMwM
         YfF/xmXlpGfAL1krTzSUHWKEb3ov4A++DvhGxjbA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 25D7F60850
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/4] brcmfmac: support repeated brcmf_fw_alloc_request()
 calls
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190226131119.7907-2-zajec5@gmail.com>
References: <20190226131119.7907-2-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190404100057.DD15A614B6@smtp.codeaurora.org>
Date:   Thu,  4 Apr 2019 10:00:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> During a normal brcmfmac lifetime brcmf_fw_alloc_request() is called
> once only during the probe. It's safe to assume provided array is clear.
> 
> Further brcmfmac improvements may require calling it multiple times
> though. This patch allows it by fixing invalid firmware paths like:
> brcm/brcmfmac4366c-pcie.binbrcm/brcmfmac4366c-pcie.bin
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>

3 patches applied to wireless-drivers-next.git, thanks.

c9692820710f brcmfmac: support repeated brcmf_fw_alloc_request() calls
a2ec87ddbf16 brcmfmac: add a function designated for handling firmware fails
4684997d9eea brcmfmac: reset PCIe bus on a firmware crash

-- 
https://patchwork.kernel.org/patch/10830169/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

