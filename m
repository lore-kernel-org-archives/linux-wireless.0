Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:33678 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179AbaF3KyG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 06:54:06 -0400
Message-ID: <53B141CB.7010000@broadcom.com> (sfid-20140630_125410_374277_2B6ECC07)
Date: Mon, 30 Jun 2014 12:54:03 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	<linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
CC: <b43-dev@lists.infradead.org>
Subject: Re: [PATCH] b43: treat LCNXN-PHY as extra N-PHY devices
References: <1404071205-12568-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1404071205-12568-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29-06-14 21:46, Rafał Miłecki wrote:
> LCNXN is simply a continuation of N, e.g. code handling LCNXN revs 0 and
> 1 is mostly the same as for N-PHY revs 7+.

Hi Rafał,

LCNXN is actually a LCN phy with 2 streams (mimo).

Regards,
Arend

> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/net/wireless/b43/main.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> index 3e4333c..0b1aac4 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -4331,6 +4331,13 @@ static int b43_phy_versioning(struct b43_wldev *dev)
>  	analog_type = (tmp & B43_PHYVER_ANALOG) >> B43_PHYVER_ANALOG_SHIFT;
>  	phy_type = (tmp & B43_PHYVER_TYPE) >> B43_PHYVER_TYPE_SHIFT;
>  	phy_rev = (tmp & B43_PHYVER_VERSION);
> +
> +	/* LCNXN is continuation of N which run out of revisions */
> +	if (phy_type == B43_PHYTYPE_LCNXN) {
> +		phy_type = B43_PHYTYPE_N;
> +		phy_rev += 16;
> +	}
> +
>  	switch (phy_type) {
>  #ifdef CONFIG_B43_PHY_G
>  	case B43_PHYTYPE_G:
> 

