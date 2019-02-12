Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5654C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 18:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 942432190B
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 18:48:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="idnVe5+0";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="G+tPosYV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbfBLSsr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 13:48:47 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44420 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729066AbfBLSsr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 13:48:47 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 090AF6030D; Tue, 12 Feb 2019 18:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549997326;
        bh=YVjx0L0FGfXLKoBF4VJWWZHsJSazJSP9oof4yk+8Irs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=idnVe5+0Jc4b6AUgbLr763W5a6aqsp9SuO1p2P19hzV0WDJwRxz24cDTH8gn1Uk+o
         1uWAtlLL5wY/fOS44kXmD6PMA4PXu2wLUa5Wc3GKg4bFOUrl4j2YZlPEd7SMUd5z0W
         USckefKhofxGx09lGfi3CTk5aqTYE0Ma31ov7yjI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 738156090B;
        Tue, 12 Feb 2019 18:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549997325;
        bh=YVjx0L0FGfXLKoBF4VJWWZHsJSazJSP9oof4yk+8Irs=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=G+tPosYVAE6mvBuPS4ACD60a+I7WEEqwWdEHSG7KNA2HSw7iPInXgD0ozOYdv2jXJ
         yJ/fkMdSNgVB4I//S5Ykbkh5yM33R7rrAYgb4nHTRDThSXF34LJow6WwyYj4urjQ8H
         OI4UEMfBNO6Cd11FKe6Q91lLKnyX5vcW4wAT9DNk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 738156090B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: report tx airtime provided by fw
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1542298483-15879-1-git-send-email-mpubbise@codeaurora.org>
References: <1542298483-15879-1-git-send-email-mpubbise@codeaurora.org>
To:     Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190212184846.090AF6030D@smtp.codeaurora.org>
Date:   Tue, 12 Feb 2019 18:48:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Manikanta Pubbisetty <mpubbise@codeaurora.org> wrote:

> If supported, update transmit airtime in mac80211 with the airtime
> values reported by the firmware. TX airtime of the PPDU is reported
> via HTT data TX completion indication message.
> 
> A new service flag 'WMI_SERVICE_REPORT_AIRTIME' is added to advertise
> the firmware support. For firmwares which do not support this feature,
> TX airtime is calculated in the driver using TX bitrate.
> 
> Hardwares tested : QCA9984
> Firmwares tested : 10.4-3.6.1-00841
> 
> Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

bb31b7cb106c ath10k: report tx airtime provided by fw

-- 
https://patchwork.kernel.org/patch/10684687/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

