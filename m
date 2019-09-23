Return-Path: <SRS0=1g4v=XS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B92A9C3A5A6
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Sep 2019 07:28:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8710620820
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Sep 2019 07:28:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SqPUf0KH";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CM0fJGoC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393533AbfIWH2m (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Sep 2019 03:28:42 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49798 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393525AbfIWH2m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Sep 2019 03:28:42 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7214C6119D; Mon, 23 Sep 2019 07:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569223721;
        bh=p7bArJ23MTwi+07gdxra/vS5ObDsiMQ36sC5zCsrcZk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=SqPUf0KH52oFh3h9YlP5Am4jyEYo4aPvD8T2jFS/xokq4hDNvqB4B+Oi+l+3CqeT/
         d1CQBIGaqDwG4H7bxEmIcoUrBLRRPSxWV3gCxDJmlbeSU2cv4Vkd5tGPqcCm99rEr8
         f65WDEeIjskcKg79OAcfEsS9onVyn/p2UXZf5KFY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 02CF060A97;
        Mon, 23 Sep 2019 07:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569223721;
        bh=p7bArJ23MTwi+07gdxra/vS5ObDsiMQ36sC5zCsrcZk=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=CM0fJGoClbEMOsb4lASLgnMEavYoZfvx+IH6r2SeSsA81DmzxqjFhh3rwUVN9bORA
         vBoIxyGFOopKDTy2/x/ezhU9eLVBLP3kpDIeNpDK6O4sDXObIbj9HQPkr23ohFDAVT
         ilunzo8iD1ckVdMTqY3YSjXvFohZ65BL9yiVe92Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 02CF060A97
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Add peer param map for tlv and non-tlv
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1550556576-19803-1-git-send-email-pillair@codeaurora.org>
References: <1550556576-19803-1-git-send-email-pillair@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190923072841.7214C6119D@smtp.codeaurora.org>
Date:   Mon, 23 Sep 2019 07:28:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rakesh Pillai <pillair@codeaurora.org> wrote:

> The peer param id for PEER_PARAM_USE_FIXED_PWR
> is different for tlv and non-tlv firmware. This
> causes incorrect peer param to be set by the driver
> to the firmware(tlv/non-tlv).
> 
> Create seperate peer param map for tlv and non-tlv
> firmware and attach the peer param id based on the
> firmware type during the init.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1
> 
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

c0e33fe6fb0f ath10k: Add peer param map for tlv and non-tlv

-- 
https://patchwork.kernel.org/patch/10819255/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

