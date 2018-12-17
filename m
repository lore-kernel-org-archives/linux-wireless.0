Return-Path: <SRS0=RnVe=O2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2584C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 13:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8028A2133F
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 13:18:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KD+fKk92";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="K46wUhHm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732702AbeLQNSC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Dec 2018 08:18:02 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:55106 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727464AbeLQNSB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Dec 2018 08:18:01 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4825C608CC; Mon, 17 Dec 2018 13:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545052681;
        bh=e9rf2e70rqEREIC3e0a1kVgHbzGGnKDqN9axapHjeYI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=KD+fKk92pBt9TTZj1fpN/rSsYe448gYfAvxpaSDAz2pagY3feeyaXiN6DNEbEv61L
         QZeF5YMIZWpZQhCCPdfKWtMu0hWpX85oydoyRvPmg52qGYtvgbx6kanBTRV05eWBVy
         pPDmxbSX06ezxxbhGj5alRm9HqdyhHwhLx20qpb8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8B2A660886;
        Mon, 17 Dec 2018 13:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545052680;
        bh=e9rf2e70rqEREIC3e0a1kVgHbzGGnKDqN9axapHjeYI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=K46wUhHmzPZGmlffcscSoZSq7OOsoFLc8/E12U65f2Au6ikoGmd37bFPvCCszQzBb
         MrCvAkxSHnN2f2iWeN8tFHwkVuWNbNPT6gbNX5zjLJXC0Ntou7Iy+79N8r30W1k/Mx
         zj/y4UmVwTVg/ztIFl9TVrC3MP50rEmM1hNFuI8c=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8B2A660886
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4.20] iwlwifi: mvm: don't send GEO_TX_POWER_LIMIT to old
 firmwares
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181214163022.22162-1-luca@coelho.fi>
References: <20181214163022.22162-1-luca@coelho.fi>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181217131801.4825C608CC@smtp.codeaurora.org>
Date:   Mon, 17 Dec 2018 13:18:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> wrote:

> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> Old firmware versions don't support this command. Sending it
> to any firmware before -41.ucode will crash the firmware.
> 
> This fixes https://bugzilla.kernel.org/show_bug.cgi?id=201975
> 
> Fixes: 66e839030fd6 ("iwlwifi: fix wrong WGDS_WIFI_DATA_SIZE")
> CC: <stable@vger.kernel.org> #4.19+
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to wireless-drivers.git, thanks.

eca1e56ceedd iwlwifi: mvm: don't send GEO_TX_POWER_LIMIT to old firmwares

-- 
https://patchwork.kernel.org/patch/10731399/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

