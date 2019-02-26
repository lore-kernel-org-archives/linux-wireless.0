Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB1BAC10F0B
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:09:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78EA2217F9
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:09:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cfRyFWYZ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JjD7dcM+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfBZNJ3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 08:09:29 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:52764 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfBZNJ3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 08:09:29 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 447C361156; Tue, 26 Feb 2019 13:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551186568;
        bh=YJZkOYn6T8Vs7Gwvdz9JHF12m/erK1s3M/SHigVV1+8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=cfRyFWYZUoopgvE7Opr/YEjfJn6ABxuStt6BfT9C706+M8BO5AK2KftslmXpyzIXx
         odMvDHc8UWPBX8g/4zT/fhBaRRk0uXf8d2pfc2Q/0fSmBYwKJfjgoId+dHwQ8sBHLj
         fjTEUVIwm+zi0H1fajFN2tq5TBvK/jBSoVUokD6I=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3905F61156;
        Tue, 26 Feb 2019 13:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551186566;
        bh=YJZkOYn6T8Vs7Gwvdz9JHF12m/erK1s3M/SHigVV1+8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=JjD7dcM+aW+RQCTVsvQgwaJIy6saDhvANYlhcwEYTTZY/AGFfLcZ4DSbdALLUGvMw
         BTH7GD86QUHMGTXVU1v/SOUFk1zhWRT5+6EnnsDSREWM8qF4OOkp9YvQscfebyDNnx
         KoQAUkly/m3o/jylRUiOEblfrRJAQAPXKs5tnUsg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3905F61156
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ath9k: remove set but not used variable 'acq'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190225033246.127410-1-yuehaibing@huawei.com>
References: <20190225033246.127410-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190226130928.447C361156@smtp.codeaurora.org>
Date:   Tue, 26 Feb 2019 13:09:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/ath/ath9k/recv.c: In function 'ath_rx_count_airtime':
> drivers/net/wireless/ath/ath9k/recv.c:1010:18: warning:
>  variable 'acq' set but not used [-Wunused-but-set-variable]
> 
> It's not used after 89cea7493a34 ("ath9k: Switch to mac80211 TXQ scheduling
> and airtime APIs"). Also remove related variables.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

03af21d6ba35 ath9k: remove set but not used variable 'acq'

-- 
https://patchwork.kernel.org/patch/10828153/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

