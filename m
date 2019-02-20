Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1287C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 17:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C97542146E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 17:56:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZVeGTgxO";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Yob/ucAd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfBTR4O (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 12:56:14 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39210 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfBTR4O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 12:56:14 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9A9DA608EA; Wed, 20 Feb 2019 17:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550685373;
        bh=0sfAFYjsSFkeU6xztT1zm3/wzpyJGB16bR71qi1kC4c=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ZVeGTgxOfzNkOcbEp03hZSThxMb8zNZNZw9Ybuu3U0LALsTSqysAXIFM8aHdv+4rF
         TGI0p2iDBs2zJ25m1ESvmZGIspGcdkRueEV1tmiROHZ82/gK2GWo0OIOFNDwygoWQ7
         58KEAjB6gGnOXXZWxzyEXOg8ItNu3gaOkvEeNZm0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 94777605FC;
        Wed, 20 Feb 2019 17:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550685372;
        bh=0sfAFYjsSFkeU6xztT1zm3/wzpyJGB16bR71qi1kC4c=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Yob/ucAdDAqPCzjmPov+Gmqn2dB1KeZto1h/0zsWBto5d79oz/Nh76x2/Cp1eHcBJ
         DUYsfBpxdEl9FlV6wrNL7T+1VK8vRT+rCsXFXfwZlmMc6Zx5wqNeY6LJywVMdIPNDp
         LRP5KI5l7KQYmW/1XtaZvw1NagXFfJtQP68BkAak=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 94777605FC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/3] libertas_tf: move hardware callbacks to a separate
 structure
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190220105840.793525-2-lkundrak@v3.sk>
References: <20190220105840.793525-2-lkundrak@v3.sk>
To:     Lubomir Rintel <lkundrak@v3.sk>
Cc:     Steve deRosier <derosier@cal-sierra.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190220175613.9A9DA608EA@smtp.codeaurora.org>
Date:   Wed, 20 Feb 2019 17:56:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lubomir Rintel <lkundrak@v3.sk> wrote:

> We'll need to talk to the firmware to get a hardware address before
> device is registered with ieee80211 subsystem at the end of
> lbtf_add_card(). Hooking the callbacks after that is too late.
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>

3 patches applied to wireless-drivers-next.git, thanks.

be9d0d3fe139 libertas_tf: move hardware callbacks to a separate structure
baa0280f08c7 libertas_tf: don't defer firmware loading until start()
5d04b22b881d libertas_tf: get the MAC address before registering the device

-- 
https://patchwork.kernel.org/patch/10821819/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

