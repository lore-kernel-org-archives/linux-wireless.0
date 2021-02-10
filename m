Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 603E2C433DB
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Feb 2021 11:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 298C764DAF
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Feb 2021 11:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhBJLhZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Feb 2021 06:37:25 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:44928 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230409AbhBJLfv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Feb 2021 06:35:51 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=[127.0.1.1])
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1l9nls-0049Tk-1p; Wed, 10 Feb 2021 13:35:00 +0200
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Luca Coelho <luca@coelho.fi>
In-Reply-To: <20210112132449.22243-3-tiwai@suse.de>
References: <20210112132449.22243-3-tiwai@suse.de>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.9.1+
Message-Id: <E1l9nls-0049Tk-1p@farmhouse.coelho.fi>
Date:   Wed, 10 Feb 2021 13:35:00 +0200
Subject: Re: [PATCH 2/2] iwlwifi: dbg: Mark ucode tlv data as const
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Takashi Iwai <tiwai@suse.de> wrote:

> The ucode TLV data may be read-only and should be treated as const
> pointers, but currently a few code forcibly cast to the writable
> pointer unnecessarily.  This gave developers a wrong impression as if
> it can be modified, resulting in crashing regressions already a couple
> of times.
> 
> This patch adds the const prefix to those cast pointers, so that such
> attempt can be caught more easily in future.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Acked-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to iwlwifi-next.git, thanks.

71b6254a6c98 iwlwifi: dbg: Mark ucode tlv data as const

