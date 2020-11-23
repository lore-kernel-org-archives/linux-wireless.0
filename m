Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C43C2D0E4
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Nov 2020 18:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E753120758
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Nov 2020 18:06:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="df2A+Rpb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390638AbgKWSG7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Nov 2020 13:06:59 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:36733 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389617AbgKWSG7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Nov 2020 13:06:59 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606154818; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=e2bQXDHugwNh2fodXJxVgX6c/UIPBn8KjcbEjMKXJco=;
 b=df2A+RpbTzixytzilUc+9WAg0P+xGM3SeCCJk4YKWdTXHdEDHk+o/ll7qINkVzMMEtSHqoWI
 4Hx8f9TycLB7CHOeRVsuy2XL3BUoVZFSr+qX9z8wDbfc2FShqBntZt4LQ5yyHupd6QTyliDm
 VvCEiqwstoOXyqPh5J/KJQlAVeE=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5fbbfa3b22377520ee08bfbb (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 23 Nov 2020 18:06:51
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E79D9C43461; Mon, 23 Nov 2020 18:06:50 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7ED1FC433C6;
        Mon, 23 Nov 2020 18:06:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7ED1FC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: Fix beamformee STS in HE cap
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1604933229-15815-1-git-send-email-rgnanase@codeaurora.org>
References: <1604933229-15815-1-git-send-email-rgnanase@codeaurora.org>
To:     Ramya Gnanasekar <rgnanase@codeaurora.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Ramya Gnanasekar <rgnanase@codeaurora.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201123180650.E79D9C43461@smtp.codeaurora.org>
Date:   Mon, 23 Nov 2020 18:06:50 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ramya Gnanasekar <rgnanase@codeaurora.org> wrote:

> STS Beamformee capability sent from firmware is overwritten as
> num_tx_chains - 1.
> When num_tx_chains is 2, then STS is set to invalid value 1.
> Since STS is not limited by number of TX chain, not overwriting the
> capability received from firmware.
> 
> Tested on: IPQ6018 WLAN.HK.2.4.0.1-00303-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: Ramya Gnanasekar <rgnanase@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

1057db1b8b76 ath11k: Fix beamformee STS in HE cap

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1604933229-15815-1-git-send-email-rgnanase@codeaurora.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

