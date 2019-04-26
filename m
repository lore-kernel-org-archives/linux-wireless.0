Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0165C43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 11:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDF2A206C1
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 11:53:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ahbamavL";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XDYscOxa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbfDZLxf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 07:53:35 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42576 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfDZLxf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 07:53:35 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B8F136028C; Fri, 26 Apr 2019 11:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556279614;
        bh=sE+dF5a3q+1B5ChXder4EGCIHLGR/RWKlf6TvKnMelQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ahbamavLwOPu4vImsYQItATtjOW1LQfnne3i7XWItuncAbVA8qwUVBnbWkeN6T1X3
         NjYgwUirYs0jS+75Eq/bSyy7paus0xyv8a/d97PUBbeCARZj4zzAZfir8nCvaV863c
         Jsfh3fDBh/0PfZUb381kcY4XbfVYJrEneB2pNqBc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 62C336028C;
        Fri, 26 Apr 2019 11:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556279614;
        bh=sE+dF5a3q+1B5ChXder4EGCIHLGR/RWKlf6TvKnMelQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=XDYscOxagMPPg4go21vU0jo1e5ihNZxkN746OSPiI3lpS1wjcBEUU20b2udbta4OK
         MR49qmXUWT1pDHhMBYnQcSPKHMwTi94PrDMAMquMR+4Q9t3gkWG8hC0UuCic6t1GBp
         pYKwKaGnRBFl7SqgSxVs/ALB5rSPxDnBLe3UtV9s=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 62C336028C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/3] qtnfmac: handle channel switch events for connected
 stations only
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190409073500.16402-2-sergey.matyukevich.os@quantenna.com>
References: <20190409073500.16402-2-sergey.matyukevich.os@quantenna.com>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190426115334.B8F136028C@smtp.codeaurora.org>
Date:   Fri, 26 Apr 2019 11:53:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:

> Channel switch events from firmware should be processed only when STA
> is already connected to BSS. On connect this notification is not needed
> since full BSS info will be supplied by cfg80211_connect_result.
> 
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

3 patches applied to wireless-drivers-next.git, thanks.

4f87d486faf1 qtnfmac: handle channel switch events for connected stations only
888f1564a272 qtnfmac: allow to control DFS slave radar detection
0b68fe10b8e8 qtnfmac: modify debugfs to support multiple cards

-- 
https://patchwork.kernel.org/patch/10890667/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

