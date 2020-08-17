Return-Path: <SRS0=ru0V=B3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BECAAC433DF
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Aug 2020 10:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 953A52078A
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Aug 2020 10:24:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="OmmZjdHS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbgHQKYC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Aug 2020 06:24:02 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:50066 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgHQKYB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Aug 2020 06:24:01 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597659841; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=UGwvyY999RMjNaGjuYP+kUOxahtISuAIw7/wLpiUTu4=;
 b=OmmZjdHSsA1c0K6wvS5CzCeth/Rcl8nH2usH5JgMIpb5hecbO74hiLMkiGQ+EOHOAavBUGix
 jc+L2Ou0wkeAF7EOvm/TDCWQ+yR+1Kphap8FYf7bg+Jum7uBOpSTL7FgdppLLMFQKUXIoKG9
 7DdDcuUZ6/4bkxKnuWEiLZOh8RI=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5f3a5aaed48d4625ca9d9abf (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 17 Aug 2020 10:23:42
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 987CCC433CB; Mon, 17 Aug 2020 10:23:41 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1A77FC433C6;
        Mon, 17 Aug 2020 10:23:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1A77FC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k_htc: Use appropriate rs_datalen type
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200808233258.4596-1-masashi.honma@gmail.com>
References: <20200808233258.4596-1-masashi.honma@gmail.com>
To:     Masashi Honma <masashi.honma@gmail.com>
Cc:     linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        Masashi Honma <masashi.honma@gmail.com>,
        kernel test robot <lkp@intel.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200817102341.987CCC433CB@smtp.codeaurora.org>
Date:   Mon, 17 Aug 2020 10:23:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Masashi Honma <masashi.honma@gmail.com> wrote:

> kernel test robot says:
> drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:987:20: sparse: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:987:20: sparse:    expected restricted __be16 [usertype] rs_datalen
> drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:987:20: sparse:    got unsigned short [usertype]
> drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:988:13: sparse: warning: restricted __be16 degrades to integer
> drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:1001:13: sparse: warning: restricted __be16 degrades to integer
> 
> Indeed rs_datalen has host byte order, so modify it's own type.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: cd486e627e67 ("ath9k_htc: Discard undersized packets")
> Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

5024f21c159f ath9k_htc: Use appropriate rs_datalen type

-- 
https://patchwork.kernel.org/patch/11706459/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

