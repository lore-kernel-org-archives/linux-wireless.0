Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57468 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758636Ab2CFI3T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 03:29:19 -0500
Subject: Re: [PATCHv6 2/2] mac80211: Modify tsf via debugfs in mesh
 interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
In-Reply-To: <1330996838-18960-2-git-send-email-javier@cozybit.com> (sfid-20120306_022119_126257_D7F5EBF0)
References: <1330996838-18960-1-git-send-email-javier@cozybit.com>
	 <1330996838-18960-2-git-send-email-javier@cozybit.com>
	 (sfid-20120306_022119_126257_D7F5EBF0)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Mar 2012 09:29:16 +0100
Message-ID: <1331022556.3447.1.camel@jlt3.sipsolutions.net> (sfid-20120306_092922_865038_0B575D79)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-05 at 17:20 -0800, Javier Cardona wrote:
> Signed-off-by: Javier Cardona <javier@cozybit.com>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  drivers/net/wireless/mac80211_hwsim.c |   18 ++++++++++++++++++
>  net/mac80211/debugfs_netdev.c         |    7 ++++++-
>  2 files changed, 24 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index f4bcd03..99909bd 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -379,6 +379,22 @@ static __le64 __mac80211_hwsim_get_tsf(struct mac80211_hwsim_data *data)
>  	return cpu_to_le64(now + data->tsf_offset);
>  }
>  
> +static u64 mac80211_hwsim_get_tsf(struct ieee80211_hw *hw,
> +		struct ieee80211_vif *vif)
> +{
> +	struct mac80211_hwsim_data *data = hw->priv;
> +	return le64_to_cpu(__mac80211_hwsim_get_tsf(data));
> +}
> +
> +static void mac80211_hwsim_set_tsf(struct ieee80211_hw *hw,
> +		struct ieee80211_vif *vif, u64 tsf)
> +{
> +	struct mac80211_hwsim_data *data = hw->priv;
> +	struct timeval tv = ktime_to_timeval(ktime_get_real());
> +	u64 now = tv.tv_sec * USEC_PER_SEC + tv.tv_usec;
> +	data->tsf_offset = tsf - now;
> +}
> +
>  static void mac80211_hwsim_monitor_rx(struct ieee80211_hw *hw,
>  				      struct sk_buff *tx_skb)
>  {
> @@ -1224,6 +1240,8 @@ static struct ieee80211_ops mac80211_hwsim_ops =
>  	.sw_scan_start = mac80211_hwsim_sw_scan,
>  	.sw_scan_complete = mac80211_hwsim_sw_scan_complete,
>  	.flush = mac80211_hwsim_flush,
> +	.get_tsf = mac80211_hwsim_get_tsf,
> +	.set_tsf = mac80211_hwsim_set_tsf,
>  };
>  
> 
> diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
> index 510ed1d..416b906 100644
> --- a/net/mac80211/debugfs_netdev.c
> +++ b/net/mac80211/debugfs_netdev.c
> @@ -537,11 +537,15 @@ static void add_monitor_files(struct ieee80211_sub_if_data *sdata)
>  
>  #ifdef CONFIG_MAC80211_MESH
>  
> +static void add_mesh_files(struct ieee80211_sub_if_data *sdata)
> +{
> +	DEBUGFS_ADD_MODE(tsf, 0600);
> +}
> +
>  static void add_mesh_stats(struct ieee80211_sub_if_data *sdata)
>  {
>  	struct dentry *dir = debugfs_create_dir("mesh_stats",
>  						sdata->debugfs.dir);
> -
>  #define MESHSTATS_ADD(name)\
>  	debugfs_create_file(#name, 0400, dir, sdata, &name##_ops);
>  
> @@ -593,6 +597,7 @@ static void add_files(struct ieee80211_sub_if_data *sdata)
>  	switch (sdata->vif.type) {
>  	case NL80211_IFTYPE_MESH_POINT:
>  #ifdef CONFIG_MAC80211_MESH
> +		add_mesh_files(sdata);
>  		add_mesh_stats(sdata);
>  		add_mesh_config(sdata);
>  #endif


