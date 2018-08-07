Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59382 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbeHGNmd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Aug 2018 09:42:33 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Winnie Chang <winnie.chang@cypress.com>
Subject: Re: [PATCH] brcmfmac: fix brcmf_wiphy_wowl_params() NULL pointer dereference
References: <1533622686-145733-1-git-send-email-chi-hsien.lin@cypress.com>
Date: Tue, 07 Aug 2018 14:28:36 +0300
In-Reply-To: <1533622686-145733-1-git-send-email-chi-hsien.lin@cypress.com>
        (Chi-Hsien Lin's message of "Tue, 7 Aug 2018 01:18:06 -0500")
Message-ID: <87a7py4dqz.fsf@kamboji.qca.qualcomm.com> (sfid-20180807_132845_644323_13EB7738)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chi-Hsien Lin <chi-hsien.lin@cypress.com> writes:

> From: Winnie Chang <winnie.chang@cypress.com>
>
> The kernel BUG happens when wowl is enabled from firmware. In
> brcmf_wiphy_wowl_params(), cfg is a NULL pointer because it is
> drvr->config returned from wiphy_to_cfg(), and drvr->config is not set
> yet. To fix it, set drvr->config before brcmf_setup_wiphy() which
> calls brcmf_wiphy_wowl_params().
>
> The kernel panic is introduced in below commit:
> commit id: 856d5a011c86b59f6564be4508912fb1d866adfc
> brcmfmac: allocate struct brcmf_pub instance using wiphy_new()
>
> Signed-off-by: Winnie Chang <winnie.chang@cypress.com>
> Reviewed-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>

Chi-Hsien, you need to include your own s-o-b as well when you are
submitting the patch:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#signed-off-by_missing

-- 
Kalle Valo
