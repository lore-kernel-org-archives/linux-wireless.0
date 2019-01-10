Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF648C43444
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E33C21783
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:36:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LZJkHM8y";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Gi+HeTPW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbfAJLgI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 06:36:08 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49584 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727938AbfAJLgH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 06:36:07 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3AD05601D1; Thu, 10 Jan 2019 11:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547120167;
        bh=sADhFp9BdewiYGT6/GpksG4N1JR0Ljdr9l7CiOG5hPc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LZJkHM8yKW+Z2V7xz7Ml32EHMT/C5YYBdE9T8FgDoF1infK+Z5GSZdQqJ7KDgew7o
         Dz+h5zmSsSA7dxlZD5FfFEDi0Jc2/+GN54bL9NjannxaWq5KfBIPzHmWWJRhfpQSWK
         V0hSgITvMcKTRaqilmspxfCLoVXtEPysrYKkh3JU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0B1C9601D1;
        Thu, 10 Jan 2019 11:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547120166;
        bh=sADhFp9BdewiYGT6/GpksG4N1JR0Ljdr9l7CiOG5hPc=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Gi+HeTPWoBNg1z/PHcfAk8PQG33PezJPdsgIGNtgOg+zszMXaRi1V39nv1OuRcJbh
         J4E5dx85J9WHeAsLhev6cWIzTyHvt6iJY9qMFmN6BDcsuVWAyV2SpKTd5FYMUc4GCF
         VJ2fwgqXK3oIUFgqbzxYN34XFMivD1YCMuT5GzVc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0B1C9601D1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 20/20] cw1200: drop useless LIST_HEAD
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1545555435-24576-21-git-send-email-Julia.Lawall@lip6.fr>
References: <1545555435-24576-21-git-send-email-Julia.Lawall@lip6.fr>
To:     Julia Lawall <Julia.Lawall@lip6.fr>
Cc:     Solomon Peachy <pizza@shaftnet.org>,
        kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190110113607.3AD05601D1@smtp.codeaurora.org>
Date:   Thu, 10 Jan 2019 11:36:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Julia Lawall <Julia.Lawall@lip6.fr> wrote:

> Drop LIST_HEAD where the variable it declares has never
> been used.
> 
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> identifier x;
> @@
> - LIST_HEAD(x);
>   ... when != x
> // </smpl>
> 
> Fixes: a910e4a94f692 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Patch applied to wireless-drivers-next.git, thanks.

06605b0d38b4 cw1200: drop useless LIST_HEAD

-- 
https://patchwork.kernel.org/patch/10741603/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

