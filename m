Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105C8C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 05:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8A82214AE
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 05:41:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LAgzGYQP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LAgzGYQP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfCLFlW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 01:41:22 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44848 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbfCLFlW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 01:41:22 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A55BF608FC; Tue, 12 Mar 2019 05:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552369281;
        bh=b0tXPn+qVW0lTMFzhcv045OUzb7eoMoGFu+hV4Onsd8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=LAgzGYQPXRPU5aRAMuO/5577SMaU8bG+hnAKz56JJHPTbh3w+nH93j21qGANNOGt8
         mwl2n4nvTHXZP3O6hH9Jvl6kvoe8oz3Kuou+DHn1SRb6W3jJtsaCS/5Ta8/6qqQ12e
         4BK498FY3+21/EKOc74lnXSP3FN8eiAaYR8mBdNA=
Received: from x230.qca.qualcomm.com (178-55-209-27.bb.dnainternet.fi [178.55.209.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 542556028C;
        Tue, 12 Mar 2019 05:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552369281;
        bh=b0tXPn+qVW0lTMFzhcv045OUzb7eoMoGFu+hV4Onsd8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=LAgzGYQPXRPU5aRAMuO/5577SMaU8bG+hnAKz56JJHPTbh3w+nH93j21qGANNOGt8
         mwl2n4nvTHXZP3O6hH9Jvl6kvoe8oz3Kuou+DHn1SRb6W3jJtsaCS/5Ta8/6qqQ12e
         4BK498FY3+21/EKOc74lnXSP3FN8eiAaYR8mBdNA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 542556028C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mwifiex: fix a NULL pointer dereference
References: <20190312053107.5790-1-kjlu@umn.edu>
Date:   Tue, 12 Mar 2019 07:41:15 +0200
In-Reply-To: <20190312053107.5790-1-kjlu@umn.edu> (Kangjie Lu's message of
        "Tue, 12 Mar 2019 00:31:07 -0500")
Message-ID: <87zhq04pl0.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kangjie Lu <kjlu@umn.edu> writes:

> In case dev_alloc_skb fails, the fix returns -ENOMEM to avoid
> NULL pointer dereference.
>
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>

No changelog, please always add a changelog:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing

-- 
Kalle Valo
