Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CD6FC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE16620651
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:04:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jgORuOxE";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ecur6Rwd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfBZNEy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 08:04:54 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44928 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfBZNEx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 08:04:53 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 83D8461A87; Tue, 26 Feb 2019 13:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551186292;
        bh=PSDs/1OV/O1NlGhSWdRwvBZEwDCvv2aJvp0xABGYvLM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jgORuOxEIv2AjZlYILRUH05M1yxj3KhBd/2VXVFSjqcldraJ9iLVhEfH2vPLfv6iA
         BCPmF13i/iaCCCkiyu7aJdxHAxEdeJNooFj1ulW8RfiI6KBf+78w9mQkUuyUJSY8xV
         O8oiQkaVHAEFtMAxJt3204/XaMczl07tieVaVMUA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1291861A8B;
        Tue, 26 Feb 2019 13:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551186287;
        bh=PSDs/1OV/O1NlGhSWdRwvBZEwDCvv2aJvp0xABGYvLM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ecur6Rwde3JbMyHdgGHMpNCU3A5/Jms3uqc623bwDWIsjcKT0JWT7v8jQW/6ypP5/
         upDdkZQF0RpLGvwjM8oGFSzlNddsSl5tjYqJMQXYlM+leqqlNEKpt7LfLFp2+iFk8e
         JEb6xTA0b0ohNwz0KnvNgmyoDSZGAk9Ggmp6Ylx4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1291861A8B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fix length of wmi tlv command for protected mgmt
 frames
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1550243977-8612-1-git-send-email-svishnoi@codeaurora.org>
References: <1550243977-8612-1-git-send-email-svishnoi@codeaurora.org>
To:     Surabhi Vishnoi <svishnoi@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190226130452.83D8461A87@smtp.codeaurora.org>
Date:   Tue, 26 Feb 2019 13:04:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Surabhi Vishnoi <svishnoi@codeaurora.org> wrote:

> The length of wmi tlv command for management tx send is calculated
> incorrectly in case of protected management frames as there is addition
> of IEEE80211_CCMP_MIC_LEN twice. This leads to improper behaviour of
> firmware as the wmi tlv mgmt tx send command for protected mgmt frames
> is formed wrongly.
> 
> Fix the length calculation of wmi tlv command for mgmt tx send in case
> of protected management frames by adding the IEEE80211_CCMP_MIC_LEN only
> once.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1
> 
> Fixes: 1807da49733e "ath10k: wmi: add management tx by reference support over wmi"
> Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

761156ff573d ath10k: Fix length of wmi tlv command for protected mgmt frames

-- 
https://patchwork.kernel.org/patch/10815099/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

