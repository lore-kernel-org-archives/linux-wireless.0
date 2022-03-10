Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94A0C433F5
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Mar 2022 16:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240817AbiCJQLD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Mar 2022 11:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240760AbiCJQLC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Mar 2022 11:11:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA5918E43C;
        Thu, 10 Mar 2022 08:10:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9E11B82644;
        Thu, 10 Mar 2022 16:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8712C340E8;
        Thu, 10 Mar 2022 16:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646928598;
        bh=lgG2OUw7ssQ9BqwAhNW1q08hlDaAZoIOoBddSpD4ors=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=RzXiOBEhG6OMxgTRkISWSeM1WiCWm1rhruZbQOtHrclXMXOxj6vY/iuFY95j4BPfO
         E4UHzivmao0gGhfi6OgWClhi0ChU3/ZNBlLm8KRk5CzDuV1+FUvWOsW4Mobkl+HK5u
         xUXQwVPRlQmNssx0Po81do06LbFrsptAFLly21nrXmIKM7MSXHce8EEVQnrRiFxVEV
         8W4pctKhiJMvT5WjiKHRiLpiqcA8eNveZ1APYnb7rzG9nmHZN4BPFtQUVfY1xjfJGn
         BhGf+KARDyF//ZczyLpWHi6i5ScIxb5beimDTdfzUSU3xFqFFiUhJ8QGzwYtRhGoOx
         oVyajF9xpGVbg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: check the return value of devm_kzalloc() in
 brcmf_of_probe()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220225132138.27722-1-baijiaju1990@gmail.com>
References: <20220225132138.27722-1-baijiaju1990@gmail.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@infineon.com,
        wright.feng@infineon.com, chung-hsien.hsu@infineon.com,
        davem@davemloft.net, kuba@kernel.org, shawn.guo@linaro.org,
        gustavoars@kernel.org, len.baker@gmx.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164692859274.6056.13961655347011053680.kvalo@kernel.org>
Date:   Thu, 10 Mar 2022 16:09:54 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Jia-Ju Bai <baijiaju1990@gmail.com> wrote:

> The function devm_kzalloc() in brcmf_of_probe() can fail, so its return
> value should be checked.
> 
> Fixes: 29e354ebeeec ("brcmfmac: Transform compatible string for FW loading")
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

You are not calling of_node_put() in the error path. And I don't think
this even applies.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220225132138.27722-1-baijiaju1990@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

