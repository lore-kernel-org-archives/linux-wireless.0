Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46951 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab1KXPWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 10:22:30 -0500
Subject: Re: [RFC 2/2] cfg80211: amend regulatory NULL dereference fix
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@vger.kernel.org
In-Reply-To: <1322060687-6512-3-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111123_160529_165324_6E4AEB51)
References: <1322060687-6512-1-git-send-email-mcgrof@qca.qualcomm.com>
	 <1322060687-6512-3-git-send-email-mcgrof@qca.qualcomm.com>
	 (sfid-20111123_160529_165324_6E4AEB51)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 16:22:22 +0100
Message-ID: <1322148142.5366.25.camel@jlt3.sipsolutions.net> (sfid-20111124_162234_047862_36CEBF82)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-23 at 10:04 -0500, Luis R. Rodriguez wrote:
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
> ---
>  net/wireless/reg.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index df73b96..6049050 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -2091,8 +2091,10 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
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

This seems OK to me, but the function is really hard to follow -- maybe
(later) we should take some code duplication and make it easier to read
by switching on the type of hint first?

johannes

