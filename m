Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51732 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751215AbdKJGPY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Nov 2017 01:15:24 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Wright Feng <wright.feng@cypress.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>
Subject: Re: [PATCH v6] brcmfmac: add CLM download support
References: <1507188678-24985-1-git-send-email-wright.feng@cypress.com>
Date: Fri, 10 Nov 2017 08:15:19 +0200
In-Reply-To: <1507188678-24985-1-git-send-email-wright.feng@cypress.com>
        (Wright Feng's message of "Thu, 5 Oct 2017 15:31:18 +0800")
Message-ID: <87vaiilkw8.fsf@purkki.adurom.net> (sfid-20171110_071527_628165_0DE3AEF7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wright Feng <wright.feng@cypress.com> writes:

> From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
>
> The firmware for brcmfmac devices includes information regarding
> regulatory constraints. For certain devices this information is kept
> separately in a binary form that needs to be downloaded to the device.
> This patch adds support to download this so-called CLM blob file. It
> uses the same naming scheme as the other firmware files with extension
> of .clm_blob.
>
> The CLM blob file is optional. If the file does not exist, the download
> process will be bypassed. It will not affect the driver loading.
>
> Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>

[...]

> +	err = brcmf_fil_iovar_data_get(ifp, "clmver", buf, sizeof(buf));
> +	if (err) {
> +		if (err == -23) {

No magic numbers, please. Is this supposed to be -ENFILE?

-- 
Kalle Valo
