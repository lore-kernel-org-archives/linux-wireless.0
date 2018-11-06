Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E0BFC32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E113E20862
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:00:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JiiVd+yP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Lg5h3E01"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E113E20862
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388918AbeKGB0C (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 20:26:02 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33654 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388422AbeKGB0C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 20:26:02 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 062DF60600; Tue,  6 Nov 2018 16:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541520010;
        bh=fZ7Wx8jqC8NdPXGxod6WBJEY8u22pGX4KNLz31iLLCE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=JiiVd+yP7xCeBpdTSo2452J++Nhn2ZrNz4X0qBIZZXqXFMa0NgG+oEKXCuiB7pUcF
         mYVVPqR7I2XvLCkU3QsWzRpBVBeAIJGRyhBUJcvjOyXDsqsotd3wWi183FK+Px5QxK
         q+TBtdb1pgOnyqYIof2vcaVtNAPc263Go4DqvJQo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DBEEE60591;
        Tue,  6 Nov 2018 16:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541520009;
        bh=fZ7Wx8jqC8NdPXGxod6WBJEY8u22pGX4KNLz31iLLCE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Lg5h3E01WiSMbNkSuwt2R7S+FB7HaZy383ipB+sYM7CP6DRlU1S67ARunjaxjWh/O
         w0w5a5+6CzJ7pW3/P1N9hTfFFS78HzAqhuF0m1EYCYhxSpCVCvQxczgpK4oM6cYO2q
         OXf39ZWoJ9Y1E0GEUSnTB78KLE2mmJSp65d2vXtY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DBEEE60591
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: add amsdu support for monitor mode
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1540794104-30957-2-git-send-email-yyuwang@codeaurora.org>
References: <1540794104-30957-2-git-send-email-yyuwang@codeaurora.org>
To:     Yu Wang <yyuwang@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106160010.062DF60600@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 16:00:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yu Wang <yyuwang@codeaurora.org> wrote:

> When processing HTT_T2H_MSG_TYPE_RX_IN_ORD_PADDR_IND, if the length of a msdu
> is larger than the tailroom of the rx skb, skb_over_panic issue will happen
> when calling skb_put.  In monitor mode, amsdu will be handled in this path, and
> msdu_len of the first msdu_desc is the length of the entire amsdu, which might
> be larger than the maximum length of a skb, in such case, it will hit the issue
> upon.
> 
> To fix this issue, process msdu list separately for monitor mode.
> 
> Successfully tested with:
> QCA6174 (FW version: RM.4.4.1.c2-00057-QCARMSWP-1).
> 
> Signed-off-by: Yu Wang <yyuwang@codeaurora.org>
> [kvalo@codeaurora.org: cosmetic cleanup]
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

I did some cosmetic changes (commit log, line wraps, declaring variables
beginning of the function), please check:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=8f5579342f10719341ae11307ce56c6235cfd484

-- 
https://patchwork.kernel.org/patch/10658777/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

