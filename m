Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39554 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732570AbeHIRci (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 13:32:38 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH v3] brcmfmac: fix brcmf_wiphy_wowl_params() NULL pointer
 dereference
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1533694781-176974-1-git-send-email-chi-hsien.lin@cypress.com>
References: <1533694781-176974-1-git-send-email-chi-hsien.lin@cypress.com>
To: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Winnie Chang <winnie.chang@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Message-Id: <20180809150718.B7FB260B77@smtp.codeaurora.org> (sfid-20180809_170722_161274_411673D1)
Date: Thu,  9 Aug 2018 15:07:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chi-Hsien Lin <chi-hsien.lin@cypress.com> wrote:

> From: Winnie Chang <winnie.chang@cypress.com>
> 
> The kernel BUG happens when wowl is enabled from firmware. In
> brcmf_wiphy_wowl_params(), cfg is a NULL pointer because it is
> drvr->config returned from wiphy_to_cfg(), and drvr->config is not set
> yet. To fix it, set drvr->config before brcmf_setup_wiphy() which
> calls brcmf_wiphy_wowl_params().
> 
> Fixes: 856d5a011c86 ("brcmfmac: allocate struct brcmf_pub instance using wiphy_new()")
> Signed-off-by: Winnie Chang <winnie.chang@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>

Patch applied to wireless-drivers-next.git, thanks.

27a8aea13053 brcmfmac: fix brcmf_wiphy_wowl_params() NULL pointer dereference

-- 
https://patchwork.kernel.org/patch/10559407/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
