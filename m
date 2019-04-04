Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BEE7C4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED82720882
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:21:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bhhuH6Y4";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HC62xji5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbfDDKVL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 06:21:11 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41928 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbfDDKVK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 06:21:10 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EBBCE61948; Thu,  4 Apr 2019 10:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554373270;
        bh=Q20oaEgCeKgb/CIMmYEt6Tu76PJKYPTYfhbzm7G7Cjc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=bhhuH6Y456eVtGfT/+2olCH5+uo+eDOHJzS+3m09vB8r4CyXj4mxuZIGTeu0FKNkP
         mRSoeO3gOOGdZtlqgja77YHvMrR6ZMBO+H9g0HHJLbISn3zK3Da8ZkpxPyCO1Xv+6I
         oBIgRNh0I9pKg6LjtibyQBYDtNV3wufMaEtp5/Ps=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 59C8B60C72;
        Thu,  4 Apr 2019 10:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554373269;
        bh=Q20oaEgCeKgb/CIMmYEt6Tu76PJKYPTYfhbzm7G7Cjc=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=HC62xji5k5pQq3WKm8RoLuN8uycN2R6LXK1LXqa5xmKgCy/5u0NwGXGpPnBHibqr0
         9Ozq8/pWYs3n1155rJ7Hrt05532hGGiwrm3jEH5eCmAd59nk+mL+KNqW0zDroEBBMi
         HO1NLz6T6EFQlZ8a6Dnkmha/5SNQ2tM3X4luN11A=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 59C8B60C72
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: add a bounds check in
 mwifiex_process_sta_rx_packet()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190402070338.GB15171@kadam>
References: <20190402070338.GB15171@kadam>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190404102109.EBBCE61948@smtp.codeaurora.org>
Date:   Thu,  4 Apr 2019 10:21:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> Smatch complains that "local_rx_pd->priority" can't be trusted because
> it comes from skb->data and it can go up to 255 instead of being capped
> in the 0-7 range.  A few lines earlier, on the other side of the if
> statement, we cap priority so it seems harmless to add a bounds check
> here as well.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

2cd2b42439ea mwifiex: add a bounds check in mwifiex_process_sta_rx_packet()

-- 
https://patchwork.kernel.org/patch/10881135/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

