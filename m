Return-Path: <SRS0=l3ON=XT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C650C432C1
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Sep 2019 07:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E824214D9
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Sep 2019 07:56:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lujCygFO";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dVcNQEcF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394761AbfIXH4f (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 24 Sep 2019 03:56:35 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48090 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388712AbfIXH4f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Sep 2019 03:56:35 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DEA7861AD7; Tue, 24 Sep 2019 07:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569311791;
        bh=muwisYgtwDH/JfvQvz8m5f+1Jt/JSBTbwB4GBv4v/No=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=lujCygFOVm4GWSQ4VFXgmm5n+nCwaYl6k0wqh24jpS/aV+p5PbyW+/aSkZmU/4a82
         +Pnj7xl79xjSnZbi3dZo2MQZ6gm9C5PUwOG9TxJnFe2KIS2vVdXxWgpge3s4oIh6US
         ApFVoS0/5HjqM7Gv6Z4hJVAQUewU5ayAAOiD+28c=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 58FB161790;
        Tue, 24 Sep 2019 07:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569311779;
        bh=muwisYgtwDH/JfvQvz8m5f+1Jt/JSBTbwB4GBv4v/No=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=dVcNQEcFq+t3gPFnkvvEeCVmT29Bl279RgJm6K1b+SmIkX4DYUP4fNuq+81rwKp9L
         vjKWiBm178d74nDAYW/q8mhvTMTMVEEkfCmgv/qq5e+lXk5BsV31r1BOLH2QYXH1Fz
         1xPX35pKAOgoKUn439thKrQ/n4eGSibhh/o63VKc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 58FB161790
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 5.4 v2] rtw88: configure firmware after HCI started
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190923024703.2995-1-yhchuang@realtek.com>
References: <20190923024703.2995-1-yhchuang@realtek.com>
To:     <yhchuang@realtek.com>
Cc:     <linux-wireless@vger.kernel.org>, <briannorris@chromium.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190924075630.DEA7861AD7@smtp.codeaurora.org>
Date:   Tue, 24 Sep 2019 07:56:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<yhchuang@realtek.com> wrote:

> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> After firmware has been downloaded, driver should send
> some information to it through H2C commands. Those H2C
> commands are transmitted through TX path.
> 
> But before HCI has been started, the TX path is not
> working completely. Such as PCI interfaces, the interrupts
> are not enabled, hence TX interrupts will not be issued
> after H2C skb has been DMAed to the device. And the H2C
> skbs will not be released until the device is powered off.
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>

Patch applied to wireless-drivers.git, thanks.

0b8dc6abbdb9 rtw88: configure firmware after HCI started

-- 
https://patchwork.kernel.org/patch/11155999/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

