Return-Path: <SRS0=lMj3=ZV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F5EC432C3
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Nov 2019 07:41:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C08FF21736
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Nov 2019 07:41:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hcPqC5ZB";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="IgkTVnfR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfK2HlW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 Nov 2019 02:41:22 -0500
Received: from a27-10.smtp-out.us-west-2.amazonses.com ([54.240.27.10]:42178
        "EHLO a27-10.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726763AbfK2HlW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Nov 2019 02:41:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575013281;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=U43cAUmWdsTQ74Pn+9TgtaLtJGnzCBJkpnasXxKZwRQ=;
        b=hcPqC5ZBONivQyR4s5agASjq6wBUsOTT5g+G9IopDh8qeuOo0zADfJW0A9hUaBRb
        iAsEXTUev0vIF/n3fdA3F6ORsX8LcSnzwr1Qk+TK5ygNuwyUqDks/JYwhNXvBt5Jwir
        y9wxxrCMuxLuNAOFn+TS3JC6HAkQArLxnRpVFdOQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575013281;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=U43cAUmWdsTQ74Pn+9TgtaLtJGnzCBJkpnasXxKZwRQ=;
        b=IgkTVnfRcmqImbD+R72vhlXqYWMxfVVbUaY74EYJW6IXIZZ7pKhJ0Z/oFl/8laya
        YD3w0B34OkgC4v+a4vG/BGQEBAFYxWtYNIpwbNHt/3pBuTIFMZFcGumZzgh147aIyBJ
        3kjR2V8bTvkRQSERDXBfUFGIlgtr5lx2Z/cyYvwA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E5C4DC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: enable firmware log by default for sdio
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191108091914.16785-1-wgong@codeaurora.org>
References: <20191108091914.16785-1-wgong@codeaurora.org>
To:     Wen Gong <wgong@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-ID: <0101016eb61b6e0f-43b8d4f8-9c11-48f3-98a9-8e74d2b44a76-000000@us-west-2.amazonses.com>
Date:   Fri, 29 Nov 2019 07:41:21 +0000
X-SES-Outgoing: 2019.11.29-54.240.27.10
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wen Gong <wgong@codeaurora.org> wrote:

> On SDIO chips the firmware log does not impact performance. To make it
> easier to debug firmware problems keep it enabled on the firmware.
> 
> Tested with QCA6174 SDIO with firmware WLAN.RMH.4.4.1-00029.
> 
> Signed-off-by: Wen Gong <wgong@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

7cbf4c96d715 ath10k: enable firmware log by default for sdio

-- 
https://patchwork.kernel.org/patch/11234367/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

