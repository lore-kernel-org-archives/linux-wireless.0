Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0126.outbound.protection.outlook.com ([104.47.37.126]:56808
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752982AbdKCI1b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Nov 2017 04:27:31 -0400
Date: Fri, 3 Nov 2017 03:27:25 -0500
From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, stanley.hsu@cypress.com
Subject: Re: [PATCH v6] brcmfmac: add CLM download support
Message-ID: <20171103082725.GB25372@aremote01.aus.cypress.com> (sfid-20171103_092739_675568_EC23D633)
References: <1507188678-24985-1-git-send-email-wright.feng@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1507188678-24985-1-git-send-email-wright.feng@cypress.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 05, 2017 at 03:31:18PM +0800, Wright Feng wrote:
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
> v6: Add debug log for the case of no CLM file present
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  10 ++
>  .../wireless/broadcom/brcm80211/brcmfmac/common.c  | 162 +++++++++++++++++++++
>  .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   2 +
>  .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   2 +
>  .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  31 ++++
>  .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  19 +++
>  .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  19 +++
>  .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  18 +++
>  8 files changed, 263 insertions(+)

Any comments or feedback about this? I'm hoping to have it in v4.15.

Regards,
Chung-Hsien
