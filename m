Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B11C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 15:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90BF920811
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 15:35:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="frgtNQVr";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="n89vQDka"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfCSPfK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 11:35:10 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53396 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfCSPfK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 11:35:10 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DFC3560FEE; Tue, 19 Mar 2019 15:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553009709;
        bh=elRgvuayj2Fc42+ujD9BjHdiI0QR5WaZB/WgzbfQ8tQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=frgtNQVrRq3qbCboOtxBkktb3hA4638nh21AY2emLaPynJZatZ3yBO0oM9za1ruao
         HorrsT7Uq/7PYOYpE3zdJo5MCv6PVHuJjUxbiYPkRnfQrJg/RKWdeP3a2AjWigkyu2
         IdYgFLP/h8PRjrLWAO0zYl88XzRCyW7v26g6W8ww=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1563B60DB3;
        Tue, 19 Mar 2019 15:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553009706;
        bh=elRgvuayj2Fc42+ujD9BjHdiI0QR5WaZB/WgzbfQ8tQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=n89vQDkaueXBHgi8iUxwWSiMy49fo9I4ALnT1Ag++P5SM/AGQ2HHgPbWMsb1aN8wa
         fI2VQdiYpid7d3DDrlz0kbL3+lQqqLqbmIH8Bq08EN0Ix6l/1gHJQBCh5WbsQNY2bD
         WpcPGmxpnZ896hCzij+4FEyEZevxTUfyYLbB/3/U=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1563B60DB3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] mt76x02u: check chip version on probe
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1551961341-28975-1-git-send-email-sgruszka@redhat.com>
References: <1551961341-28975-1-git-send-email-sgruszka@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190319153508.DFC3560FEE@smtp.codeaurora.org>
Date:   Tue, 19 Mar 2019 15:35:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> Since some USB device IDs are duplicated between mt76x0u, mt7601u
> and mt76x2u device, check chip version on probe and return error if
> not match the driver.
> 
> Don't think this is serious issue, probe most likely will fail at
> some other point for wrong device, but we do not have to configure
> it if we know is not our device.
> 
> Reported-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers.git, thanks.

40b941611bd4 mt76x02u: check chip version on probe

-- 
https://patchwork.kernel.org/patch/10842759/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

