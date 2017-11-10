Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam02on0097.outbound.protection.outlook.com ([104.47.36.97]:33024
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755575AbdKJCvl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 21:51:41 -0500
Date: Thu, 9 Nov 2017 20:51:27 -0600
From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH v6] brcmfmac: add CLM download support
Message-ID: <20171110025126.GA193831@aremote01.aus.cypress.com> (sfid-20171110_035149_151242_7FFA66F7)
References: <1507188678-24985-1-git-send-email-wright.feng@cypress.com>
 <20171103082725.GB25372@aremote01.aus.cypress.com>
 <9773ee9a-90d3-a303-54b0-9893503190f9@broadcom.com>
 <20171103094016.GA51515@aremote01.aus.cypress.com>
 <87efpflbtu.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87efpflbtu.fsf@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 03, 2017 at 03:40:45PM +0200, Kalle Valo wrote:
> Chung-Hsien Hsu <stanley.hsu@cypress.com> writes:
> 
> > On Fri, Nov 03, 2017 at 10:20:07AM +0100, Arend van Spriel wrote:
> >> On 03-11-17 09:27, Chung-Hsien Hsu wrote:
> >> >On Thu, Oct 05, 2017 at 03:31:18PM +0800, Wright Feng wrote:
> >> >>From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> >> >>
> >> >>The firmware for brcmfmac devices includes information regarding
> >> >>regulatory constraints. For certain devices this information is kept
> >> >>separately in a binary form that needs to be downloaded to the device.
> >> >>This patch adds support to download this so-called CLM blob file. It
> >> >>uses the same naming scheme as the other firmware files with extension
> >> >>of .clm_blob.
> >> >>
> >> >>The CLM blob file is optional. If the file does not exist, the download
> >> >>process will be bypassed. It will not affect the driver loading.
> >> >>
> >> >>Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> >> >>---
> >> >>v2: Revise commit message to describe in more detail
> >> >>v3: Add error handling in brcmf_c_get_clm_name function
> >> >>v4: Correct the length of dload_buf in brcmf_c_download function
> >> >>v5: Remove unnecessary cast and alignment
> >> >>v6: Add debug log for the case of no CLM file present
> >> >>---
> >> >>  .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  10 ++
> >> >>  .../wireless/broadcom/brcm80211/brcmfmac/common.c  | 162 +++++++++++++++++++++
> >> >>  .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   2 +
> >> >>  .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   2 +
> >> >>  .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  31 ++++
> >> >>  .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  19 +++
> >> >>  .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  19 +++
> >> >>  .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  18 +++
> >> >>  8 files changed, 263 insertions(+)
> >> >
> >> >Any comments or feedback about this? I'm hoping to have it in v4.15.
> 
> This might not necessary make it to v4.15, it depends if Linus releases
> the final v4.14 on Sunday or not.

Since the final v4.14 was not released last Sunday, is it possible to get this to v4.15?

> 
> >> Sorry for not following up. The change log for v6 made me wonder if
> >> all my comments on v5 were addressed. I just checked and it looks
> >> fine to me. Kalle has set this patch to Deferred state in patchwork
> >> maybe awaiting my response.
> 
> Yup, I was waiting your comments.
> 
> >> I already gave my "Reviewed-by:" on v5 so you may add that for v6,
> >> but I am sure Kalle can do that.
> >> 
> >> Regards,
> >> Arend
> >
> > Hi Arend,
> >
> > Thanks for the confirmation and quick reply. How can I know the state of
> > a patch, e.g., a patch is set to Deferred state?
> 
> I have documented this in the wiki:
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#checking_state_of_patches_from_patchwork
> 
> > Could you please help to add Arend's "Reviewed-by:" on v6? Or should I
> > add it and resend v6?
> 
> Sure, I can add it. No need to resend.
> 
> And actually Arend should be able to add the tag automatically by
> replying to the patch with his tag, patchwork would then pick it up and
> add it when I apply the patch. To my knowledge patchwork supports
> Acked-by, Reviewed-by and Tested-by tags.

Thanks for the info.

Regards,
Chung-Hsien

> 
> -- 
> Kalle Valo
