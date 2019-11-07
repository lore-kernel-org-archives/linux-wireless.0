Return-Path: <SRS0=sGVr=Y7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98072C5DF61
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Nov 2019 13:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67AD72178F
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Nov 2019 13:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388954AbfKGN1a (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Nov 2019 08:27:30 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55172 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728172AbfKGN1a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Nov 2019 08:27:30 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1iShou-00010Q-2I; Thu, 07 Nov 2019 15:27:28 +0200
Message-ID: <a83688d756bf51225be51865d96b72452f88aead.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 07 Nov 2019 15:27:27 +0200
In-Reply-To: <20191107115149.10709-3-luca@coelho.fi>
References: <20191107115149.10709-1-luca@coelho.fi>
         <20191107115149.10709-3-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5.4 3/3] iwlwifi: check kasprintf() return value
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-11-07 at 13:51 +0200, Luca Coelho wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> kasprintf() can fail, we should check the return value.
> 
> Fixes: 5ed540aecc2a ("iwlwifi: use mac80211 throughput trigger")
> Fixes: 8ca151b568b6 ("iwlwifi: add the MVM driver")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---

Let's drop this one from v5.4.  This is extremely unlikely to fail and
the real reason for the crash we have observed was fixed in Johannes'
mac80211 patch (2/3 in this series).

--
Luca.

