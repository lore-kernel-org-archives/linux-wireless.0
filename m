Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0095.outbound.protection.outlook.com ([104.47.41.95]:13968
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752211AbdKCJk3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Nov 2017 05:40:29 -0400
Date: Fri, 3 Nov 2017 04:40:17 -0500
From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        kvalo@codeaurora.org, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH v6] brcmfmac: add CLM download support
Message-ID: <20171103094016.GA51515@aremote01.aus.cypress.com> (sfid-20171103_104033_986599_54D907AF)
References: <1507188678-24985-1-git-send-email-wright.feng@cypress.com>
 <20171103082725.GB25372@aremote01.aus.cypress.com>
 <9773ee9a-90d3-a303-54b0-9893503190f9@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9773ee9a-90d3-a303-54b0-9893503190f9@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 03, 2017 at 10:20:07AM +0100, Arend van Spriel wrote:
> On 03-11-17 09:27, Chung-Hsien Hsu wrote:
> >On Thu, Oct 05, 2017 at 03:31:18PM +0800, Wright Feng wrote:
> >>From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> >>
> >>The firmware for brcmfmac devices includes information regarding
> >>regulatory constraints. For certain devices this information is kept
> >>separately in a binary form that needs to be downloaded to the device.
> >>This patch adds support to download this so-called CLM blob file. It
> >>uses the same naming scheme as the other firmware files with extension
> >>of .clm_blob.
> >>
> >>The CLM blob file is optional. If the file does not exist, the download
> >>process will be bypassed. It will not affect the driver loading.
> >>
> >>Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> >>---
> >>v2: Revise commit message to describe in more detail
> >>v3: Add error handling in brcmf_c_get_clm_name function
> >>v4: Correct the length of dload_buf in brcmf_c_download function
> >>v5: Remove unnecessary cast and alignment
> >>v6: Add debug log for the case of no CLM file present
> >>---
> >>  .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  10 ++
> >>  .../wireless/broadcom/brcm80211/brcmfmac/common.c  | 162 +++++++++++++++++++++
> >>  .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   2 +
> >>  .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   2 +
> >>  .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  31 ++++
> >>  .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  19 +++
> >>  .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  19 +++
> >>  .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  18 +++
> >>  8 files changed, 263 insertions(+)
> >
> >Any comments or feedback about this? I'm hoping to have it in v4.15.
> 
> Hi Chung-Hsien,
> 
> Sorry for not following up. The change log for v6 made me wonder if
> all my comments on v5 were addressed. I just checked and it looks
> fine to me. Kalle has set this patch to Deferred state in patchwork
> maybe awaiting my response. I already gave my "Reviewed-by:" on v5
> so you may add that for v6, but I am sure Kalle can do that.
> 
> Regards,
> Arend

Hi Arend,

Thanks for the confirmation and quick reply. How can I know the state of
a patch, e.g., a patch is set to Deferred state?


Hi Kalle,

Could you please help to add Arend's "Reviewed-by:" on v6? Or should I
add it and resend v6?

Regards,
Chung-Hsien
