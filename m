Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E35C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 05:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78541218A1
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 05:24:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="g0ENhu+f";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="g0ENhu+f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfCOFY2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 01:24:28 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48748 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbfCOFY2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 01:24:28 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 97D4C60909; Fri, 15 Mar 2019 05:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552627467;
        bh=3SmD/oFrTB9rgtC/YZ4FDSZrYqEcuyQZURQCgITSwlw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=g0ENhu+ffpOAhRUFGHksSPu3qwtlpgngQZtVsN69ij7J62ZXKvV8wlNnVXF2QAlY9
         mjb4nkssNW0Nq5nNEAanMUmMJkyQ4GvSYO8mr3qPV5wA5m3M5dC/DvizsK05/8LoZU
         ZuNBaoH1cvKNB1r/qcxpoZ30Tc7HZh7QRW0684pM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6FDDE60386;
        Fri, 15 Mar 2019 05:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552627467;
        bh=3SmD/oFrTB9rgtC/YZ4FDSZrYqEcuyQZURQCgITSwlw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=g0ENhu+ffpOAhRUFGHksSPu3qwtlpgngQZtVsN69ij7J62ZXKvV8wlNnVXF2QAlY9
         mjb4nkssNW0Nq5nNEAanMUmMJkyQ4GvSYO8mr3qPV5wA5m3M5dC/DvizsK05/8LoZU
         ZuNBaoH1cvKNB1r/qcxpoZ30Tc7HZh7QRW0684pM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6FDDE60386
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ath: fix missing checks for bmi reads and writes
References: <20190315051903.10664-1-kjlu@umn.edu>
Date:   Fri, 15 Mar 2019 07:24:22 +0200
In-Reply-To: <20190315051903.10664-1-kjlu@umn.edu> (Kangjie Lu's message of
        "Fri, 15 Mar 2019 00:19:03 -0500")
Message-ID: <87tvg44smx.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kangjie Lu <kjlu@umn.edu> writes:

> ath10k_bmi_write32 and ath10k_bmi_read32 can fail. The fix
> checks their statuses to avoid potential undefined behaviors.
>
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>

The title prefix should be "ath10k: ", I'll fix that.

-- 
Kalle Valo
