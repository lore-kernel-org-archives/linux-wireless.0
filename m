Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2796CC4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 12:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB4FC2084B
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 12:24:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FDy9Snnr";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="k4POQHVr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfDCMYw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 08:24:52 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54076 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbfDCMYr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 08:24:47 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6048960ADE; Wed,  3 Apr 2019 12:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554294286;
        bh=FQiNlfhSezZPzvy2kzvd6DG9b5VmxTKgCcgUHbXtkoM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=FDy9SnnrU9n/nGXPpNL23+OtokhKTQvxYEHqYK3CB7k04lf51aB9GSKxmODdUViDy
         gdr5j73hPN8KMvPCkv9F0Wj8/TytIrtTtEDoZK/O2c0kHuQ6EOEVrANyI7bwFEpxQN
         kr3a178qCH3oIieDdtFOMiax0otF6pa+9t0Wy8/c=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 80A38609CD;
        Wed,  3 Apr 2019 12:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554294285;
        bh=FQiNlfhSezZPzvy2kzvd6DG9b5VmxTKgCcgUHbXtkoM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=k4POQHVrXciF0oV/snER+NbvYYKLiraTH+Lp8OtUgc4XmLBD++MmuK+OL7ZVg8IJ+
         Nj0t9TSOS5bJ+IsTIC0Us6Bf3wxLCTkgentC37apmtM2fnDDz/3Wu73DhVWo2u+lZp
         hsHPJO7rj8EqE37U5o6vXJFDNhBj1dAV6N7+Logs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 80A38609CD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Fix encoding for protected management frames
References: <1554208970-16527-1-git-send-email-pillair@codeaurora.org>
Date:   Wed, 03 Apr 2019 15:24:41 +0300
In-Reply-To: <1554208970-16527-1-git-send-email-pillair@codeaurora.org>
        (Rakesh Pillai's message of "Tue, 2 Apr 2019 18:12:50 +0530")
Message-ID: <877ecbuvhy.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rakesh Pillai <pillair@codeaurora.org> writes:

> Currently the protected management frames are
> not appended with the MIC_LEN which results in
> the protected management frames being encoded
> incorrectly.
>
> Add the extra space at the end of the protected
> management frames to fix this encoding error for
> the protected management frames.
>
> Tested HW: WCN3990
> Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1
>
> Fixes: 1807da49733e "ath10k: wmi: add management tx by reference support over wmi"

This should be:

Fixes: 1807da49733e ("ath10k: wmi: add management tx by reference support over wmi")

But I can fix that.

-- 
Kalle Valo
