Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:37044 "EHLO
        li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932659AbeCSLTh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Mar 2018 07:19:37 -0400
Date: Mon, 19 Mar 2018 13:09:56 +0200
From: Jouni Malinen <j@w1.fi>
To: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 1/3] mac80211_hwsim: add permanent mac address option
 for new radios
Message-ID: <20180319110956.GA11426@w1.fi> (sfid-20180319_121941_476616_A0A95E82)
References: <20180122170437.14213-1-benjamin.beichler@uni-rostock.de>
 <20180122170437.14213-2-benjamin.beichler@uni-rostock.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180122170437.14213-2-benjamin.beichler@uni-rostock.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 22, 2018 at 06:04:35PM +0100, Benjamin Beichler wrote:
> If simulation needs predictable permanent mac addresses of hwsim wireless
> phy, this patch add the ability to create a new radio with a user defined
> permanent mac address. Allowed mac addresses needs to be locally
> administrated mac addresses (as also the former fixed 42:* and 02:* were).
> 
> To do not break the operation with legacy software using hwsim, the new
> address is set twice. The problem here is, the netlink call backs use
> wiphy->addresses[1] as identification of a radio and not the proposed
> permanent address (wiphy->addresses[0]). This design decision is not
> documented in the kernel repo, therefore this patch simply reproduces this,
> but with the same address.

But this patch does break operation with legacy software.. Namely, some
mac80211_hwsim test cases in hostap.git. However, that seems to be due
to a strange swapping of operations here:

> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> @@ -2571,15 +2573,25 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,

> -	eth_zero_addr(addr);
> -	addr[0] = 0x02;
> -	addr[3] = idx >> 8;
> -	addr[4] = idx;
> -	memcpy(data->addresses[0].addr, addr, ETH_ALEN);
> -	memcpy(data->addresses[1].addr, addr, ETH_ALEN);
> -	data->addresses[1].addr[0] |= 0x40;
> -	hw->wiphy->n_addresses = 2;
> -	hw->wiphy->addresses = data->addresses;
> +	if (!param->perm_addr) {
> +		eth_zero_addr(addr);
> +		addr[0] = 0x02;
> +		addr[3] = idx >> 8;
> +		addr[4] = idx;
> +		memcpy(data->addresses[0].addr, addr, ETH_ALEN);
> +		/* Why need here second address ? */
> +		data->addresses[1].addr[0] |= 0x40;
> +		memcpy(data->addresses[1].addr, addr, ETH_ALEN);
> +		hw->wiphy->n_addresses = 2;
> +		hw->wiphy->addresses = data->addresses;

Why did that ORing of 0x40 got moved to be before the memcpy()?
Effectively, that removes the OR operation completely since the
following memcpy() overrides the first octets of
data->addresses[1].addr. Restoring the order of those two lines seems to
fix the behavior.

-- 
Jouni Malinen                                            PGP id EFC895FA
