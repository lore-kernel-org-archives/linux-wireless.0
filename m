Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF26AC169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 14:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AA5320844
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 14:17:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="efFeT44G";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gcDo1bmA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbfBHORk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 09:17:40 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56314 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727411AbfBHORk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 09:17:40 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9688760740; Fri,  8 Feb 2019 14:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549635459;
        bh=8YI/z7ASmK6KEAEOe50DHMG22iBgMXn+61Pan3bAPow=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=efFeT44Ghl6gLVkiimlfb9ztUbUS0Lk2QjuYJhVUbYZUMmB9m9LZUJ0q0Ng3tZW4E
         Rdap6xgz1KIIcKrzvsslkKzPn1pZPTLf9UDrc4mdkiEGGZ77XC4e1r+rh6xvtGMy4d
         yH8NnsQiPVZ8S1ys/D0CPwQAl7+vBCulWVXOGD5k=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4DC2A60264;
        Fri,  8 Feb 2019 14:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549635453;
        bh=8YI/z7ASmK6KEAEOe50DHMG22iBgMXn+61Pan3bAPow=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=gcDo1bmAzfHkL/5ARf3sLre9NQMU2wAIWs52sChHFiVZNGRIqpHWLW0w7Y3fPep1H
         N99y/wK8NqsRM0gz6TP2V/sjmxwDQpuO8Q61YD9wJ1fBQuArlMB7Ad4Z90Oc5GdVF2
         JOhCiOF3lvsPMhFswYUtcdIAbuJ3S3rQdZLTnk1M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4DC2A60264
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fix shadow register implementation for WCN3990
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1548755647-23356-1-git-send-email-pillair@codeaurora.org>
References: <1548755647-23356-1-git-send-email-pillair@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190208141739.9688760740@smtp.codeaurora.org>
Date:   Fri,  8 Feb 2019 14:17:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rakesh Pillai <pillair@codeaurora.org> wrote:

> WCN3990 supports shadow registers write operation support
> for copy engine for regular operation in powersave mode.
> 
> Since WCN3990 is a 64-bit target, the shadow register
> implementation needs to be done in the copy engine handlers
> for 64-bit target. Currently the shadow register implementation
> is present in the 32-bit target handlers of copy engine.
> 
> Fix the shadow register copy engine write operation
> implementation for 64-bit target(WCN3990).
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
> 
> Fixes: b7ba83f7c414 ("ath10k: add support for shadow register for WNC3990")
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

I was able to apply with 3-way merge but please double check the results:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=45112636f48a180c2867c78731ea28ac665495d9

Applying: ath10k: Fix shadow register implementation for WCN3990
Using index info to reconstruct a base tree...
M       drivers/net/wireless/ath/ath10k/ce.c
M       drivers/net/wireless/ath/ath10k/ce.h
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/ath/ath10k/ce.h
Auto-merging drivers/net/wireless/ath/ath10k/ce.c

-- 
https://patchwork.kernel.org/patch/10785903/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

