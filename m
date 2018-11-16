Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0497FC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 13:29:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C37CE2087C
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 13:29:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VWyR9pHV";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VWyR9pHV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C37CE2087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389753AbeKPXmK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 18:42:10 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57760 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727727AbeKPXmK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 18:42:10 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BC37E60767; Fri, 16 Nov 2018 13:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542374985;
        bh=IYlBJtfAhRlCgAFp8COONKtzn0dT5GhGCwO/kKQDTog=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VWyR9pHVJH6H4aeI4+oCtAanduLfAVWJsu3Jz5mySgl2yeNF2p9/CDzEUi0cKsp7F
         iAwGETac5gch9DWXdLRp5HvqtILVCVIirwnIiPJElUEFOT0rK4L5XQjTY7/O1n7Ve4
         rPM4zVYlcTjcsnjtA9pv507xGY1MAi7qJ6Z4au6M=
Received: from x230.qca.qualcomm.com (87-95-226-75.bb.dnainternet.fi [87.95.226.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4376A60452;
        Fri, 16 Nov 2018 13:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542374985;
        bh=IYlBJtfAhRlCgAFp8COONKtzn0dT5GhGCwO/kKQDTog=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VWyR9pHVJH6H4aeI4+oCtAanduLfAVWJsu3Jz5mySgl2yeNF2p9/CDzEUi0cKsp7F
         iAwGETac5gch9DWXdLRp5HvqtILVCVIirwnIiPJElUEFOT0rK4L5XQjTY7/O1n7Ve4
         rPM4zVYlcTjcsnjtA9pv507xGY1MAi7qJ6Z4au6M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4376A60452
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     briannorris@chromium.org, andy.gross@linaro.org,
        ath10k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-wireless@vger.kernel.org, robh+dt@kernel.org,
        sboyd@kernel.org, dianders@chromium.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/3] Enable ath10k wcn3990 wifi driver support on sdm845
References: <1541423318-19312-1-git-send-email-govinds@codeaurora.org>
Date:   Fri, 16 Nov 2018 15:29:39 +0200
In-Reply-To: <1541423318-19312-1-git-send-email-govinds@codeaurora.org>
        (Govind Singh's message of "Mon, 5 Nov 2018 18:38:35 +0530")
Message-ID: <87d0r55ews.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Govind Singh <govinds@codeaurora.org> writes:

> This series enables ath10k wifi driver support for WCN3990 target
> on sdm845 SOC. This series also updates the missing dt binding documentation
> and adds optional iommu property.
>
> Changes since v3:
>     Moved interrupt/reg/reg-name to required property.
>     Removed unused clocks.
>     Corrected interrupt no's.
>
> Changes since v2:
>     dropped [v2,4/4] dts: arm64/sdm845: Enable iommu for WCN3990 wifi module
>     device node patch from the series as dependent patch is not yet merged.
>     Enabled status flag from sdm845-mtp.dts.
>
> Changes since v1:
>     Listed no of interrupts/clocks for each set of compatible.
>     Added missing 'wifi' label to sdm845.dtsi.
>
> Govind Singh (3):
>   dt: bindings: add missing dt properties for WCN3990 wifi node
>   dts: arm64/sdm845: Add WCN3990 WLAN module device node
>   dt: bindings: add bindings for wifi iommu node
>
>  .../bindings/net/wireless/qcom,ath10k.txt          | 62 ++++++++++++++--------
>  arch/arm64/boot/dts/qcom/sdm845-mtp.dts            |  8 +++
>  arch/arm64/boot/dts/qcom/sdm845.dtsi               | 26 +++++++++
>  3 files changed, 74 insertions(+), 22 deletions(-)

Via which tree are these patches going? That's not clear for me.

-- 
Kalle Valo
