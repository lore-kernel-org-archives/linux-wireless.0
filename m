Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.cypress.com ([157.95.67.100]:56654 "EHLO
        smtp1.cypress.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751170AbdH1N3o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Aug 2017 09:29:44 -0400
Date: Mon, 28 Aug 2017 08:29:38 -0500
From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Wright Feng <wright.feng@cypress.com>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org,
        chi-hsien.lin@cypress.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH v4] brcmfmac: add CLM download support
Message-ID: <20170828132937.GA128508@aremote01.aus.cypress.com> (sfid-20170828_152948_833302_FDF570B4)
References: <1503912332-4275-1-git-send-email-wright.feng@cypress.com>
 <59A3F01A.5030403@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <59A3F01A.5030403@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 28, 2017 at 12:27:38PM +0200, Arend van Spriel wrote:
> On 8/28/2017 11:25 AM, Wright Feng wrote:
> >From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> >
> >The firmware for brcmfmac devices includes information regarding
> >regulatory constraints. For certain devices this information is kept
> >separately in a binary form that needs to be downloaded to the device.
> >This patch adds support to download this so-called CLM blob file. It
> >uses the same naming scheme as the other firmware files with extension
> >of .clm_blob.
> >
> >The CLM blob file is optional. If the file does not exist, the download
> >process will be bypassed. It will not affect the driver loading.
> >
> >Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> >---
> >v2: Revise commit message to describe in more detail
> >v3: Add error handling in brcmf_c_get_clm_name function
> >v4: Correct the length of dload_buf in brcmf_c_download function
> >---
> >  .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  10 ++
> >  .../wireless/broadcom/brcm80211/brcmfmac/common.c  | 161 +++++++++++++++++++++
> >  .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   2 +
> >  .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   2 +
> >  .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  31 ++++
> >  .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  19 +++
> >  .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  19 +++
> >  .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  18 +++
> >  8 files changed, 262 insertions(+)
> >
> 
> [...]
> 
> >diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> >index 7a2b495..d09922b 100644
> >--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> >+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> 
> [...]
> 
> >@@ -104,12 +106,139 @@ void brcmf_c_set_joinpref_default(struct brcmf_if *ifp)
> >  		brcmf_err("Set join_pref error (%d)\n", err);
> >  }
> >
> >+static int brcmf_c_download(struct brcmf_if *ifp, u16 flag,
> >+			    struct brcmf_dload_data_le *dload_buf,
> >+			    u32 len)
> >+{
> >+	s32 err;
> >+
> >+	flag |= (DLOAD_HANDLER_VER << DLOAD_FLAG_VER_SHIFT);
> >+	dload_buf->flag = cpu_to_le16(flag);
> >+	dload_buf->dload_type = cpu_to_le16(DL_TYPE_CLM);
> >+	dload_buf->len = cpu_to_le32(len);
> >+	dload_buf->crc = cpu_to_le32(0);
> >+	len = sizeof(*dload_buf) + len - 1;
> >+	len = len + 8 - (len % 8);
> 
> In case len is 8 this will result in 16. So better use roundup()
> macro from include/linux/kernel.h [1]. However, this means
> brcmf_fil_iovar_data_set() will read after the allocated buffer
> space.
> 
> By the way, where does the alignment requirement come from?
> 

Thanks for pointing this out. I've tried the download process without
this alignment. There's no error/failure showed up. Looks like the
alignment is not necessary here so I will remove it.

> >+
> >+	err = brcmf_fil_iovar_data_set(ifp, "clmload", (void *)dload_buf, len);
> 
> The cast is not necessary so please remove.

Will do it.

Regards,
Chung-Hsien

> 
> Regards,
> Arend
> 
> [1] http://elixir.free-electrons.com/linux/latest/source/include/linux/kernel.h#L90
