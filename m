Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EBCDC10F00
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:16:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F8D620700
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:16:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cDl1LD58";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="J27Yo8Th"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbfBSPQJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:16:09 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42980 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfBSPQI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:16:08 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1D51F608CD; Tue, 19 Feb 2019 15:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589368;
        bh=2R1xiwbZYucztUl2xvKDOi9it8KQuHlifEU+ymMwROg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=cDl1LD58pA9+mhrX8BFnYlnB4thsBNjlO2RBWGTucRC/XQsNcau8LPKYfiL5958fE
         pNmc6ns7/dVvsbIFsXqRJzdPeHx5cP5oFzSw0pGNeaO/WwZaCN0KBmqMQiRJPfwDIA
         aIpAi4hODX14eQoJv/JhbkJu2DMcE5O/r4S7RiaU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6785860779;
        Tue, 19 Feb 2019 15:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589367;
        bh=2R1xiwbZYucztUl2xvKDOi9it8KQuHlifEU+ymMwROg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=J27Yo8Thb4PFytUK2iHrE+e6KyjP2o8Ta+kL3ckE9eIFTesBfgx8foggEurAcbGgu
         qWgx71hzXLxoj7pzu+O2o7oqyMt/sUd7gT5FqxKLqPDcMIjQEYFvBVYY5ujNdF5Qfg
         aDWINxRHSavWPd93TsW2WkTej0VE6kZk90f/nUaY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6785860779
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: don't advertise IBSS features without FW support
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190215003129.98298-1-briannorris@chromium.org>
References: <20190215003129.98298-1-briannorris@chromium.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Karthik D A <karthida@marvell.com>,
        Brian Norris <briannorris@chromium.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190219151608.1D51F608CD@smtp.codeaurora.org>
Date:   Tue, 19 Feb 2019 15:16:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

> As it is, doing something like
> 
>   # iw phy phy0 interface add foobar type ibss
> 
> on a firmware that doesn't have ad-hoc support just yields failures of
> HostCmd_CMD_SET_BSS_MODE, which happened to return a '-1' error code
> (-EPERM? not really right...) and sometimes may even crash the firmware
> along the way.
> 
> Let's parse the firmware capability flag while registering the wiphy, so
> we don't allow attempting IBSS at all, and we get a proper -EOPNOTSUPP
> from nl80211 instead.
> 
> Fixes: e267e71e68ae ("mwifiex: Disable adhoc feature based on firmware capability")
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

6f21ab30469d mwifiex: don't advertise IBSS features without FW support

-- 
https://patchwork.kernel.org/patch/10814041/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

