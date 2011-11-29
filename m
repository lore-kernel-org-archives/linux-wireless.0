Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54411 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1K2IlK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 03:41:10 -0500
Subject: Re: [PATCH v3 2/2] cfg80211: amend regulatory NULL dereference fix
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@vger.kernel.org
In-Reply-To: <1322516836-5474-2-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111128_224755_464917_59420C07)
References: <1322516836-5474-1-git-send-email-mcgrof@qca.qualcomm.com>
	 <1322516836-5474-2-git-send-email-mcgrof@qca.qualcomm.com>
	 (sfid-20111128_224755_464917_59420C07)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Nov 2011 09:41:05 +0100
Message-ID: <1322556065.4110.12.camel@jlt3.sipsolutions.net> (sfid-20111129_094114_468535_4191253F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-28 at 16:47 -0500, Luis R. Rodriguez wrote:
> Johannes' patch for "cfg80211: fix regulatory NULL dereference"
> broke user regulaotry hints and it did not address the fact that
> last_request was left populated even if the previous regulatory
> hint was stale due to the wiphy disappearing.
> 
> Fix user reguluatory hints by only bailing out if for those
> regulatory hints where a request_wiphy is expected. The stale last_request
> considerations are addressed through the previous fixes on last_request
> where we reset the last_request to a static world regdom request upon
> reset_regdomains(). In this case though we further enhance the effect
> by simply restoring reguluatory settings completely.
> 
> Cc: stable@vger.kernel.org
> Cc: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/wireless/reg.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index a5f0ac7..70b171a 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -2090,8 +2090,10 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
>  	}
>  
>  	request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
> -	if (!request_wiphy) {
> -		reg_set_request_processed();
> +	if (!request_wiphy &&
> +	    (last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER ||
> +	     last_request->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE)) {
> +		schedule_delayed_work(&reg_timeout, 0);
>  		return -ENODEV;
>  	}
>  


