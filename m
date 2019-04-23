Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD47C10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 13:25:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A86A820645
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 13:25:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kNcLl9vj";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TlF2ZQq3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbfDWNZO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 09:25:14 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46514 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbfDWNZN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 09:25:13 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EDF3D615AD; Tue, 23 Apr 2019 13:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556025912;
        bh=uJm58UB6TX86k14JqdM2ndHn0mPgqUsENIQWAvQTV2I=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=kNcLl9vjVuArhcar04UXrMbw/Y0BN3JHQ5bDVqbjQEJ9CSfe+ljW6sFxfebcNU4cD
         CcPWXpJwvgVFqQi7LWQpyFaWFN+MdiLdYAV4aCb9/NDdN7StWsk/o0Y3zae35oHzjO
         Oiiu2TmaJTV+3PcQmU8dgpJ2o/e4/G4fV+zwa2Go=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A627A60AD1;
        Tue, 23 Apr 2019 13:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556025912;
        bh=uJm58UB6TX86k14JqdM2ndHn0mPgqUsENIQWAvQTV2I=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=TlF2ZQq3jjsDptafhwWfpUKHr3akoL6+HSkxLURIn4YVeZqUtvHxa9zmxd8uCXFiG
         eb5Z8H6kQy88/UgHREjFDddtL4/ZfN6lBRflUne3gsiL+SYccR84XVXopzHihv2u76
         pcWoWaMsnBydcfA/KVrx1DljXSBgFAOto0K7JNBw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A627A60AD1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/6] ath10k: sdio: workaround firmware UART pin
 configuration bug
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <155507569645.32018.15231567732563770250.stgit@potku.adurom.net>
References: <155507569645.32018.15231567732563770250.stgit@potku.adurom.net>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190423132512.EDF3D615AD@smtp.codeaurora.org>
Date:   Tue, 23 Apr 2019 13:25:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> wrote:

> On QCA6174 SDIO devices the SDIO interrupt will fail if UART is
> disabled from ath10k. SDIO firmware enables UART printouts by
> default. If ath10k will try to enable UART again the firmware
> will configure it's GPIO line incorrectly and SDIO interrupts
> won't work anymore. The workaround is to set UART pin again (19
> for QCA6174 SDIO) if uart_print is 0.
> 
> Tested with QCA6174 SDIO with firmware WLAN.RMH.4.4.1-00007-QCARMSWP-1.
> 
> Signed-off-by: Wen Gong <wgong@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

6 patches applied to ath-next branch of ath.git, thanks.

4504f0e5b571 ath10k: sdio: workaround firmware UART pin configuration bug
70736b9753fd ath10k: don't disable interrupts in ath10k_sdio_remove()
e2a6b711282a ath10k: htt: don't use txdone_fifo with SDIO
6d084ac27ab4 ath10k: initialise struct ath10k_bus params to zero
8ea51e409eb0 ath10k: htt: support MSDU ids with SDIO
30382dd1cf3a ath10k: fix use-after-free on SDIO data frames

-- 
https://patchwork.kernel.org/patch/10898285/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

