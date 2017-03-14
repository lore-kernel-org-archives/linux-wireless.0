Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:35237 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbdCNJvq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 05:51:46 -0400
Received: by mail-wr0-f179.google.com with SMTP id g10so120243417wrg.2
        for <linux-wireless@vger.kernel.org>; Tue, 14 Mar 2017 02:51:45 -0700 (PDT)
Subject: Re: brcmfmac and WIPHY_FLAG_NETNS_OK
To: Mark Asselstine <mark.asselstine@windriver.com>
References: <2253234.njokx7NVYT@yow-masselst-lx1>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <df16691e-62f7-4c95-0534-48d1dea4f5ba@broadcom.com> (sfid-20170314_105150_280842_7649693D)
Date: Tue, 14 Mar 2017 10:51:43 +0100
MIME-Version: 1.0
In-Reply-To: <2253234.njokx7NVYT@yow-masselst-lx1>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless
+ Johannes

On 13-3-2017 19:15, Mark Asselstine wrote:
> Hello Arend,
> 
> I am thinking about proposing the following patch on linux-wireless but would 
> like to ask you your thoughts first. I have looked in detail at the kernel 
> code, the brcmfmac development pages, the mailing list archives etc. to make 
> sure that I haven't missed previous discussions on this subject, if you have 
> already ruled this functionality out I apologize for missing the relevant 
> info.
> 
> Like others folks (for example https://github.com/fgg89/docker-ap/issues/3) I 
> would like to have the ability to make the wifi interface available in a 
> container. The *80211 infrastructure should allow this but the brcmfmac driver 
> does not enable WIPHY_FLAG_NETNS_OK so attempts to move the phy and vifs to a 
> network NS results in -EOPNOTSUPP. Is there a reason for this not being 
> supported?

Hi Mark,

It never came up with any projects so far. I doubt that the patch below
is sufficient. I suspect something more is needed. Using git blame I
ended up finding these commits:

a272a72 mac80211: allow using network namespaces
463d018 cfg80211: make aware of net namespaces
5061b0c mac80211: cooperate more with network namespaces

I think what is required from brcmfmac is to set netns for each netdev
that we create to the same netns as the wiphy instance using
wiphy_net(). Not sure if there is more to consider, but hopefully
Johannes can comment on this although the mentioned commits have been
around for a while.

Regards,
Arend

> Thanks so much for taking the time to read this email and thanks in advance 
> for any feedback you are able to provide.
> 
> Regards,
> Mark Asselstine
> 
> ----
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 944b83c..f38500b 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -6452,7 +6452,8 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct 
> brcmf_if *ifp)
>  
>         wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT |
>                         WIPHY_FLAG_OFFCHAN_TX |
> -                       WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
> +                       WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
> +                       WIPHY_FLAG_NETNS_OK;
>         if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_TDLS))
>                 wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
>         if (!ifp->drvr->settings->roamoff)
> 
