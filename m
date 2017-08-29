Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0064.outbound.protection.outlook.com ([104.47.37.64]:55552
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753623AbdH2OmR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Aug 2017 10:42:17 -0400
Date: Tue, 29 Aug 2017 17:42:06 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: igor.mitsyanko.os@quantenna.com
Cc: linux-wireless@vger.kernel.org, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko@quantenna.com>
Subject: Re: [PATCH 03/27] qtnfmac: retreive current channel info from EP
Message-ID: <20170829144206.3zri6qpacy7cklkt@bars> (sfid-20170829_164221_080960_C8BD1119)
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
 <20170825023024.10565-4-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170825023024.10565-4-igor.mitsyanko.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Typo in commit title: retrieve

...

> -	if (!cfg80211_chandef_valid(&mac->chandef)) {
> -		pr_err("invalid channel settings on %s\n", ndev->name);
> -		return -ENODATA;
> +	if (!cfg80211_chandef_valid(chandef)) {
> +		pr_err("%s: bad chan freq1=%u bw=%u\n", ndev->name,
> +		       chandef->center_freq1, chandef->width);
> +		ret = -ENODATA;
>  	}

Lets keep both center_freq1 and center_freq2 in error message.

Regards,
Sergey
