Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.u-psud.fr ([129.175.33.41]:53750 "EHLO smtp1.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab2LJKnR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 05:43:17 -0500
Message-ID: <50C5BCC3.8090809@lri.fr> (sfid-20121210_114321_001399_3DB41361)
Date: Mon, 10 Dec 2012 11:43:15 +0100
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Antonio Quartulli <antonio@open-mesh.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: in AD-HOC mode wait for the AUTH response
References: <1355134917-17705-1-git-send-email-antonio@open-mesh.com> <1355134917-17705-2-git-send-email-antonio@open-mesh.com>
In-Reply-To: <1355134917-17705-2-git-send-email-antonio@open-mesh.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/12/2012 11:21, Antonio Quartulli wrote:
> To prevent race conditions between kernel state and
> user-space application knowledge, it is better to wait for
> a new peer to be completely authenticated before telling the
> userspace that it is ready to start authorization
> (IBSS/RSN).
> 
> Use the IBSS_STA event to tell userspace when a station is
> authenticated and ready.
> 
> It could still be the case that the other node joining the
> AD-HOC cell does not implement AUTH messages exchange,
> therefore a fallback mechanism will authenticate the peer
> after a timeout set for the purpose expires
> 
> Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
> ---
>  net/mac80211/ibss.c     | 97 ++++++++++++++++++++++++++++++++++++++++---------
>  net/mac80211/sta_info.h |  2 +
>  2 files changed, 81 insertions(+), 18 deletions(-)
> 
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index 700d0ed..9a11ec3 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -30,6 +30,7 @@
>  
>  #define IEEE80211_IBSS_MERGE_INTERVAL (30 * HZ)
>  #define IEEE80211_IBSS_INACTIVITY_LIMIT (60 * HZ)
> +#define IEEE80211_IBSS_AUTH_TIMEOUT (HZ / 2)
>  
>  #define IEEE80211_IBSS_MAX_STA_ENTRIES 128
>  
> @@ -273,8 +274,7 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>  				  false);
>  }
>  
> -static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta,
> -						  bool auth)
> +static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta)
>  	__acquires(RCU)
>  {
>  	struct ieee80211_sub_if_data *sdata = sta->sdata;
> @@ -284,19 +284,12 @@ static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta,
>  
>  	ibss_dbg(sdata, "Adding new IBSS station %pM\n", addr);
>  
> -	sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
> -	sta_info_pre_move_state(sta, IEEE80211_STA_ASSOC);
> -	/* authorize the station only if the network is not RSN protected. If
> -	 * not wait for the userspace to authorize it */
> -	if (!sta->sdata->u.ibss.control_port)
> -		sta_info_pre_move_state(sta, IEEE80211_STA_AUTHORIZED);
> -
>  	rate_control_rate_init(sta);
>  
>  	/* If it fails, maybe we raced another insertion? */
>  	if (sta_info_insert_rcu(sta))
>  		return sta_info_get(sdata, addr);
> -	if (auth && !sdata->u.ibss.auth_frame_registrations) {
> +	if (!sdata->u.ibss.auth_frame_registrations) {
>  		ibss_dbg(sdata,
>  			 "TX Auth SA=%pM DA=%pM BSSID=%pM (auth_transaction=1)\n",
>  			 sdata->vif.addr, addr, sdata->u.ibss.bssid);

If userspace registered for auth frames, then we shouldn't wait for auth responses,
as this code will never see them.

I'm also curious about compatibility with the current wpa_supplicant which does not know
about that new event.
