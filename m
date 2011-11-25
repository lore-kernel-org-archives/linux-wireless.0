Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:61415 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab1KYUAb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 15:00:31 -0500
From: Timo Lindhorst <tlnd@online.de>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: Re: [RFC 1/2] cfg80211: fix race on init and driver registration
Date: Fri, 25 Nov 2011 20:59:44 +0100
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, stable@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
References: <1322060687-6512-1-git-send-email-mcgrof@qca.qualcomm.com> <1322060687-6512-2-git-send-email-mcgrof@qca.qualcomm.com>
In-Reply-To: <1322060687-6512-2-git-send-email-mcgrof@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201111252059.44293.tlnd@online.de> (sfid-20111125_210042_833686_E170515E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 23. November 2011, 16:04:46 schrieb Luis R. Rodriguez:
> There is a theoretical race that if hit will trigger
> a crash. The race is between when we issue the first
> regulatory hint, regulatory_hint_core(), gets processed
> by the workqueue and between when the first device
> gets registered to the wireless core. This is not easy
> to reproduce but it was easy to do so through the
> regulatory simulator I have been working on. This
> is a port of the fix I implemented there [1].
> 
> [1]
> https://github.com/mcgrof/regsim/commit/a246ccf81f059cb662eee288aa13100f63
> 1e4cc8
> 
> Cc: stable@vger.kernel.org
> Cc: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
> ---
>  net/wireless/reg.c |   28 ++++++++++++++++++++--------
>  1 files changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 76b35df..df73b96 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -57,8 +57,17 @@
>  #define REG_DBG_PRINT(args...)
>  #endif
> 
> +static struct regulatory_request core_request_world = {
> +	.initiator = NL80211_REGDOM_SET_BY_CORE,
> +	.alpha2[0] = '0',
> +	.alpha2[1] = '0',
> +	.intersect = false,
> +	.processed = true,
> +	.country_ie_env = ENVIRON_ANY,
> +};
> +
>  /* Receipt of information from last regulatory request */
> -static struct regulatory_request *last_request;
> +static struct regulatory_request *last_request = &core_request_world;
> 
>  /* To trigger userspace events */
>  static struct platform_device *reg_pdev;
> @@ -165,6 +174,10 @@ static void reset_regdomains(void)
> 
>  	cfg80211_world_regdom = &world_regdom;
>  	cfg80211_regdomain = NULL;
> +
> +	if (last_request != &core_request_world)
> +		kfree(last_request);
> +	last_request = &core_request_world;
>  }
This breaks setting the regdom correctly! reset_regdomains() is called from 
within set_regdom() (i.e. via __set_regdom()), however, the subsequent 
functions called within set_regdom() expect last_request to still hold the 
currently processed request:

	update_all_wiphy_regulatory(last_request->initiator);
	print_regdomain(cfg80211_regdomain);
	nl80211_send_reg_change_event(last_request);
	reg_set_request_processed();

This, for instance, prevents to set the regdom from userspace -- or precisely: 
the regdom is set, but the reg_timeout worker restores the settings after the 
timeout, which is not canceled as intended within reg_set_request_processed(), 
since last_request->initiator is not NL80211_REGDOM_SET_BY_USER anymore as 
last_request was reset to &core_request_world.

The targeted race condition is already solved by letting last_request 
initially point to the static core_request_world, isn't it? I'd thus suggest 
not to touch last_request from within reset_regdomains().


> @@ -1409,7 +1422,8 @@ static int __regulatory_hint(struct wiphy *wiphy,
>  	}
> 
>  new_request:
> -	kfree(last_request);
> +	if (last_request != &core_request_world)
> +		kfree(last_request);
> 
>  	last_request = pending_request;
>  	last_request->intersect = intersect;
> @@ -1579,9 +1593,6 @@ static int regulatory_hint_core(const char *alpha2)
>  {
>  	struct regulatory_request *request;
> 
> -	kfree(last_request);
> -	last_request = NULL;
> -
>  	request = kzalloc(sizeof(struct regulatory_request),
>  			  GFP_KERNEL);
>  	if (!request)
> @@ -1823,6 +1834,10 @@ static void restore_regulatory_settings(bool
> reset_user) /* First restore to the basic regulatory settings */
>  	cfg80211_regdomain = cfg80211_world_regdom;
> 
> +	if (last_request != &core_request_world)
> +		kfree(last_request);
> +	last_request = &core_request_world;
> +
>  	mutex_unlock(&reg_mutex);
>  	mutex_unlock(&cfg80211_mutex);
> 
> @@ -2306,9 +2321,6 @@ void /* __init_or_exit */ regulatory_exit(void)
> 
>  	reset_regdomains();
> 
> -	kfree(last_request);
> -
> -	last_request = NULL;
We hence need to free last_request here if necessary:
-       kfree(last_request);
+       if (last_request != &core_request_world)
+               kfree(last_request);
 
-       last_request = NULL;


Regards,
Timo
