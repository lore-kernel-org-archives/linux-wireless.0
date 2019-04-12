Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C02FC10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 12:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 078D72082E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 12:36:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TsHQXNrv";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NFJhzyjq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfDLMgU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 08:36:20 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:47586 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbfDLMgT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 08:36:19 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 179D261728; Fri, 12 Apr 2019 12:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555072579;
        bh=/xArxoZPt6jdFxx8bZuxo3pSFJ/blfAFBPCJ8VzpObQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TsHQXNrv7Y1WtFzKHY9TvNetuU+McX/jDBJllKRGY20rUOWoU5SBcmIKB3LoqDaLI
         95sy8dBqGstLTeaugh7eG6NqPZpuFkYYRqwCJDHJM+H4qZ6iXeqYzxZp4nOow/83A/
         BfGGMMCX018EpQKAga2DGdboWTF/HMTpQv0iTEgA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 99CCD615E7;
        Fri, 12 Apr 2019 12:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555072578;
        bh=/xArxoZPt6jdFxx8bZuxo3pSFJ/blfAFBPCJ8VzpObQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=NFJhzyjqmZVn3I7XAUf1cDIAFQtk/4j63v1SnlL54FbO98TORtunxg9N1VBP7Wu2S
         930VLVQbIPnKv/bRYpQh0bJut62oDLEOlOsw0eRswGMbNq/15nh84Ne8qVOc/OFlMl
         amsA4bZetc0QIkmDV5tZNHquQK5Y5arA9KP0yToo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 99CCD615E7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Erik Stromdahl <erik.stromdahl@gmail.com>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 0/6] ath10k: SDIO and high latency patches from Silex
References: <20190409190851.4557-1-erik.stromdahl@gmail.com>
Date:   Fri, 12 Apr 2019 15:36:15 +0300
In-Reply-To: <20190409190851.4557-1-erik.stromdahl@gmail.com> (Erik
        Stromdahl's message of "Tue, 9 Apr 2019 21:08:45 +0200")
Message-ID: <87pnprflj4.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> This series adds a few more fixes for SDIO and high latency devices.
>
> I have had these on my private tree for quite some time now so they
> should be considered fairly well tested.
>
> 4 out of 6 patches are from Alagu Sankar at Silex.
> I have made some adjustments to some of them in order to make them
> smaller and easier to review.
>
> Alagu Sankar (4):
>   ath10k: use clean packet headers
>   ath10k: high latency fixes for beacon buffer
>   ath10k: sdio: read RX packets in bundles
>   ath10k: sdio: add MSDU ID allocation in HTT TX path
>
> Erik Stromdahl (2):
>   ath10k: sdio: add missing error check
>   ath10k: sdio: replace skb_trim with explicit set of skb->len

Bad timing as also me and Wen have been cleaning up these patches and
finalising the SDIO support so our work overlapped. I'll send our
version of patches soon and we can then compare.

-- 
Kalle Valo
