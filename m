Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 455C0C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1501720665
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:12:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lAM8tkPx";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="J77ogggn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbfBSPMI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:12:08 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39228 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbfBSPMI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:12:08 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 786BE608CC; Tue, 19 Feb 2019 15:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589127;
        bh=ltWyoQoBv928OUcMyK48QgMJbYrdyRj3SeD+UegiCN0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=lAM8tkPxB/7ir2/Xoj2tO6D3N5vu4hzuN1YTI9xkEPEWKzxMf3bUy178oueRDurCo
         AO9Ey9ttS0hjSZClPTUbWfucNJ742+R0RNJxiN9mOyqGSBBtzjWDRTrjsqmowvm96X
         9R5frfETFW3FGo5onB0C5r1DDg7zHegspKKsVtII=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A97FC608D4;
        Tue, 19 Feb 2019 15:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589126;
        bh=ltWyoQoBv928OUcMyK48QgMJbYrdyRj3SeD+UegiCN0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=J77ogggnh559So/cLH2wY6fRGtNzMaGANOsqThgkeBk20SCXufLNE0MvUvLmt1pgH
         ZweSp1Rb3C7zAtPUnRHzo89dtFDGfbxMlU57qJ4Q4Y6S+NJnZOPPPoxNFb+Qr5KK3d
         E4yvBEa4J66THQCOAGAY8V1G6cE41gdf5gfOk6bE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A97FC608D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] libertas_tf: fix signal reporting
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190210194822.18539-1-lkundrak@v3.sk>
References: <20190210194822.18539-1-lkundrak@v3.sk>
To:     Lubomir Rintel <lkundrak@v3.sk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190219151207.786BE608CC@smtp.codeaurora.org>
Date:   Tue, 19 Feb 2019 15:12:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lubomir Rintel <lkundrak@v3.sk> wrote:

> Instead of exposing the signal-to-noise ration, calculate the actual signal
> level taking the noise floor into account.
> 
> Also, flip the SIGNAL_DBM bit on, so that mac80211 exposes the signal
> level along with the station info in scan results. This fills
> NetworkManager's "nmcli d wifi output" output with colors, bars and joy.
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> Reviewed-by: Steve deRosier <derosier@cal-sierra.com>

Patch applied to wireless-drivers-next.git, thanks.

b723dbb313f0 libertas_tf: fix signal reporting

-- 
https://patchwork.kernel.org/patch/10804879/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

