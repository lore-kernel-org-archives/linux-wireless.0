Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39C4C4360F
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B38B20700
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:15:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ICh6tDeZ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XimmRR4i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbfBSPPh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:15:37 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42282 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbfBSPPh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:15:37 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 87CD260388; Tue, 19 Feb 2019 15:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589336;
        bh=rTqo6ijt4aNvhEJtPuwadJay20C8UFfUyc7zPBlqTHs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ICh6tDeZsIJjTM+L7osaEbAnDCE00pC44JqPBplV/5N7OaVwCkcdK+2cdkDWiossN
         9uoZARM00yohPE4Qf6eEV1oMoY7IfRFkVK8+tatY090T3Y1piyoUDj9mABjfptCPSK
         WGYUdaMyAixellFWQU/8WIb2BWoVf8ZckbFbToO0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 78F1E60388;
        Tue, 19 Feb 2019 15:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589336;
        bh=rTqo6ijt4aNvhEJtPuwadJay20C8UFfUyc7zPBlqTHs=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=XimmRR4iAeX02r1AyG7cCRFlGqvC28vIO1jBgZWC7Sc5kdgN7KVLJcSqJEevCFdxQ
         OUYw0y51QU9fZgbAGG5mbN4r+9Iciu/G83vlsg+imG+ULVg2nxntMXd4tFHnu8Gboj
         PjqkI1jbwjCRyt78mc4JDSvd55R70esT4QMGAgP0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 78F1E60388
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net] mwifiex: Fix NL80211_TX_POWER_LIMITED
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190213135938.13664-1-bunk@kernel.org>
References: <20190213135938.13664-1-bunk@kernel.org>
To:     Adrian Bunk <bunk@kernel.org>
Cc:     netdev@vger.kernel.org, Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190219151536.87CD260388@smtp.codeaurora.org>
Date:   Tue, 19 Feb 2019 15:15:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Adrian Bunk <bunk@kernel.org> wrote:

> NL80211_TX_POWER_LIMITED was treated as NL80211_TX_POWER_AUTOMATIC,
> which is the opposite of what should happen and can cause nasty
> regulatory problems.
> 
> if/else converted to a switch without default to make gcc warn
> on unhandled enum values.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Patch applied to wireless-drivers-next.git, thanks.

65a576e27309 mwifiex: Fix NL80211_TX_POWER_LIMITED

-- 
https://patchwork.kernel.org/patch/10810011/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

