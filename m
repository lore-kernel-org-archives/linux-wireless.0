Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F09CCC32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B86EF2081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:53:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hUoXKp0c";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ya04nXEF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B86EF2081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389441AbeKGCTi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:19:38 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:55244 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389214AbeKGCTi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:19:38 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9446F60BDE; Tue,  6 Nov 2018 16:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523212;
        bh=nHf3MeZUzMETq7NZm9c/FcatO40Xelx7mKNcy2+Pnqk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=hUoXKp0c+QJVtvUrHdN3So/BYuRFbRnDykvKGNPq+Z7LeXKCGZe1o+ek4sDt2zcm6
         avWO7vd1pNHNG10KjUbzGveTVdShOxMD7cgYnzHWksgWYmRoArcPqRt5sms9PF+ui8
         zYJa3rUOSCANeV3ERVqCLGMPtZe7SwEznNIDxBfk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 711BC601D7;
        Tue,  6 Nov 2018 16:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523212;
        bh=nHf3MeZUzMETq7NZm9c/FcatO40Xelx7mKNcy2+Pnqk=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Ya04nXEFE07gHTsgQPrIi3fEO3w8vmuKJNwhm3p6BnYRRhmzghO9QryRBrm3b+U8H
         CQ8ODRnYY5gYrPQllAsW9hiAquzfFyyatgamMG08O8mpAkJL1Zpp0vF7x5zqtbXPUa
         lCp4vnwN/LDKmQDOX+Gh8ovD3I/2zvpcZPf/4gCw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 711BC601D7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wlcore: Fix the return value in case of error in
 'wlcore_vendor_cmd_smart_config_start()'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181016073940.26797-1-christophe.jaillet@wanadoo.fr>
References: <20181016073940.26797-1-christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, tony@atomide.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106165332.9446F60BDE@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 16:53:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> We return 0 unconditionally at the end of
> 'wlcore_vendor_cmd_smart_config_start()'.
> However, 'ret' is set to some error codes in several error handling paths
> and we already return some error codes at the beginning of the function.
> 
> Return 'ret' instead to propagate the error code.
> 
> Fixes: 80ff8063e87c ("wlcore: handle smart config vendor commands")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Patch applied to wireless-drivers-next.git, thanks.

3419348a97bc wlcore: Fix the return value in case of error in 'wlcore_vendor_cmd_smart_config_start()'

-- 
https://patchwork.kernel.org/patch/10643195/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

