Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D5FAC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 12:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B8042173C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 12:56:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FQEC+GJ9";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FwNucqx2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbfBZM4t (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 07:56:49 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:32988 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfBZM4t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 07:56:49 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 863C2613A8; Tue, 26 Feb 2019 12:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551185808;
        bh=gs/YeR1w/O8n7EaW7AF0TchkoN+xfNfZAXRt0aZ+MVI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=FQEC+GJ9wOAbdm2FF8ph9BeA9JStd4o3IfA3r31KKOBwpwCIdfA44r4UzEFgqx6md
         Bvg24cxlJxq9X7WpgDOxnw7ximG+snzGe32t5i0XXXMGsOb+BUuZNzqcU9DY0qMCIR
         4o7Y/a48+4IMBVk2S6fTwPMD1H5cLqUy18f8tOo0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EF5AE60E42;
        Tue, 26 Feb 2019 12:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551185807;
        bh=gs/YeR1w/O8n7EaW7AF0TchkoN+xfNfZAXRt0aZ+MVI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=FwNucqx243a+bfBxXf4WkT/OXxgsigPkF0oqLdzykBp7GhTnSJTuArL9UcBQvAxQQ
         vkVpAcuwIDeiOgm0fyCbhkkkUlvVecU83KvtIhZvj/hOqw7q8auCc3XVro3PZuAbLr
         Bv1N9ABjBAZbV+8glUEQL6fdiiJU3rW5veJEob9s=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EF5AE60E42
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fix descriptor size in ce tx completion for
 WCN3990
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1549952423-25096-1-git-send-email-pillair@codeaurora.org>
References: <1549952423-25096-1-git-send-email-pillair@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190226125648.863C2613A8@smtp.codeaurora.org>
Date:   Tue, 26 Feb 2019 12:56:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rakesh Pillai <pillair@codeaurora.org> wrote:

> When the driver receives the tx completion of the
> descriptor over ce, it clears the nbytes configured
> for that particular descriptor. WCN3990 uses ce
> descriptors with 64-bit address.
> 
> Currently during handling the tx completion of the
> descriptors, the nbytes are accessed from the descriptors
> using ce_desc for 32-bit targets. This will lead to clearing
> of memory at incorrect offset if DMA MASK is set to greater
> than 32 bits.
> 
> Attach different ce tx copy completed handler for targets
> using address above 32-bit address.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01387-QCAHLSWMTPLZ-1
> 
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

02f73d3a9bdb ath10k: fix descriptor size in ce tx completion for WCN3990

-- 
https://patchwork.kernel.org/patch/10807393/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

