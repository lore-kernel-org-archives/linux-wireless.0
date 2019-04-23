Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4571BC10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 13:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1190F20645
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 13:26:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fMra6YZP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ctg9Bl/w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbfDWN0u (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 09:26:50 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49134 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbfDWN0u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 09:26:50 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AC6E861156; Tue, 23 Apr 2019 13:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556026009;
        bh=u/8SYv+vdh/D+eG//k33Z+xRKRI2Gycwgue+pChoxwU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=fMra6YZPSuMb+LgJQFjt1s18DBuY4OJ43ECFc8JPuFtHqPPu4e7ovk20wVCJijPdw
         WwYI7VOoKBt2oxXG9f0bE8Y3yjoXqb1bNcNzrz9E17tcJAzRsgwiuDLj9WCXyuE5TR
         VjjwJr1W+X11uTVjOx8cEq8xzM1wZVYkJLhUvios=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 07EB060F3F;
        Tue, 23 Apr 2019 13:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556026008;
        bh=u/8SYv+vdh/D+eG//k33Z+xRKRI2Gycwgue+pChoxwU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Ctg9Bl/w88GAX3aU6pPrGzpfXP3UQdpLhkKIj6mlAc68o7Cm4nnyLooAYSBB2p4lB
         qIpShdUCotiawLF3oSDt9y4/4T0rgE8iNLy/B4JsoWkbYcvSF7PvEMmH1E6ly/bZXw
         4/XpKXjXtZDi5Ymhx0P1uw2tEMCiaT4nz1goWuY4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 07EB060F3F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/5] ath10k: add initialization of HTC header
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190417191503.18814-2-erik.stromdahl@gmail.com>
References: <20190417191503.18814-2-erik.stromdahl@gmail.com>
To:     Erik Stromdahl <erik.stromdahl@gmail.com>
Cc:     kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org,
        Alagu Sankar <alagusankar@silex-india.com>,
        Erik Stromdahl <erik.stromdahl@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190423132649.AC6E861156@smtp.codeaurora.org>
Date:   Tue, 23 Apr 2019 13:26:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Erik Stromdahl <erik.stromdahl@gmail.com> wrote:

> HTC header carries junk values that may be interpreted by the firmware
> differently. Enable credit update only if flow control is enabled for
> the corresponding endpoint.
> 
> Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

fbd428a5b828 ath10k: add initialization of HTC header
f91b63b0e3b2 ath10k: sdio: add missing error check

-- 
https://patchwork.kernel.org/patch/10906001/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

