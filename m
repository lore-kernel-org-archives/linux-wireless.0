Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF0FC282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:58:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 368D42147C
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:58:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FFlSjt/8";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JTk95vJu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbfBGO6o (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 09:58:44 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60556 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfBGO6o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 09:58:44 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 49520605FC; Thu,  7 Feb 2019 14:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549551523;
        bh=I8eRJyhFP7XDM2jZH44Z64D/lAnlZxCr+Y2exg9vvUs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=FFlSjt/838FJti1Bq5LZ2p6WZQIj2FHUOPNs/2Wlg9xcsHy20QF/IWZQzC2kKwQl+
         3Y0/KGtSc4MjYJs3/bVczLhb6xXBBXmwAmL0h0yfh+Lh5XBKfBSwLtlwBLEujNFzuW
         uLG2LyL7aB6CtwN7EQ93C2pb8fd1Xq4zJWWwb2Cw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E12E360264;
        Thu,  7 Feb 2019 14:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549551522;
        bh=I8eRJyhFP7XDM2jZH44Z64D/lAnlZxCr+Y2exg9vvUs=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=JTk95vJuSNexZApgnYaDZVL+v8C6FAul7u4HBMwWkGUtxF2dRh4Bbtu0rqwrarwLH
         HHlWMc7s6hv58DvA6R7hNnQTVvm699Zok/fwVciM6W5icIoxb6+Kbqp+ncWV+oeocH
         nsB352vbkP3ENSsLGpno2BqwW1QUP44f2msndclg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E12E360264
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fill tx_duration for each peer in Tx stats per STA
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1548999390-25576-1-git-send-email-svishnoi@codeaurora.org>
References: <1548999390-25576-1-git-send-email-svishnoi@codeaurora.org>
To:     Surabhi Vishnoi <svishnoi@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190207145843.49520605FC@smtp.codeaurora.org>
Date:   Thu,  7 Feb 2019 14:58:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Surabhi Vishnoi <svishnoi@codeaurora.org> wrote:

> Firmware sends the tx_duration for each in HTT_T2H_MSG_TYPE_PEER_STATS
> msg. Fill the tx_duration sent by firmware in the tx stats information
> per STA.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1,
>            WLAN.HL.2.0-01617-QCAHLSWMTPLZ-1
> 
> Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

056550291d98 ath10k: fill tx_duration for each peer in Tx stats per STA

-- 
https://patchwork.kernel.org/patch/10791825/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

