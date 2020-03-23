Return-Path: <SRS0=u4Rx=5I=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 436D9C3F2CD
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Mar 2020 17:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C38F20714
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Mar 2020 17:35:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="MGkhoGQK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgCWRfO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Mar 2020 13:35:14 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:60490 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726984AbgCWRfO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Mar 2020 13:35:14 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1584984913; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=cmqVjReZrg/0rOUQjghrITou1WyAcRf1WVuEB5WzkCw=;
 b=MGkhoGQK9okpRpGCzcZ7qmN4aPvcD6w1yP2yqd/26Of9to6cEB4JnYcCpFBPjF7QdWqSOo1o
 OYt95agCDLLEoX9WlKzUJ4vXkx9w/R9HsilxOONuKRDQOhJIcJf64E2DKwtZcR0qpW0fFNZ8
 ylpX4HCzWySSjTY0l480y+VcplU=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e78f350.7fcbcc622f10-smtp-out-n04;
 Mon, 23 Mar 2020 17:35:12 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9AFC4C43637; Mon, 23 Mar 2020 17:35:11 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6F015C433CB;
        Mon, 23 Mar 2020 17:35:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6F015C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/3] mt76: mt7615: fix mt7663e firmware struct endianness
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <d14dfd7cd91a4dda8c5dcd03e8a70ff11314182e.1584534454.git.lorenzo@kernel.org>
References: <d14dfd7cd91a4dda8c5dcd03e8a70ff11314182e.1584534454.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name,
        lorenzo.bianconi@redhat.com, sean.wang@mediatek.com,
        ryder.lee@mediatek.com, linux-mediatek@lists.infradead.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200323173511.9AFC4C43637@smtp.codeaurora.org>
Date:   Mon, 23 Mar 2020 17:35:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Convert fields in mt7663_fw_trailer and mt7663_fw_buf to little-endian
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Fixes: f40ac0f3d3c0 ("mt76: mt7615: introduce mt7663e support")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

3 patches applied to wireless-drivers-next.git, thanks.

54178cc134fd mt76: mt7615: fix mt7663e firmware struct endianness
d14f0a5c62d3 mt76: mt7615: fix endianness in unified command
b899150e60ce mt76: mt7615: add missing declaration in mt7615.h

-- 
https://patchwork.kernel.org/patch/11445177/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
