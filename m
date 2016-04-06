Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36114 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134AbcDFJHW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 05:07:22 -0400
Message-ID: <1459933638.17504.55.camel@sipsolutions.net> (sfid-20160406_110727_652624_DD0891B9)
Subject: Re: [PATCHv3 RESEND 08/11] mac80211: implement nan_change_conf
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Wed, 06 Apr 2016 11:07:18 +0200
In-Reply-To: <1459244109-16038-8-git-send-email-emmanuel.grumbach@intel.com>
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1459244109-16038-8-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-03-29 at 12:35 +0300, Emmanuel Grumbach wrote:
> 
>   * @start_nan: join an existing nan cluster, or create a new one.
>   * @stop_nan: leave the nan cluster.
> + * @nan_change_conf: change nan configuration. The data in
> cfg80211_nan_conf
> + *	contains full new configuration and changes specify which
> parameters

@changes I guess? at least you should be consistent, even if there's no
perfectly correct syntax here.

Also please specify where the change flags come from.

I'm also not sure that the description is actually correct? How can
both "contains [the] full new configuration" and "changes speicfy which
parameters" be correct? You have a full new configuration but still
want to indicate the changes?

> + *	are changed with respect to the last nan config.
> 

Also, more nan vs. NAN, I'm sure I didn't comment on them all.

> +	int (*nan_change_conf)(struct ieee80211_hw *hw,
> +			       struct ieee80211_vif *vif,
> +			       struct cfg80211_nan_conf *conf, u8
> changes);

An earlier patch in your series used u32, why u8 here?

> +	memcpy(&sdata->u.nan.nan_conf, conf, sizeof(sdata-
> >u.nan.nan_conf));

why not use struct assignment?

sdata->u.nan.conf = conf;

> +		memcpy(&sdata->u.nan.nan_conf, &new_conf,
> +		       sizeof(sdata->u.nan.nan_conf));

ditto

> +/**
> + * struct ieee80211_if_nan - NAN state
> + *
> + * @nan_conf: current nan configuration
> + */
> +struct ieee80211_if_nan {
> +	struct cfg80211_nan_conf nan_conf;
> +};

There's no point in calling it nan_conf since it's within a nan struct
and then later called "nan.nan_conf"...

> +		__field(u32, changes)

You're not being very consistent with the type of the "changes"
parameter :)

johannes
