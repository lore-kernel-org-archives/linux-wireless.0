Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:48973 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756079Ab1KWWst convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 17:48:49 -0500
From: Bing Zhao <bzhao@marvell.com>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>
Date: Wed, 23 Nov 2011 14:48:45 -0800
Subject: RE: [RFC 5/5] mwifiex: fix usage of set tx power
Message-ID: <477F20668A386D41ADCC57781B1F70430818351F4B@SC-VEXCH1.marvell.com> (sfid-20111123_234852_601664_AC7F8AFC)
References: <1322064521-16540-1-git-send-email-mcgrof@qca.qualcomm.com>
In-Reply-To: <1322064521-16540-1-git-send-email-mcgrof@qca.qualcomm.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

> Subject: [RFC 5/5] mwifiex: fix usage of set tx power
> 
> mBm is passed but dBm was assumed...
> 
> Cc: Bing Zhao <bzhao@marvell.com>
> Cc: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/cfg80211.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
> index e9ab9a3..0db97cc 100644
> --- a/drivers/net/wireless/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/mwifiex/cfg80211.c
> @@ -120,10 +120,11 @@ mwifiex_cfg80211_del_key(struct wiphy *wiphy, struct net_device *netdev,
>  static int
>  mwifiex_cfg80211_set_tx_power(struct wiphy *wiphy,
>  			      enum nl80211_tx_power_setting type,
> -			      int dbm)
> +			      int mbm)
>  {
>  	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
>  	struct mwifiex_power_cfg power_cfg;
> +	int dbm = MBM_TO_DBM(mbm);
> 
>  	if (type == NL80211_TX_POWER_FIXED) {
>  		power_cfg.is_power_auto = 0;
> --
> 1.7.4.15.g7811d

