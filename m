Return-Path: <SRS0=PzJh=Y6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0351C5DF63
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Nov 2019 17:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BB21217D7
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Nov 2019 17:55:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="H7QV05bg";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="S24sM0Ab"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbfKFRzz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Nov 2019 12:55:55 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35294 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfKFRzz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Nov 2019 12:55:55 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0F79A60913; Wed,  6 Nov 2019 17:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573062954;
        bh=7Ve4JPk7jSnlevxFcGuL3VLvkJOYG00XEtK/6lbscmw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=H7QV05bgCgD/RYOB0qqYCDLrD1lKdVu2QsTskJpJvNdOsjTzLwR5+P0VXrCPvMxNu
         bgIjiE3y1yH0m9P7BEu/f9nbliVBBL0Pwzy6LKqasBmDvsOZWZ0Phj7goZjM7/kEg/
         zpwAsrFdTvOFsJAsxPudRfnMCT2V11Jxfq+k5jQs=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A7A8860134;
        Wed,  6 Nov 2019 17:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573062953;
        bh=7Ve4JPk7jSnlevxFcGuL3VLvkJOYG00XEtK/6lbscmw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=S24sM0Abo7IosRYQi2VvJGMuDNQCB8iijIPeIcEeTVK9siYt6vHdIyUJgblWyMqOo
         VjyvIEq5uoPOLjhaWDI10+k0KkkBDhu2Mdo2lVhwFDrGdlLP5dHWBVQDH0t7CUBDh8
         5PHHtsDj/sgW4yfYJn80SY4XcNf8t3jGfp2Cqhjw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A7A8860134
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rtw88: raise LPS threshold to 50,
 for less power consumption
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191101051942.18730-1-yhchuang@realtek.com>
References: <20191101051942.18730-1-yhchuang@realtek.com>
To:     <yhchuang@realtek.com>
Cc:     <linux-wireless@vger.kernel.org>, <briannorris@chromium.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191106175554.0F79A60913@smtp.codeaurora.org>
Date:   Wed,  6 Nov 2019 17:55:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<yhchuang@realtek.com> wrote:

> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> The LPS threshold was set to 2, means driver will leave LPS
> mode if there is more than 2 frames TX/RX for every 2 seconds.
> This makes driver enter/leave LPS frequently even if we just
> "ping -i1" to the others.
> 
> Apparently we do not want to leave LPS mode if there is only
> some background traffics or web surfing. By experiment, set
> this to 50 is a more reasonable value to lower the over all
> power consumption.
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

bf9840ccf8ef rtw88: raise LPS threshold to 50, for less power consumption

-- 
https://patchwork.kernel.org/patch/11222327/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

