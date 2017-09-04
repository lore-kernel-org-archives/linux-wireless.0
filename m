Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.cypress.com ([157.95.67.100]:56295 "EHLO
        smtp1.cypress.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753463AbdIDLdb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Sep 2017 07:33:31 -0400
Date: Mon, 4 Sep 2017 06:33:25 -0500
From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
To: arend.vanspriel@broadcom.com
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        kvalo@codeaurora.org, chi-hsien.lin@cypress.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, wright.feng@cypress.com
Subject: Re: [PATCH v5] brcmfmac: add CLM download support
Message-ID: <20170904113324.GA126340@aremote01.aus.cypress.com> (sfid-20170904_133334_939347_4BB7184C)
References: <1503987821-6132-1-git-send-email-wright.feng@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1503987821-6132-1-git-send-email-wright.feng@cypress.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 29, 2017 at 02:23:41PM +0800, Wright Feng wrote:
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
> ---
> v2: Revise commit message to describe in more detail
> v3: Add error handling in brcmf_c_get_clm_name function
> v4: Correct the length of dload_buf in brcmf_c_download function
> v5: Remove unnecessary cast and alignment
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  10 ++
>  .../wireless/broadcom/brcm80211/brcmfmac/common.c  | 160 +++++++++++++++++++++
>  .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   2 +
>  .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   2 +
>  .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  31 ++++
>  .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  19 +++
>  .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  19 +++
>  .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  18 +++
>  8 files changed, 261 insertions(+)

Hi Arend,

Do you think this patch is ready to be merged or is there something more
to change?

Regards,
Chung-Hsien
