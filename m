Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5588FC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24126206B6
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:38:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="c/dELYhO";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="J10SFFLa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbfAJLiu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 06:38:50 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51928 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727938AbfAJLit (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 06:38:49 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 29450608A5; Thu, 10 Jan 2019 11:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547120329;
        bh=5v8UfKZi+Tyty8YTpRp9AYLKR74TihU4L1LYbr8pXyk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=c/dELYhONIQLuCiU0QanlWq7eWzxo1NqUL//ve0LQX3C51m9DDdvCaI9SHAj1/hkY
         XnerFj+pbRtEtsZ/S9MstgJdCy7EqwUNwrdVfvo+m6wzFFvWReREd1sPIxLFa6zdHA
         6wtB3gA/X4vN4Nwq35Rxv81EkTtv9qoRU16aAuFY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4540D601D1;
        Thu, 10 Jan 2019 11:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547120328;
        bh=5v8UfKZi+Tyty8YTpRp9AYLKR74TihU4L1LYbr8pXyk=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=J10SFFLaKmI8CrrDzElAasG1b6BAIX60S3M8R22k3OxFCyoe3DRQku/G/iORVozri
         0GTSOXvPfNa6ivx4gzh0ugcTpuS7BvIsU/f1luRtqhIiryvNCEmUfYzkFMFUHWROjo
         /g1Y5A3rPYycpmN1/cD/bpFCQzP0pleupmXvJhL4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4540D601D1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v4] rsi: add support for hardware scan offload
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1545902778-20205-1-git-send-email-siva8118@gmail.com>
References: <1545902778-20205-1-git-send-email-siva8118@gmail.com>
To:     Siva Rebbagondla <siva8118@gmail.com>
Cc:     linux-wireless@vger.kernel.org, prameela.j04cs@gmail.com,
        rishikesh.basu@redpinesignals.com,
        siva.rebbagondla@redpinesignals.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190110113849.29450608A5@smtp.codeaurora.org>
Date:   Thu, 10 Jan 2019 11:38:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Siva Rebbagondla <siva8118@gmail.com> wrote:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> 
> With the current approach of scanning, roaming delays are observed.
> Firmware has support for back ground scanning. To get this advantage,
> mac80211 hardware scan is implemented, which decides type of scan to
> do based on connected state.
> 
> When station is in not connected, driver returns with special value 1
> to trigger software scan in mac80211. In case of connected state,
> background scan will be triggered.
> 
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

Patch applied to wireless-drivers-next.git, thanks.

7fdcb8e12660 rsi: add support for hardware scan offload

-- 
https://patchwork.kernel.org/patch/10743621/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

