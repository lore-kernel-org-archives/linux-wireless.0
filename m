Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C7D3E732E8
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Sep 2023 16:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbjI1QZv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Sep 2023 12:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbjI1QZs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Sep 2023 12:25:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434E1EB
        for <linux-wireless@vger.kernel.org>; Thu, 28 Sep 2023 09:25:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C053FC433C8;
        Thu, 28 Sep 2023 16:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695918345;
        bh=i/EPi8i8KnOn6iK+Rx0MHVFSN8pIvaaYv1KRyWqxEaY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ZmuDRBffDDRcpZXFJ9kVa5saeyRATz3bQunFcp7o5Sgr+9xM6iZfbXBkh73a6yLdN
         ezLOkVGkft7Pe3f7jzkGTprZ4p7gR696h5Erx2CGkqZHTD88g6LOhmZ5NYGdlUSLxE
         MDEd4GVEG0X0rbQxDgedCqMQD5Z9tsuT0N3Exgfbz18kfP2r57fycZ0rOHtTQ9pTCo
         OtlAyq3sAXwHRmCHMxNKfjKd9R9k6t46AyJlrSp/2rmtyfUfW7sx61rSqRIxwuyiLm
         FAlNdroJJY2vy7bcxtVVSoStr2vTfyqANqvC04djSB+RqTE0q0xTcFtViz3BkJfDtB
         Cuyo598xabmLg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rtlwifi: cleanup few rtlxxxx_set_hw_reg() routines
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230925090452.25633-1-dmantipov@yandex.ru>
References: <20230925090452.25633-1-dmantipov@yandex.ru>
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org,
        lvc-project@linuxtesting.org, Dmitry Antipov <dmantipov@yandex.ru>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169591834305.3187104.8658235364226283925.kvalo@kernel.org>
Date:   Thu, 28 Sep 2023 16:25:44 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dmitry Antipov <dmantipov@yandex.ru> wrote:

> Since 'u8' comparison against zero is always false, drop the
> corresponding branches of AMPDU_MIN_SPACE adjustment within
> 'rtlxxxx_set_hw_reg()' for rtl8188ee, rtl8192ce, rtl8192de,
> rtl8723ae, rtl8723be, and rtl8821ae. Compile tested only.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

6016f0cb02f4 wifi: rtlwifi: cleanup few rtlxxxx_set_hw_reg() routines

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230925090452.25633-1-dmantipov@yandex.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

