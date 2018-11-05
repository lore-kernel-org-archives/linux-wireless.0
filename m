Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF8DECDE43
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 13:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21F9F20819
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 13:01:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="N5YXqcZR";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OCnh3d4M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21F9F20819
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbeKEWVb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 17:21:31 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54474 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728643AbeKEWVa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 17:21:30 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AF99F60600; Mon,  5 Nov 2018 13:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541422911;
        bh=LDfxs+iKUQuahqAg4Ia4wS2CVP+lxk1SxHZlF5eSR7k=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=N5YXqcZR4TfkWx2DawSzpvwW3jH7hj8t5Ti9oQ3bIwhnwPWHPsVrwbI381LqHqHMI
         r8ERruU2ZWip4wnQ6hXvHgF5ZgwrdkEvn2Qj1rYfKS4icQHm1FJVNIjp2nFWx0QH65
         QPdI33CEQ0g40A/Lkj/5VaFN4adrY9wZtbGXFyqw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6015F60316;
        Mon,  5 Nov 2018 13:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541422911;
        bh=LDfxs+iKUQuahqAg4Ia4wS2CVP+lxk1SxHZlF5eSR7k=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=OCnh3d4MI6xydG1VW2HEvhKtZEFxvkp3cAogXgoZ1PZv5akImXV7rLHp33SOyZBRz
         YMOAoDikx120MC8s05wAHaYQooKSAuJ9lZAMF4xCH8r8UV7O1TEtB+b1REiV+SAf2M
         PoOUCGxIr34kXsxNX6tM/d0mMOD7zohPEwEH4D4M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6015F60316
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 2/3] ath10k: Disable interface pause wow config for
 integrated chipset
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181012094938.14734-3-govinds@codeaurora.org>
References: <20181012094938.14734-3-govinds@codeaurora.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181105130151.AF99F60600@smtp.codeaurora.org>
Date:   Mon,  5 Nov 2018 13:01:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Govind Singh <govinds@codeaurora.org> wrote:

> wow pause iface config controls the PCI D0/D3-WOW cases for pcie
> bus state. Firmware does not expects WOW_IFACE_PAUSE_ENABLED config
> for bus/link that cannot be suspended ex:snoc and does not trigger
> common subsystem shutdown.
> Disable interface pause wow config for integrated chipset(WCN3990)
> for correct WOW configuration in the firmware.
> 
> Testing:
>     Tested on WCN3990 HW.
>     Tested FW: WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

This introduced a new warning:

drivers/net/wireless/ath/ath10k/wmi-tlv.c:3263:41: warning: incorrect type in assignment (different base types)
drivers/net/wireless/ath/ath10k/wmi-tlv.c:3263:41:    expected restricted __le32 [usertype] pause_iface_config
drivers/net/wireless/ath/ath10k/wmi-tlv.c:3263:41:    got int

I fixed it in the pending branch:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=22aab99eaf71dadc3cf2e8a2b982986a40ca641e

-- 
https://patchwork.kernel.org/patch/10638235/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

