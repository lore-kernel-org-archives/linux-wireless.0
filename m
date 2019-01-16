Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA616C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 18:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91D9320840
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 18:09:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Wi15Vwb2";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TZAycgs6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbfAPSJo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 13:09:44 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46344 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfAPSJo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 13:09:44 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 30CF4607F4; Wed, 16 Jan 2019 18:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547662184;
        bh=F9xvf8nnamQ/B9mrY8XFsIOzWcW4jbIkjgmxwq48sj8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Wi15Vwb2xHA9+4Sk55ylgQpueA2ui1Wl0P48rTzAILKKwMrp1Q93wW2aKK8VP14T+
         2kh1wLsWe9ZPYm1p7286DfSz55q3wsHm8S1b98lzYDicKh57WlJntV69zow3eoMzBR
         U+5Q/uKHTSMrNFRzbOoSOZOhcHa1eqtJJFr9Nbp0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C332960208;
        Wed, 16 Jan 2019 18:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547662183;
        bh=F9xvf8nnamQ/B9mrY8XFsIOzWcW4jbIkjgmxwq48sj8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=TZAycgs6mgtJXwsbQVrOAnpx+7Ge/XygM/R1EnHABhxX/pbq1Ah/vppuu9S0sODKN
         muP1HowtHpdN02xSuLlGxLKn3gzPUcTbU37SqB2DAO1gvSEDcpeFd5OXTL2X1jRBII
         F6hbTInDbdlhkdc+STBEB/WLL/vyiVu7ndLM+9o8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C332960208
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH for v5.0] iwlwifi: make IWLWIFI depend on CFG80211
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190114110023.23172-1-luca@coelho.fi>
References: <20190114110023.23172-1-luca@coelho.fi>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190116180944.30CF4607F4@smtp.codeaurora.org>
Date:   Wed, 16 Jan 2019 18:09:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> wrote:

> From: Luca Coelho <luciano.coelho@intel.com>
> 
> Since IWLWIFI doesn't depend on MAC80211 anymore, it needs to depend
> on CFG80211, because it uses a few symbols from it.  Add the
> dependency on CFG80211 accordingly.
> 
> Additionally, make IWLWIFI_LEDS depend on IWLMVM or IWLDVM, since it
> doesn't need mac80211 but must be used for these.
> 
> Fixes: aca432f06b8a ("iwlwifi: make MVM and DVM depend on MAC80211")
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to wireless-drivers.git, thanks.

ec5aecc0b227 iwlwifi: make IWLWIFI depend on CFG80211

-- 
https://patchwork.kernel.org/patch/10762079/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

