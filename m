Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E183CC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 15:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B00A2083D
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 15:38:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Lu57QcKv";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AKeYkVpY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfCSPiF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 11:38:05 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57704 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbfCSPiF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 11:38:05 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DFC92614DB; Tue, 19 Mar 2019 15:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553009884;
        bh=ozqEIhBaptY+VX07w+q58X075Pq0Rh/5EPaCpNUyoE4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Lu57QcKvgann3tm8b9LkjXTTkV/+M5EYN/clm811ayZ0TrXD5YgPzdetDUigKbgtH
         E+tcEQOOtqIV54nUE69EByTVqpoHien8sPYS2pQP2yVqu+S64mO7wx9u28uQ9I6j52
         nC3xdIYLNPMeNNiI925gOUZhsz65L+Pu8HP6QUkA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3BFE1613A3;
        Tue, 19 Mar 2019 15:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553009884;
        bh=ozqEIhBaptY+VX07w+q58X075Pq0Rh/5EPaCpNUyoE4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=AKeYkVpY4NuHjYPnkQ7WIzH43+yG4w8t30TJiDXHPdxQayyfyAzj6lsv4HICcHX+n
         kQTmqSIN+nr5Jcwhu1jhWalzFNgPQAV0iZQtSdiddfbb7ymjoY10DBBLuYEf+4//yd
         jXNNL4UzP73qEVOj/PEs6rlH03hmN0kcreAS7VOA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3BFE1613A3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 5.1] mt76x02: do not enable RTS/CTS by default
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1552393927-26634-1-git-send-email-sgruszka@redhat.com>
References: <1552393927-26634-1-git-send-email-sgruszka@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190319153804.DFC92614DB@smtp.codeaurora.org>
Date:   Tue, 19 Mar 2019 15:38:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> My commit 26a7b5473191 ("mt76x02: set protection according to ht
> operation element") enabled by default RTS/CTS protection for OFDM
> and CCK traffic, because MT_TX_RTS_CFG_THRESH is configured to non
> 0xffff by initvals and .set_rts_threshold callback is not called by
> mac80211 on initialization, only on user request or during
> ieee80211_reconfig() (suspend/resuem or restart_hw).
> 
> Enabling RTS/CTS cause some problems when sending probe request
> frames by hcxdumptool penetration tool, but I expect it can cause
> other issues on different scenarios.
>  
> Restore previous setting of RTS/CTS being disabled by default for
> OFDM/CCK by changing MT_TX_RTS_CFG_THRESH initvals to 0xffff.
> 
> Fixes: 26a7b5473191 ("mt76x02: set protection according to ht operation element")
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers.git, thanks.

7dfc45e6282a mt76x02: do not enable RTS/CTS by default

-- 
https://patchwork.kernel.org/patch/10849179/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

