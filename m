Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C203C282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 16:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FBC420823
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 16:43:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NXuYOIaB";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NxujD+ev"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729955AbfBDQmz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 11:42:55 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54112 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727062AbfBDQmz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 11:42:55 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 86E0860734; Mon,  4 Feb 2019 16:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549298574;
        bh=1GPTfXBbZXobE8F8AvnVuiGEwNBmTM4TvMVOTyfE+P4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=NXuYOIaB6ej8f/Ewm9H2j7F4cQdgrI+9q/30F195Jt4VlRO1ckpNSJy7HNdzPpSry
         +clYMKQFmnPSNSyWO9NVkO/ikaeI9xWZh95T3AxqoiZ5Sbmqu5uRGGHocGPgfmW9ia
         aI7RMnw6/uW8xuUsLGctp1H+yexh/EWy9ZxE02y4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3A83E6043F;
        Mon,  4 Feb 2019 16:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549298574;
        bh=1GPTfXBbZXobE8F8AvnVuiGEwNBmTM4TvMVOTyfE+P4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=NxujD+evLaB+vqqSdTu9zxkQYVfHcn6LaAu6tHt7I1EMBnwzKIk/qJK/rBSe7cwIU
         b18Dme2oFfokpEn5eN9VyT+CKRS1uV5qfduqI0xzZOPMWsWp19KU1unRX05Lsd0EGY
         MtCbPym0R0j9IDwBUWf4tl2W4hdY2yQ8wWcZnb2A=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3A83E6043F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH REGRESSION] Revert "ath10k: add quiet mode support for
 QCA6174/QCA9377"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181107185643.240346-1-briannorris@chromium.org>
References: <20181107185643.240346-1-briannorris@chromium.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Yu Wang <yyuwang@codeaurora.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Govind Singh <govinds@codeaurora.org>, stable@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190204164254.86E0860734@smtp.codeaurora.org>
Date:   Mon,  4 Feb 2019 16:42:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

> This reverts commit cfb353c0dc058bc1619cc226d3cbbda1f360bdd3.
> 
> WCN3990 firmware does not yet implement this feature, and so it crashes
> like this:
> 
>   fatal error received: err_qdi.c:456:EX:wlan_process:1:WLAN RT:207a:PC=b001b4f0
> 
> This feature can be re-implemented with a proper service bitmap or other
> feature-discovery mechanism in the future. But it should not break
> working boards.
> 
> Fixes: cfb353c0dc05 ("ath10k: add quiet mode support for QCA6174/QCA9377")
> Cc: Yu Wang <yyuwang@codeaurora.org>
> Cc: Rakesh Pillai <pillair@codeaurora.org>
> Cc: Govind Singh <govinds@codeaurora.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

This regression should be fixed by (which is in v4.20):

53884577fbce ath10k: skip sending quiet mode cmd for WCN3990

So this revert should not be needed anymore and I'll drop this.

-- 
https://patchwork.kernel.org/patch/10672903/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

