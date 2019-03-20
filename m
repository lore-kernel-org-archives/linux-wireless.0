Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C19C10F05
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 07:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B03F21850
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 07:26:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KiZ/7Spk";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KiZ/7Spk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfCTH0c (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 03:26:32 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59874 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbfCTH03 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 03:26:29 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 910FA60850; Wed, 20 Mar 2019 07:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553066788;
        bh=BlbMmcSUQ+1gbzVIOZJC1WZ0TVsvZmReGeTN/mVM94g=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KiZ/7Spk892XsX3lYn+gCBCGF/pkQawHPY9huVYIPKQKSWhrIbNTUcJLEyVj91gb1
         zzsvGJ9630EhLvLK4ieoxiBCStdfcY++DHaTWqgR1n9rX/K0ImIMrrf2OQh9rTHRp1
         IcAOV87yFGsA9W6IHul8oBj3dxpMWBbxtWwHtsKM=
Received: from x230.qca.qualcomm.com (unknown [195.39.71.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C5B1B60850;
        Wed, 20 Mar 2019 07:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553066788;
        bh=BlbMmcSUQ+1gbzVIOZJC1WZ0TVsvZmReGeTN/mVM94g=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KiZ/7Spk892XsX3lYn+gCBCGF/pkQawHPY9huVYIPKQKSWhrIbNTUcJLEyVj91gb1
         zzsvGJ9630EhLvLK4ieoxiBCStdfcY++DHaTWqgR1n9rX/K0ImIMrrf2OQh9rTHRp1
         IcAOV87yFGsA9W6IHul8oBj3dxpMWBbxtWwHtsKM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C5B1B60850
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Wireless <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Fixes tag needs some work in the net tree
References: <20190320081549.7112c33c@canb.auug.org.au>
Date:   Wed, 20 Mar 2019 09:26:23 +0200
In-Reply-To: <20190320081549.7112c33c@canb.auug.org.au> (Stephen Rothwell's
        message of "Wed, 20 Mar 2019 08:15:49 +1100")
Message-ID: <87ftrit3a8.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> In commit
>
>   13f61dfc5235 ("mt76: fix schedule while atomic in mt76x02_reset_state")
>
> Fixes tag
>
>   Fixes: e4ebb8b403d1 ("mt76: mt76x2: implement full device restart on watchdog reset")
>
> has these problem(s):
>
>   - Target SHA1 does not exist
>
> Did you mean:
>
>   004960423fe1 ("mt76: mt76x2: implement full device restart on watchdog reset")

Sorry, I missed this but too late to fix now.

-- 
Kalle Valo
