Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:35826 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751870AbdFJJds (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Jun 2017 05:33:48 -0400
Received: by mail-wr0-f170.google.com with SMTP id q97so53412018wrb.2
        for <linux-wireless@vger.kernel.org>; Sat, 10 Jun 2017 02:33:47 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: iso cfg80211: Fix grammar issue in error
 message
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20170608080141.rswb2czupjeblqzq@jirafa.cyrius.com>
 <3bf898aa-c890-32ec-aa83-c7a1e7f56729@broadcom.com>
 <20170610092247.2gz6sydytp5pomq6@jirafa.cyrius.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <a79b0fa3-2f7d-e704-371d-c2eec383afaf@broadcom.com> (sfid-20170610_113737_756944_F8C5ED3A)
Date: Sat, 10 Jun 2017 11:33:45 +0200
MIME-Version: 1.0
In-Reply-To: <20170610092247.2gz6sydytp5pomq6@jirafa.cyrius.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hah. That is (unintended?) fun. I actually meant to change the subject
from "cfg80211: Fix grammar issue in error message" into "brcmfmac: Fix
grammar issue in error message". Using the abbreviation "iso" in this
context was maybe a bit misleading of me.

One more purely educational note: when sending a reworked patch it is
good practice to use "[PATCH V2]" in the subject and add a changelog
between the signature tags and the diff separated by "---" so people now
what changed, ie.:

---
 changes:
  V2:
   - updated subject prefix.
---

Thanks,
Arend

On 10-06-17 11:22, Martin Michlmayr wrote:
> Fix grammar issue in error message about ISO3166.
> 
> Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index cd1d6730eab7..c1ad81f34658 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -6767,7 +6767,7 @@ static void brcmf_cfg80211_reg_notifier(struct wiphy *wiphy,
>  	/* ignore non-ISO3166 country codes */
>  	for (i = 0; i < sizeof(req->alpha2); i++)
>  		if (req->alpha2[i] < 'A' || req->alpha2[i] > 'Z') {
> -			brcmf_err("not a ISO3166 code (0x%02x 0x%02x)\n",
> +			brcmf_err("not an ISO3166 code (0x%02x 0x%02x)\n",
>  				  req->alpha2[0], req->alpha2[1]);
>  			return;
>  		}
> 
