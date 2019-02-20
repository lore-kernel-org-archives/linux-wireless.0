Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8235AC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 17:55:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 563042146E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 17:55:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JnNfYR67";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="T4H/objO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfBTRzk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 12:55:40 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38572 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfBTRzk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 12:55:40 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 769096034E; Wed, 20 Feb 2019 17:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550685339;
        bh=0Kpgowbg/6NQ7DjdKpgjQ7Rke8mADH7FoLoNdNOLbDQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=JnNfYR67/LDsHxAsp43y2V0bmWd/tWe6QnzSTGWelAo7TskG8zzhStYjdMlFDmq2P
         GRh9w27dBQEsGXnAm/PwZkvZPfD5jnsiAsFj8yheTr22VvtIcu3W/8kIyEwE1Ox/mK
         FmyowuZyvjMhgLHdvhQZYtca892NKSpf9yBOb/VU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 74C9B6034E;
        Wed, 20 Feb 2019 17:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550685338;
        bh=0Kpgowbg/6NQ7DjdKpgjQ7Rke8mADH7FoLoNdNOLbDQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=T4H/objOm/x9o030ee8tv5PwDXt9X3DEWl0q+BALgzEXAK32rrxjVfWIexDOr4/b2
         S4NcszAtscaY6HVxBSX5d0ZgbcKBXGOyifLXGTVqtwKo9LH1TIiA5ZtTZdwsrNGrWt
         p4FVtfJEpCAy5q0TtLlrM+n/GLAVN4UtoWZPpyRk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 74C9B6034E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH wireless-drivers-next] brcmfmac: add basic validation of
 shared RAM address
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190220103047.8960-1-zajec5@gmail.com>
References: <20190220103047.8960-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190220175539.769096034E@smtp.codeaurora.org>
Date:   Wed, 20 Feb 2019 17:55:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> While experimenting with firmware loading I ended up in a state of
> firmware reporting shared RAM address 0x04000001. It was causing:
> [   94.448015] Unable to handle kernel paging request at virtual address cd680001
> due to reading out of the mapped memory.
> 
> This patch adds some basic validation to avoid kernel crashes due to the
> unexpected firmware behavior.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

e0a8ef4d7b43 brcmfmac: add basic validation of shared RAM address

-- 
https://patchwork.kernel.org/patch/10821803/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

