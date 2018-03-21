Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:60736 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751739AbeCUHsB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 03:48:01 -0400
Message-ID: <1521618479.2645.1.camel@sipsolutions.net> (sfid-20180321_084855_418877_B677B672)
Subject: Re: [RFC v5 3/9] nl80211: Add CONTROL_PORT_OVER_NL80211 attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Wed, 21 Mar 2018 08:47:59 +0100
In-Reply-To: <20180313215942.29176-4-denkenz@gmail.com> (sfid-20180313_230016_681135_490AC38A)
References: <20180313215942.29176-1-denkenz@gmail.com>
         <20180313215942.29176-4-denkenz@gmail.com>
         (sfid-20180313_230016_681135_490AC38A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-03-13 at 16:59 -0500, Denis Kenzior wrote:
> 
> +	if (info->attrs[NL80211_ATTR_CONTROL_PORT_OVER_NL80211]) {
> +		if (!info->attrs[NL80211_ATTR_SOCKET_OWNER])
> +			return -EINVAL;
> 
There might be value in adding GENL_SET_ERR_MSG() calls to new
instances of -EINVAL, but if you don't want to do that now I won't
insist (and perhaps add some when I apply the patches).

johannes
