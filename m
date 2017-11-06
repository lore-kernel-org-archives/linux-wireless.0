Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:55235 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750760AbdKFIre (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 03:47:34 -0500
Received: by mail-qt0-f170.google.com with SMTP id z19so9940266qtg.11
        for <linux-wireless@vger.kernel.org>; Mon, 06 Nov 2017 00:47:34 -0800 (PST)
Subject: Re: [PATCH v6] brcmfmac: add CLM download support
To: Wright Feng <wright.feng@cypress.com>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org,
        chi-hsien.lin@cypress.com
References: <1507188678-24985-1-git-send-email-wright.feng@cypress.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A0021A3.6040005@broadcom.com> (sfid-20171106_094738_451552_D2458741)
Date: Mon, 6 Nov 2017 09:47:31 +0100
MIME-Version: 1.0
In-Reply-To: <1507188678-24985-1-git-send-email-wright.feng@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/5/2017 9:31 AM, Wright Feng wrote:
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

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> ---
> v2: Revise commit message to describe in more detail
> v3: Add error handling in brcmf_c_get_clm_name function
> v4: Correct the length of dload_buf in brcmf_c_download function
> v5: Remove unnecessary cast and alignment
> v6: Add debug log for the case of no CLM file present
> ---
