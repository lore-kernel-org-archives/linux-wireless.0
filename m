Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF3CC67839
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 13:39:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C623C20879
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 13:38:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lQ0XwG43";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="j5qIphoX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C623C20879
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbeLMNi7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 08:38:59 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58454 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729366AbeLMNi6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 08:38:58 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2C01360128; Thu, 13 Dec 2018 13:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544708338;
        bh=YT6iGle3nNNw8r2vF5Q3ETnIwfjLiy2HLEmiclTpPZE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=lQ0XwG43iNrWVZkc0U9oG4qT5PSlL/+55UaASgnNf0a+sayHmSIHAmMff+mT1PjpD
         BdCGBqbXR/yhPTA4VdrOUNy8coFIypcMw8YSTgmzNYswgM768LGGi5HDVtaviBzdGz
         Yj65KyBh9R2TMySG3m8lv9vmvAFqAVsmyHBwXzfM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1AAA960128;
        Thu, 13 Dec 2018 13:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544708337;
        bh=YT6iGle3nNNw8r2vF5Q3ETnIwfjLiy2HLEmiclTpPZE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=j5qIphoX8WhyMDSdF+SXEj/eU/tQi9IrOMyReytdrOIUwUiy27qcT91Ypvdc3HxJX
         bxy8TdUDorg696DZyKT17D25NciFOMBgVkGjNxxe+fVh8cV2U+GvJsV2G+ZcdE6R0X
         82pE//1tBKR1uDHWeYTQrgZwOLbB0FxVAIjKIFWU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1AAA960128
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 4.20] rtlwifi: Fix leak of skb when processing C2H_BT_INFO
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181118025503.20639-1-Larry.Finger@lwfinger.net>
References: <20181118025503.20639-1-Larry.Finger@lwfinger.net>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        =?utf-8?q?Francisco_Machado_Magalh=C3=A3es_Neto?= 
        <franmagneto@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>,
        Stable <stable@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181213133858.2C01360128@smtp.codeaurora.org>
Date:   Thu, 13 Dec 2018 13:38:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> With commit 0a9f8f0a1ba9 ("rtlwifi: fix btmpinfo timeout while processing
> C2H_BT_INFO"), calling rtl_c2hcmd_enqueue() with rtl_c2h_fast_cmd() true,
> the routine returns without freeing that skb, thereby leaking it.
> 
> This issue has been discussed at https://github.com/lwfinger/rtlwifi_new/issues/401
> and the fix tested there.
> 
> Fixes: 0a9f8f0a1ba9 ("rtlwifi: fix btmpinfo timeout while processing C2H_BT_INFO")
> Reported-and-tested-by: Francisco Machado Magalhães Neto <franmagneto@gmail.com>
> Cc: Francisco Machado Magalhães Neto <franmagneto@gmail.com>
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Stable <stable@vger.kernel.org> # 4.18+
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers.git, thanks.

8cfa272b0d32 rtlwifi: Fix leak of skb when processing C2H_BT_INFO

-- 
https://patchwork.kernel.org/patch/10687671/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

