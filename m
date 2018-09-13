Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:55590 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725757AbeINELJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Sep 2018 00:11:09 -0400
Date: Thu, 13 Sep 2018 15:59:34 -0700 (PDT)
Message-Id: <20180913.155934.742447935316828936.davem@davemloft.net> (sfid-20180914_005940_836009_9F9699C5)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        mkubecek@suse.cz, johannes.berg@intel.com
Subject: Re: [PATCH 1/2] netlink: add NLA_REJECT policy type
From: David Miller <davem@davemloft.net>
In-Reply-To: <20180913084603.7979-1-johannes@sipsolutions.net>
References: <20180913084603.7979-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 13 Sep 2018 10:46:02 +0200

> +					NL_SET_BAD_ATTR(extack, nla);
> +					if (extack && !extack->_msg)
> +						NL_SET_ERR_MSG(extack,
> +							       "Attribute failed policy validation");

Given the lively discussion that resulted from this conditional I am
pretty sure we want to override existing messages.

If we have an existing message, and we continued to process and
parse anyways, then the existing message was informational or
a warning.

The message should be overridden when the action will be to fail, as
it will be here when we return -EINVAL.
