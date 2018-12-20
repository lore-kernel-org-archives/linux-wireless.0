Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34738C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0225021720
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:03:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jbzre4Fg";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ACnTi/f3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733293AbeLTRC7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 12:02:59 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59648 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbeLTRC7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 12:02:59 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2E58E60A3B; Thu, 20 Dec 2018 17:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545325378;
        bh=7w75xKwFUksvFzmdNb9mfsoBQWg60h+ouEjW669U2k4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jbzre4Fg9RCVZwrLVXG/UFcSuXdDtU0HM7iabHIPL7ndXCVisVGST/06rfi0nt04v
         ZW4E7Fhhw6WT7rKUkr8fvX/3mf00zesPLi+I5pQJpmXtwcbaU9hOYgVxcKNX6aBj/s
         o1NM3Xh+1kBccMxs078V1kfTe1LR1OqnIJDTn/gM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7514660A77;
        Thu, 20 Dec 2018 17:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545325370;
        bh=7w75xKwFUksvFzmdNb9mfsoBQWg60h+ouEjW669U2k4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ACnTi/f3LIDTSCDmx8BkbhX5fnkWvojJnYYtG33OkC2aA+/bqSTpiXd2XG0Y9lYQL
         ev8e1reqzUf4RTOxkY1OQtIiFREK+7ieX6DfVZn2HvY8FadVLRAyobzexl/NiXI6Iu
         BFsAe0799Z1/FvHp6p3lwAPVaFtbMTYtAmb+UcHk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7514660A77
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fix warning due to msdu limit error
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1542613703-9704-1-git-send-email-bperumal@codeaurora.org>
References: <1542613703-9704-1-git-send-email-bperumal@codeaurora.org>
To:     Bhagavathi Perumal S <bperumal@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Bhagavathi Perumal S <bperumal@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220170258.2E58E60A3B@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 17:02:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Bhagavathi Perumal S <bperumal@codeaurora.org> wrote:

> Some hardwares variants (QCA99x0) are limiting msdu deaggregation with
> some threshold value(default limit in QCA99x0 is 64 msdus), it was introduced to
> avoid excessive MSDU-deaggregation in error cases. When number of sub frames
> exceeds the limit, target hardware will send all msdus starting from present
> msdu in RAW format as a single msdu packet and it will be indicated with
> error status bit "RX_MSDU_END_INFO0_MSDU_LIMIT_ERR" set in rx descriptor.
> This msdu frame is a partial raw MSDU and does't have first msdu and ieee80211
> header. It caused below warning message.
> 
> [  320.151332] ------------[ cut here ]------------
> [  320.155006] WARNING: CPU: 0 PID: 3 at drivers/net/wireless/ath/ath10k/htt_rx.c:1188
> 
> In our issue case, MSDU limit error happened due to FCS error and generated
> this warning message.
> 
> This fixes the warning by handling the MSDU limit error. If msdu limit error
> happens, driver adds first MSDU's ieee80211 header and sets A-MSDU present bit
> in QOS header so that upper layer processes this frame if it is valid or drop it
> if FCS error set. And removed the warning message, hence partial msdus without
> first msdu is expected in msdu limit error cases.
> 
> Tested on QCA9984, Firmware 10.4-3.6-00104
> 
> Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

a2864772f33a ath10k: fix warning due to msdu limit error

-- 
https://patchwork.kernel.org/patch/10688251/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

