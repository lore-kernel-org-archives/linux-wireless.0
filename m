Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A141DCD4F27
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Sep 2023 07:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbjIVHpJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Sep 2023 03:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbjIVHoz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Sep 2023 03:44:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1573410C4
        for <linux-wireless@vger.kernel.org>; Fri, 22 Sep 2023 00:43:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA8EC433C8;
        Fri, 22 Sep 2023 07:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695368616;
        bh=+f8zGftn3d5DLHUAhA2ti+9ph0p0emRcrgqvWCGeRXI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=cKGT3bSFLbTSM57i5Bj8/qDbxudN63hnfH9R6JdikO/gitRpgX4S12XE/+d/RSEHe
         BXgn/nZjko1KK3F2KzaJeElb50CTDG0V8fEHIceRgRNHfX6mZjEGhH45nBeQS8c/s2
         PdnTBBaS35EObq1nbOgFySsYwIvkpqe1k4j944mn/sJdAm61EZRK0WZTq3lccrcKEI
         jApqJ5fEVPQlyTkrrf2Hrz7eYkJkU2fwN+lW5O8VX9Sb6NPCqmjVMxPkrk3iZWlYHl
         z+7odRKfR7a9H/DxGgiA2iMRvAT/6vvgO4Ujrw0+WlsCS0ZCsb7C5MHaEDD82R2Lcp
         M4WLmPomZ55Sg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] wifi: mwifiex: simplify PCIE write operations
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230919132804.73340-1-dmantipov@yandex.ru>
References: <20230919132804.73340-1-dmantipov@yandex.ru>
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     Brian Norris <briannorris@chromium.org>,
        linux-wireless@vger.kernel.org, lvc-project@linuxtesting.org,
        Dmitry Antipov <dmantipov@yandex.ru>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169536861298.2011393.6026492051683606786.kvalo@kernel.org>
Date:   Fri, 22 Sep 2023 07:43:34 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dmitry Antipov <dmantipov@yandex.ru> wrote:

> Since 'mwifiex_write_reg()' just issues void 'iowrite32()',
> convert the former to 'void' and simplify all related users
> (with the only exception of 'read_poll_timeout()' which
> explicitly requires a non-void function argument).
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> Acked-by: Brian Norris <briannorris@chromium.org>

2 patches applied to wireless-next.git, thanks.

c2e01a3a7b9a wifi: mwifiex: simplify PCIE write operations
804edf4d18e2 wifi: mwifiex: followup PCIE and related cleanups

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230919132804.73340-1-dmantipov@yandex.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

