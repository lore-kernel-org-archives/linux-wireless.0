Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BAAFC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 14:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6613E2083E
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 14:49:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SvLDo13/";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UZVddneY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbfBSOtB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 09:49:01 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:47902 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbfBSOtB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 09:49:01 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 15CB6608CC; Tue, 19 Feb 2019 14:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550587740;
        bh=UquqPx1RrTAIQkgJOAwBC+HF9G5vnVuZiwLMnv0yoHo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SvLDo13/bjHwzVbS9SkTbzEeFRrnnh/hvEkfJCxhyjuFttivAfWEdQJ3MjsIIjDGU
         dbwB9A+YA83SyB8zj7KQZ/UdXlBVqz7Ms6Ed+fQRSQFuCoq7fECd/9NaCYUtSYDJXe
         xKCBpxdsGiEUDrRBY49jV+iWOiHAsSpwX3gkJBag=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1BA2660388;
        Tue, 19 Feb 2019 14:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550587739;
        bh=UquqPx1RrTAIQkgJOAwBC+HF9G5vnVuZiwLMnv0yoHo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=UZVddneYS5zq3FJe6Xm1ao9cMO4IWHpRcu/nBZy8ufhCthJ/so72NC9oFRQJ54zYd
         Dpjn9eUzRo3xsyy7T0zS0DtEmSNvM0Dm3Grt9IQFCljU10IDof/a1nGCWRI776XWLS
         k26XKUeZam2I4LDQ1hb2o2j0pLJZSEYDZn2A0k0I=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1BA2660388
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull request: mt76 2019-02-18
References: <13bb375f-9800-3b09-d7c2-c97b263691b5@nbd.name>
Date:   Tue, 19 Feb 2019 16:48:54 +0200
In-Reply-To: <13bb375f-9800-3b09-d7c2-c97b263691b5@nbd.name> (Felix Fietkau's
        message of "Mon, 18 Feb 2019 21:19:50 +0100")
Message-ID: <87k1hvrfzd.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> here's another pull request for 5.1
>
> - Felix
>
> The following changes since commit f77ecde5f206195cdce16dd2ac92d7ca0305ba2b:
>
>   Merge tag 'iwlwifi-next-for-kalle-2019-02-14' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next (2019-02-18 20:10:46 +0200)
>
> are available in the Git repository at:
>
>   https://github.com/nbd168/wireless tags/mt76-for-kvalo-2019-02-18
>
> for you to fetch changes up to 9f688473408b6334c5da5ec085f9ea1954675fe7:
>
>   mt76: mt76x2: simplify per-chain signal strength handling (2019-02-18 20:41:50 +0100)
>
> ----------------------------------------------------------------
> mt76 patches for 5.1
>
> * beacon support for USB devices (mesh+ad-hoc only)
> * mt76x0 tx power fixes
> * fixes for encryption, calibration and ED/CCA
> * more code unification
> * USB fixes
> * fix for using the correct hweight8 function
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
