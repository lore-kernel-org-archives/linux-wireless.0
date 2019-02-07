Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D84A5C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 16:33:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A9632175B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 16:33:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="d/R3XdKH";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EzEBmvHh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfBGQdQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 11:33:16 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57814 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfBGQdQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 11:33:16 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E3E3F60734; Thu,  7 Feb 2019 16:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549557195;
        bh=4O9/BhiH3CfQThw7yxmmUF9uMsxrIG8ueGJwVe8ceMk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=d/R3XdKHHt/7ltsv9Dy/HBPWIZqZV/INeJTOSJ+xhFpkoM7csl2Q3Wwfsjl2ap/iv
         Vqi8Z74Hx3ZpJO1Aix+557ezJ8XvDRSeVQMhHj/xLCp7wykVKEqF60IhoJVVH8zbzW
         8daNkfCJYdffw2uNls9tvO3f5kUz7WVnyxTSYKVc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B697A60134;
        Thu,  7 Feb 2019 16:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549557195;
        bh=4O9/BhiH3CfQThw7yxmmUF9uMsxrIG8ueGJwVe8ceMk=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=EzEBmvHhsOte8P/tyLDuU5KKgZ52020SVnITR20Q/vn0JGZRofWL10a81bHGbh0KY
         aHjAwBJPYBqTkCSqC7AXEulDE7QcyPrKUhnot3y9N3J9UeX3TS4A2q+d8Oczoa0a6M
         PTtCwh3dzVXOPZPxcH4/GPB3SiZLzV8W3m6ZMZTM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B697A60134
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 5.0 v2] mt76x0u: fix suspend/resume
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1549463656-22219-1-git-send-email-sgruszka@redhat.com>
References: <1549463656-22219-1-git-send-email-sgruszka@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190207163315.E3E3F60734@smtp.codeaurora.org>
Date:   Thu,  7 Feb 2019 16:33:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> We need to reset MCU and do other initializations on resume otherwise
> MT7610U device will fail to initialize, what cause system hung due to
> USB requests timeouts.
> 
> Patch fixes 4.19 -> 4.20 regression.
> 
> Cc: stable@vger.kernel.org # 4.20+
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Patch applied to wireless-drivers.git, thanks.

d04ca383860b mt76x0u: fix suspend/resume

-- 
https://patchwork.kernel.org/patch/10799445/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

