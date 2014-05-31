Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43554 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaEaUYM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 16:24:12 -0400
Date: Sat, 31 May 2014 23:23:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	kernel-janitors@vger.kernel.org,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/11] net: wireless: Remove useless return variables
Message-ID: <20140531202351.GN15585@mwanda> (sfid-20140531_222427_560645_6787A986)
References: <1401542051-3174-6-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401542051-3174-6-git-send-email-peter.senna@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 31, 2014 at 10:14:06AM -0300, Peter Senna Tschudin wrote:
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
> index b0fd807..57ecc05 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
> @@ -1538,11 +1538,7 @@ static s8
>  wlc_user_txpwr_antport_to_rfport(struct brcms_phy *pi, uint chan, u32 band,
>  				 u8 rate)
>  {
> -	s8 offset = 0;
> -
> -	if (!pi->user_txpwr_at_rfport)
> -		return offset;
> -	return offset;
> +	return 0;
>  }

The original code looks buggy.  I wonder what it was supposed to do?

regards,
dan carpenter

