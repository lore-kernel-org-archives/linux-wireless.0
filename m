Return-Path: <SRS0=yPAo=EN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D924EC388F9
	for <linux-wireless@archiver.kernel.org>; Sat,  7 Nov 2020 16:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AF0220888
	for <linux-wireless@archiver.kernel.org>; Sat,  7 Nov 2020 16:17:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="CFY3C1It"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbgKGQRg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 7 Nov 2020 11:17:36 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:19959 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgKGQRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Nov 2020 11:17:36 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604765855; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=r4HgFfe8kVKVKuCkwgtPECQYbXKH5/tCFh+fgAdC7vc=;
 b=CFY3C1ItjVABqUyblPgaCXE6Oi0WJfXdLk6jX3rJOIcZlBxjzLlq5mMVfezhYGf1usZu1N2j
 hUhX10d7YZWejNahSmVtaJixjH84mQ3vkieqDDrwW4JWyooRu+0rEqzmB3yppBGe6SydZklR
 vP0WoiQlubt0cn/9mN0ZxMj8g8U=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5fa6c89df8c560b580bfa989 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 07 Nov 2020 16:17:33
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A5B94C433F0; Sat,  7 Nov 2020 16:17:32 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0811FC433C6;
        Sat,  7 Nov 2020 16:17:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0811FC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/4] brcmfmac: add change_bss to support AP isolation
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201020022812.37064-2-wright.feng@cypress.com>
References: <20201020022812.37064-2-wright.feng@cypress.com>
To:     Wright Feng <wright.feng@cypress.com>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        brcm80211-dev-list@broadcom.com, brcm80211-dev-list@cypress.com,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201107161732.A5B94C433F0@smtp.codeaurora.org>
Date:   Sat,  7 Nov 2020 16:17:32 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wright Feng <wright.feng@cypress.com> wrote:

> Hostap has a parameter "ap_isolate" which is used to prevent low-level
> bridging of frames between associated stations in the BSS.
> Regarding driver side, we add cfg80211 ops method change_bss to support
> setting AP isolation if firmware has ap_isolate feature.
> 
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Dropping as no response to Arend's comment.

4 patches set to Changes Requested.

11845611 [v2,1/4] brcmfmac: add change_bss to support AP isolation
11845613 [v2,2/4] brcmfmac: don't allow arp/nd offload to be enabled if ap mode exists
11845615 [v2,3/4] brcmfmac: support the forwarding packet
11845617 [v2,4/4] brcmfmac: add a variable for packet forwarding condition

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201020022812.37064-2-wright.feng@cypress.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

