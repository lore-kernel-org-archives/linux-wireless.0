Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56282 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750716AbdBOIDR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 03:03:17 -0500
Message-ID: <1487145795.4026.9.camel@sipsolutions.net> (sfid-20170215_090321_160538_65165132)
Subject: Re: [PATCH v3] iw: Add support for controlling tx power for per
 station
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        arnagara@codeaurora.org
Date: Wed, 15 Feb 2017 09:03:15 +0100
In-Reply-To: <1486555277-25258-1-git-send-email-arnagara@qti.qualcomm.com> (sfid-20170208_131118_350049_87BE682C)
References: <1486555277-25258-1-git-send-email-arnagara@qti.qualcomm.com>
         (sfid-20170208_131118_350049_87BE682C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +		sta_txpwr = strtoul(argv[0], &err, 0);

you should error-check this.

> +		NLA_PUT_U32(msg, NL80211_ATTR_STA_TX_POWER,
> sta_txpwr);
> +	}

> +}
> +COMMAND_ALIAS(station, set, "<MAC address> txpwr <auto|limit> [<tx
> power mBm>]",
> 

Seems like that should be

<MAC address> txpwr <auto|limit <tx power dBm>>

or so?

I made that dBm there, doing that and parsing floating point numbers
would be nice I think.

johannes
