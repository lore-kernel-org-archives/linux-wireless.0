Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:59535 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab3BLR4k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 12:56:40 -0500
Received: by mail-bk0-f49.google.com with SMTP id w11so164010bku.36
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2013 09:56:39 -0800 (PST)
Message-ID: <511A8254.8060306@cozybit.com> (sfid-20130212_185644_270404_C008285F)
Date: Tue, 12 Feb 2013 18:56:36 +0100
From: Marco Porsch <marco@cozybit.com>
MIME-Version: 1.0
To: devel@lists.open80211s.org
CC: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] mac80211: consolidate MBSS change notification
References: <1360616843-24618-1-git-send-email-thomas@cozybit.com>
In-Reply-To: <1360616843-24618-1-git-send-email-thomas@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/11/2013 10:07 PM, Thomas Pedersen wrote:
> A few mesh utility functions will call
> ieee80211_bss_info_change_notify(), and then the caller
> might notify the driver of the same change again. Avoid
> this redundancy by propagating the BSS changes and
> generally calling bss_info_change_notify() once per
> change.
>
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---
>   net/mac80211/cfg.c        |   19 +++++++++++--------
>   net/mac80211/mesh.c       |    2 +-
>   net/mac80211/mesh.h       |   10 +++++-----
>   net/mac80211/mesh_plink.c |   33 ++++++++++++++++++---------------
>   net/mac80211/mesh_ps.c    |   24 ++++++++++++++++++------
>   5 files changed, 53 insertions(+), 35 deletions(-)

[...]

> diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
> index b677962..aa83eac 100644
> --- a/net/mac80211/mesh_ps.c
> +++ b/net/mac80211/mesh_ps.c
> @@ -74,14 +74,17 @@ static void mps_qos_null_tx(struct sta_info *sta)
>    * @sdata: local mesh subif
>    *
>    * sets the non-peer power mode and triggers the driver PS (re-)configuration
> + * Return BSS_CHANGED_BEACON if a beacon update is necessary.
>    */
> -void ieee80211_mps_local_status_update(struct ieee80211_sub_if_data *sdata)
> +u32 ieee80211_mps_local_status_update(struct ieee80211_sub_if_data *sdata)
>   {
>   	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
>   	struct sta_info *sta;
>   	bool peering = false;
>   	int light_sleep_cnt = 0;
>   	int deep_sleep_cnt = 0;
> +	u32 changed = 0;
> +	enum nl80211_mesh_power_mode nonpeer_pm;
>
>   	rcu_read_lock();
>   	list_for_each_entry_rcu(sta, &sdata->local->sta_list, list) {
> @@ -115,17 +118,25 @@ void ieee80211_mps_local_status_update(struct ieee80211_sub_if_data *sdata)
>   	 */
>   	if (peering) {
>   		mps_dbg(sdata, "setting non-peer PM to active for peering\n");
> -		ifmsh->nonpeer_pm = NL80211_MESH_POWER_ACTIVE;
> +		nonpeer_pm = NL80211_MESH_POWER_ACTIVE;
>   	} else if (light_sleep_cnt || deep_sleep_cnt) {
>   		mps_dbg(sdata, "setting non-peer PM to deep sleep\n");
> -		ifmsh->nonpeer_pm = NL80211_MESH_POWER_DEEP_SLEEP;
> +		nonpeer_pm = NL80211_MESH_POWER_DEEP_SLEEP;
>   	} else {
>   		mps_dbg(sdata, "setting non-peer PM to user value\n");
> -		ifmsh->nonpeer_pm = ifmsh->mshcfg.power_mode;
> +		nonpeer_pm = ifmsh->mshcfg.power_mode;
>   	}
>
> +	if (ifmsh->nonpeer_pm != nonpeer_pm ||
> +	    ifmsh->ps_peers_light_sleep != light_sleep_cnt ||
> +	    ifmsh->ps_peers_deep_sleep != deep_sleep_cnt)
> +		changed = BSS_CHANGED_BEACON;

Here it only affects the beacon if the number of light/deep sleep peers 
changed from/to zero or non-zero.
The following should avoid some unnecessary updates:

!ifmsh->ps_peers_deep_sleep != !deep_sleep_cnt ||
!ifmsh->ps_peers_deep_sleep != !deep_sleep_cnt)

> +
> +	ifmsh->nonpeer_pm = nonpeer_pm;
>   	ifmsh->ps_peers_light_sleep = light_sleep_cnt;
>   	ifmsh->ps_peers_deep_sleep = deep_sleep_cnt;
> +
> +	return changed;
>   }
>
>   /**

