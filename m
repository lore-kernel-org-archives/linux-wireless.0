Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB80C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 16:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 047902175B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 16:01:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WJLCjzhz";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kzpzxdKp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfBGQBg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 11:01:36 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37768 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfBGQBg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 11:01:36 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4F668608CF; Thu,  7 Feb 2019 16:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549555295;
        bh=8fZbYtqPgCpvOuYhTacC5Nbzg3j1Yvmvy7zcyhobdwE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=WJLCjzhz0bei6FpN8ae1rrQW0osS7UC+mIm+MFYYljdHVYbdNDCY2lZTIqfxG11Gy
         PajJt1y+Sr9DFFVx1tKBeNqPlJYSI+bh0dlofPCv/Pgihy9r65U/zYevSs39fvZrlr
         LB84kxu+6z7F/ZXxZlXt/on0ONPKTqvLeb8wzatI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9AAD06047C;
        Thu,  7 Feb 2019 16:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549555294;
        bh=8fZbYtqPgCpvOuYhTacC5Nbzg3j1Yvmvy7zcyhobdwE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=kzpzxdKppdTAcxdyNHHHvPq7yThH8uql7cMuv+A0QLzE2ulAQUIT6pohf+IfI/iQJ
         4+KzAslmGTRoYNswWVYwOyBsQPrAdb76WvG7O5AAuWWHXcciepCj1ND5XRNLOHSf7V
         yPqPmmqa0VVt194/brWZ1T+5GMy2tagq1lGBJ4xs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9AAD06047C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 2/3] ath10k: Disable interface pause wow config for
 integrated chipset
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190206121433.11606-3-govinds@codeaurora.org>
References: <20190206121433.11606-3-govinds@codeaurora.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190207160135.4F668608CF@smtp.codeaurora.org>
Date:   Thu,  7 Feb 2019 16:01:35 +0000 (UTC)
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

This issued a new warning:

drivers/net/wireless/ath/ath10k/wmi-tlv.c:3327:41: warning: incorrect type in assignment (different base types)
drivers/net/wireless/ath/ath10k/wmi-tlv.c:3327:41:    expected restricted __le32 [usertype] pause_iface_config
drivers/net/wireless/ath/ath10k/wmi-tlv.c:3327:41:    got int

I fixed it in the pending branch:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=f21da752a87f8fefdf97fcef565adce9c778fc5e

-- 
https://patchwork.kernel.org/patch/10799253/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

