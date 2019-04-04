Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03FC9C4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 09:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4E7620449
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 09:58:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VLBcS7SA";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Uos+d8Qv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbfDDJ61 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 05:58:27 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53626 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728442AbfDDJ60 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 05:58:26 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A859061359; Thu,  4 Apr 2019 09:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554371905;
        bh=woCWbjGPLoGzGhMMYROQ+hpfFirGwWwl/k9cGP32na4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=VLBcS7SAsswMDLhBqDQxRMXKGyPeQgHTqWdklA2mJIEwVe2DPMDUYeZqVgYydLWYh
         /4eBX1BSPoUwJ+eB1YLpBbqxmBr6q/uqIDizr0s3zvwkCfFgA1D6FWSuqdX14NLqig
         ht0XUn2BdKFBN+htO6XI6cyXCRM2idiq8BsYbihk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1DEDF61359;
        Thu,  4 Apr 2019 09:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554371904;
        bh=woCWbjGPLoGzGhMMYROQ+hpfFirGwWwl/k9cGP32na4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Uos+d8Qvn3LOczojma+kpvzuxqHBcljwX7TkyZeYg7jWYu6ttxgwJYH9y7TERbWxq
         ZiRcD8d2hwwuz0ahzqd8URJN096uTvJ1Y13uwrpsnJeRTgLV2wmSjDhmT6m4fKeu1P
         Fob2Rk03GxwQ8JWOwkZjc2HeMH9/8V1ykBJGHlVQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1DEDF61359
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 01/14] qtnfmac: make regulatory notifier work on per-phy
 basis
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190320100340.14168-2-sergey.matyukevich.os@quantenna.com>
References: <20190320100340.14168-2-sergey.matyukevich.os@quantenna.com>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190404095825.A859061359@smtp.codeaurora.org>
Date:   Thu,  4 Apr 2019 09:58:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:

> From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> 
> Wireless core calls regulatory notifier for each wiphy and it only
> guarantees that bands info is updated for this particular wiphy prior
> to calling a notifier. Hence updating all wiphy which belong to driver
> in a single notifier callback is redundant and incorrect.
> 
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

13 patches applied to wireless-drivers-next.git, thanks.

d123172175db qtnfmac: make regulatory notifier work on per-phy basis
642f15a5cee7 qtnfmac: simplify error reporting in regulatory notifier
a2fbaaf757e3 qtnfmac: include full channels info to regulatory notifier
2c31129f8f40 qtnfmac: pass complete channel info in regulatory notifier
48cefdfbcb57 qtnfmac: flexible regulatory domain registration logic
c698bce01562 qtnfmac: allow each MAC to specify its own regulatory rules
438fb43bcab1 qtnfmac: pass DFS region to firmware on region update
93eeab26791d qtnfmac: update bands information on CHANGE_INTF command
ae1946be26bc qtnfmac: fix core attach error path in pcie backend
83b00f6eb863 qtnfmac: simplify firmware state tracking
72b3270e01ab qtnfmac: allow changing the netns
bc70732f9bd9 qtnfmac: send EAPOL frames via control path
b63967cae6b1 qtnfmac: use scan duration param for different scan types

-- 
https://patchwork.kernel.org/patch/10861235/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

