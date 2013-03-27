Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50964 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab3C0Raq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 13:30:46 -0400
Date: Wed, 27 Mar 2013 13:27:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 1/2] b43: mark some functions and structs static
Message-ID: <20130327172740.GE1868@tuxdriver.com> (sfid-20130327_183052_749790_6E37EA47)
References: <1364400951-25488-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1364400951-25488-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 27, 2013 at 05:15:50PM +0100, Hauke Mehrtens wrote:
> This fixes some sparse warnings.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/wireless/b43/phy_n.c          |    6 ++++--
>  drivers/net/wireless/b43/radio_2056.c     |    2 +-
>  drivers/net/wireless/b43/sdio.h           |    4 ++--
>  drivers/net/wireless/b43/tables_nphy.c    |    4 ++--
>  drivers/net/wireless/b43/tables_phy_lcn.c |    6 +++---
>  5 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
> index 1ec0d69..8d15878 100644
> --- a/drivers/net/wireless/b43/phy_n.c
> +++ b/drivers/net/wireless/b43/phy_n.c
> @@ -2789,9 +2789,11 @@ static void b43_nphy_iq_cal_gain_params(struct b43_wldev *dev, u16 core,
>   * Tx and Rx
>   **************************************************/
>  
> -void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
> +#if 0
> +static void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
>  {//TODO
>  }
> +#endif
>  
>  static void b43_nphy_op_adjust_txpower(struct b43_wldev *dev)
>  {//TODO

If this isn't necessary, why not just remove it?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
