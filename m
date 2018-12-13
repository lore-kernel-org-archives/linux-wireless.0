Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD91C65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45EB12086D
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:55:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="n102LHND";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XNysctt5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 45EB12086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbeLMOzt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 09:55:49 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44706 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728947AbeLMOzs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 09:55:48 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 68F0260918; Thu, 13 Dec 2018 14:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544712947;
        bh=WN+wMegvQrjg9qirZr0ng2i7TLWnHymea9OdN/Wwdn0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=n102LHNDTzRAwzsdhCgyy+eszBPRhIrHpHMgjGbiapvjep7fx/ljxOFKuMOvtq45F
         h3gog4Q2L0iKV6DcG1mpJXHhqtPE9kWfaI15Q8E4qoCwn5iyGOytBbRKUa4W/38goJ
         O86VluICPm/dPw6FZhH5825ZYSbJtEYrwQsObTH8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3902660960;
        Thu, 13 Dec 2018 14:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544712945;
        bh=WN+wMegvQrjg9qirZr0ng2i7TLWnHymea9OdN/Wwdn0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=XNysctt5cnarYIh5a7dCpME1h77QI8dkoDZH7yUdXE+AgPHGYv4h4Lc7BbgtnJdET
         KoHTyUcxdotawNlw6wX02q+dGiYCXA3K19WAiKDRf0Jvuqv++EOh+FslFNd2uwV+1D
         i8cRxN4FtQhKQi7iDCKD2z2hPt6ky/A+6pCZ22nM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3902660960
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH v2 1/2] mwifiex: refactor mwifiex_parse_htinfo() for
 reuse
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181207001249.165477-1-briannorris@chromium.org>
References: <20181207001249.165477-1-briannorris@chromium.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     <linux-kernel@vger.kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181213145547.68F0260918@smtp.codeaurora.org>
Date:   Thu, 13 Dec 2018 14:55:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

> This function converts some firmware-specific parameters into cfg80211
> 'rate_info' structures. It currently assumes it's dealing only with TX
> bitrate, but the RX bitrate looks to be the same, so refactor this
> function to be reusable.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>

2 patches applied to wireless-drivers-next.git, thanks.

a256707fbd4b mwifiex: refactor mwifiex_parse_htinfo() for reuse
ed0b2b067bad mwifiex: add NL80211_STA_INFO_RX_BITRATE support

-- 
https://patchwork.kernel.org/patch/10717275/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

