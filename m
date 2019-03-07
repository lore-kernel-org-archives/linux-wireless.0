Return-Path: <SRS0=M0/e=RK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5AB8C43381
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 17:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70A702081B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 17:14:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GzruIjgg";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Q2knc1g3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbfCGROq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Mar 2019 12:14:46 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49188 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbfCGROq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Mar 2019 12:14:46 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 036B7602FC; Thu,  7 Mar 2019 17:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551978886;
        bh=v8WY/KkzCVKHZWvZZ/K3SU/UvviupNeqmxwyybqth3Y=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=GzruIjggKPGRquOBBYy99+bj9QnIiOsmhhtTPQsmzHx8vdmPag6dGZH3SvJk4knk9
         WBWq78/D17lzAbOCK4GsPTNilIw1AF5ZnkRTyE0XoJvU3mxoBP6qbt7DNYjes7nH70
         QbGA5MXn9mHByGZT+XdxnUyOCvbBM3nxr4Luk610=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C75036029B;
        Thu,  7 Mar 2019 17:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551978885;
        bh=v8WY/KkzCVKHZWvZZ/K3SU/UvviupNeqmxwyybqth3Y=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Q2knc1g3HCVGT9lq2HHRxgMmJHvJoOE+0PtgDR9zjkQheOQ6V5Bvtg8o4/UDOUlAH
         /Lq8DzkWscny2Y3hJR0qBponZVlrQF4UZPGZ2Q+3LVelGNvV6KcWQoviozUl7Bm6Q5
         xbkKkaqIpY0O3Kn2t4mfXPcZDiGsp6kH2fomdSso=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C75036029B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull request: mt76 2019-03-07
References: <241bb056-21ef-0343-7a17-368a07359180@nbd.name>
Date:   Thu, 07 Mar 2019 19:14:42 +0200
In-Reply-To: <241bb056-21ef-0343-7a17-368a07359180@nbd.name> (Felix Fietkau's
        message of "Thu, 7 Mar 2019 12:59:33 +0100")
Message-ID: <87imwua9od.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> here's another pull request with fixes for 5.1
>
> - Felix
>
> The following changes since commit 4177c5d94264b57f426ef5c45a788808d1a1e536:
>
>   net/sched: act_tunnel_key: Fix double free dst_cache (2019-03-05 12:57:28 -0800)
>
> are available in the Git repository at:
>
>   https://github.com/nbd168/wireless tags/mt76-for-kvalo-2019-03-07
>
> for you to fetch changes up to 411e05f4e87794332f328ca3fa201b731f023db5:
>
>   mt76x2u: remove duplicated entry in mt76x2u_device_table (2019-03-07 12:55:30 +0100)
>
> ----------------------------------------------------------------
> mt76 patches for 5.1
>
> * fix hardware restart for mt76x2
> * fix writing txwi on USB devices
> * fix (and disable by default) ED/CCA support on 76x2
> * fix powersave issues on 7603
> * fix return value check for ioremap on 7603
> * fix duplicate USB device IDs
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
