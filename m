Return-Path: <SRS0=wUDZ=DN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49153C4727E
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Oct 2020 07:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E850820760
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Oct 2020 07:18:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="CBrrnHHo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgJFHSz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Oct 2020 03:18:55 -0400
Received: from z5.mailgun.us ([104.130.96.5]:26304 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbgJFHSz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Oct 2020 03:18:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601968734; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=9Bgnf5yb7Qe23xkz/B3GUG4YvFw6rRqLrKIvEHwuJW4=; b=CBrrnHHoXhrVWspx9UzIzq8G/DSFMhvaDGAGoAnTQUIycZ+Q04oK2GJ0J5/ESuJ6WwO5Fcp2
 +hEYDJ0VpN/Aj+i4Vsv7gVmy4jYCZPIRFlHeEWopswsg07MsCwZpXM2Kq8J4WIbQa1+61Fqt
 G7klh6GXVJnVhJlY98t8boiTELs=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5f7c1a5a0764f13b0086bd55 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 06 Oct 2020 07:18:50
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 96557C43395; Tue,  6 Oct 2020 07:18:49 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A263BC433CB;
        Tue,  6 Oct 2020 07:18:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A263BC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Allen Pais <allen.lkml@gmail.com>
Cc:     ryder.lee@mediatek.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        lorenzo.bianconi83@gmail.com, kuba@kernel.org,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <apais@linux.microsoft.com>, davem@davemloft.net,
        nbd@nbd.name
Subject: Re: [PATCH 2/2] wireless: mt76: convert tasklets to use new tasklet_setup() API
References: <20201006055135.291411-1-allen.lkml@gmail.com>
        <20201006055135.291411-3-allen.lkml@gmail.com>
Date:   Tue, 06 Oct 2020 10:18:43 +0300
In-Reply-To: <20201006055135.291411-3-allen.lkml@gmail.com> (Allen Pais's
        message of "Tue, 6 Oct 2020 11:21:35 +0530")
Message-ID: <87h7r7bz58.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Allen Pais <allen.lkml@gmail.com> writes:

> From: Allen Pais <apais@linux.microsoft.com>
>
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
>
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <apais@linux.microsoft.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |  4 ++--
>  drivers/net/wireless/mediatek/mt76/mt7603/init.c   |  3 +--
>  drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |  2 +-
>  drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |  6 +++---
>  drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c   | 10 +++++-----
>  drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |  7 +++----
>  drivers/net/wireless/mediatek/mt76/usb.c           |  6 +++---
>  drivers/net/wireless/mediatek/mt7601u/dma.c        | 12 ++++++------

mt76 and mt7601u patches go into separate trees, so please split the
patch into two.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
