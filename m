Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70AF4C4332F
	for <linux-wireless@archiver.kernel.org>; Tue, 14 Nov 2023 10:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbjKNKSb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 14 Nov 2023 05:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjKNKSb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2023 05:18:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5D0A4;
        Tue, 14 Nov 2023 02:18:28 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14F7C433C8;
        Tue, 14 Nov 2023 10:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699957108;
        bh=E6qJf5xkvt72gnGBq8WeS8tYIMgOIXLwZyGWKa+8WKg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=OSN0dq8HLeTBHO7ktFmZI0+Y0fLYQbP9RpOimeZAMk2sDz7G8L6a614RYO2Y90VdS
         lfiyMaBRQyKomTtwqwbiaaEGtXyDDfJNmQ5a0YbQYtsaGN6NGis6CtX8IN4H8UPdwx
         pGuDD4L3TBXwr3NvU9kuVZND3uv+GyDG+jnQqYL5lHHLfiudOOVmXtxzwVvlESBw8i
         6/JCTGTUlQTZLxuLGLAVmrXsU5euzEircU/9B1ZJ5tpuD8NPidPfsLWBDiUTOBS9MB
         CynAdPjjWMJUbOpKYDPU2z8iJ2nvy4MVxbBAOIIYI3idenzZEscGFzsjNPldhJ96HD
         xEBtzeBGd2blQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rt2x00: correct wrong BBP register in RxDCOC
 calibration
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <TYAP286MB0315B13B89DF57B6B27BB854BCAFA@TYAP286MB0315.JPNP286.PROD.OUTLOOK.COM>
References: <TYAP286MB0315B13B89DF57B6B27BB854BCAFA@TYAP286MB0315.JPNP286.PROD.OUTLOOK.COM>
To:     Shiji Yang <yangshiji66@outlook.com>
Cc:     linux-wireless@vger.kernel.org, Stanislaw Gruszka <stf_xl@wp.pl>,
        linux-kernel@vger.kernel.org, Shiji Yang <yangshiji66@outlook.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169995710456.3786790.695504990029617196.kvalo@kernel.org>
Date:   Tue, 14 Nov 2023 10:18:26 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Shiji Yang <yangshiji66@outlook.com> wrote:

> Refer to Mediatek vendor driver RxDCOC_Calibration() function, when
> performing gainfreeze calibration, we should write register 140
> instead of 141. This fix can reduce the total calibration time from
> 6 seconds to 1 second.
> 
> Signed-off-by: Shiji Yang <yangshiji66@outlook.com>
> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

Patch applied to wireless-next.git, thanks.

50da74e1e8b6 wifi: rt2x00: correct wrong BBP register in RxDCOC calibration

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/TYAP286MB0315B13B89DF57B6B27BB854BCAFA@TYAP286MB0315.JPNP286.PROD.OUTLOOK.COM/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

