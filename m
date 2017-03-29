Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33920 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932596AbdC2LSh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 07:18:37 -0400
Received: by mail-lf0-f65.google.com with SMTP id x137so1291303lff.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Mar 2017 04:18:35 -0700 (PDT)
Subject: Re: [PATCH 1/5] brcmfmac: wrap brcmf_fws_init into bcdc layer
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <1490697808-5538-1-git-send-email-arend.vanspriel@broadcom.com>
 <1490697808-5538-2-git-send-email-arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Franky Lin <franky.lin@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <a1ced78f-6769-be2d-f2a6-cb3ae4d8a0c2@gmail.com> (sfid-20170329_132235_621583_46EC9647)
Date: Wed, 29 Mar 2017 13:18:33 +0200
MIME-Version: 1.0
In-Reply-To: <1490697808-5538-2-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/28/2017 12:43 PM, Arend van Spriel wrote:
> From: Franky Lin <franky.lin@broadcom.com>
>
> Create a new protocol layer interface brcmf_proto_init_cb for protocol
> layer to finish initialzation after core module components(fweh and
> etc.) are initialized.
>
> Signed-off-by: Franky Lin <franky.lin@broadcom.com>
> Change-Id: I560d2478a7c09766cf07b20d74b31dff5ca6ac7b
> Reviewed-on: http://hnd-swgit.sj.broadcom.com:8080/8156

These 2 lines are rather useless.


> Reviewed-by: brcm80211 ci <brcm80211-ci@broadcom.com>

Please use full names only.


> Reviewed-by: Arend Van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c  | 7 +++++++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c  | 2 +-
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h | 9 +++++++++
>  3 files changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
> index 92eafcc..bc24b00 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
> @@ -417,6 +417,12 @@ static void brcmf_proto_bcdc_rxreorder(struct brcmf_if *ifp,
>  	brcmf_fws_reset_interface(ifp);
>  }
>
> +static int
> +brcmf_proto_bcdc_init_done(struct brcmf_pub *drvr)
> +{
> +	return brcmf_fws_init(drvr);
> +}
> +
>  int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
>  {
>  	struct brcmf_bcdc *bcdc;
> @@ -443,6 +449,7 @@ int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
>  	drvr->proto->add_if = brcmf_proto_bcdc_add_if;
>  	drvr->proto->del_if = brcmf_proto_bcdc_del_if;
>  	drvr->proto->reset_if = brcmf_proto_bcdc_reset_if;
> +	drvr->proto->init_done = brcmf_proto_bcdc_init_done;
>  	drvr->proto->pd = bcdc;
>
>  	drvr->hdrlen += BCDC_HEADER_LEN + BRCMF_PROT_FW_SIGNAL_MAX_TXBYTES;
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> index 60c6c78..9886280 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> @@ -986,7 +986,7 @@ int brcmf_bus_started(struct device *dev)
>  	}
>  	brcmf_feat_attach(drvr);
>
> -	ret = brcmf_fws_init(drvr);
> +	ret = brcmf_proto_init_done(drvr);
>  	if (ret < 0)
>  		goto fail;
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
> index 3048ed5..600fd33 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
> @@ -47,6 +47,7 @@ struct brcmf_proto {
>  	void (*add_if)(struct brcmf_if *ifp);
>  	void (*del_if)(struct brcmf_if *ifp);
>  	void (*reset_if)(struct brcmf_if *ifp);
> +	int (*init_done)(struct brcmf_pub *drvr);
>  	void *pd;
>  };
>
> @@ -145,4 +146,12 @@ static inline bool brcmf_proto_is_reorder_skb(struct sk_buff *skb)
>  	drvr->proto->reset_if(ifp);
>  }
>
> +static inline int
> +brcmf_proto_init_done(struct brcmf_pub *drvr)
> +{
> +	if (!drvr->proto->init_done)
> +		return 0;
> +	return drvr->proto->init_done(drvr);
> +}
> +
>  #endif /* BRCMFMAC_PROTO_H */

So how is it any different from change in my:
[PATCH] brcmfmac: wrap brcmf_fws_(de)init into bcdc layer
? Is it only about replacing "init" with "init_done"?

I don't see why you couldn't rebase your changes on top of my patch.
