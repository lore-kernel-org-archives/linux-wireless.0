Return-Path: <SRS0=E8CW=XQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29107C49ED7
	for <linux-wireless@archiver.kernel.org>; Sat, 21 Sep 2019 05:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E888820882
	for <linux-wireless@archiver.kernel.org>; Sat, 21 Sep 2019 05:47:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GZMOrYaH";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IFP3cvyR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730856AbfIUFr4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 21 Sep 2019 01:47:56 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36200 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbfIUFr4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 21 Sep 2019 01:47:56 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 52E79613A3; Sat, 21 Sep 2019 05:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569044875;
        bh=6ZOGcgzAUDX/GUhpeJSKTRPO0mncjwpofjNKFMU268s=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=GZMOrYaH+CL3lpUDy+vvjb7dL4SdemzEnJVE/5f9zF+s/BtPiKKknk00SRMkTF4CK
         BV8OJzj9dZ8VSEAaO4pVLefUysgyZXVtjhvWMjRzXNiTCR0Y0a+lNo9K4Qw4R2R4MG
         KfaosAKn8Ix04wkkMtbr5yNOlI6FQ+fTdua6vL1I=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C815960364;
        Sat, 21 Sep 2019 05:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569044874;
        bh=6ZOGcgzAUDX/GUhpeJSKTRPO0mncjwpofjNKFMU268s=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=IFP3cvyRi9gchtHj2NSJqqvpEiw5Bx46U/YNhy2FgjQXnPIwCtDVlwdqUGAa1a/zv
         pyvFbY06nImQX9bt9SDa5nN4YXxvFW3pGew35xVYxPGd2YzCmzEmxpHsdDipNFW9VF
         KBbQf94R49d3XBW9ZVpZDSVdoovWPrr0grEt4pHs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C815960364
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 04/15] rtw88: pci: extract skbs free routine for trx rings
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1568617425-28062-5-git-send-email-yhchuang@realtek.com>
References: <1568617425-28062-5-git-send-email-yhchuang@realtek.com>
To:     <yhchuang@realtek.com>
Cc:     <linux-wireless@vger.kernel.org>, <briannorris@chromium.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190921054755.52E79613A3@smtp.codeaurora.org>
Date:   Sat, 21 Sep 2019 05:47:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<yhchuang@realtek.com> wrote:

> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> These skbs free routines could be used when driver wants
> to stop PCI bus, because some of the skbs remained in the
> queue may not have been returned via DMA interrupt.
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>

2 patches applied to wireless-drivers.git, thanks.

dc579ca5cfea rtw88: pci: extract skbs free routine for trx rings
0e41edcdfe86 rtw88: pci: release tx skbs DMAed when stop

-- 
https://patchwork.kernel.org/patch/11146415/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

