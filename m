Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCBB1C4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B05E2184A
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:29:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fhr+0yZc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="oz1NRYmc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbfB1I3e (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 03:29:34 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38278 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbfB1I3e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 03:29:34 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3763B60E5C; Thu, 28 Feb 2019 08:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551342573;
        bh=u3Bpu7zTFE5/HPBkm+B3fFKG4yyZbDXswKYFM+/sHrE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=fhr+0yZcJiIWL8T/sh5MHCPkBRfo6SmxUYtqfOmxqTAdqLUvEPbUW4CqqWzoEXiL6
         7mIasrfq0c3XpKGCSzUX5A8K4GwIyGMULO1HIlPOL3M9+mHv4+IDOuJalq7SXDfd3/
         O0RXnX4zrJJ702ayOzDGI67lz9Zb/0PA/7MWmKT8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0E0DF60909;
        Thu, 28 Feb 2019 08:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551342572;
        bh=u3Bpu7zTFE5/HPBkm+B3fFKG4yyZbDXswKYFM+/sHrE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=oz1NRYmcqOGnlj3lYzYhVtMxbXU/FDYBUsyguojIo33PoTyuJepJE9RRBRtoqslkP
         4w8bzadCf2c2Qfe3r8waC/PM6NKAD2/M6dvA8NHFvn6EMTmqu5DAEtM2SKt8w4he1H
         okMIHT9Lh2gypfvc7ACyD3lJkCWmodlux0b+DWCw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0E0DF60909
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] rsi: fix missing null pointer check from a failed
 ieee80211_probereq_get call
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190221123549.7294-1-colin.king@canonical.com>
References: <20190221123549.7294-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190228082933.3763B60E5C@smtp.codeaurora.org>
Date:   Thu, 28 Feb 2019 08:29:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The call to ieee80211_probereq_get can return NULL if a skb allocation
> fails, so add a null pointer check and free an earlier skb on the error
> exit return path.
> 
> Fixes: 7fdcb8e12660 ("rsi: add support for hardware scan offload")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

74ee436f9581 rsi: fix missing null pointer check from a failed ieee80211_probereq_get call

-- 
https://patchwork.kernel.org/patch/10824023/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

