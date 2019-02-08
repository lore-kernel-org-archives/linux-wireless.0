Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D98C169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 15:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A06BF2075C
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 15:28:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GzV3ZVHa";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PHU5dD3n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbfBHP23 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 10:28:29 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33228 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbfBHP22 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 10:28:28 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D781C60B10; Fri,  8 Feb 2019 15:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549639707;
        bh=d1JptAOx+ARdPv7y69hKWFcuf6kfnOI4NsuK+U7Mc9k=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=GzV3ZVHaCu6dsxpzwrSBRrYRHdyT9G09ypXqpzd+usl1HA6ps2chlHncQDFIHiYkg
         TKkMpcHH67++4LK1XD2oAdDxbv2PXdda27o7eQiOP/Tls1jorXyDQQ6Js9KSU7Zfte
         Zoee3rZvtaC09wP162cHxZhJoS/IyAzDi/4lM9j0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 43B0460B10;
        Fri,  8 Feb 2019 15:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549639706;
        bh=d1JptAOx+ARdPv7y69hKWFcuf6kfnOI4NsuK+U7Mc9k=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=PHU5dD3nYVLDmeuN68ulXR/MYSK+4udTa38sVt32Qz/Mm5osFDoZ1tuRjYBfBmz3L
         C/+E3a7qixeAubrUti2pibGPtQBxozXsMjBgXmxP4TbxD7WOzQeWVahs/Yz3bk8pvL
         eKpOL7Cu8bWEZIz3GArnc8XUjWAPnG7HoHSWp3MI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 43B0460B10
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: don't print error message on coex event
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190128154310.17322-1-stefan@agner.ch>
References: <20190128154310.17322-1-stefan@agner.ch>
To:     Stefan Agner <stefan@agner.ch>
Cc:     amitkarwar@gmail.com, nishants@marvell.com, gbhat@marvell.com,
        huxinming820@gmail.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190208152827.D781C60B10@smtp.codeaurora.org>
Date:   Fri,  8 Feb 2019 15:28:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stefan Agner <stefan@agner.ch> wrote:

> The BT coex event is not an error condition. Don't print an error
> message in this case. The same even in sta_event.c prints a
> message using the debug level already.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

5208fea64e4f mwifiex: don't print error message on coex event

-- 
https://patchwork.kernel.org/patch/10783935/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

