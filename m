Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8932C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 18:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79E222190B
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 18:47:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="johrISfF";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CSVt/alq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731057AbfBLSrv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 13:47:51 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42878 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729132AbfBLSrv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 13:47:51 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6D5FE60227; Tue, 12 Feb 2019 18:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549997270;
        bh=vi5RzShDFpaao3WoA9zr4c7lvVx9d7aDY/EZy7p5fPs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=johrISfFbpH1v6QH1yytg7G0QZJfWQoVunl3jTweZ9dt7J3ivX4PizeDhQiekWQNw
         uakPZXaLwsVCm74L1wfzPXzSP9lmtA41yAeOolQprd7Ny6lpCq628C5ZF27AK68y9p
         0dq89c7UJCy0fACP2c7sAcRhzgho759ZxcRCuQSo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BCD8F60247;
        Tue, 12 Feb 2019 18:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549997269;
        bh=vi5RzShDFpaao3WoA9zr4c7lvVx9d7aDY/EZy7p5fPs=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=CSVt/alqZHr/miL65r16e/ooocE7d4eMUkCheVPqtNO5vuWis2iOeZsPF0sTnKch+
         kYDPs70nndicnIr8Lw8EBrfiNXQoxIJQKIy3cmoQpx+0ExLlnU7dVlbPKI0KSQuZpX
         jnb4Krde2eGPMMSvLP6NLEeeZqrerBDhPzeyEyCI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BCD8F60247
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath10k: add dynamic vlan support
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1542798288-8946-1-git-send-email-mpubbise@codeaurora.org>
References: <1542798288-8946-1-git-send-email-mpubbise@codeaurora.org>
To:     Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190212184750.6D5FE60227@smtp.codeaurora.org>
Date:   Tue, 12 Feb 2019 18:47:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Manikanta Pubbisetty <mpubbise@codeaurora.org> wrote:

> Multicast/broadcast traffic destined for a particular vlan group will
> always be encrypted in software. To enable dynamic VLANs, it requires
> driver support for sending software encrypted packets.
> 
> In ath10k, sending software encrypted frames is allowed only when we insmod
> the driver with cryptmode param set to 1, this configuration disables
> hardware crypto and enables RAW mode implicitly. Since, enabling raw
> mode has performance impact, this cannot be considered as an ideal
> solution for supporting VLANs in the driver.
> 
> As an alternative take, in this approach, cryptographic keys for
> unicast traffic (per peer PTKs) and keys for non-vlan group traffic
> will be configured in hardware, allowing hardware encryption for unicast
> and non-vlan group traffic. Only vlan group traffic will be encrypted in
> software and pushed to the target with encap mode set to RAW in the TX
> descriptors.
> 
> Not all firmwares can support this type of key configuration(having few
> keys installed in hardware and few only in software); for this purpose a
> new WMI service flag "WMI_SERVICE_PER_PACKET_SW_ENCRYPT" is introduced to
> advertise this support.
> 
> Also, adding the logic required to send sw encrypted frames in raw mode.
> 
> Hardwares Tested : QCA9984, QCA988X
> Firmwares Tested : 10.4-3.5.3-00057, 10.2.4-1.0-00042
> 
> Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

4920ce3bf7e0 ath10k: add dynamic vlan support

-- 
https://patchwork.kernel.org/patch/10692385/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

