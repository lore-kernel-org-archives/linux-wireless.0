Return-Path: <SRS0=l3ON=XT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88366C432C1
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Sep 2019 14:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 597CB207FD
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Sep 2019 14:48:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ky5noSWl";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ub1Fip3C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731146AbfIXOsT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 24 Sep 2019 10:48:19 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36742 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfIXOqT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Sep 2019 10:46:19 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8AAB160A97; Tue, 24 Sep 2019 14:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569336378;
        bh=VwDBP5dU+zG6Qy6lwpYKrZqDwxKMAH0pQAIBblp0SyU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Ky5noSWlyARiEkt0tlkSqQ8lZCmwGj9O4/9zl+V55dsF1M2BImrjbNke8XsA+qYX5
         wklGLXlQUYth121o2v4UiCYe3qMjhMhopbA/OYLrueZb5hiA7IQ5AT8PKf5fbEkuzv
         wpnuqvVrQNdGRfx7p3pyQktTjBsbrb3N6mJgArNg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C019760128;
        Tue, 24 Sep 2019 14:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569336378;
        bh=VwDBP5dU+zG6Qy6lwpYKrZqDwxKMAH0pQAIBblp0SyU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Ub1Fip3ChS7/RJUqi4FSKhQu60u8WX85RcRSzdRylPIIKaWClDeAj4Lm8HHmH/GVW
         H2w8l+4+JlJL+TUEZlI+CIQ6CeBGOMOpTlgOzRxq4JtxbTkBwF32LFVnqlYCWlgomm
         pzyQEuyRFcwRy8uXHpFCNByaZqeKYIgPHfBYbAPc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C019760128
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mt76: mt7615: fix mt7615 firmware path definitions
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <9e132c0949139155a4fb3375e4c83218159efce7.1569159209.git.lorenzo@kernel.org>
References: <9e132c0949139155a4fb3375e4c83218159efce7.1569159209.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     nbd@nbd.name, lorenzo.bianconi@redhat.com,
        linux-wireless@vger.kernel.org, ryder.lee@mediatek.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190924144618.8AAB160A97@smtp.codeaurora.org>
Date:   Tue, 24 Sep 2019 14:46:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> mt7615 patch/n9/cr4 firmwares are available in mediatek folder in
> linux-firmware repository. Because of this mt7615 won't work on regular
> distributions like Ubuntu. Fix path definitions.  Moreover remove useless
> firmware name pointers and use definitions directly
> 
> Fixes: 04b8e65922f6 ("mt76: add mac80211 driver for MT7615 PCIe-based chipsets")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Patch applied to wireless-drivers.git, thanks.

9d4d0d06bbf9 mt76: mt7615: fix mt7615 firmware path definitions

-- 
https://patchwork.kernel.org/patch/11155889/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

