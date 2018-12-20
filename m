Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5035C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 06:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91E4A20866
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 06:42:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="R6oksck5";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="H4m0pN3j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbeLTGmK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 01:42:10 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57758 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728436AbeLTGmK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 01:42:10 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E5AD9606FC; Thu, 20 Dec 2018 06:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545288129;
        bh=sOqtDBMHmiI4MoHmD8MVILJTe1lPkk0u5CBbSaoFyx8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=R6oksck5S/ttL+2s15wuETFqvh0jT9m6+4Oj/YG5aRJOpyzgtfuNhUA1S1cTNQNvU
         YToKK1OUsAfUY0hypZIobJevauVuV1cdp4/RWtfBNEmxc6TlHS1YjuNVTss/w1ThGA
         O9WHAGv15fD7Xazi41FEDUXvJ74SmXDWDW6we6O0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DC5BE606FC;
        Thu, 20 Dec 2018 06:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545288129;
        bh=sOqtDBMHmiI4MoHmD8MVILJTe1lPkk0u5CBbSaoFyx8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=H4m0pN3j3s2bSYNqStE0xAeSyoTLoFda1SNXYv1r1ny+1jmdbEvOUas8Ta3aMH9oQ
         NadZvb6Th+yvV0XYiwoH3MCkcR5uUePR6h5hgZqmJfkFG890MjP1yby2fNApRlbE8m
         AITymeCo9t+zA3W3l3vCZpzWGlee3zHjlyNHmOgQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DC5BE606FC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: Fix non-working BSS STA mode
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181212051335.22580-1-kai.heng.feng@canonical.com>
References: <20181212051335.22580-1-kai.heng.feng@canonical.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     pkshih@realtek.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220064209.E5AD9606FC@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 06:42:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kai-Heng Feng <kai.heng.feng@canonical.com> wrote:

> Once BSS STA mode gets started, it can be scanned by other clients but
> cannot entablish a connection.
> 
> Turns out the set_bcn_reg() and its *_set_beacon_related_registers()
> callbacks never get called so it has problem beaconing.
> 
> Enable the function in rtl_op_bss_info_changed() can make BSS STA mode
> start to work.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

The commit log is quite misleading. It implies that the client mode is broken
for all rtlwifi hardware and that can't be the case, otherwise we would be
flooded by bug reports. So please improve the commit log and describe clearly
the problem you are solving.

-- 
https://patchwork.kernel.org/patch/10725537/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

