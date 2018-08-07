Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:38217 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388581AbeHGVtY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Aug 2018 17:49:24 -0400
Received: by mail-qt0-f195.google.com with SMTP id w26-v6so6660146qto.5
        for <linux-wireless@vger.kernel.org>; Tue, 07 Aug 2018 12:33:31 -0700 (PDT)
Subject: Re: [PATCH v2] brcmfmac: fix brcmf_wiphy_wowl_params() NULL pointer
 dereference
To: Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        linux-wireless@vger.kernel.org
References: <1533649107-157808-1-git-send-email-chi-hsien.lin@cypress.com>
Cc: brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Winnie Chang <winnie.chang@cypress.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B69F407.6040004@broadcom.com> (sfid-20180807_213409_215861_91DD798A)
Date: Tue, 7 Aug 2018 21:33:27 +0200
MIME-Version: 1.0
In-Reply-To: <1533649107-157808-1-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/7/2018 3:38 PM, Chi-Hsien Lin wrote:
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

The above info should be in Fixes: tag, but maybe Kalle is willing to 
reformat it this time.

Regards,
Arend

> Signed-off-by: Winnie Chang <winnie.chang@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
