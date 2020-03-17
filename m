Return-Path: <SRS0=6JIn=5C=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A0A2C10F29
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Mar 2020 06:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A878E20674
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Mar 2020 06:36:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="HpTxh4w6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgCQGgl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 17 Mar 2020 02:36:41 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:43611 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbgCQGgl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Mar 2020 02:36:41 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1584427001; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=xvFgNez5iQJug+yeBep1gjuVYmgRXA6RuDCTwudLvUc=;
 b=HpTxh4w6JCtjroNmritEknypykYCYcsw9s2V3nypfagAxWPOhBNfemqYGTBVTPUfaI8syNVF
 yl1DoJuhy4Eyup1VM8+GGLexRAB5hbvBeWjKVHl66cPtDPZpiho1dpugyS5MqH1SNhSNCjPA
 Tdc+pRpdv1qyefXRpEnMd+PjMPU=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e706fe5.7fe0859d1a78-smtp-out-n03;
 Tue, 17 Mar 2020 06:36:21 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AFA2FC432C2; Tue, 17 Mar 2020 06:36:20 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 326F4C433CB;
        Tue, 17 Mar 2020 06:36:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 326F4C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/2] ath11k: handle RX fragments
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1584088343-3584-2-git-send-email-mpubbise@codeaurora.org>
References: <1584088343-3584-2-git-send-email-mpubbise@codeaurora.org>
To:     Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200317063620.AFA2FC432C2@smtp.codeaurora.org>
Date:   Tue, 17 Mar 2020 06:36:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Manikanta Pubbisetty <mpubbise@codeaurora.org> wrote:

> IPQ8074 HW has support to verify the PN of the received frames.
> For all frames except for fragmented ones, HW checks the PN and
> delivers them to the driver. For fragmented frames, driver is
> required to do a little more; it has to reassemble the fragments
> and then reinject them to the HW for verifying the PN. Currently,
> to keep the logic simple, PN verifcation is disabled in HW and is
> handled in mac80211 for all the frames (fragmented and unfragmented).
> 
> On the contrary, offloading PN Validation to the HW brings important
> benefits. It reduces CPU cycles spent on the host CPU for verifying
> the same; helps in enabling features which improve performance like
> mac80211 fast RX path, enabling multiple REO rings for parallel RX
> processing, 802.11 decapsulation offloading. All these features are
> dependent on PN offload which in turn is dependent on handling of
> the received fragments in the driver.
> 
> When TKIP security is used, additional handling is required while
> processing the fragments; since MIC is computed on an MSDU in TKIP,
> only the last fragment has the MIC info. In this case, driver has to
> compute the MIC after reassembly and compare it against the MIC
> present in the frame. For this, MICHAEL_MIC kernel crypto library
> APIs are used and the dependencies are appropriately set.
> 
> Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

243874c64c81 ath11k: handle RX fragments
1441b2f205a7 ath11k: enable PN offload

-- 
https://patchwork.kernel.org/patch/11436249/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
