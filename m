Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB839EB64DB
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Jun 2023 11:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238766AbjFOL76 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Jun 2023 07:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238762AbjFOL7j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2023 07:59:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FE93C00
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jun 2023 04:54:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB293611AF
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jun 2023 11:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525E7C433C0;
        Thu, 15 Jun 2023 11:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686830077;
        bh=6CoRaWMid+fQTV2bHeZBEjDGeum3/Gt6XAbRRbm/J4E=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HhzbrC486BKWz6RYvwnlLwmCVZyHQV7rzfIHQcNtb7dIFz4P2XAfLR6NYatxDSsbx
         NevboWz9ELM5tjUOY33CX7KaFkIVGpYenQoK3X5YVz6oeKK+Fz7c5JGSrSYm6usm0D
         EDakWDLV5TGgQOAijHU6y3Q83Kpj9l60/YyGevKNrnLCH/qvTiq3LojjrIAmDg5tnF
         y5s7NGowIfo7OxZ7oMg4sEVBiCCgD1jJ6oWY8zoGUTeFDv8iwcipPMbTiDotR0vDEm
         WSq96piZ1z4o2Sx27f1PC0K4gkzNtqLlL+aVJSS7AroB97oVHVWA8uV6ma60OQBM+S
         f/Fbv9XMttwFA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: rtw89: delete timer and free skb queue when unloading
References: <20230615110519.61687-1-dmantipov@yandex.ru>
Date:   Thu, 15 Jun 2023 14:54:34 +0300
In-Reply-To: <20230615110519.61687-1-dmantipov@yandex.ru> (Dmitry Antipov's
        message of "Thu, 15 Jun 2023 14:05:19 +0300")
Message-ID: <87leglaqkl.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dmitry Antipov <dmantipov@yandex.ru> writes:

> Delete TX purge timer and free C2H queue in 'rtw_core_deinit()'.

The commit log should always answer to the question "Why?". Please
explain in the commit log why this is needed.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
