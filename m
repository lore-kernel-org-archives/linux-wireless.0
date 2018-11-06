Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30FF6C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE2232081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:04:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YC2J6tyC";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TFJr89Nz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE2232081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389656AbeKGCbD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:31:03 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33192 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389386AbeKGCbC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:31:02 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 16BD0602F4; Tue,  6 Nov 2018 17:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523893;
        bh=T99Gn4rDWvf9usClWFCzlUX0oisES7Pu34mp+/TAs28=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=YC2J6tyCkNWHWV/NvBQHrulkC1EWbKifGwRwUlZTrfAIhJJBuRHwyWG+pKv378bw4
         TdsB5vq+V6U98xzEdg4F4GJOggvEu80XIe3K0hlE9gO+Z7IgDCu90tQt1W2WGE6sr6
         tOBHmBmRjl9jqHeJ5FCOTA4BV3Ka5qqg7O4FDmWs=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3CA5B601DA;
        Tue,  6 Nov 2018 17:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523892;
        bh=T99Gn4rDWvf9usClWFCzlUX0oisES7Pu34mp+/TAs28=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=TFJr89NzuZyHRuhG9iWNz2+cUy0EMD+1w5jNTo4VErdCiNvx3womEKGakPMwmt37E
         mG2PMglMx0JKckqkZsfa3yDlr0rqgfVK29DoB0pTlLzsWlHpVoJGVXZplxiODB0F53
         SabcsVf3Ki3Z9/0bNPDsLu/KdD+PKwT2Gn4bPUHA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3CA5B601DA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlegacy: fix small typo
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181101154023.22990-1-tiny.windzz@gmail.com>
References: <20181101154023.22990-1-tiny.windzz@gmail.com>
To:     Yangtao Li <tiny.windzz@gmail.com>
Cc:     sgruszka@redhat.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106170453.16BD0602F4@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 17:04:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yangtao Li <tiny.windzz@gmail.com> wrote:

> Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

ac9ccb8b991c iwlegacy: fix small typo

-- 
https://patchwork.kernel.org/patch/10664187/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

