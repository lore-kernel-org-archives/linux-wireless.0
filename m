Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EAC8C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04FCA20825
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:17:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Cyh6l8gU";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="pD2XT/lH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04FCA20825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbeKEUgG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 15:36:06 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43762 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728122AbeKEUgG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 15:36:06 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CC7B1607F7; Mon,  5 Nov 2018 11:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541416613;
        bh=d6b7Tdyi95bYgJvWcSADG72wdZvUnbof0HtXvex+OiA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Cyh6l8gUFXrnspvL7th0w17YhqV0094LyfWXxQg1Og6yGU84AWnLMRVMZrCjym7Xb
         4jNxa1T8OeWSjKSQAvI0MRVhU2fmE2FrKjLMiKzQdXlePnz89QRfzITNGTlkOGtAel
         O19AyDaMGBYXP1vmr7y00r/A11kiihFCNsX0peSo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E98DC60247;
        Mon,  5 Nov 2018 11:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541416613;
        bh=d6b7Tdyi95bYgJvWcSADG72wdZvUnbof0HtXvex+OiA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=pD2XT/lHDoBav9JfEn7r9JL8Uh+4eoPh2cGCtB62k7KTq3AoSXsu7rznGt/MM8Q6T
         BvA8MqHaivJNF9h0A2PIORBZkNj1rfxwY7+Fdx/Dmf9viX7p7KvgvAvAdh6u2x5sP8
         K9qh3FgIZkdw+Q6R/qyx+ZaSa5ImRQon66naFObk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E98DC60247
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 02/20] ath9k: ar5008_phy: mark expected switch fall-through
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1727f5c9f0bb87651831d267e35af5aa1ed1f98b.1540239684.git.gustavo@embeddedor.com>
References: <1727f5c9f0bb87651831d267e35af5aa1ed1f98b.1540239684.git.gustavo@embeddedor.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181105111653.CC7B1607F7@smtp.codeaurora.org>
Date:   Mon,  5 Nov 2018 11:16:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Addresses-Coverity-ID: 1056532 ("Missing break in switch")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

3 patches applied to ath-next branch of ath.git, thanks.

604e98670072 ath9k: ar5008_phy: mark expected switch fall-through
f2a881055094 ath9k: ar9002_phy: mark expected switch fall-throughs
bf74fd75137d ath9k: hw: mark expected switch fall-through

-- 
https://patchwork.kernel.org/patch/10652551/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

