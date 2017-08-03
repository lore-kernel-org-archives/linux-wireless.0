Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35074 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752369AbdHCKFY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 06:05:24 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Wright Feng <wright.feng@cypress.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH v2 3/3] brcmfmac: fix wrong num_different_channels when mchan feature enabled
References: <1501753079-1758-1-git-send-email-wright.feng@cypress.com>
        <1501753079-1758-3-git-send-email-wright.feng@cypress.com>
Date: Thu, 03 Aug 2017 13:05:17 +0300
In-Reply-To: <1501753079-1758-3-git-send-email-wright.feng@cypress.com>
        (Wright Feng's message of "Thu, 3 Aug 2017 17:37:59 +0800")
Message-ID: <87k22lnezm.fsf@kamboji.qca.qualcomm.com> (sfid-20170803_120608_571917_BC9D793E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wright Feng <wright.feng@cypress.com> writes:

> brcmfmac: fix wrong num_different_channels when mchan feature enabled

Here also the title is duplicated, but I'll fix that.

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
>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> ---
> v2: Describe the motivation and reason for this patch in commit message

Perfect, thanks.

-- 
Kalle Valo
