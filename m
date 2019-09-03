Return-Path: <SRS0=FCSK=W6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD9CC3A5A2
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D375D23711
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:51:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="h+J/7pg5";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HEbFZHMV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729425AbfICNvR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Sep 2019 09:51:17 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58866 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729353AbfICNvQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Sep 2019 09:51:16 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C243160FEA; Tue,  3 Sep 2019 13:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567518675;
        bh=TOvXB/asPF0wWOiQeTMcHCFq7+GNSxRmZeRLeEpvcXU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=h+J/7pg52jOZ36y+Jn/bLEgijNsuToMXSmyUiQD01Mfev2iXpyFk6zwo+d6GUvDIw
         33iJEopobmTZhFQVXwtV/9XJMc3AvAjX5QMSj73k3tKZsVWnRyIXN6QvgsQPMzGg+P
         QNlEKotebXa2DyL/8f8tjoug7yFWQZtZ73X07CLc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D3DD860F38;
        Tue,  3 Sep 2019 13:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567518674;
        bh=TOvXB/asPF0wWOiQeTMcHCFq7+GNSxRmZeRLeEpvcXU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=HEbFZHMV46vmT1t2HnZg6l9uFovlBUjW56MekaF7RM4mMURNomBNWRA/ECD6l8Fjt
         pBKfD9oQWmctw0iTxS1YE+6MtudVaMINy61m5hP2FC36x0a0AQXMAvngIqQ+YEEQy+
         S+I1lnPT5KOFbOL1+C+cwGZThUi/pbJDIlbXYcRo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D3DD860F38
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5.3] iwlwifi: assign directly to iwl_trans->cfg in QuZ
 detection
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190829081346.13294-1-luca@coelho.fi>
References: <20190829081346.13294-1-luca@coelho.fi>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190903135115.C243160FEA@smtp.codeaurora.org>
Date:   Tue,  3 Sep 2019 13:51:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> wrote:

> From: Luca Coelho <luciano.coelho@intel.com>
> 
> We were erroneously assigning the new configuration to a local
> variable cfg, but that was not being assigned to anything, so the
> change was getting lost.  Assign directly to iwl_trans->cfg instead.
> 
> Fixes: 5a8c31aa6357 ("iwlwifi: pcie: fix recognition of QuZ devices")
> Cc: stable@vger.kernel.org # 5.2
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to wireless-drivers.git, thanks.

968dcfb49052 iwlwifi: assign directly to iwl_trans->cfg in QuZ detection

-- 
https://patchwork.kernel.org/patch/11120625/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

