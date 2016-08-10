Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36236 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934593AbcHJTxV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 15:53:21 -0400
Received: by mail-pa0-f42.google.com with SMTP id pp5so18556844pac.3
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2016 12:53:21 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: shut down AP and set IBSS mode only on primary
 interface
To: Wright Feng <wright.feng@cypress.com>,
	brcm80211-dev-list.pdl@broadcom.com, franky.lin@broadcom.com,
	hante.meuleman@broadcom.com, pieterpg@broadcom.com,
	chln@cypress.com, linux-wireless@vger.kernel.org,
	kvalo@codeaurora.org
References: <20160810080100.GA10783@cypress.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <4d60ec5e-6462-372a-2d3c-5770493e7e98@broadcom.com> (sfid-20160810_215332_799994_EF9601D9)
Date: Wed, 10 Aug 2016 10:26:16 +0200
MIME-Version: 1.0
In-Reply-To: <20160810080100.GA10783@cypress.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10-8-2016 10:01, Wright Feng wrote:
> When stopping hostap on virtual interface, driver will set INFRA and AP
> mode that may affect the functionality on primary interface. For example,
> if we create and stop hostapd on virtual interface then association
> cannot work on primary interface because INFRA mode has been set to IBSS.
> Hence we shut down AP and set IBSS mode only on primary interface.

What is actually the use-case here. Can you elaborate? BRCMF_C_DOWN
command turns out to be effectively bring the whole stack down and not
just the supplied interface. I suppose you are hitting that issue here
as well, right?

Regards,
Arend

> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 2628d5e..0687ab9 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -4716,6 +4716,8 @@ exit:
> 
>  static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
>  {
> +       struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
> +       struct net_device *primary_ndev = cfg_to_ndev(cfg);
>         struct brcmf_if *ifp = netdev_priv(ndev);
>         s32 err;
>         struct brcmf_fil_bss_enable_le bss_enable;
> @@ -4723,7 +4725,8 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
> 
>         brcmf_dbg(TRACE, "Enter\n");
> 
> -       if (ifp->vif->wdev.iftype == NL80211_IFTYPE_AP) {
> +       if ((ifp->vif->wdev.iftype == NL80211_IFTYPE_AP) &&
> +           (ndev == primary_ndev)) {
>                 /* Due to most likely deauths outstanding we sleep */
>                 /* first to make sure they get processed by fw. */
>                 msleep(400);
> --
> 1.9.1
> 
> 
> This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
> 
