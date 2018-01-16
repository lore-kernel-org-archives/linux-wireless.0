Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:44980 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751102AbeAPFRF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 00:17:05 -0500
Received: by mail-pl0-f68.google.com with SMTP id f8so3265481plk.11
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jan 2018 21:17:05 -0800 (PST)
Date: Mon, 15 Jan 2018 21:17:01 -0800
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: Make sure CLM downloading is optional
Message-ID: <20180116051701.GA7804@builder> (sfid-20180116_061711_764928_2EEABEAF)
References: <20180115171053.8802-1-bjorn.andersson@linaro.org>
 <5A5D03B2.3070002@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5A5D03B2.3070002@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon 15 Jan 11:40 PST 2018, Arend van Spriel wrote:

> On 1/15/2018 6:10 PM, Bjorn Andersson wrote:
> > The presence of a CLM file is described as optional, but missing the clm
> > blob causes the preinit to return unsuccessfully. Fix this by ignoring
> > the return value of the brcmf_c_process_clm_blob().
> > 
> > Also remove the extra debug print, as brcmf_c_process_clm_blob() already
> > did print a useful error message before returning.
> > 
> > Fixes: fdd0bd88ceae ("brcmfmac: add CLM download support")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> > ---
> > 
> > This regression was introduced in v4.15-rc1, but I unfortunately didn't test
> > WiFi until now. Included a Cc to stable@ in case you choose to pick this up
> > after v4.15.
> 
> Hi Bjorn,
> 
> Thanks for looking into this. Actually there already have been a couple of
> fixes posted on the linux-wireless list. [1] was rejected, [2] is being
> discussed, and [2] was posted by me and I was awaiting response from the guy
> reporting it.
> 

Thanks for pointing me to these discussions, I did for some reason not
find them this morning. I don't see the need for the retry in [1], so I
think that's invalid.

I tested [2] and it works well for me, but I agree with Kalle that a
better description of why would be in order. Unfortunatley I can't find
it in my inbox...even though I'm subscribed to linux-wireless@.

The answer to Kalle's question should probably include a reference to
0542ad88fbdd ("firmware loader: Fix _request_firmware_load() return val
for fw load abort")

> Now the thing is that for old (Broadcom) firmware this is optional. Those
> firmwares don't even have CLM support and those that do have the CLM data
> embedded in firmware.

I don't know which applies to my device, but it at least doesn't come
with a dedicated clm blob - and the device won't receive any upgrades
and hence will never get a clm blob.

> However, Cypress wants to provide their customers with
> firmware without CLM data. For those devices it is not optional. I still
> prefer we add a mechanism to the driver to detect that, but we do not have
> that yet.
> 

That sounds reasonable, but I hope we can sort out the regression first
and then add such logic.

> Now regarding your patch some comments below ...
> 
> >   drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 8 ++------
> >   1 file changed, 2 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> > index 6a59d0609d30..0c67ba6ae135 100644
> > --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> > @@ -278,12 +278,8 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
> >   	}
> >   	ri->result = err;
> > 
> > -	/* Do any CLM downloading */
> > -	err = brcmf_c_process_clm_blob(ifp);
> > -	if (err < 0) {
> > -		brcmf_err("download CLM blob file failed, %d\n", err);
> > -		goto done;
> > -	}
> > +	/* Do any optional CLM downloading */
> > +	brcmf_c_process_clm_blob(ifp);
> 
> The error print is indeed redundant and should be removed here. However,
> brcmf_c_process_clm_blob() also returns -ENOMEM upon allocation failure and
> I would still fail the driver probe for that.
> 

Agreed, but as we want to let a few errors, specifically from the
firmware loader, slip by I believe it's better to check the return value
there instead. So I prefer Write's [2].

Regards,
Bjorn
