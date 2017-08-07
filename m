Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35021 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752172AbdHGMdh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 08:33:37 -0400
Received: by mail-wm0-f52.google.com with SMTP id m85so6026537wma.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 05:33:36 -0700 (PDT)
Subject: Re: [PATCH v2 3/3] brcmfmac: fix wrong num_different_channels when
 mchan feature enabled
To: Wright Feng <wright.feng@cypress.com>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org
References: <1501753079-1758-1-git-send-email-wright.feng@cypress.com>
 <1501753079-1758-3-git-send-email-wright.feng@cypress.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <59885E1E.5020602@broadcom.com> (sfid-20170807_143340_668570_EE09DA4A)
Date: Mon, 7 Aug 2017 14:33:34 +0200
MIME-Version: 1.0
In-Reply-To: <1501753079-1758-3-git-send-email-wright.feng@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/3/2017 11:37 AM, Wright Feng wrote:
> brcmfmac: fix wrong num_different_channels when mchan feature enabled
>
> When the device/firmware supports multi-channel, it can have P2P
> connection and regular connection with AP simultaneous. In this case,
> the num_different_channels in wiphy info was not correct when firmware
> supports multi-channel (The iw wiphy# info showed "#channels <= 1" in
> interface combinations). It caused association failed and error message
> "CTRL-EVENT-FREQ-CONFLICT error" in wpa_supplicant when P2P GO interface
> was running at the same time.
> The root cause is that the num_different_channels was always overridden
> to 1 in brcmf_setup_ifmodes even multi-channel was enabled.
> We correct the logic by moving num_different_channels setting forward.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> ---
> v2: Describe the motivation and reason for this patch in commit message
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
