Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51381 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760515AbcINQsX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 12:48:23 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: Re: [PATCH v2] mwifiex: cfg80211 set_default_mgmt_key handler
References: <1473428038-15308-1-git-send-email-akarwar@marvell.com>
Date: Wed, 14 Sep 2016 19:48:18 +0300
In-Reply-To: <1473428038-15308-1-git-send-email-akarwar@marvell.com>
        (Amitkumar Karwar's message of "Fri, 9 Sep 2016 19:03:58 +0530")
Message-ID: <87twdictrh.fsf@kamboji.qca.qualcomm.com> (sfid-20160914_184827_271204_8B32C400)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> From: Ganapathi Bhat <gbhat@marvell.com>
>
> Previously device used to start using IGTK key as Tx key as soon as it
> gets downloaded in add_key(). This patch implements set_default_mgmt_key
> handler. We will update Tx key ID in set_default_mgmt_key().
>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
> Changes in v2: v1 had a dummy handler. v2 addresses a corner case problem
> pointed by Jouni in which AP may send frames encrypted with new key when some
> of the stations are still using old key.
> ---
>  drivers/net/wireless/marvell/mwifiex/cfg80211.c | 25 +++++++++++++++++++++++++
>  drivers/net/wireless/marvell/mwifiex/fw.h       |  1 +
>  drivers/net/wireless/marvell/mwifiex/ioctl.h    |  1 +
>  drivers/net/wireless/marvell/mwifiex/sta_cmd.c  |  5 +++++
>  4 files changed, 32 insertions(+)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> index 0a03d3f..33e7a74 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> @@ -484,6 +484,30 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
>  }
>  
>  /*
> + * CFG802.11 operation handler to set default mgmt key.
> + */
> +static int
> +mwifiex_cfg80211_set_default_mgmt_key(struct wiphy *wiphy,
> +				      struct net_device *netdev,
> +				      u8 key_index)
> +{
> +	struct mwifiex_private *priv = mwifiex_netdev_get_priv(netdev);
> +	struct mwifiex_ds_encrypt_key encrypt_key;
> +	const u8 bc_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};

This should be static const, but...

> +	wiphy_dbg(wiphy, "set default mgmt key, key index=%d\n", key_index);
> +
> +	memset(&encrypt_key, 0, sizeof(struct mwifiex_ds_encrypt_key));
> +	encrypt_key.key_len = WLAN_KEY_LEN_CCMP;
> +	encrypt_key.key_index = key_index;
> +	encrypt_key.is_igtk_def_key = true;
> +	ether_addr_copy(encrypt_key.mac_addr, bc_mac);

...can't you use eth_broadcast_addr() here?

-- 
Kalle Valo
