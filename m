Return-Path: <SRS0=FCSK=W6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68D37C3A5A2
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:34:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CE6423431
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:34:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TDbLBiSj";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DfafE2xN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbfICNeI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Sep 2019 09:34:08 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:47434 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfICNeI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Sep 2019 09:34:08 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 58E6960592; Tue,  3 Sep 2019 13:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567517647;
        bh=ZTsA71flYaoxrhwxXQNWTDPHWlyP8bSGyGQZ3zihZjM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=TDbLBiSjUjSXSha1XGJE/lc4msFtor5ZH18J1nJv0uTjBRjl6MyAfYeE6KMT5ktXI
         OpuXjrya5udLpihZ4c+XxvV3pRhOjK7flJmnlvCmSezbYfICcmWUK3Nvsta3JA3zRV
         mQJ13uGz9JlLhbE6apNNfnWtr3hEPFg+sMoT4xNQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D79286058E;
        Tue,  3 Sep 2019 13:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567517646;
        bh=ZTsA71flYaoxrhwxXQNWTDPHWlyP8bSGyGQZ3zihZjM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=DfafE2xNh5mRo9BMuhj74h6dRU4Hn81DaDa63LnEAJ8e6E8oA15BeRdAxSVP+3twn
         f5nSVa8C3SMg8ztQc/aFj+JiZ/EoumnKBcoxJGjtpoflvLPVt2ZCBg5+oOCaPnHjMn
         tBw4TdfhHGG11MYkS5GkCHDK11DYxyRa4W760FEo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D79286058E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/4] rtlwifi: rtl8192cu: Remove unused GET_XXX and SET_XXX
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190901154706.24193-2-Larry.Finger@lwfinger.net>
References: <20190901154706.24193-2-Larry.Finger@lwfinger.net>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190903133407.58E6960592@smtp.codeaurora.org>
Date:   Tue,  3 Sep 2019 13:34:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> As the first step in converting from macros that get/set information
> in the RX and TX descriptors, unused macros are being removed.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

4 patches applied to wireless-drivers-next.git, thanks.

4170941ed19c rtlwifi: rtl8192cu: Remove unused GET_XXX and SET_XXX
081420490083 rtlwifi: rtl8192cu: Replace local bit manipulation macros
3925ae06ba60 rtlwifi: rtl8192cu: Convert macros that set descriptor
afd708f74f1e rtlwifi: rtl8192cu: Convert inline routines to little-endian words

-- 
https://patchwork.kernel.org/patch/11125339/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

