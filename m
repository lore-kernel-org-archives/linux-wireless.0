Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A970DC64ED6
	for <linux-wireless@archiver.kernel.org>; Sun, 26 Feb 2023 17:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjBZRhG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 26 Feb 2023 12:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjBZRhF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 26 Feb 2023 12:37:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5907318B02;
        Sun, 26 Feb 2023 09:37:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8E6A60B46;
        Sun, 26 Feb 2023 17:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D133EC433EF;
        Sun, 26 Feb 2023 17:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677433020;
        bh=rYPnofxC2fS1NbIr0LLF9MRr+J8gcD33KZgjOgGwxos=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=fztnZjxN9iDRu2GHSbygtGLT/kORkxgl2HyX2TxfHQRM3IXgEqp0FYLvUgkUEnyvq
         B3jRC3LwAHWt33TWUZK2w0Zn6c8PxUTqrJZInIeQmQA2+X03GomZxjtlFesa3VlKtl
         xG/VB0BtgZMuTYSCEOCv3hZtm8TtRUjUzR3oFckhlo/KsFi2rHyxWxh+Sn/E2PKksS
         DelJg4z0VolpSpCManTRnt/bmN+yKi+Zn7prwLD5JKvw+qniRQbnRZ2lhejgmJWmZ+
         zTzGxjrCdwK97UtN2JPisGvt3FUp+ciWyHBweb9iOQCn8bMv9uLmfqgh0xXkhTb9Gy
         v7wGZfiEiV3uQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: wext: warn about usage only once
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230224135933.94104aeda1a0.Ie771c6a66d7d6c3cf67da5f3b0c66cea66fd514c@changeid>
References: <20230224135933.94104aeda1a0.Ie771c6a66d7d6c3cf67da5f3b0c66cea66fd514c@changeid>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Nicolas Cavallari <Nicolas.Cavallari@green-communications.fr>,
        Johannes Berg <johannes.berg@intel.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167743301673.28904.15521250684332419538.kvalo@kernel.org>
Date:   Sun, 26 Feb 2023 17:36:58 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> wrote:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> Warn only once since the ratelimit parameters are still
> allowing too many messages to happen. This will no longer
> tell you all the different processes, but still gives a
> heads-up of sorts.
> 
> Also modify the message to note that wext stops working
> for future Wi-Fi 7 hardware, this is already implemented
> in commit 4ca69027691a ("wifi: wireless: deny wireless
> extensions on MLO-capable devices") and is maybe of more
> relevance to users than the fact that we'd like to have
> wireless extensions deprecated.
> 
> The issue with Wi-Fi 7 is that you can now have multiple
> connections to the same AP, so a whole bunch of things
> now become per link rather than per netdev, which can't
> really be handled in wireless extensions.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Patch applied to wireless-next.git, thanks.

35c2dcbb64d4 wifi: wext: warn about usage only once

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230224135933.94104aeda1a0.Ie771c6a66d7d6c3cf67da5f3b0c66cea66fd514c@changeid/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

