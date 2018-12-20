Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47DFEC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 06:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 129882176F
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 06:49:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ACYqJ23Y";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XjJ+2xoI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729308AbeLTGt1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 01:49:27 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60166 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbeLTGt0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 01:49:26 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1BB7360591; Thu, 20 Dec 2018 06:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545288566;
        bh=wX0c7IAwFe2IoHoUxdJK+eESB8Nz8JI2ny5Vioan4sA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ACYqJ23Yovjk6UFjCSPHwicsbEVmarj7WLmyK4rxwjrlQkMmIJt91dqK/PeT1VrAG
         Kt4t+VMaKW2vwMtcXiPKJ6w0Gyy3qIDCrUJ8quA8oJwt+pLmayYECcSxXzSAmEHJUC
         RjLkuFuCmb0J+qEooJRxQpQZzXOndi8V68oUz6Do=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 40C2A60736;
        Thu, 20 Dec 2018 06:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545288565;
        bh=wX0c7IAwFe2IoHoUxdJK+eESB8Nz8JI2ny5Vioan4sA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=XjJ+2xoION/FxtnpmtvDwq/XBlOwzvhz0gj8SQnHfpoBLVWVqZ9trui0je6xg/EoT
         KPKMe72TeeZ4sSvptshIelY1qFtqUFLiVn+Da/2vTHa5/Lil1dKg5TplvZrNTnXuNe
         nuXiMAVOQ2Qz4fpRBdBUXqA2sYthH9mEzML50Mr8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 40C2A60736
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: Fix access point mode
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1544642406-24272-1-git-send-email-stefan.wahren@i2se.com>
References: <1544642406-24272-1-git-send-email-stefan.wahren@i2se.com>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220064926.1BB7360591@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 06:49:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stefan Wahren <stefan.wahren@i2se.com> wrote:

> Since commit 1204aa17f3b4 ("brcmfmac: set WIPHY_FLAG_HAVE_AP_SME flag")
> the Raspberry Pi 3 A+ (BCM43455) isn't able to operate in AP mode with
> hostapd (device_ap_sme=1 use_monitor=0):
> 
> brcmfmac: brcmf_cfg80211_stop_ap: setting AP mode failed -52
> 
> So add the missing mgmt_stypes for AP mode to fix this.
> 
> Fixes: 1204aa17f3b4 ("brcmfmac: set WIPHY_FLAG_HAVE_AP_SME flag")
> Suggested-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

861cb5eb467f brcmfmac: Fix access point mode

-- 
https://patchwork.kernel.org/patch/10726965/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

