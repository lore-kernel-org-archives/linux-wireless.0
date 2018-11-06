Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93389C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:05:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3760F20862
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:05:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TNPaauMk";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dbMKA2Tl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3760F20862
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388891AbeKGBbj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 20:31:39 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37524 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388527AbeKGBbi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 20:31:38 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6317C60591; Tue,  6 Nov 2018 16:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541520345;
        bh=p1iPhrdYvrKQlYf+SXJ9eYS3575bw9O3UV2mSifB+w4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=TNPaauMkc+I0Y8gwPEX35y67tJHbPEYoF8pVJAj0ioQIWEDZixwl/7V+FbeJTuU10
         bWdTripaLOQbgJMeMMXrJofMwAx/kUTECzCOWpMCC9NRAEEd6N8T5jpx5qDX+Sz5XX
         v8mBDahbWHFIfMGpLl/u7P1/SPuxDfxiMhu6CMqI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8DD65601DA;
        Tue,  6 Nov 2018 16:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541520344;
        bh=p1iPhrdYvrKQlYf+SXJ9eYS3575bw9O3UV2mSifB+w4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=dbMKA2TlZ9Nw1jliTiHHP0UZVBfERhFeIK8BZjNHPglRKLYDr3tWh5byD/RSiP8mz
         hVCrjN5SKzDrzuEWrd73E76sIkCW71Sut+HGy+vDa7o3P2LP5UsZ0SbUiEVfcEQTgV
         JT4UWUf3Iq0+G5vyrta7zD2GyJhdA9NBNo3F2Gmw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8DD65601DA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 01/16] wil6210: remove fake support for RXHASH
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1540975944-30576-2-git-send-email-merez@codeaurora.org>
References: <1540975944-30576-2-git-send-email-merez@codeaurora.org>
To:     Maya Erez <merez@codeaurora.org>
Cc:     Hamad Kadmany <hkadmany@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>,
        Lior David <liord@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106160545.6317C60591@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 16:05:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Maya Erez <merez@codeaurora.org> wrote:

> Setting the same fake hash to all skbs prevents
> distributing different flows to different CPU cores.
> 
> Signed-off-by: Hamad Kadmany <hkadmany@codeaurora.org>
> Signed-off-by: Lior David <liord@codeaurora.org>
> Signed-off-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

15 patches applied to ath-next branch of ath.git, thanks.

a078c4cf0197 wil6210: remove fake support for RXHASH
d083b2e2b7db wil6210: fix reset flow for Talyn-mb
cbebe277beb1 wil6210: increase RX rings and RX buff array size
61e5ec044748 wil6210: make sure Rx ring sizes are correlated
e41ab937d47b wil6210: add recovery for FW error while in AP mode
664497400c89 wil6210: fix memory leak in wil_find_tx_bcast_2
e1b43407c034 wil6210: refactor disconnect flow
b571e71bcb98 wil6210: notify cqm packet loss on disable_ap_sme
ac0e541ab2f2 wil6210: add general initialization/size checks
84ec040d0fb2 wil6210: fix debugfs memory access alignment
04de15010aa4 wil6210: fix L2 RX status handling
7c69709f8ed2 wil6210: fix RGF_CAF_ICR address for Talyn-MB
a834df7497b4 wil6210: remove unnecessary alignment code from rx flow
6470f31927b4 wil6210: fix freeing of rx buffers in EDMA mode
dc57731dbd53 wil6210: fix locking in wmi_call

-- 
https://patchwork.kernel.org/patch/10662235/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

