Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C05FC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 14:08:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B55F213F2
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 14:08:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QDz+tsm/";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QDz+tsm/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbfCTOIp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:08:45 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52920 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbfCTOIp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 10:08:45 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6C45860850; Wed, 20 Mar 2019 14:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553090924;
        bh=/DxiASGSxGOYTIuY9b6rtOSjeej15Nhz24FeZzI3geE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=QDz+tsm/8fO9aTTAF4/oQu5QEs4FOZcifIx8Lo/kHtKzkEY8rxc/QNBun7Bu0DLkx
         xxL6jPHzDi8f8ElGR/k+Uc7csoshSj1DvMlqc4AlRB/Q3gQ2rl1jzOtQ8lljLidPTj
         uOuDG/PDRerK/UPyvZjy7Rc1wEIf4DdFFjMqd4/Y=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7908F606DB;
        Wed, 20 Mar 2019 14:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553090924;
        bh=/DxiASGSxGOYTIuY9b6rtOSjeej15Nhz24FeZzI3geE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=QDz+tsm/8fO9aTTAF4/oQu5QEs4FOZcifIx8Lo/kHtKzkEY8rxc/QNBun7Bu0DLkx
         xxL6jPHzDi8f8ElGR/k+Uc7csoshSj1DvMlqc4AlRB/Q3gQ2rl1jzOtQ8lljLidPTj
         uOuDG/PDRerK/UPyvZjy7Rc1wEIf4DdFFjMqd4/Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7908F606DB
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: [PATCH 14/14] qtnfmac: use scan duration param for different scan types
References: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
        <20190320100340.14168-15-sergey.matyukevich.os@quantenna.com>
Date:   Wed, 20 Mar 2019 16:08:41 +0200
In-Reply-To: <20190320100340.14168-15-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Wed, 20 Mar 2019 10:04:11 +0000")
Message-ID: <87zhppy6xi.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
>
> Use scan duration param for both active and passive scan dwell times.
> Document what different types of dwell times are used for. Explicitly
> specify that if unset, automatic selection by device firmware
> will be used.
>
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> ---
>  drivers/net/wireless/quantenna/qtnfmac/commands.c | 49 ++++++++++++++++++-----
>  drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 11 ++++-
>  2 files changed, 49 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
> index 62edddb8551e..e58495403dde 100644
> --- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
> +++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
> @@ -11,6 +11,13 @@
>  #include "bus.h"
>  #include "commands.h"
>  
> +#define QTNF_SCAN_TIME_AUTO	0
> +
> +/* Let device itself to select best values for current conditions */
> +#define QTNF_SCAN_DWELL_ACTIVE_DEFAULT		QTNF_SCAN_TIME_AUTO
> +#define QTNF_SCAN_DWELL_PASSIVE_DEFAULT		QTNF_SCAN_TIME_AUTO
> +#define QTNF_SCAN_SAMPLE_DURATION_DEFAULT	QTNF_SCAN_TIME_AUTO

These three defines look odd. Why not just use QTNF_SCAN_TIME_AUTO
directly?

-- 
Kalle Valo
