Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FAD9C433DB
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Feb 2021 10:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4774364FF2
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Feb 2021 10:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhBEKF2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Feb 2021 05:05:28 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:43860 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230378AbhBEKB2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Feb 2021 05:01:28 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=[127.0.1.1])
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1l7xuT-0044mc-N3; Fri, 05 Feb 2021 12:00:18 +0200
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Luca Coelho <luca@coelho.fi>
In-Reply-To: <iwlwifi.20210205110447.d206ac428823.Ia19339efb09f9d80143f0d0e398a158180754cfa@changeid>
References: <iwlwifi.20210205110447.d206ac428823.Ia19339efb09f9d80143f0d0e398a158180754cfa@changeid>
To:     Luca Coelho <luca@coelho.fi>
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.9.1+
Message-Id: <E1l7xuT-0044mc-N3@farmhouse.coelho.fi>
Date:   Fri, 05 Feb 2021 12:00:17 +0200
Subject: Re: [RESEND PATCH 10/12] iwlwifi: pcie: Disable softirqs during Rx
 queue
 init
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> wrote:

> From: Ilan Peer <ilan.peer@intel.com>
> 
> When Rx queues are configured during module init, NAPI is enabled
> while the Rx queue lock is held. However, since softirqs are not
> disabled, it is possible that and IRQ would fire and call
> iwl_pcie_rx_handle() which would also try to acquire the Rx lock.
> 
> Prevent this by disabling softirqs during Rx queue configuration,
> as part of module init flow.
> 
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to iwlwifi-next.git, thanks.

47ef328c2090 iwlwifi: pcie: Disable softirqs during Rx queue init

