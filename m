Return-Path: <SRS0=j5ME=N6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00FDDC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 18:10:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA97620671
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 18:10:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=plaes.org header.i=@plaes.org header.b="NTsVT3Rv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA97620671
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=plaes.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730417AbeKTEe4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Nov 2018 23:34:56 -0500
Received: from plaes.org ([188.166.43.21]:48176 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730394AbeKTEe4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Nov 2018 23:34:56 -0500
Received: from plaes.org (localhost [127.0.0.1])
        by plaes.org (Postfix) with ESMTPSA id B21D340634;
        Mon, 19 Nov 2018 18:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=plaes.org; s=mail;
        t=1542651017; bh=yJheclpnSaUpxoEiTzq0NrE/h/4Wmm51fNAQpyPUHmM=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=NTsVT3RvHNPk0lowEBRCdB9u7Uqlh4wEINI/J1d4Foxz8BuFHYGgsF2w6Hfe5MhHZ
         TQ+lMNV1b+Bf4oiFlkhgBrPFJztgzGlgpf8jr5mOTMAnSpJ1W7g9dO80HcnxB7PYjt
         yccpgSPafxBBTsIEVBg4x1LXQIWWAE5Z+iE9Ri3FVl9DETl7JSDuRJA2fa+6PYY/wS
         eobpmuqijw+bNh6/UvUOLq/ovV/vCfgcYf+SLYyIgJxyJvtExhoWcWYFxveQcVXBjK
         AK9Qal9Py3q44NpllY8l8jDbbT7I4KjDn5r2SDbILf22Z5wLPI6tmNkGX84EXJGkRj
         6FwpHrZ61zeIA==
Date:   Mon, 19 Nov 2018 18:10:16 +0000
From:   Priit Laes <plaes@plaes.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Colin Ian King <colin.king@canonical.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH 0/4] wireless: Use common cordic algorithm for b43 driver
Message-ID: <20181119181016.4fxuszvvyiokuqvl@plaes.org>
References: <cover.87f16ede7954f8d9cde4ecae5f050bf8f4008dd8.1542649316.git-series.plaes@plaes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.87f16ede7954f8d9cde4ecae5f050bf8f4008dd8.1542649316.git-series.plaes@plaes.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Nov 19, 2018 at 08:01:21PM +0200, Priit Laes wrote:
> b43 wireless driver includes an internal implementation of
> cordic algorithm, although there's a common cordic library
> which was split out from brcmsmac driver. Use that and drop
> internal implementation.
> 
> During the process, cordic-algorithm related macros in
> brcmfmac driver were also removed and use general macros.
> 
> Please note that this series is only compile-tested, as I
> do not have access to the hardware.


Gah.. I missed the series version in subject. Shall I resend?

> 
> --
> 
> Changes since v3:
> - Added ACKed-By bits for patches 1, 4
> - Added new patch for stable by Larry as patch 3
> - Fixed argument scaling for b43 driver in patch 4
> 
> Changes since v2:
> - Improvements to commit messages. No functional changes.
> - Collect reviewed-by bits.
> 
> Changes since v1:
> - Merged brcmsmac driver patches into single patch
> - Merged b43 driver patches into single patch
> 
> Larry Finger (1):
>   b43: Fix error in cordic routine
> 
> Priit Laes (3):
>   lib: cordic: Move cordic macros and defines to header file
>   brcmsmac: Use cordic-related macros from common cordic library
>   b43: Use cordic algorithm from kernel library
> 
>  drivers/net/wireless/broadcom/b43/Kconfig                      |  1 +-
>  drivers/net/wireless/broadcom/b43/phy_common.c                 | 47 +-------
>  drivers/net/wireless/broadcom/b43/phy_common.h                 |  9 +-
>  drivers/net/wireless/broadcom/b43/phy_lp.c                     | 13 +-
>  drivers/net/wireless/broadcom/b43/phy_n.c                      | 13 +-
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_int.h |  7 +-
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c |  4 +-
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c   |  4 +-
>  include/linux/cordic.h                                         |  9 +-
>  lib/cordic.c                                                   | 23 +---
>  10 files changed, 35 insertions(+), 95 deletions(-)
> 
> base-commit: 9ff01193a20d391e8dbce4403dd5ef87c7eaaca6
> -- 
> git-series 0.9.1
