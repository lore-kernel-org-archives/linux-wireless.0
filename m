Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F3EC43219
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 206DF206BF
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:44:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hW6cOscA";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LdnB2VtG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfDYQoG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:44:06 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55800 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbfDYQoG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:44:06 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7B33960736; Thu, 25 Apr 2019 16:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556210645;
        bh=qj9hz4hYHmxU4ABi7+O2pPuVGLecw9x0h14AULZRAUY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=hW6cOscALwSWq9dbLSRtwzgS/BIU+XlHNeeC1IY7F3x4kHg+o7aMKqavNXUxOGkPN
         OTG0NDxV2V7BS4XLWaonsYb1Zbp02f91Nbyh7g2q2TXpSA957fyu4BIHv2hRwws+yB
         X+zSiwyYXHyLASGHrlitYxvHVZlq0jHUVau0gMw0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 49C61601B4;
        Thu, 25 Apr 2019 16:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556210644;
        bh=qj9hz4hYHmxU4ABi7+O2pPuVGLecw9x0h14AULZRAUY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=LdnB2VtGkd5Cz9txDciSL0kIZwhEdq3IIzjiGgaMW0ijfMf3U+fy/wM5gCZXir8Zj
         pVF0nX7m7fTNHXZ7n7yccmoEHIc5kSOx4nXNCk4KmEJG8irBiWh8lEfrn19Jj3xzAY
         XSd0As4GCuZkYQ3N4YNDdmjP3cfLfKejhIDrboeY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 49C61601B4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/8] rt2800: partially restore old mmio txstatus behaviour
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1553680711-15730-2-git-send-email-sgruszka@redhat.com>
References: <1553680711-15730-2-git-send-email-sgruszka@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        =?utf-8?q?Tomislav_Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425164405.7B33960736@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:44:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> Do not disable txstatus interrupt and add quota of processed tx statuses in
> one tasklet. Quota is needed to allow to fed device with new frames during
> processing of tx statuses.
> 
> Patch fixes about 15% performance degradation on some scenarios caused by
> 0b0d556e0ebb ("rt2800mmio: use txdone/txstatus routines from lib").
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

8 patches applied to wireless-drivers-next.git, thanks.

889bb866baaf rt2800: partially restore old mmio txstatus behaviour
f61131505e85 rt2800: new flush implementation for SoC devices
6efa79876486 rt2800: move txstatus pending routine
2c7ba758cc4b rt2800mmio: fetch tx status changes
e5ceab9df437 rt2800mmio: use timer and work for handling tx statuses timeouts
eb662b1dc62e rt2x00: remove last_nostatus_check
d954f9e3fb42 rt2x00: remove not used entry field
9ea3812f015b rt2x00mmio: remove legacy comment

-- 
https://patchwork.kernel.org/patch/10873121/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

