Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A04C6783C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 14:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B32B220835
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 14:34:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YfLeeSZE";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SHEUB5KA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B32B220835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbeJLWHS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 18:07:18 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60140 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728616AbeJLWHS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 18:07:18 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6066A60BFE; Fri, 12 Oct 2018 14:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539354874;
        bh=H/PjmJwkDTqph1ySC7qTCLmA+16FpmWA5GteT68Djx8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=YfLeeSZEZ9elvopOAqixGrmN2WlBIzOIN81q7Q2OWo0en/EPd8P7iIHmKL4hUopSU
         kZCvUyrGIg/PAoGiwkWxQ3ndBb5Z1w9Xrn0sFYCW/wpGuRPAS3ep2OKt4dlg9s/olP
         vyEEAhnhx2sFSNuoL0rfQ7ZzeNAHzmfkcbs+d1Uw=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9FE656024C;
        Fri, 12 Oct 2018 14:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539354873;
        bh=H/PjmJwkDTqph1ySC7qTCLmA+16FpmWA5GteT68Djx8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=SHEUB5KAcnTfPhExrhEv+Osc/qRQn34o2H6Y0eU1Te8iQR/HQgI4gixHMVonouGZE
         kOqdiLkad2HLe9rngDlwgxrmZwZlq9zao3Z+xMb0w92IhK+pct1rdc2eELG18sRNov
         OKolEieI69o3u68EdzvBeehiBE9v5Pg4aTsMxHIg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9FE656024C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fill the channel survey results for WCN3990
 correctly
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1538564267-19863-1-git-send-email-pillair@codeaurora.org>
References: <1538564267-19863-1-git-send-email-pillair@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181012143434.6066A60BFE@smtp.codeaurora.org>
Date:   Fri, 12 Oct 2018 14:34:34 +0000 (UTC)
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

Kbuild bot reported some errors:

>> ERROR: "__udivdi3" [drivers/net/wireless/ath/ath10k/ath10k_core.ko] undefined!
>> ERROR: "__divdi3" [drivers/net/wireless/ath/ath10k/ath10k_core.ko] undefined!

Need to investigate those if they are valid or problem with the bot.

-- 
https://patchwork.kernel.org/patch/10624567/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

