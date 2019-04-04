Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3648FC4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:25:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0216E20882
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:25:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jgpsI2nD";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LkjJ7Gze"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbfDDKZr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 06:25:47 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45244 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfDDKZq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 06:25:46 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B98E361A5E; Thu,  4 Apr 2019 10:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554373545;
        bh=JZOuMXuluvl5jBISMkvoHGTP1JUDW/kmhQjYJYpAY40=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jgpsI2nDE1A1FzBEzu9tc5A/hNINoFlgoIMyI4xTjoTkc0aZgznHZcWQadNijsd95
         IGOush4r7a+GODNbAPB/+Y1GuZDjy1Qg/OEbwSoUQfVoyUkOTb49Q29iz4J/aqnuIS
         20pmR6C9H99YTVs2B38S1yuX5d9Gl5t1VlC+0+Zo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2B3AD619B2;
        Thu,  4 Apr 2019 10:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554373544;
        bh=JZOuMXuluvl5jBISMkvoHGTP1JUDW/kmhQjYJYpAY40=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=LkjJ7GzepbGxQX2sop/y8BA7Q96bA/wnrsmDyERjSMEK6iG50zeNg0OJfO6xQ0us6
         qORY+mUfXY2lk+wSELDBUMU2Grprm4c1egx5zNVrubvQ3VFQHJoofLx0DR+5zcdTCl
         ncN3NqRKDzUTxK3hoLdrT6c+pvKFZc8IulUyCoT8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2B3AD619B2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: fix potential NULL pointer dereference
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190312090648.30750-1-pkshih@realtek.com>
References: <20190312090648.30750-1-pkshih@realtek.com>
To:     <pkshih@realtek.com>
Cc:     <linux-wireless@vger.kernel.org>, <Larry.Finger@lwfinger.net>,
        <kjlu@umn.edu>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190404102545.B98E361A5E@smtp.codeaurora.org>
Date:   Thu,  4 Apr 2019 10:25:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<pkshih@realtek.com> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> In case dev_alloc_skb fails, the fix safely returns to avoid
> potential NULL pointer dereference.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

60209d482b97 rtlwifi: fix potential NULL pointer dereference

-- 
https://patchwork.kernel.org/patch/10848803/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

