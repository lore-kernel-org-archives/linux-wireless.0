Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971AbbBZRlp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 12:41:45 -0500
Date: Thu, 26 Feb 2015 18:41:43 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, ArikX Nemtsov <arik@wizery.com>
Subject: Re: [PATCH v8 2/3] cfg80211: Add API to change the indoor
	regulatory setting
Message-ID: <20150226174143.GM8749@wotan.suse.de> (sfid-20150226_184148_611015_3B272F01)
References: <1424944447-10988-1-git-send-email-ilan.peer@intel.com> <1424944447-10988-2-git-send-email-ilan.peer@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1424944447-10988-2-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 26, 2015 at 04:54:06AM -0500, Ilan Peer wrote:
> Previously, the indoor setting configuration assumed that as
> long as a station interface is connected, the indoor environment
> setting does not change. However, this assumption is problematic
> as:
> 
> - It is possible that a station interface is connected to a mobile
>   AP, e.g., softAP or a P2P GO, where it is possible that both the
>   station and the mobile AP move out of the indoor environment making
>   the indoor setting invalid. In such a case, user space has no way to
>   invalidate the setting.
> - A station interface disconnection does not necessarily imply that
>   the device is no longer operating in an indoor environment, e.g.,
>   it is possible that the station interface is roaming but is still
>   stays indoor.
> 
> To handle the above, extend the indoor configuration API to allow
> user space to indicate a change of indoor settings, and allow it to
> indicate weather it controls the indoor setting, such that:
> 
> 1. If the user space process explicitly indicates that it is going
>    to control the indoor setting, do not clear the indoor setting
>    internally, unless the socket is released. The user space process
>    should use the NL80211_ATTR_SOCKET_OWNER attribute in the command
>    to state that it is going to control the indoor setting.
> 2. Reset the indoor setting when restoring the regulatory settings in
>    case it is not owned by a user space process.
> 
> Based on the above, a user space tool that continuously monitors the
> indoor settings, i.e., tracking power setting, location etc., can
> indicate environment changes to the regulatory core.
> 
> Currently, in case a received country IE includes environment
> information (indicates that the country IE applies only to
> indoor operation or only to outdoor operation) it is currently not
> used.

Since I spotted an issue and you have to remake this patch
please also change this to:

It should be noted that currently userspace is the only
provided mechanism used to hint to the regulatory core
over the indoor/outdoor environment -- while the country
IEs do have an environment setting this has been completely
ignored by the regulatory core by design  for a while now
since country IEs typically can contain bogus data.

> @@ -4984,7 +4988,15 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
>  		data = nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
>  		return regulatory_hint_user(data, user_reg_hint_type);
>  	case NL80211_USER_REG_HINT_INDOOR:
> -		return regulatory_hint_indoor_user();
> +		if (info->attrs[NL80211_ATTR_SOCKET_OWNER]) {
> +			owner_nlportid = info->snd_portid;
> +			is_indoor = !!info->attrs[NL80211_ATTR_REG_INDOOR];
> +		} else {
> +			owner_nlportid = 0;
> +			is_indoor = true;
> +		}
> +
> +		return regulatory_hint_indoor(is_indoor, owner_nlportid);

Good, this looks better now. But you are missing the chance that a secondary
random interface can come up and override that environmental information
without checking for previous users. I'll illustrate below.

>  	default:
> @@ -2288,15 +2291,51 @@ int regulatory_hint_user(const char *alpha2,
>  	return 0;
>  }
>  
> -int regulatory_hint_indoor_user(void)
> +int regulatory_hint_indoor(bool is_indoor, u32 portid)
>  {
> +	spin_lock(&reg_indoor_lock);
>  
> +	/*
> +	 * Process only if there is a real change, so the original port ID is
> +	 * saved (to handle cases that several processes try to change the
> +	 * indoor setting).
> +	 */
> +	if (reg_is_indoor == is_indoor) {
> +		spin_unlock(&reg_indoor_lock);
> +		return 0;
> +	}
>  
> -	reg_is_indoor = true;
> +	reg_is_indoor = is_indoor;
> +	if (reg_is_indoor)
> +		reg_is_indoor_portid = portid;
> +	else
> +		reg_is_indoor_portid = 0;

Why do we ignore port id if we go outdoor? Also we seem to allow
interfaces to disagree on the setting, how are you handling that here?
Don't tell me that cannot happen, I want you to think about that and
handle it.

  Luis
