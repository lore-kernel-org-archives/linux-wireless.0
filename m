Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1159 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926Ab2AETMb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 14:12:31 -0500
Message-ID: <4F05F60C.5030406@broadcom.com> (sfid-20120105_201234_971998_D1C9003C)
Date: Thu, 5 Jan 2012 20:12:12 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Stephen Hemminger" <shemminger@vyatta.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: Re: [PATCH 2/2] brcmfmac: use existing net_device_stats
References: <20120105183947.295358582@vyatta.com>
 <20120105184000.572918423@vyatta.com>
In-Reply-To: <20120105184000.572918423@vyatta.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/05/2012 07:39 PM, Stephen Hemminger wrote:
> Minor space savings. Compile tested only.
> 

This is actually not going to work. The struct brcmf_if represents
individual interfaces which each have their own device statistics.

> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> 
> --- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c	2012-01-05 10:02:57.488495190 -0800
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c	2012-01-05 10:09:58.536972268 -0800
> @@ -56,7 +56,6 @@ struct brcmf_if {
>  	struct brcmf_info *info;	/* back pointer to brcmf_info */
>  	/* OS/stack specifics */
>  	struct net_device *ndev;
> -	struct net_device_stats stats;
>  	int idx;		/* iface idx in dongle */
>  	int state;		/* interface state */
>  	u8 mac_addr[ETH_ALEN];	/* assigned MAC address */
> @@ -526,7 +525,6 @@ static struct net_device_stats *brcmf_ne
>  {
>  	struct brcmf_info *drvr_priv = *(struct brcmf_info **)
>  					netdev_priv(ndev);
> -	struct brcmf_if *ifp;
>  	int ifidx;
>  

Gr. AvS

