Return-Path: <SRS0=1g4v=XS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E56C4740C
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Sep 2019 08:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23DDC2087C
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Sep 2019 08:25:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jefdjzgg";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZEUFMhZT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406779AbfIWIZM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Sep 2019 04:25:12 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53086 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406076AbfIWIZM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Sep 2019 04:25:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4088660850; Mon, 23 Sep 2019 08:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569227111;
        bh=WOFRHwq7H+xLOuFoB5NSwTtl8vKLqopZli8GexNDdAg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jefdjzggo1SuHyUOqv5y/m6CCjHi7L9q3YXcxvsEl3p3zAp/ib+Q5Y6uwHvoBmPdE
         sCqnlzlKavjH6mwyEvtT0J/Ne9BKDx4wIl7l3PZr15x40POFM5tbR445QkWH8+LMpA
         cKUQHN1C3FAZL/GnM3NASSzuic5SuAny6ja1fTQU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8D73C60850;
        Mon, 23 Sep 2019 08:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569227110;
        bh=WOFRHwq7H+xLOuFoB5NSwTtl8vKLqopZli8GexNDdAg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ZEUFMhZTZofECZ+NjFNcRCX33MNFX7u+h5sr5xTlGF7oCdrSlgjW7hssDpm0GNXbh
         WHhbH4Hw7IfDjt0r6012c3MR9Na8Y+ChLA6bOq7sIRhp81jySN2lFaE810OWN4vJ/7
         ndayYPXUE6zXfrCEiEF6iwKibTicvoWZDP6bum+s=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8D73C60850
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] ath: fix various spelling mistakes
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190702123904.8786-1-colin.king@canonical.com>
References: <20190702123904.8786-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Maya Erez <merez@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        wil6210@qti.qualcomm.com, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190923082511.4088660850@smtp.codeaurora.org>
Date:   Mon, 23 Sep 2019 08:25:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> There are a bunch of spelling mistakes in two ath drivers, fix
> these.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

80ce8ca7a647 ath: fix various spelling mistakes

-- 
https://patchwork.kernel.org/patch/11027799/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

