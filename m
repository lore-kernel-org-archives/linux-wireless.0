Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35907 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932604AbcDFIrz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 04:47:55 -0400
Message-ID: <1459932471.17504.35.camel@sipsolutions.net> (sfid-20160406_104804_701966_9CEC3D50)
Subject: Re: [PATCHv3 RESEND 03/11] cfg80211: add add_nan_func / rm_nan_func
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Wed, 06 Apr 2016 10:47:51 +0200
In-Reply-To: <1459244109-16038-3-git-send-email-emmanuel.grumbach@intel.com>
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1459244109-16038-3-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +	NL80211_ATTR_NAN_FUNC_INST_ID,

I don't see why this has to be a top-level attribute.

> +enum nl80211_nan_func_attributes {
> +	__NL80211_NAN_FUNC_INVALID,
> +	NL80211_NAN_FUNC_TYPE,

You can easily move it into here, and 

> +	/* propagate the instance id and cookie to userspace  */
> +	if (WARN_ON(nla_put_u8(msg, NL80211_ATTR_NAN_FUNC_INST_ID,
> +			       func.instance_id) ||
> +		    nla_put_u64(msg, NL80211_ATTR_COOKIE,
> func.cookie))) {

use the appropriate nesting here.

johannes
