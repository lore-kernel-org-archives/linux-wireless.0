Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF19C10F14
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 18:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21F8520818
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 18:29:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OBq5j2JG";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IX8R9LoF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfDLS3u (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 14:29:50 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38068 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbfDLS3u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 14:29:50 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 49D53616D3; Fri, 12 Apr 2019 18:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555093789;
        bh=RwdLuHjmEEspowqNjIynNBb0L47ydZK01bH+GZPnqyw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=OBq5j2JGEXQ6Xp1Gv3rTlOYeqXkAJipvpGCYxWmIFWYx1aivdyijIX+ybNxjlloL2
         4eD+5JLId81O4hqc4xV4C94kvCsYlKB2GRmenZZQs44aZMDR1OHfcQ4qXFS/w3FS9r
         k1sMjU3iAeqQBklLO7OynsfXrfMfBt9XpOyQz0Zo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2927D616BA;
        Fri, 12 Apr 2019 18:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555093788;
        bh=RwdLuHjmEEspowqNjIynNBb0L47ydZK01bH+GZPnqyw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=IX8R9LoFacBbV+6KIafxM6U5CSa/3qDgM8etcdBkKh3ZOxCCxaWaJkhTczOvYr1fL
         cM9Cb5zwuuG4kTGeb27Yy3uk9l38P1kQ90wVclgh7L4U5G6L/WvxIO9UludmTnEtyX
         mXGzmZYoSFWptYqlJdezWPbNXNsGQOr0td01TRiQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2927D616BA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 5.1 1/3] mt76: mt7603: add missing initialization for
 dev->ps_lock
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190326083421.57998-1-nbd@nbd.name>
References: <20190326083421.57998-1-nbd@nbd.name>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190412182949.49D53616D3@smtp.codeaurora.org>
Date:   Fri, 12 Apr 2019 18:29:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> wrote:

> Fixes lockdep complaint and a potential race condition
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

3 patches applied to wireless-drivers.git, thanks.

2170e2157d7c mt76: mt7603: add missing initialization for dev->ps_lock
aa3cb24be18b mt76: mt7603: fix sequence number assignment
9dc27bcbe78c mt76: mt7603: send BAR after powersave wakeup

-- 
https://patchwork.kernel.org/patch/10870631/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

