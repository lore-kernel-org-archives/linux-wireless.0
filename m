Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CBBDC10F00
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD22C2075C
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:29:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jPqJSHRZ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="i9AYArlz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbfBVO34 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:29:56 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54852 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfBVO34 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 09:29:56 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 102E4608CD; Fri, 22 Feb 2019 14:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550845795;
        bh=ujVBz2VVgWFlXBilPBCL603UyF8mEDHzaSvNz5iBVwg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jPqJSHRZydC4FeO9/FR41y3LXBNc8R3/d4XeIylGrHLNtB4cEIfUTrqnFvJOQRPg6
         TZm4vLP6ua+1QYk24RIToccsjvbpymPzsjGf2eTXOC98gAza1T506lxAtCyGIfNaNx
         tuw0977AOPg2WwwELBZeNB2OxqHbkbnAcz5lalGk=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 91C8D60247;
        Fri, 22 Feb 2019 14:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550845794;
        bh=ujVBz2VVgWFlXBilPBCL603UyF8mEDHzaSvNz5iBVwg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i9AYArlzM3czo5qHmHA7cC9PsR9bBg1F0JLKzBC07E8SLKvixxz1ZMoHoOxeU2PYh
         5hv08pUrwW61PNqlP4ZEGKMOklF4fUT8RMduGIplonIMezid7oX+3oTlANwtJp6imr
         PaRc+3u9dsb7BdYnbSHvOhvcfhs+83QBfBAnGPsM=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 22 Feb 2019 16:29:54 +0200
From:   merez@codeaurora.org
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH v2 00/12] wil6210 patches
In-Reply-To: <1548689786-23288-1-git-send-email-merez@codeaurora.org>
References: <1548689786-23288-1-git-send-email-merez@codeaurora.org>
Message-ID: <c63a47c2625b92ffdbfbb13187c43888@codeaurora.org>
X-Sender: merez@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-01-28 17:36, Maya Erez wrote:
> Changes from V1:
> - Update copyright year to 2019.
> - Change bool usage in structures to u8.
> 
> The following set of patches include:
> - Use platform specific configuration instead of wil6210 module 
> parameters
> - Various wil6210 fixes.
> 
> Ahmad Masri (5):
>   wil6210: support ndo_select_queue in net_device_ops
>   wil6210: add support for AC queues per station
>   wil6210: support up to 20 stations in AP mode
>   wil6210: accessing 802.3 addresses via utility functions
>   wil6210: prevent device memory access while in reset or suspend
> 
> Alexei Avshalom Lazar (2):
>   wil6210: check null pointer in _wil_cfg80211_merge_extra_ies
>   wil6210: align to latest auto generated wmi.h
> 
> Dedy Lansky (2):
>   wil6210: add option to drop Tx packets when tx ring is full
>   wil6210: fix invalid sta statistics update
> 
> Maya Erez (3):
>   wil6210: remove rtap_include_phy_info module param
>   wil6210: use platform specific configuration
>   wil6210: ignore HALP ICR if already handled
> 
>  drivers/net/wireless/ath/wil6210/cfg80211.c       |  43 ++-
>  drivers/net/wireless/ath/wil6210/debugfs.c        |  48 ++-
>  drivers/net/wireless/ath/wil6210/interrupt.c      |  12 +-
>  drivers/net/wireless/ath/wil6210/main.c           | 162 +++++----
>  drivers/net/wireless/ath/wil6210/netdev.c         |  77 +++-
>  drivers/net/wireless/ath/wil6210/pcie_bus.c       |  33 +-
>  drivers/net/wireless/ath/wil6210/pm.c             |  31 +-
>  drivers/net/wireless/ath/wil6210/rx_reorder.c     |  10 +-
>  drivers/net/wireless/ath/wil6210/trace.h          |   3 +-
>  drivers/net/wireless/ath/wil6210/txrx.c           | 407 
> +++++++++++++++-------
>  drivers/net/wireless/ath/wil6210/txrx.h           |  51 ++-
>  drivers/net/wireless/ath/wil6210/txrx_edma.c      |  14 +-
>  drivers/net/wireless/ath/wil6210/wil6210.h        |  70 ++--
>  drivers/net/wireless/ath/wil6210/wil_crash_dump.c |  18 +-
>  drivers/net/wireless/ath/wil6210/wil_platform.h   |  29 ++
>  drivers/net/wireless/ath/wil6210/wmi.c            | 111 ++++--
>  drivers/net/wireless/ath/wil6210/wmi.h            |  48 ++-
>  17 files changed, 809 insertions(+), 358 deletions(-)

Please drop this set of patches.
I upstreamed a new set of patches.

-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
