Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 287D3C2BC61
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 14:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D888C20657
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 14:25:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dYGNNvzQ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cv1Ap6Kv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D888C20657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbeJ2XO1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 19:14:27 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46906 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725967AbeJ2XO1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 19:14:27 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 401BE60159; Mon, 29 Oct 2018 14:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540823135;
        bh=IfT9jN1HExkEkAE249H6pVzspS0bFd57ivcYAPdofL4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dYGNNvzQxVnfvkDrU4xdJBGsCVyR1ynOBfcz3sKv+bDYzF6zPJ2UtkwHE6DzXqLDx
         HRtDK+Ng1g/SbGrr5x4BodMJS69v9MrvMdC64qabKaDENITj7vs/as3QW2ZgE4w1mj
         N5oxdmeVUONqvB28FlPK/njLICh5kXdivKw+dZ74=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1E39A60744;
        Mon, 29 Oct 2018 14:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540823134;
        bh=IfT9jN1HExkEkAE249H6pVzspS0bFd57ivcYAPdofL4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cv1Ap6KvUNQFGkq8k1Ooh7kfNh9+6jD+sZpvs0y/qvF/AUaItLMrlROWWRWy9mzH+
         LNllVYE6CSPd4RSS2Df1QZ41lSL8yKGyMmqEELM3D+t0K33I0xv0yEo+JfZHb+d3rC
         /jG0kJT1a3MsYs89FVo2lAHNdT9g61+0hguu8KhM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1E39A60744
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x0: run calibration after scanning
References: <1540808213-14442-1-git-send-email-sgruszka@redhat.com>
Date:   Mon, 29 Oct 2018 16:25:31 +0200
In-Reply-To: <1540808213-14442-1-git-send-email-sgruszka@redhat.com>
        (Stanislaw Gruszka's message of "Mon, 29 Oct 2018 11:16:53 +0100")
Message-ID: <87zhuwbzj8.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> If we are associated and scanning is performed , sw_scan_complete callback
> is done after we get back to operating channel, so we do not perform
> phy calibration and queue cal work. Fix this by run calibration from
> sw_scan_complete().
>
> Fixes: bbd10586f0df ("mt76x0: phy: do not run calibration during channel switch")
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> This is for 4.20

So what are the symptoms from user's point of view? Is this a
regression?

I'm just trying to understand if this really is needed for 4.20. There
are so many mt76 patches flowing to -next that the bar for mt76 -rc
patches is even higher than normally.

-- 
Kalle Valo
