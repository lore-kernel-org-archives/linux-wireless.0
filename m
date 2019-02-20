Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA10C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 08:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAE0B20880
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 08:32:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="U6vRUHxQ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LUd6bhQU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbfBTIcn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 03:32:43 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50188 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbfBTIcm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 03:32:42 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EE79C605FC; Wed, 20 Feb 2019 08:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550651562;
        bh=LXJOJRSUBIqPZpiVWZrscMvCkhhNCi44XCK6XCErXv8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=U6vRUHxQJp9+YFq+SDKe1vJ4R7f8Yn7u0FUuzJ+74/fqVM0mQgWFOljQSSTyy4EnT
         qbk5eh517kuuhbjsXLPjLRHf80vg7w7k0POiESe351AI4de52dqUhQ0iGdPvLf8gzQ
         yVeeVRmG19wAaxMRP22CQfnx65ruIkPf3q4DKun0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1854560388;
        Wed, 20 Feb 2019 08:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550651560;
        bh=LXJOJRSUBIqPZpiVWZrscMvCkhhNCi44XCK6XCErXv8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=LUd6bhQUxHayEvEFQitudYoV5AFWsXg79mu5DakueEThI37LGLAN1BN6pgtwpH+6r
         D7FYXJ9JWCGBqm2J9dKLemVj43kovk8jnktRm7WBSu+jaqnJnfRBqBKgM/vCcIO3SP
         /rKGTtGCzDKfxjL9LdEgAiRPFeYxl1yKI7BY7+5k=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1854560388
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: change 'unsigned long int' to 'unsigned long'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1550578303-15962-1-git-send-email-kvalo@codeaurora.org>
References: <1550578303-15962-1-git-send-email-kvalo@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190220083241.EE79C605FC@smtp.codeaurora.org>
Date:   Wed, 20 Feb 2019 08:32:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> wrote:

> Fixes checkpatch warnings:
> 
> Prefer 'unsigned long' over 'unsigned long int' as the int is unnecessary
> 
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

28bbe2374041 ath10k: change 'unsigned long int' to 'unsigned long'

-- 
https://patchwork.kernel.org/patch/10819777/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

