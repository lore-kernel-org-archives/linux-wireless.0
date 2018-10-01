Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA23C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 13:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7F47213A2
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 13:55:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="h/e3tErW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XL7OLNTW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7F47213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbeJAUdn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 16:33:43 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52618 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729182AbeJAUdn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 16:33:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 52ABF6079B; Mon,  1 Oct 2018 13:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538402148;
        bh=8c73G5lsfLHxeyhsWdPJgip+zjn6Dm5tHbDeDbVHvls=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=h/e3tErWXW1ClCbLk/YM96GNFYy7ZMVLpbrt+rDlcQLiqtjlsEJQF/Rn9NUizkHwD
         dbGVxqgaYfqVHKVZ5HebFmKatD7hQs3X+GQxSLq5qz6wGvm02yf8PgIKN8u6jOLLsq
         fDQTsavFO1Z7bKfub+6tfOLQN4f48LC09loWfsjw=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B054960376;
        Mon,  1 Oct 2018 13:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538402147;
        bh=8c73G5lsfLHxeyhsWdPJgip+zjn6Dm5tHbDeDbVHvls=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=XL7OLNTWIMThxuTOy2d+/P/pINOxph+vnGmfguX+lXApTMK5fCm12qQ3AYiYTPQ2x
         YL4JN6yFRkQdM2wM64O1gC7mZ6PXPEkdQSgbUv8C/Ui9Nrwz+2gQJktQOeL9+Z/1zJ
         KnNpwIcbKcEqmTDhNRLfBGsrjNnTRlYzOQ3ggiuA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B054960376
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] ath10k: add default value for num_peers in WMI TLV
 init
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180913144506.8272-1-erik.stromdahl@gmail.com>
References: <20180913144506.8272-1-erik.stromdahl@gmail.com>
To:     Erik Stromdahl <erik.stromdahl@gmail.com>
Cc:     kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org,
        Erik Stromdahl <erik.stromdahl@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181001135548.52ABF6079B@smtp.codeaurora.org>
Date:   Mon,  1 Oct 2018 13:55:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Erik Stromdahl <erik.stromdahl@gmail.com> wrote:

> The hw_params value will only be used if it was explicitly set in the
> global hw_params array.
> 
> This makes it possible to have the num_peers member unset.
> 
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

8e8374db3424 ath10k: add default value for num_peers in WMI TLV init
08fafd646d63 ath10k: remove num_peers in hw_params for most targets

-- 
https://patchwork.kernel.org/patch/10599685/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

