Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8948DC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 15:33:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5542320811
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 15:33:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jvH+hO2F";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KG9T7Oxw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbfCSPdQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 11:33:16 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52084 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbfCSPdQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 11:33:16 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 34B8060E42; Tue, 19 Mar 2019 15:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553009595;
        bh=Az6AxIetC2BBLxVKTZRrBCYUPMtx3SiXs9+LRntrOTQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jvH+hO2FIxyjbcB2aNhCmwOFS8l7omynpe3mI0XvyXwfnlGElcNQx2aZ9fwJLh2KW
         Ha+XNmC6cOWBpMH7HC+R5fA0Jv+OzXKVZ/NJEmPlTpVesGEXlwSUUVA6z2CRIxzdkQ
         4UdvHu1LJigLmddBPrMXNnEdldYsUaYo/lVwODsY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A929960E42;
        Tue, 19 Mar 2019 15:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553009593;
        bh=Az6AxIetC2BBLxVKTZRrBCYUPMtx3SiXs9+LRntrOTQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=KG9T7Oxwj9KqDnQajQ9QK2wyegKa3UR7IFDpsaQdSPq2PnUGAiGLkzb2DBYp3P89B
         65oJCg6rPL6YOZMzbqS1BEKCM1erAJcVB/8yev/JcOoCUAJvOvAqHHpHLkqOF2QcFT
         ahPyLoAGJ2+w2htRkcaY6ulrnfGew4KAZdzldy88=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A929960E42
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] mt7601u: check chip version on probe
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1551961327-28912-1-git-send-email-sgruszka@redhat.com>
References: <1551961327-28912-1-git-send-email-sgruszka@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org, Jakub Kicinski <kubakici@wp.pl>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190319153315.34B8060E42@smtp.codeaurora.org>
Date:   Tue, 19 Mar 2019 15:33:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> Since some USB device IDs are duplicated between mt7601u and mt76x0u
> devices, check chip version on probe and return error if not match
> 0x7601.
> 
> Don't think this is serious issue, probe most likely will fail at
> some other point for wrong device, but we do not have to configure
> it if we know is not mt7601u device.
> 
> Reported-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Acked-by: Jakub Kicinski <kubakici@wp.pl>

Patch applied to wireless-drivers.git, thanks.

c0316470683a mt7601u: check chip version on probe

-- 
https://patchwork.kernel.org/patch/10842757/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

