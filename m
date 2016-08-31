Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33903 "EHLO
        mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753070AbcHaTkJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Aug 2016 15:40:09 -0400
Received: by mail-pa0-f46.google.com with SMTP id fi15so21520698pac.1
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2016 12:40:08 -0700 (PDT)
Date: Wed, 31 Aug 2016 12:40:05 -0700
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [v4,2/2] mwifiex: add cfg80211 testmode support
Message-ID: <20160831194003.GA31478@localhost> (sfid-20160831_214027_342324_D13B4CF1)
References: <1469525960-6643-2-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1469525960-6643-2-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 26, 2016 at 03:09:20PM +0530, Amitkumar Karwar wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> This patch adds cfg80211 testmode support so that userspace tools can
> download necessary commands to firmware during manufacturing mode tests.
> 
> Signed-off-by: Xinming <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
> v4: Used cfg80211 testmode interface instead of wext in 2/2 patch.(Kalle Valo)
> v3: Add "select WIRELESS_EXT" in Kconfig to resolve kbuild test robot errors.
>     WEXT_PRIV seems to have a dependency with WIRELESS_EXT.
> v2: 1) Sequence of these two patches are changed to resolve compilation
>     error seen if only 1/2 is applied.
>     2) Add "select WEXT_PRIV" in Kconfig to resolve warnings reported by
>     kbuild test robot.
> ---
>  drivers/net/wireless/marvell/mwifiex/cfg80211.c | 83 +++++++++++++++++++++++++
>  1 file changed, 83 insertions(+)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> index 235fb39..86b31b1 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> @@ -3919,6 +3919,88 @@ static int mwifiex_cfg80211_get_channel(struct wiphy *wiphy,
>  	return ret;
>  }
>  
> +#ifdef CONFIG_NL80211_TESTMODE
> +
> +enum mwifiex_tm_attr {
> +	__MWIFIEX_TM_ATTR_INVALID	= 0,
> +	MWIFIEX_TM_ATTR_CMD		= 1,
> +	MWIFIEX_TM_ATTR_DATA		= 2,
> +
> +	/* keep last */
> +	__MWIFIEX_TM_ATTR_AFTER_LAST,
> +	MWIFIEX_TM_ATTR_MAX		= __MWIFIEX_TM_ATTR_AFTER_LAST - 1,
> +};
> +
> +static const struct nla_policy mwifiex_tm_policy[MWIFIEX_TM_ATTR_MAX + 1] = {
> +	[MWIFIEX_TM_ATTR_CMD]		= { .type = NLA_U32 },
> +	[MWIFIEX_TM_ATTR_DATA]		= { .type = NLA_BINARY,
> +					    .len = MWIFIEX_SIZE_OF_CMD_BUFFER },
> +};
> +
> +enum mwifiex_tm_cmd {
> +	MWIFIEX_TM_CMD_HOSTCMD	= 0,
> +};
> +
> +int mwifiex_tm_cmd(struct wiphy *wiphy, struct wireless_dev *wdev,

This function should be static, no?

Brian

> +		   void *data, int len)
> +{
> +	struct mwifiex_private *priv = mwifiex_netdev_get_priv(wdev->netdev);
> +	struct mwifiex_ds_misc_cmd *hostcmd;
> +	struct nlattr *tb[MWIFIEX_TM_ATTR_MAX + 1];
> +	struct mwifiex_adapter *adapter;
> +	struct sk_buff *skb;
> +	int err;
> +
> +	if (!priv)
> +		return -EINVAL;
> +	adapter = priv->adapter;
> +
> +	err = nla_parse(tb, MWIFIEX_TM_ATTR_MAX, data, len,
> +			mwifiex_tm_policy);
> +	if (err)
> +		return err;
> +
> +	if (!tb[MWIFIEX_TM_ATTR_CMD])
> +		return -EINVAL;
> +
> +	switch (nla_get_u32(tb[MWIFIEX_TM_ATTR_CMD])) {
> +	case MWIFIEX_TM_CMD_HOSTCMD:
> +		if (!tb[MWIFIEX_TM_ATTR_DATA])
> +			return -EINVAL;
> +
> +		hostcmd = kzalloc(sizeof(*hostcmd), GFP_KERNEL);
> +		if (!hostcmd)
> +			return -ENOMEM;
> +
> +		hostcmd->len = nla_len(tb[MWIFIEX_TM_ATTR_DATA]);
> +		memcpy(hostcmd->cmd, nla_data(tb[MWIFIEX_TM_ATTR_DATA]),
> +		       hostcmd->len);
> +
> +		if (mwifiex_send_cmd(priv, 0, 0, 0, hostcmd, true)) {
> +			dev_err(priv->adapter->dev, "Failed to process hostcmd\n");
> +			return -EFAULT;
> +		}
> +
> +		/* process hostcmd response*/
> +		skb = cfg80211_testmode_alloc_reply_skb(wiphy, hostcmd->len);
> +		if (!skb)
> +			return -ENOMEM;
> +		err = nla_put(skb, MWIFIEX_TM_ATTR_DATA,
> +			      hostcmd->len, hostcmd->cmd);
> +		if (err) {
> +			kfree_skb(skb);
> +			return -EMSGSIZE;
> +		}
> +
> +		err = cfg80211_testmode_reply(skb);
> +		kfree(hostcmd);
> +		return err;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +#endif
> +
>  static int
>  mwifiex_cfg80211_start_radar_detection(struct wiphy *wiphy,
>  				       struct net_device *dev,
> @@ -4031,6 +4113,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
>  	.tdls_cancel_channel_switch = mwifiex_cfg80211_tdls_cancel_chan_switch,
>  	.add_station = mwifiex_cfg80211_add_station,
>  	.change_station = mwifiex_cfg80211_change_station,
> +	CFG80211_TESTMODE_CMD(mwifiex_tm_cmd)
>  	.get_channel = mwifiex_cfg80211_get_channel,
>  	.start_radar_detection = mwifiex_cfg80211_start_radar_detection,
>  	.channel_switch = mwifiex_cfg80211_channel_switch,
