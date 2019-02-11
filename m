Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F25C6C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 16:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C19EE21773
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 16:32:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CqWQpKMT";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZRzPyBZQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbfBKQcb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 11:32:31 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:41218 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbfBKQcb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 11:32:31 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9ED8060CA2; Mon, 11 Feb 2019 16:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549902750;
        bh=YML773F71MhbQNyfjIYLU+uK6/b6F4iiABBN6k6Qc30=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=CqWQpKMTTDr5l9XMCcZkuI5+ZfciPlNIIWQ2U0Lq3Kd1Jq/YHqJNuz0oEctNQZB6q
         55pFith3yPHlGd6YxyGGRO4nE+n9bC65uEKGwa2i30kLBmEk9FLtrE2Gh0cKz+zzvR
         v3IaL90R3OMTtWcvwNZxA6eo+Hfmih0IiLstjnzg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DC72060208;
        Mon, 11 Feb 2019 16:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549902749;
        bh=YML773F71MhbQNyfjIYLU+uK6/b6F4iiABBN6k6Qc30=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ZRzPyBZQnIkWxdO/obkn8uKTrrlQnaRNwWnM6KU4OOWkaKzLLzuEwxKdSOHGrujY8
         6H551aNzhpLiOAiCEXB+qfyolSOWfSV+03uNUtEajnX3bjHp+GU3wu8sLk7PvEe25r
         3igRFz2Xi/XlX3cMX3BPv6XJKDQyQhHPejdaL8wU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DC72060208
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: pci: use mutex for diagnostic window CE polling
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190207014143.41529-1-briannorris@chromium.org>
References: <20190207014143.41529-1-briannorris@chromium.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Carl Huang <cjhuang@codeaurora.org>,
        Wen Gong <wgong@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190211163230.9ED8060CA2@smtp.codeaurora.org>
Date:   Mon, 11 Feb 2019 16:32:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

> The DIAG copy engine is only used via polling, but it holds a spinlock
> with softirqs disabled. Each iteration of our read/write loops can
> theoretically take 20ms (two 10ms timeout loops), and this loop can be
> run an unbounded number of times while holding the spinlock -- dependent
> on the request size given by the caller.
> 
> As of commit 39501ea64116 ("ath10k: download firmware via diag Copy
> Engine for QCA6174 and QCA9377."), we transfer large chunks of firmware
> memory using this mechanism. With large enough firmware segments, this
> becomes an exceedingly long period for disabling soft IRQs. For example,
> with a 500KiB firmware segment, in testing QCA6174A, I see 200 loop
> iterations of about 50-100us each, which can total about 10-20ms.
> 
> In reality, we don't really need to block softirqs for this duration.
> The DIAG CE is only used in polling mode, and we only need to hold
> ce_lock to make sure any CE bookkeeping is done without screwing up
> another CE. Otherwise, we only need to ensure exclusion between
> ath10k_pci_diag_{read,write}_mem() contexts.
> 
> This patch moves to use fine-grained locking for the shared ce_lock,
> while adding a new mutex just to ensure mutual exclusion of diag
> read/write operations.
> 
> Tested on QCA6174A, firmware version WLAN.RM.4.4.1-00132-QCARMSWPZ-1.
> 
> Fixes: 39501ea64116 ("ath10k: download firmware via diag Copy Engine for QCA6174 and QCA9377.")
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

25733c4e67df ath10k: pci: use mutex for diagnostic window CE polling

-- 
https://patchwork.kernel.org/patch/10800343/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

