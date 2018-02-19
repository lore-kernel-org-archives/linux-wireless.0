Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:50320 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752657AbeBSMpA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 07:45:00 -0500
Message-ID: <1519044297.16723.4.camel@sipsolutions.net> (sfid-20180219_134503_595027_E0C71C36)
Subject: Re: [RFC v4 3/6] nl80211: Implement TX of control port frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Mon, 19 Feb 2018 13:44:57 +0100
In-Reply-To: <20180201010420.6102-4-denkenz@gmail.com> (sfid-20180201_020437_479619_BE4C79BC)
References: <20180201010420.6102-1-denkenz@gmail.com>
         <20180201010420.6102-4-denkenz@gmail.com>
         (sfid-20180201_020437_479619_BE4C79BC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-31 at 19:04 -0600, Denis Kenzior wrote:
> 
> +	switch (wdev->iftype) {
> +	case NL80211_IFTYPE_STATION:
> +		if (wdev->current_bss)
> +			break;
> +		err = -ENOTCONN;
> +		goto out;
> +	default:
> +		err = -EOPNOTSUPP;
> +		goto out;
> +	}
> 
Why restrict this to client mode? At the very least, P2P_CLIENT really
should be listed there, but I'm not sure why not also support it in
IBSS, and AP/P2P_GO/AP_VLAN modes?

We could do this in a separate patch, but then we have to define
different flags for the modes which seems somewhat pointless.

johannes
