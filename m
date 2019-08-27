Return-Path: <SRS0=iaJH=WX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A9FC3A5A3
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Aug 2019 10:51:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B368217F5
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Aug 2019 10:51:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gVxpTkSp";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="T1TEoDfV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbfH0Kvm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 27 Aug 2019 06:51:42 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34960 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfH0Kvm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Aug 2019 06:51:42 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 27C5C60C5F; Tue, 27 Aug 2019 10:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1566903101;
        bh=dXh5psJH6KJJwOule8YyV+lVoNFEfbqfaGzAIfFICjk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gVxpTkSpLlaBiMFIfcR7epwWKbcMZ678oYJ2rlddCMUmTf/G/Cj1iP/CavPa1u9GH
         Mu9/L32YQvUzj88J3ekb+D4kkUkC4j7Xd1FNgtmGPBOcqbmefHtGJB8dqvDozCooeq
         iDbToqppgB/uXxOagBGbnNZAlSKt3B4ut2G8GdCo=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id DE32F60271;
        Tue, 27 Aug 2019 10:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1566903100;
        bh=dXh5psJH6KJJwOule8YyV+lVoNFEfbqfaGzAIfFICjk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T1TEoDfVyZADU302XoSqoVVv+q1iRcGcfduhF6tujJ5Da1UZtQwc4MTCCBvlHFoKJ
         JF8X6pRW2R/6cVl4EBRjlx93Czshdn/mYpHCCvclibn7FIvA1NT3HQAKwXXklx/l9e
         31og8cOBU8FLcvXBAn4qIO+Ocnk0Oaik5mSNyTAo=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 27 Aug 2019 16:21:40 +0530
From:   Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
To:     Nicolas Cavallari <Nicolas.Cavallari@green-communications.fr>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH 31/49] ath11k: add mac.c
In-Reply-To: <c37a9fc4-aa74-a333-a67c-cce66ad78ec0@green-communications.fr>
References: <1566316095-27507-1-git-send-email-kvalo@codeaurora.org>
 <1566316095-27507-32-git-send-email-kvalo@codeaurora.org>
 <c37a9fc4-aa74-a333-a67c-cce66ad78ec0@green-communications.fr>
Message-ID: <1da054e86da63423a5e58c22c2c79d79@codeaurora.org>
X-Sender: vthiagar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-08-23 20:32, Nicolas Cavallari wrote:
> On 20/08/2019 17:47, Kalle Valo wrote:
>> +	ar->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
>> +					 BIT(NL80211_IFTYPE_AP) |
>> +					 BIT(NL80211_IFTYPE_MESH_POINT);
> 
> [...]
> 
>> +	ar->hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
> 
> so IBSS-RSN is supported without IBSS support ?

Sure. IBSS-RSN is not relevant when IBSS is not supported, I guess.
We'll take care of this. Thanks.

Vasanth
