Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB3FC282D0
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 11:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0644120882
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 11:59:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KNjUIT8k";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="n8QEswMY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730656AbfA2LrL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 06:47:11 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57624 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731147AbfA2LrJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 06:47:09 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B8BB460C69; Tue, 29 Jan 2019 11:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548762428;
        bh=nUVxgQkFbGThxYhAjo9bLf6oF+HdNFnzLio4NMmx2Vk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KNjUIT8k0wFwq6OdpfSbudlx03/WOMN3Q9/aPXv/dvGWyj0GmRnCfEi9vU1N19IYl
         WiIhYPwkZlB0y/cqV07SqTU3HSCBTB7GpqExIgubtC1VAQ0XXcPwClde9lJdYkjzRi
         24CJmDu7wisXBVxu/g0aBo6oFXe2CU4swze7uIdk=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1CDA860CEF;
        Tue, 29 Jan 2019 11:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548762427;
        bh=nUVxgQkFbGThxYhAjo9bLf6oF+HdNFnzLio4NMmx2Vk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=n8QEswMYYSAHuxinI5l/VWviu/ExSQWyZrBmVkwSqzf3jxEEK9auMv5HA1yhOQXek
         ydG1H8EhScOsZkIIufkOyokU436elvRkhfXTxo5gFyOX0c28TPypT1H0SUiwdzoXyx
         WCb8UNd4AryCWmBQzf8DytTcF7pJ6NMoOtY3yPiE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1CDA860CEF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCH v2 0/7] mt76x02: Beacon support for USB
References: <1548678108-9526-1-git-send-email-sgruszka@redhat.com>
Date:   Tue, 29 Jan 2019 13:47:04 +0200
In-Reply-To: <1548678108-9526-1-git-send-email-sgruszka@redhat.com> (Stanislaw
        Gruszka's message of "Mon, 28 Jan 2019 13:21:41 +0100")
Message-ID: <87a7jju1mv.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> We can configure beaconing, but without TBTT interrupt we
> can not support PS buffering. This can be added later using
> kernel hrtimer, if we can keep it in sycn with device timer.
>
> I tested AP and IBSS modes.

So how does this work reliably so that there's no packet loss with
clients using power save?

-- 
Kalle Valo
