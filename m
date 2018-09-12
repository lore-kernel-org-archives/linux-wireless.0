Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:55116 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbeILNlw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Sep 2018 09:41:52 -0400
Message-ID: <1536741492.3678.9.camel@sipsolutions.net> (sfid-20180912_103827_312299_50CD05D9)
Subject: Re: [RFC v2 1/2] netlink: add NLA_REJECT policy type
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: Michal Kubecek <mkubecek@suse.cz>
Date: Wed, 12 Sep 2018 10:38:12 +0200
In-Reply-To: <20180912083610.20857-1-johannes@sipsolutions.net> (sfid-20180912_103626_907703_3A24107A)
References: <20180912083610.20857-1-johannes@sipsolutions.net>
         (sfid-20180912_103626_907703_3A24107A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-09-12 at 10:36 +0200, Johannes Berg wrote:
> @@ -251,7 +257,7 @@ int nla_parse(struct nlattr **tb, int maxtype, const struct nlattr *head,
>  
>  		if (type > 0 && type <= maxtype) {
>  			if (policy) {
> -				err = validate_nla(nla, maxtype, policy);
> +				err = validate_nla(nla, maxtype, policy, extack);
>  				if (err < 0) {
>  					NL_SET_ERR_MSG_ATTR(extack, nla,
>  							    "Attribute failed policy validation");

Err... I should read my patches before sending them :-)

Clearly, this NL_SET_ERR_MSG_ATTR() overwrites the error message, so
would have to be made conditional.

I can fix that (and I should use/test it) if we decide it's worthwhile.

johannes
