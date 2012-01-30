Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zmc.proxad.net ([212.27.53.206]:45007 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab2A3RZg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 12:25:36 -0500
Message-ID: <4F26D27A.9010909@freebox.fr> (sfid-20120130_182554_187837_3BB2ED81)
Date: Mon, 30 Jan 2012 18:25:14 +0100
From: Florian Fainelli <ffainelli@freebox.fr>
MIME-Version: 1.0
To: Yogesh Ashok Powar <yogeshp@marvell.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH] mwl8k: Configuring correct MAC address in broadcast key
References: <20120127130434.GA5718@hertz.marvell.com>
In-Reply-To: <20120127130434.GA5718@hertz.marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On 01/27/12 14:04, Yogesh Ashok Powar wrote:
> While configuring the broadcast key in the hardware, in
> multi-BSS environment, BSSes other than first were
> incorrectly configured with the MAC address of first
> BSS. Fixing it with correct MAC addresses.
>
> Signed-off-by: Yogesh Ashok Powar<yogeshp@marvell.com>
> ---
> (resent to include the linux-wireless list)

You might want to get this fix included for the stable 3.0, 3.1 and 3.2 
releases since mwl8k_set_key() was introduced in 2.6.39 with:
fcdc403c31ed5bb5f3baf42f4e2b5e7198fef0c0: mwl8k: Enable HW encryption 
for AP mode

>
>
>   drivers/net/wireless/mwl8k.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
> index dd5aeaf..fd12547 100644
> --- a/drivers/net/wireless/mwl8k.c
> +++ b/drivers/net/wireless/mwl8k.c
> @@ -4093,7 +4093,7 @@ static int mwl8k_set_key(struct ieee80211_hw *hw,
>   		return -EOPNOTSUPP;
>
>   	if (sta == NULL)
> -		addr = hw->wiphy->perm_addr;
> +		addr = vif->addr;
>   	else
>   		addr = sta->addr;
>
