Return-Path: <SRS0=FCSK=W6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED866C3A5A2
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:37:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1B722339D
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:37:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DYW+yX7P";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="imLzYa4t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbfICNhF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Sep 2019 09:37:05 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49944 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728490AbfICNhE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Sep 2019 09:37:04 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 408506083E; Tue,  3 Sep 2019 13:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567517824;
        bh=U4xR+zZDds/fIoyunWBCZz+eHjHm8WCfgJuM+QhuYkY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=DYW+yX7PdADYgteqEFsA+dI2oAMkxwd4MLWgBPE6+V6q72sbWc9eczZb2BxiXxQ6Q
         Gtp1dVgCRsJDQByhDseXtPNPz8I1YtJoyBWpaEQSReSVMk7Se17raupyZTV77xwEoy
         GriZh236QMDErPA04CD5/lkF/+PzCCo/jMqIZTak=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AC7A1602CA;
        Tue,  3 Sep 2019 13:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567517822;
        bh=U4xR+zZDds/fIoyunWBCZz+eHjHm8WCfgJuM+QhuYkY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=imLzYa4t06xhmA7i9AdVxsOToOfjwdgG+FshZAIsEyi7gl3x1UJuEwk/0XaBwVzvE
         EpyKezzVJsVUDTIuR9ilfO3w1vGhMgS075YVrAfRwWkJhonBXVWPIV3qvPN/Zf5Ocy
         29ZqK4HOxBVFLER7nIonjApmNt+DXPkh1JDAxSyI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AC7A1602CA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH rebased 1/2] rtw88: pci: Move a mass of jobs in hw IRQ to
 soft IRQ
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1567502047-24102-2-git-send-email-yhchuang@realtek.com>
References: <1567502047-24102-2-git-send-email-yhchuang@realtek.com>
To:     <yhchuang@realtek.com>
Cc:     <linux-wireless@vger.kernel.org>, <jano.vesely@gmail.com>,
        <linux@endlessm.com>, <briannorris@chromium.org>,
        <gojun077@gmail.com>, <drake@endlessm.com>, <davem@davemloft.net>,
        <jian-hong@endlessm.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190903133704.408506083E@smtp.codeaurora.org>
Date:   Tue,  3 Sep 2019 13:37:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<yhchuang@realtek.com> wrote:

> From: Jian-Hong Pan <jian-hong@endlessm.com>
> 
> There is a mass of jobs between spin lock and unlock in the hardware
> IRQ which will occupy much time originally. To make system work more
> efficiently, this patch moves the jobs to the soft IRQ (bottom half) to
> reduce the time in hardware IRQ.
> 
> Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>

2 patches applied to wireless-drivers-next.git, thanks.

b3d07736b30a rtw88: pci: Move a mass of jobs in hw IRQ to soft IRQ
79066903454b rtw88: pci: enable MSI interrupt

-- 
https://patchwork.kernel.org/patch/11127455/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

