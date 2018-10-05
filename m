Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C670C65BA7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 000CF20875
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:37:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="T1xDfQE3";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MP2sBXHN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 000CF20875
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbeJEPf3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:35:29 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49422 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727617AbeJEPf3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 11:35:29 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 466806079C; Fri,  5 Oct 2018 08:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538728667;
        bh=6AKMlmxU/9Nf58QZlQmS7Yf2P9jtmMrltNBfUO8dnP4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=T1xDfQE39L3KVwOxOgQLXImT33aGSNelocoBhi3z91evHqyhGN45QyzFVl/RE1pRu
         DhTW9YmGt7YW1323cJy72htD0RilPhJB2ezHJ4QatGiMpoNeTNzUuACQ54scTlmPxE
         Jwvxf9LaeXskzb6AhNk0PHDHCortEAS+jskRec+w=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 78C246024C;
        Fri,  5 Oct 2018 08:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538728666;
        bh=6AKMlmxU/9Nf58QZlQmS7Yf2P9jtmMrltNBfUO8dnP4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=MP2sBXHNowm11Wq6tfAM4jhWOFdnS2uXMUkNKlSpOXbpfaiN/QvlFnpCeA2akC0uS
         g3mzm1ztR9SsAAHatHm4Div3HkgpgdEwH8FEiL2JdIWp3OThOqCw6hPaggtwViqVm7
         yndCXdRiL5sd0rosCd46gXOWG6ybQBpnVhwRAt9c=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 78C246024C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ssb: chipcommon: fix fall-through annotation
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181003120102.GA22824@embeddedor.com>
References: <20181003120102.GA22824@embeddedor.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Michael Buesch <m@bues.ch>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181005083747.466806079C@smtp.codeaurora.org>
Date:   Fri,  5 Oct 2018 08:37:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> Replace "Fallthough" with a proper "fall through" annotation.
> 
> This fix is part of the ongoing efforts to enabling
> -Wimplicit-fallthrough
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Acked-by: Michael Buesch <m@bues.ch>

Patch applied to wireless-drivers-next.git, thanks.

74aa3586c599 ssb: chipcommon: fix fall-through annotation

-- 
https://patchwork.kernel.org/patch/10624745/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

