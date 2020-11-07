Return-Path: <SRS0=yPAo=EN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46D37C388F7
	for <linux-wireless@archiver.kernel.org>; Sat,  7 Nov 2020 15:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA99520888
	for <linux-wireless@archiver.kernel.org>; Sat,  7 Nov 2020 15:52:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="lTQwqFBY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgKGPwK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 7 Nov 2020 10:52:10 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:37692 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgKGPwI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Nov 2020 10:52:08 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604764328; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=paRPLLMEDaPHNpLWzkRap3o9yFkBZDHVPQZ4eder14I=;
 b=lTQwqFBYKmbdzS/kzKzw/BROBHcJWVJIEtT20olvNK0kcfsg/YebNKgF/IyqgIC3Kq359Btu
 fKr8rGbajgr0xAncI8Thn9MlE4hupmzPUmfg4ofiuNhzw1Ns07L3HpEc3vFD7dHMzebyPfri
 s12bcdm5ydjiVewawxtqrOnBvkQ=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5fa6c2a2dd52edb734693199 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 07 Nov 2020 15:52:02
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9EF89C433C8; Sat,  7 Nov 2020 15:52:02 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7F5EAC433C9;
        Sat,  7 Nov 2020 15:52:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7F5EAC433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtl8xxxu: Add Buffalo WI-U3-866D to list of supported
 devices
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201101173236.7851-1-ikegami.t@gmail.com>
References: <20201101173236.7851-1-ikegami.t@gmail.com>
To:     Tokunori Ikegami <ikegami.t@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Tokunori Ikegami <ikegami.t@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201107155202.9EF89C433C8@smtp.codeaurora.org>
Date:   Sat,  7 Nov 2020 15:52:02 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tokunori Ikegami <ikegami.t@gmail.com> wrote:

> Buffalo WI-U3-866D is supported by the rtl8812au driver.
> Also RTL8812AU software supports the product RTL8192EU also.
> So add Buffalo WI-U3-866D with the RTL8192EU driver info.
> 
> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
> Cc: linux-wireless@vger.kernel.org

Patch applied to wireless-drivers-next.git, thanks.

28606150768a rtl8xxxu: Add Buffalo WI-U3-866D to list of supported devices

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201101173236.7851-1-ikegami.t@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

