Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92DA4C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:09:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3810320825
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:09:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lEuZi3QZ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="g90kqYSx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3810320825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbeKEU2O (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 15:28:14 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:55654 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbeKEU2O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 15:28:14 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5CA4C60588; Mon,  5 Nov 2018 11:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541416144;
        bh=P49G+P3AIM+MCJZzLON6gNSxR6jKQV+s32m8vTOPPJM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=lEuZi3QZIJtf2Kj0uMyr8db1ASgf2pu3Kt/bj9JzObPaenxeLSeXdDPEEHwH5K3pv
         rfwo2xswwUF7lfQs2vkli3Fg0GVZRfBMsus++DUKoB7xNiRCkyUnyOaJRBGiNKsVIp
         5tM/J9GScVbxo5eWTzarmo4tV2zZukml3ql403YA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D14906053D;
        Mon,  5 Nov 2018 11:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541416144;
        bh=P49G+P3AIM+MCJZzLON6gNSxR6jKQV+s32m8vTOPPJM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=g90kqYSx3iDInWBJ02BMkvNvp47c3qYrjKPXFncIi/4AF/6BxoRkDDkgA+TQRgGPh
         JWsUR6imqOMV7PGbxPvH2JrvQNnkjee7oSunRQe0lX9ypFI4Z2XZf+GQGLptx6Dh+V
         Jt9D94W7j83537Q5NCmmbP/6QvnllfASjsk6nDWM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D14906053D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath10k: Fill the channel survey results for WCN3990
 correctly
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1539775203-22764-1-git-send-email-pillair@codeaurora.org>
References: <1539775203-22764-1-git-send-email-pillair@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181105110904.5CA4C60588@smtp.codeaurora.org>
Date:   Mon,  5 Nov 2018 11:09:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rakesh Pillai <pillair@codeaurora.org> wrote:

> The host driver currently expects the channel info event to be
> received in pairs for all the channels, i.e. the first
> chan_info event for a particular channel will not have the
> COMPLETE flag set and the second chan_info event for the
> same channel will have the COMPLETE flag set.
> 
> The HL2.0 firmware sends only one channel info event per channel
> which is scanned without the COMPLETE flag set. After sending the
> chan_info_event for all the channels, the HL2.0 firmware sends a
> chan_info_event with COMPLETE flag set to indicate the completion
> of the channel info event.
> 
> The firmware does not indicate this behavior with any service bitmap
> and hence a new firmware feature flag is used to handle the modified
> parsing of the channel info events, in the host driver, for the
> firmware which sends single channel info event per scanned channel.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
> 
> Co-developed-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
> Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

13104929d2ec ath10k: fill the channel survey results for WCN3990 correctly

-- 
https://patchwork.kernel.org/patch/10645331/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

