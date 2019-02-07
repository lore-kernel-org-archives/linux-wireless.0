Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB572C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 16:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91B0A2175B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 16:00:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Jh9dK9rH";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="j+sttb5Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfBGQAW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 11:00:22 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36180 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbfBGQAW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 11:00:22 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D1345607DD; Thu,  7 Feb 2019 16:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549555221;
        bh=NXeHefk0glawIx3OcrZPr9w0Z82EytAQd8p+oQ086i8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Jh9dK9rHgrzR1/UwE6uEfkxL9o4tVtFYc8Sb6lUg5JpY3kEqpDXRjKC5PiriW52/b
         L/xa8tNgFCIsmAkmthKZPlUeV6akw4EUcRG6hiCZg8hK3obRMIRD+pfOp+UDOHw5/u
         fYFxrbf2J9bWe2YZ348dwR7lXhWzZY7qfEVzr3Ls=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4DCCC6030D;
        Thu,  7 Feb 2019 16:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549555221;
        bh=NXeHefk0glawIx3OcrZPr9w0Z82EytAQd8p+oQ086i8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=j+sttb5QLi61x26xBHvl4uvnmZSWTUDXGgLNl9PjvnLr8ofzbS8i0Kua9GIREGTa0
         8oJy7wB6dOUipL1Yk4AVJSnBPe8grCoDqdcr+WJxEVbN7yIoioYXzsvh78CmzUQEf8
         dRQILdZlI/rmY6vLnNabV/ja3kC9xOaIepEKPcX8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4DCCC6030D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] ath10k: Assign 'n_cipher_suites = 11' for WCN3990 to
 enable WPA3
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1548339697-17766-2-git-send-email-aambure@codeaurora.org>
References: <1548339697-17766-2-git-send-email-aambure@codeaurora.org>
To:     Abhishek Ambure <aambure@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Abhishek Ambure <aambure@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190207160021.D1345607DD@smtp.codeaurora.org>
Date:   Thu,  7 Feb 2019 16:00:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Abhishek Ambure <aambure@codeaurora.org> wrote:

> Hostapd uses CCMP, GCMP & GCMP-256 as 'wpa_pairwise' option to run WPA3.
> In WCN3990 firmware cipher suite numbers 9 to 11 are for CCMP,
> GCMP & GCMP-256.
> 
> To enable CCMP, GCMP & GCMP-256 cipher suites in WCN3990 firmware,
> host sets 'n_cipher_suites = 11' while initializing hardware parameters.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
> 
> Signed-off-by: Abhishek Ambure <aambure@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

This issued a new warning:

drivers/net/wireless/ath/ath10k/core.c:564:18: warning: Initializer entry defined twice
drivers/net/wireless/ath/ath10k/core.c:574:18:   also defined here

I fixed that in the pending branch:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=de1c369206cf48b73f74d5bf904ee26da485c84f

-- 
https://patchwork.kernel.org/patch/10779097/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

