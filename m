Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0110.hostedemail.com ([216.40.44.110]:54477 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751711AbcFQLXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2016 07:23:20 -0400
Message-ID: <1466162594.19647.107.camel@perches.com> (sfid-20160617_132340_045637_8988DB87)
Subject: Re: [PATCH] brcmfmac: use const char * for interface name in
 brcmf_add_if
From: Joe Perches <joe@perches.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
	<linux-wireless@vger.kernel.org>,
	"open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
	<brcm80211-dev-list.pdl@broadcom.com>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Date: Fri, 17 Jun 2016 04:23:14 -0700
In-Reply-To: <1466160530-32626-1-git-send-email-zajec5@gmail.com>
References: <1464378815-23282-1-git-send-email-zajec5@gmail.com>
	 <1466160530-32626-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-06-17 at 12:48 +0200, Rafał Miłecki wrote:
> This function can work just fine with const pointer, it only calls
> alloc_netdev which take const as well. Moreover it makes this function
> more flexible as some cfg80211 callback may provide const char * as
> well, e.g. add_virtual_intf. This will be needed for more advanced
> interface management.
[]
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
[]
> @@ -638,7 +638,7 @@ fail:
>  }
>  
>  struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
> -			      bool is_p2pdev, char *name, u8 *mac_addr)
> +			      bool is_p2pdev, const char *name, u8 *mac_addr)

Looks like mac_addr should be const too

>  {
>  	struct brcmf_if *ifp;
>  	struct net_device *ndev;
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
[]
> @@ -215,7 +215,7 @@ char *brcmf_ifname(struct brcmf_if *ifp);
>  struct brcmf_if *brcmf_get_ifp(struct brcmf_pub *drvr, int ifidx);
>  int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked);
>  struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
> -			      bool is_p2pdev, char *name, u8 *mac_addr);
> +			      bool is_p2pdev, const char *name, u8 *mac_addr);
>  void brcmf_remove_interface(struct brcmf_if *ifp, bool rtnl_locked);
>  void brcmf_txflowblock_if(struct brcmf_if *ifp,
>  			  enum brcmf_netif_stop_reason reason, bool state);
