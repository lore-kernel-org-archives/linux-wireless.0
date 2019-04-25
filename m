Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 574C3C43219
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDE7C206BF
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:45:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HdluXp/B";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="abxeBrUX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfDYQpC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:45:02 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56052 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfDYQpC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:45:02 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7DE3860791; Thu, 25 Apr 2019 16:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556210701;
        bh=uDyDqxgk/sY2QWM2aXcDJhJZ8MERQ++rzXOGKmt2TOY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=HdluXp/B4n8akFKMW7Gy/6BJlxr4gu2/5HmI7QimBejDxzdqjhEM4PrVhE7uAAnO1
         24/hg6SLFkVVqRqiVp2bp9Ua7AEOs74e33FahBojyJYaj4TKpdngynCDfWo0jTAv4H
         8dI5/T2BXtVzBHESdqWZ/eegFaymmu7vbBpipapA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ABD93601B4;
        Thu, 25 Apr 2019 16:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556210701;
        bh=uDyDqxgk/sY2QWM2aXcDJhJZ8MERQ++rzXOGKmt2TOY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=abxeBrUX5SE51lUef0kyf+d0UNnBnXvn1cipT3r8qC1zOY+tNIlZLgUk2tw7vIHeg
         M3hepD/zXR2s+/ixuucYOlM/PPeMvZD5/yW33/mkYQynP1fmJswXPEqafDzCavuqro
         n01kgXlbFNispe6xmxhJ5c7WSsrQOuRdZuh7IXfw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org ABD93601B4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/8] rsi: add new device model for 9116
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190403041309.12829-2-siva8118@gmail.com>
References: <20190403041309.12829-2-siva8118@gmail.com>
To:     Siva Rebbagondla <siva8118@gmail.com>
Cc:     linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        krishna.pedda@redpinesignals.com,
        Ganapathiraju Kondraju <ganapathi.kondraju@redpinesignals.com>,
        Siva Rebbagondla <siva8118@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425164501.7DE3860791@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:45:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Siva Rebbagondla <siva8118@gmail.com> wrote:

> 9116 device id entry is added in both SDIO and USB interfaces.
> New enumberation value taken for the device model. Based on the
> device model detected run time, few device specific operations
> needs to be performed.
> 
> adding rsi_dev_model to get device type in run time, as we can use
> same driver for 9113 and 9116 except few firmware load changes.
> 
> Signed-off-by: Siva Rebbagondla <siva8118@gmail.com>

8 patches applied to wireless-drivers-next.git, thanks.

54fdb318c111 rsi: add new device model for 9116
3ac61578fbd4 rsi: move common part of firmware load to separate function
e5a1ecc97e5f rsi: add firmware loading for 9116 device
9ba4562ac195 rsi: change in device init frame sequence for 9116
f911c86166d5 rsi: new bootup parameters for 9116
1533f976c668 rsi: send new tx command frame wlan9116 features
17ff2c794f39 rsi: reset device changes for 9116
0a60014b76f5 rsi: miscallaneous changes for 9116 and common

-- 
https://patchwork.kernel.org/patch/10882717/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

