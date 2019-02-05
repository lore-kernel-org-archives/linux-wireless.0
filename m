Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54DFEC282C4
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 01:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1544520821
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 01:02:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="JylduIH+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbfBEBCM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 20:02:12 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33406 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbfBEBCM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 20:02:12 -0500
Received: by mail-pf1-f194.google.com with SMTP id c123so757190pfb.0
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2019 17:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=h0i/s5FiGguR6lHC+HBX3JQRwkyIa6vsi6ujkJLVTQs=;
        b=JylduIH+6AK1ftuiQ5AcySeKXyswot29G4Cy9O0BhIqOYzVqAGJsE1dHg3WjmL6JE5
         b3KzL+vwWc7FbM1dTe6F6khm3dWCsvtiLhSWkEKYVLK7nRQRkTn1LO8e0z+8Y+HNEUcG
         7x7UVY9ubrO5nQnfb3JKFD6aEGzIKI64nZSDE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=h0i/s5FiGguR6lHC+HBX3JQRwkyIa6vsi6ujkJLVTQs=;
        b=sC7dMXkcOidjSUEfx34jmtZrdisD4ebl6p/tAEjcbp8HjkHfPtqcRc1FDSRDvIN9jl
         C+xQgRSQAahTt8Qn1JNMHbFHJE/hCcpv9ksT6Pa4Y056JjqCZMha2Ntun2EzHYOtSdQY
         L7z8z92Ydwsvoh5Z56778Qk7+Vj9byHjzB9FsTtQnbs126rbZ/nS91uisbcRF4+35s43
         DllbYGTDXPBG4fy7hFX4w18oUvVLCG5LXiEAZckZt9P3wplgbTqMmgkZVgBTqRHJHWUT
         fT/WHAEClz9upXlaZJO2lYaLZ5McRvN/aTZGUhSk07ahaaH5deoOBtg976mvUbnZQJR2
         AY6A==
X-Gm-Message-State: AHQUAuYPpbyjW7ramOIdXXI2/3eTQIllKTG2Vg+HYKB99l2KHcUFCwpB
        AeX0aQPawudZF57/XS8P02V6VR4sdig=
X-Google-Smtp-Source: AHgI3IaE67AO1bObWG11fkoiuo7uuLO3+9KMdc0L5D1TuKni/96Gej1tKAEZvjDhH08TnM+CsuixFw==
X-Received: by 2002:a63:287:: with SMTP id 129mr2051803pgc.332.1549328531827;
        Mon, 04 Feb 2019 17:02:11 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id 125sm1779356pfd.124.2019.02.04.17.02.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 Feb 2019 17:02:10 -0800 (PST)
Date:   Mon, 4 Feb 2019 17:02:08 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Enable Factory Test Mode for WCN3990
Message-ID: <20190205010207.GA219734@google.com>
References: <1535526038-4299-1-git-send-email-pillair@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1535526038-4299-1-git-send-email-pillair@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Aug 29, 2018 at 12:30:38PM +0530, Rakesh Pillai wrote:
> The support to put WCN3990 firmware into Factory
> test mode is not present currently. The WCN3990
> firmware can operate in Factory test mode based
> on the mode it receives in the wlan enable message
> from the host driver.
> 
> When the host driver is started in testmode send
> the operating mode as UTF mode, to the WCN3990
> firmware, in the wlan enable message to start the
> firmware in Factory test mode.
> 
> Tested on: WCN3990
> Tested FW: WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1.
> 
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/ahb.c      |  3 ++-
>  drivers/net/wireless/ath/ath10k/core.c     |  2 +-
>  drivers/net/wireless/ath/ath10k/hif.h      |  7 ++++---
>  drivers/net/wireless/ath/ath10k/mac.c      |  2 +-
>  drivers/net/wireless/ath/ath10k/pci.c      |  3 ++-
>  drivers/net/wireless/ath/ath10k/sdio.c     |  3 ++-
>  drivers/net/wireless/ath/ath10k/snoc.c     | 20 ++++++++++++++++----
>  drivers/net/wireless/ath/ath10k/testmode.c |  2 +-
>  drivers/net/wireless/ath/ath10k/usb.c      |  3 ++-
>  9 files changed, 31 insertions(+), 14 deletions(-)

What ever happened here? I'm told this is useful, but I see no comments
and it's marked Deferred in patchwork:

https://patchwork.kernel.org/patch/10579559/

FWIW, it looks OK to me:

Reviewed-by: Brian Norris <briannorris@chromium.org>
