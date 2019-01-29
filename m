Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FD4C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 12:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE42D20881
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 12:07:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="pCznoEXN";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="k7yGpj/U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbfA2MHV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 07:07:21 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49536 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729208AbfA2MHU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 07:07:20 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3E88660D84; Tue, 29 Jan 2019 12:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548763639;
        bh=FovGRTb2FCNabNS0sjnduxu8XA2WZjE4Z+023gj7J6Q=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=pCznoEXN783F8boJ0YenXhAWNs1UCu4nyoscwMR1eEE3VwY01s2ZMEEPqz0Xpv4LC
         AqIRH/UCiGXYla3zp8/5kSOfkVSwg4IIsPlloZzdq5fmgBLe+D2jDzpXkJ7uaUGS53
         dw8kHEs7zKPK/63lmrC7l2CwqxSoFpYaLRdbDAFc=
Received: from x230.qca.qualcomm.com (unknown [83.145.195.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4A78960985;
        Tue, 29 Jan 2019 12:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548763638;
        bh=FovGRTb2FCNabNS0sjnduxu8XA2WZjE4Z+023gj7J6Q=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=k7yGpj/UrG3kzH0oO+aVgM5cNd/ZPqNuVqvrEoGN2PYoquR7tOtEVW05RtkXC+9Aj
         ghrqNPu+hk2bNJoVmQJ21yV4yVK0SXYQcqIYcDPnPrxOYV3NG4Gq2bPATmduSGjBKu
         89Ub8ZdejBaHCeTaZduQY12vIePTK41WfXIm3m0w=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4A78960985
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCH v2 0/7] mt76x02: Beacon support for USB
References: <1548678108-9526-1-git-send-email-sgruszka@redhat.com>
        <87a7jju1mv.fsf@purkki.adurom.net>
        <8ec3b133-49eb-3c5f-4c3c-bc2bb4e84cde@nbd.name>
Date:   Tue, 29 Jan 2019 14:07:14 +0200
In-Reply-To: <8ec3b133-49eb-3c5f-4c3c-bc2bb4e84cde@nbd.name> (Felix Fietkau's
        message of "Tue, 29 Jan 2019 12:49:35 +0100")
Message-ID: <87k1inwtu5.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> On 2019-01-29 12:47, Kalle Valo wrote:
>> Stanislaw Gruszka <sgruszka@redhat.com> writes:
>> 
>>> We can configure beaconing, but without TBTT interrupt we
>>> can not support PS buffering. This can be added later using
>>> kernel hrtimer, if we can keep it in sycn with device timer.
>>>
>>> I tested AP and IBSS modes.
>> 
>> So how does this work reliably so that there's no packet loss with
>> clients using power save?
>
> There will be multicast packet loss for clients using power save.

Isn't that a problem? At least as a normal user I would very frustrated
if sometimes my connection work and sometimes not, for example if I'm
trying discover devices from my network. Hopefully nobody won't use USB
devices for any real AP stuff, but still enabling something which we
know doesn't work realiably is concerning.

-- 
Kalle Valo
