Return-Path: <SRS0=+7Bs=YY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC22CA9ECE
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Oct 2019 08:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F06A82083E
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Oct 2019 08:10:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Lcngf0gf";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hRQQ+qSI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfJaIKy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Oct 2019 04:10:54 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44058 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbfJaIKy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Oct 2019 04:10:54 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DC67960927; Thu, 31 Oct 2019 08:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572509453;
        bh=R9a6NR3iic6qgOQYqHn6WkolVQpxamcIauDJvCJETFM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Lcngf0gf9g3rjV5XH2/y+eg2nBUMtriTRHTdUi0IEW2fxOtvjoK1KhMRP3xbmixrN
         4incWqzdPw/KQwlXqWWzSIo+r7VQxG72neifdM7Y58mq3Da5O0PdE6QfyN86OG/zDs
         extaDTNJWtFf244PX0Ji6c30bNRCBPyEnyufweNo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8314360540;
        Thu, 31 Oct 2019 08:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572509453;
        bh=R9a6NR3iic6qgOQYqHn6WkolVQpxamcIauDJvCJETFM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=hRQQ+qSITwh1W+k4EdLFooP54FHyVM7qCdTNe4WZ7Oc7vo9YyyI5QSM8y7m49/wQX
         F17nPZ7P9oJl7D8iMCtMpKITmrDzAcAVuqiozxBcck85Hz5YxVAdn5UV1WGVdUfLvv
         IAhyNuMYVf8S5U9qJgl9m4JKUxAHg5bygNZzF2qk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8314360540
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mt7601u: use DEFINE_DEBUGFS_ATTRIBUTE to define debugfs
 fops
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1572422924-58878-1-git-send-email-zhongjiang@huawei.com>
References: <1572422924-58878-1-git-send-email-zhongjiang@huawei.com>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     <kubakici@wp.pl>, <davem@davemloft.net>, <matthias.bgg@gmail.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <zhongjiang@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191031081053.DC67960927@smtp.codeaurora.org>
Date:   Thu, 31 Oct 2019 08:10:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

zhong jiang <zhongjiang@huawei.com> wrote:

> It is more clear to use DEFINE_DEBUGFS_ATTRIBUTE to define debugfs file
> operation rather than DEFINE_SIMPLE_ATTRIBUTE.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> Acked-by: Jakub Kicinski <kubakici@wp.pl>

Patch applied to wireless-drivers-next.git, thanks.

086ddf860650 mt7601u: use DEFINE_DEBUGFS_ATTRIBUTE to define debugfs fops

-- 
https://patchwork.kernel.org/patch/11219173/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

