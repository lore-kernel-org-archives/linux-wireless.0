Return-Path: <SRS0=kZdm=TH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B8D1C004C9
	for <linux-wireless@archiver.kernel.org>; Tue,  7 May 2019 14:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C5FE205C9
	for <linux-wireless@archiver.kernel.org>; Tue,  7 May 2019 14:02:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XzPzc0Cb";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TJfZ4KbG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfEGOCI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 7 May 2019 10:02:08 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38296 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfEGOCI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 May 2019 10:02:08 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B675E60128; Tue,  7 May 2019 14:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557237727;
        bh=/hVlbXyQQMjDGxfdnaO6GMk/i/CPNdy0bGA6g5+p8MU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=XzPzc0CbrtyMTXrT98hjmMKNnB0JGzOvtNeU3AQgAfPYOrznKpj3HsmDaBPhCTgLD
         7Job7ZRtmkKverycSu49cenU0tE2FcJySUK9w2HooeNCK6yBx7NnPS6UL2p5CBYlIM
         ck8vP9AbjWcJdgqRreN3Zkbd9rOGfDcnFvUnvxs8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 56CE26016D;
        Tue,  7 May 2019 14:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557237727;
        bh=/hVlbXyQQMjDGxfdnaO6GMk/i/CPNdy0bGA6g5+p8MU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=TJfZ4KbGz/dcV6dG6VXKhpgw6pxAZIyfxS1lRsd3c0Wt940c9MsC9Jb16oe+X1DdA
         l3sZCXEbPwTKNRjTxbfUEuDqp2xxN3Gntzxoe0nA+bC5S4dwFdVkx3psFhGbODhxYN
         dbgIH0lHoO74t4u+cTgzqB4p8Bf9GKwZ9iOdNYd0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 56CE26016D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/3] ath10k: Add wmi tlv vdev subtype for mesh in WCN3990
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1555489907-30117-2-git-send-email-svishnoi@codeaurora.org>
References: <1555489907-30117-2-git-send-email-svishnoi@codeaurora.org>
To:     Surabhi Vishnoi <svishnoi@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190507140207.B675E60128@smtp.codeaurora.org>
Date:   Tue,  7 May 2019 14:02:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Surabhi Vishnoi <svishnoi@codeaurora.org> wrote:

> There is a disparity in wmi and wmi tlv vdev subtype
> enum for WMI_VDEV_SUBTYPE_MESH_11S.
> 
> Add different enum for wmi tlv vdev subtype to support
> vdev of subtype mesh 11s for WCN3990.
> 
> Tested HW: WCN3990
> 
> Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

3 patches applied to ath-next branch of ath.git, thanks.

a7368c395fc3 ath10k: Add wmi tlv vdev subtype for mesh in WCN3990
97354f2c4327 ath10k: Do not send probe response template for mesh
7835d8f8792d ath10k: Add wmi tlv service map for mesh 11s

-- 
https://patchwork.kernel.org/patch/10904959/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

