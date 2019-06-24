Return-Path: <SRS0=5Br8=UX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD28C4646B
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Jun 2019 13:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AF78212F5
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Jun 2019 13:24:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="b9arqfhP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YF+AEbHP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731061AbfFXNYd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Jun 2019 09:24:33 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40024 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730966AbfFXNYd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jun 2019 09:24:33 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C575B6016D; Mon, 24 Jun 2019 13:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561382673;
        bh=8MHij29pe/7eRAAOBieB16owB57jEIC81rmAHsrQgOk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=b9arqfhPvdzFy6lvqAaWUYAmaEmSO2gq5nYURv7SBFus2KbTvE5ZF8IXemTafe7GJ
         USZKfqryluZx6Pg+eWOi8tpZYK9wkuQk5uc5ujIxus6QZpU3glZMzBiXpYyyjHp0dq
         /XQVk+dsU1FLClhTTEsg42VtWAwUKGIu8ZQ3smyo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1B3496016D;
        Mon, 24 Jun 2019 13:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561382670;
        bh=8MHij29pe/7eRAAOBieB16owB57jEIC81rmAHsrQgOk=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=YF+AEbHPS2/qiBwlX7D2W9S3ypjZtY/V8UJR9CkpmmZ7Or5QNjps/z+xWQoLlEFku
         knMhe4qUmDLUwtF0pvVPPbKxu+OtSh7apYsVkafWQS12jQZOaZvRIM+/gt9d25MKYb
         8iexjjPD2GxGHiN6v5FWFC80/k70s/KeXyzTg3oc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1B3496016D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlwifi: add support for hr1 RF ID
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190620084623.12014-1-luca@coelho.fi>
References: <20190620084623.12014-1-luca@coelho.fi>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, Oren Givon <oren.givon@intel.com>,
        stable@vger.kernel.org, Luciano Coelho <luciano.coelho@intel.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190624132432.C575B6016D@smtp.codeaurora.org>
Date:   Mon, 24 Jun 2019 13:24:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> wrote:

> From: Oren Givon <oren.givon@intel.com>
> 
> The 22000 series FW that was meant to be used with hr is
> also the FW that is used for hr1 and has a different RF ID.
> Add support to load the hr FW when hr1 RF ID is detected.
> 
> Cc: stable@vger.kernel.org # 5.1+
> Signed-off-by: Oren Givon <oren.givon@intel.com>
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>

Patch applied to wireless-drivers.git, thanks.

498d3eb5bfbb iwlwifi: add support for hr1 RF ID

-- 
https://patchwork.kernel.org/patch/11006135/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

