Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0106.outbound.protection.outlook.com ([104.47.41.106]:43389
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751664AbdKJJAY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Nov 2017 04:00:24 -0500
Date: Fri, 10 Nov 2017 03:00:14 -0600
From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Wright Feng <wright.feng@cypress.com>,
        arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH v6] brcmfmac: add CLM download support
Message-ID: <20171110090013.GA131667@aremote01.aus.cypress.com> (sfid-20171110_100028_279379_D354D7B6)
References: <1507188678-24985-1-git-send-email-wright.feng@cypress.com>
 <87vaiilkw8.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87vaiilkw8.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 10, 2017 at 08:15:19AM +0200, Kalle Valo wrote:
> Wright Feng <wright.feng@cypress.com> writes:
> 
> > From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> >
> > The firmware for brcmfmac devices includes information regarding
> > regulatory constraints. For certain devices this information is kept
> > separately in a binary form that needs to be downloaded to the device.
> > This patch adds support to download this so-called CLM blob file. It
> > uses the same naming scheme as the other firmware files with extension
> > of .clm_blob.
> >
> > The CLM blob file is optional. If the file does not exist, the download
> > process will be bypassed. It will not affect the driver loading.
> >
> > Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> 
> [...]
> 
> > +	err = brcmf_fil_iovar_data_get(ifp, "clmver", buf, sizeof(buf));
> > +	if (err) {
> > +		if (err == -23) {
> 
> No magic numbers, please. Is this supposed to be -ENFILE?

It indicates "Unsupported". I will remove it since it will not affect
the CLM downlaod and driver loading.

Regards,
Chung-Hsien 

> 
> -- 
> Kalle Valo
