Return-Path: <SRS0=l3ON=XT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA0A5C4320D
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Sep 2019 05:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF55D2064A
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Sep 2019 05:23:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MDhvw+PC";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MDhvw+PC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392992AbfIXFXo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 24 Sep 2019 01:23:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34962 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfIXFXo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Sep 2019 01:23:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AC5E860265; Tue, 24 Sep 2019 05:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569302623;
        bh=SMrbgQBKEorJxdAd9eChv1w86kdq6F4l9abjwfbWBWw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MDhvw+PCpJi46ZOXyJLwAGq2iCUNbShH2w2SvkbT4iyLQnNyaZhIaXRltcG7qIBCM
         b6xKVJ52weYICPmwUTcpwIQ7jiKudrxvPArPjyAm4kgAvanRDX5Lswrn1W6tGzHtvT
         n7OT94+JbrEyK3/xbsx4rLvhvikiA1OHh9AMWaRU=
Received: from x230.qca.qualcomm.com (37-136-106-186.rev.dnainternet.fi [37.136.106.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9BCAC6074F;
        Tue, 24 Sep 2019 05:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569302623;
        bh=SMrbgQBKEorJxdAd9eChv1w86kdq6F4l9abjwfbWBWw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MDhvw+PCpJi46ZOXyJLwAGq2iCUNbShH2w2SvkbT4iyLQnNyaZhIaXRltcG7qIBCM
         b6xKVJ52weYICPmwUTcpwIQ7jiKudrxvPArPjyAm4kgAvanRDX5Lswrn1W6tGzHtvT
         n7OT94+JbrEyK3/xbsx4rLvhvikiA1OHh9AMWaRU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9BCAC6074F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     nbd@nbd.name, lorenzo.bianconi@redhat.com,
        linux-wireless@vger.kernel.org, ryder.lee@mediatek.com
Subject: Re: [PATCH] mt76: mt7615: fix mt7615 firmware path definitions
References: <9e132c0949139155a4fb3375e4c83218159efce7.1569159209.git.lorenzo@kernel.org>
        <87wodzirv8.fsf@tynnyri.adurom.net>
        <20190923142916.GA3385@localhost.localdomain>
Date:   Tue, 24 Sep 2019 08:23:38 +0300
In-Reply-To: <20190923142916.GA3385@localhost.localdomain> (Lorenzo Bianconi's
        message of "Mon, 23 Sep 2019 16:29:16 +0200")
Message-ID: <87lfue5kth.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> writes:

>> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>> 
>> > mt7615 patch/n9/cr4 firmwares are available in mediatek folder in
>> > linux-firmware repository. Fix path definitions.
>> > Moreover remove useless firmware name pointers and use definitions
>> > directly
>> >
>> > Fixes: 04b8e65922f6 ("mt76: add mac80211 driver for MT7615 PCIe-based chipsets")
>> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>> 
>> This sounds pretty serious, I guess distros don't work out of box
>> because of this? So I would like to queue this to v5.4.
>
> I have always worked on mt7615 driver using OpenWrt. Yesterday I installed
> another distro (Ubuntu) and I figured out the fw paths were wrong. So yes,
> distros don't work out of box now.

Thanks, I'll add this to the commit log and queue for v5.4. Shouldn't I
also cc stable? The first release was v5.2-rc1.

In the future I would prefer to have this bug info in the commit log
right from the beginning, it helps a lot with patch priorisation and
reduces email :)

-- 
Kalle Valo
