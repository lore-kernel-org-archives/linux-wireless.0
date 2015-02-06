Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbbBFX6F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 18:58:05 -0500
Date: Sat, 7 Feb 2015 00:58:02 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, ArikX Nemtsov <arik@wizery.com>
Subject: Re: [PATCH v4 1/2] cfg80211: Add API to change the indoor
	regulatory setting
Message-ID: <20150206235802.GA19988@wotan.suse.de> (sfid-20150207_005853_217286_A91B873D)
References: <1422889166-29386-1-git-send-email-ilan.peer@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422889166-29386-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 02, 2015 at 09:59:25AM -0500, Ilan Peer wrote:
> As the operating environment of a device can change, add
> API for user space to indicate a change of indoor settings.
> In addition modify the handling of the indoor processing as
> follows:
> 
> 1. Directly update the indoor setting without wrapping it as a
>    regulatory request.

Why? We have this present as part of the request as it was part
of the country IE, that's all. I can see for instance then that
it is wise to require the supplicant for instance to be still
connected to the AP and the socket tracking as solution to the
problem. Does that summarize the logic ?

> 2. Track the socket on which the indoor hint is issued, and reset
>    indoor setting if the socket was released. The motivation here is to
>    force a user space process that sets the indoor setting to constantly
>    monitor this setting, and be responsible to correctly toggling it,
>    so indoor operation will not be enabled uncontrolled.

That seems to imply a new requirement for something that used to work,
what having an option to set this requirement?

> 3. Do not reset the indoor setting when restoring the regulatory
>    settings as it has nothing to do with CRDA or interface
>    disconnection.

I disagree, if we disconnect we want the more restrictive setting
and if we put the indoor setting out of general regulatory requests
then we do want to reset this no?

> Signed-off-by: Ilan Peer <ilan.peer@intel.com>
> Signed-off-by: ArikX Nemtsov <arik@wizery.com>
> ---
>  include/uapi/linux/nl80211.h |  5 +++
>  net/wireless/nl80211.c       | 10 +++++-
>  net/wireless/reg.c           | 80 +++++++++++++++++++++++++-------------------
>  net/wireless/reg.h           | 15 ++++++++-
>  4 files changed, 73 insertions(+), 37 deletions(-)
> 
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 68b294e..d80edcc 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -1739,6 +1739,9 @@ enum nl80211_commands {
>   *
>   * @NL80211_ATTR_SCHED_SCAN_DELAY: delay before a scheduled scan (or a
>   *	WoWLAN net-detect scan) is started, u32 in seconds.
> +
> + * @NL80211_ATTR_REG_INDOOR: flag attribute, if set indicates that the device
> + *      is operating in an indoor environment.
>   *
>   * @NUM_NL80211_ATTR: total number of nl80211_attrs available
>   * @NL80211_ATTR_MAX: highest attribute number currently defined
> @@ -2107,6 +2110,8 @@ enum nl80211_attrs {
>  
>  	NL80211_ATTR_SCHED_SCAN_DELAY,
>  
> +	NL80211_ATTR_REG_INDOOR,
> +
>  	/* add attributes here, update the policy in nl80211.c */
>  
>  	__NL80211_ATTR_AFTER_LAST,
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 454d7a0..e78b096 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -399,6 +399,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
>  	[NL80211_ATTR_WIPHY_SELF_MANAGED_REG] = { .type = NLA_FLAG },
>  	[NL80211_ATTR_NETNS_FD] = { .type = NLA_U32 },
>  	[NL80211_ATTR_SCHED_SCAN_DELAY] = { .type = NLA_U32 },
> +	[NL80211_ATTR_REG_INDOOR] = { .type = NLA_FLAG },
>  };
>  
>  /* policy for the key attributes */
> @@ -4955,6 +4956,7 @@ static int parse_reg_rule(struct nlattr *tb[],
>  static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
>  {
>  	char *data = NULL;
> +	bool is_indoor;
>  	enum nl80211_user_reg_hint_type user_reg_hint_type;
>  
>  	/*
> @@ -4981,7 +4983,8 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
>  		data = nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
>  		return regulatory_hint_user(data, user_reg_hint_type);
>  	case NL80211_USER_REG_HINT_INDOOR:
> -		return regulatory_hint_indoor_user();
> +		is_indoor = !!info->attrs[NL80211_ATTR_REG_INDOOR];
> +		return regulatory_hint_indoor(is_indoor, info->snd_portid);

So we break old functionality ? No bueno.

  Luis
