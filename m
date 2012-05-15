Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4570 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279Ab2EOOYd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 10:24:33 -0400
Message-ID: <4FB26714.6020008@broadcom.com> (sfid-20120515_162448_104040_DC7F43E1)
Date: Tue, 15 May 2012 16:24:20 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <dan.carpenter@oracle.com>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] brcm80211: remove an unneeded NULL check
References: <20120514205729.GD20836@elgon.mountain>
In-Reply-To: <20120514205729.GD20836@elgon.mountain>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/14/2012 10:57 PM, Dan Carpenter wrote:
> This code causes a static checker warning because "pi" gets dereferenced
> before it is checked.  The dereference is inside the write_phy_reg()
> function which is called from wlc_phy_write_txmacreg_nphy().
> 
> This code is only called from wlc_phy_init_nphy() and "pi" is a
> valid pointer so we can remove the check for NULL.

Acked-by: Arend van Spriel <arend@broadcom.com>

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
> index 812b6e3..d6380f3 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
> @@ -14358,7 +14358,7 @@ void wlc_phy_nphy_tkip_rifs_war(struct brcms_phy *pi, u8 rifs)
>  
>  	wlc_phy_write_txmacreg_nphy(pi, holdoff, delay);
>  
> -	if (pi && pi->sh && (pi->sh->_rifs_phy != rifs))
> +	if (pi->sh && (pi->sh->_rifs_phy != rifs))
>  		pi->sh->_rifs_phy = rifs;
>  }
>  
> 


