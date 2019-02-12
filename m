Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3BA6C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 18:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E7F7222BE
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 18:51:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TT+Phy1J";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FCDUKIhs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbfBLSv0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 13:51:26 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:47994 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbfBLSv0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 13:51:26 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 168CC60734; Tue, 12 Feb 2019 18:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549997485;
        bh=7MdaXdIg+mUvfGbWjRALGiNA8qU/zMxwjPnFnSLekpQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=TT+Phy1JnQGF8wMBGtD/g6SOM7CxU5mk9WnbJ0//jrcKGvh/AB1Fj/9EJojrRJdEE
         ZoYsiA6dzuawskMGQlp9vfspAMOF8qysLaL70IYXf1vcGhk0AFkkMeJPPCbfJ0bKhS
         aaDXaimYeoBI7fA/MS/rTGtZHOxGXTIxaoqhfmSc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A03CF60208;
        Tue, 12 Feb 2019 18:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549997484;
        bh=7MdaXdIg+mUvfGbWjRALGiNA8qU/zMxwjPnFnSLekpQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=FCDUKIhs59I+R5Z+UfC4ASZUCZ0ONJmjQ7rUwZvX7FUQwXcQl6elyXBgqWWNUyvLY
         zRTfKMHuGKLYTY3tIyP6r+/ImmPkEAgVN3L6uiZikp+KhSCvtCrrSNT0CLZJ7D48Cd
         ewSl25AknuDU5LuBCWT1UyKvJciKNAB+n1iwQcBA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A03CF60208
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/6] ath10k: add missing values to wmi_service_name()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1549897787-28537-1-git-send-email-kvalo@codeaurora.org>
References: <1549897787-28537-1-git-send-email-kvalo@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190212185125.168CC60734@smtp.codeaurora.org>
Date:   Tue, 12 Feb 2019 18:51:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> wrote:

> After implementing the next patch GCC reported:
> 
> drivers/net/wireless/ath/ath10k/wmi.h:385:2: warning: enumeration value 'WMI_SERVICE_BTCOEX' not handled in switch [-Wswitch]
> drivers/net/wireless/ath/ath10k/wmi.h:385:2: warning: enumeration value 'WMI_SERVICE_MGMT_TX_WMI' not handled in switch [-Wswitch]
> drivers/net/wireless/ath/ath10k/wmi.h:385:2: warning: enumeration value 'WMI_SERVICE_SPOOF_MAC_SUPPORT' not handled in switch [-Wswitch]
> drivers/net/wireless/ath/ath10k/wmi.h:385:2: warning: enumeration value 'WMI_SERVICE_VDEV_DISABLE_4_ADDR_SRC_LRN_SUPPORT' not handled in switch [-Wswitch]
> drivers/net/wireless/ath/ath10k/wmi.h:385:2: warning: enumeration value 'WMI_SERVICE_BB_TIMING_CONFIG_SUPPORT' not handled in switch [-Wswitch]
> drivers/net/wireless/ath/ath10k/wmi.h:385:2: warning: enumeration value 'WMI_SERVICE_THERM_THROT' not handled in switch [-Wswitch]
> 
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

6 patches applied to ath-next branch of ath.git, thanks.

2321dd5d78fb ath10k: add missing values to wmi_service_name()
95cccf4d79fe ath10k: make wmi_service_name() warn about missing service ids
db3b6280f5f1 ath10k: change wmi.h to include only ieee80211.h
385bd8816cb5 ath10k: align ath10k_htt_txbuf structures
bdf2bd9aa684 ath10k: fix documentation in ath10k_wow_convert_8023_to_80211()
01dc76dfdc91 ath10k: copy the whole struct ath10k_bus_params in ath10k_core_register()

-- 
https://patchwork.kernel.org/patch/10806063/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

