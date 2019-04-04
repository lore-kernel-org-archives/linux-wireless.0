Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2678FC4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E790920882
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:18:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mbr+oia3";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WQbCkCPv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbfDDKSW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 06:18:22 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40578 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbfDDKSV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 06:18:21 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D9FE361CA3; Thu,  4 Apr 2019 10:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554373100;
        bh=FrnjyGh0J8CJkHp0LnC/Ogic1+pfatKhKBZinj70YXg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=mbr+oia3LHFeCRRU/qx0QkRgerJGoSq7nHDc0WLESpIkx40UGxD+qSR565B7awKWn
         UGH3GhKqnieCwpPx4FgjiUvGB8qgb826XnLolAfD4znpyTmbC6tG8ayGpli1tsd+ZC
         Mvwxh1eFHiqVaJ3bFiU7Kx3C4bz5AT4NN4DUwm2I=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3FBEB61891;
        Thu,  4 Apr 2019 10:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554373098;
        bh=FrnjyGh0J8CJkHp0LnC/Ogic1+pfatKhKBZinj70YXg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=WQbCkCPvcfV0oL0bpd1T677vyoml7ZliY/E4OBo/oHRy4mXxlGkrayJ/mGYXQqKIH
         lzpxwU9i3mcvtR6RskVc+P0q4aBbRn0y6U8Qwo5ckM6iwrdYASTB8oE8tjECR4/LFt
         11cmZoKDJRBUhD9ppTsmY2Z9m6XeynMsKIEEx/tI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3FBEB61891
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] net: mwifiex: fix a NULL pointer dereference
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190312053107.5790-1-kjlu@umn.edu>
References: <20190312053107.5790-1-kjlu@umn.edu>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     kjlu@umn.edu, pakki001@umn.edu,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190404101820.D9FE361CA3@smtp.codeaurora.org>
Date:   Thu,  4 Apr 2019 10:18:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kangjie Lu <kjlu@umn.edu> wrote:

> In case dev_alloc_skb fails, the fix returns -ENOMEM to avoid
> NULL pointer dereference.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>

Patch applied to wireless-drivers-next.git, thanks.

e5b9b206f3f6 net: mwifiex: fix a NULL pointer dereference

-- 
https://patchwork.kernel.org/patch/10848599/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

