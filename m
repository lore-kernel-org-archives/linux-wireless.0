Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32949 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752966AbcJGHGL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Oct 2016 03:06:11 -0400
Message-ID: <1475823963.2015.24.camel@sipsolutions.net> (sfid-20161007_090622_449444_788BFB62)
Subject: Re: [PATCH] wl18xx: Handle kfree() in better way when kzalloc fails
From: Johannes Berg <johannes@sipsolutions.net>
To: Souptick Joarder <jrdr.linux@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Julian Calaby <julian.calaby@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Rameshwar Sahu <sahu.rameshwar73@gmail.com>
Date: Fri, 07 Oct 2016 09:06:03 +0200
In-Reply-To: <20161007064923.GA3404@symbol-HP-ZBook-15> (sfid-20161007_084947_718154_2F19A852)
References: <20161007064923.GA3404@symbol-HP-ZBook-15>
         (sfid-20161007_084947_718154_2F19A852)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-10-07 at 12:19 +0530, Souptick Joarder wrote:
> This patch is added to handle kfree and return error in a better way

What's "better" about this?

kfree(NULL) is perfectly valid, adding another label makes the code
harder to read,

> -	struct wl18xx_cmd_scan_params *cmd;
> +	struct wl18xx_cmd_scan_params *cmd = NULL;

that new initialization is actually *completely* pointless since it's
overwritten immediately here:

>  	struct wlcore_scan_channels *cmd_channels = NULL;
>  	int ret;
>  
>  	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
>  	if (!cmd) {
> -		ret = -ENOMEM;
> -		goto out;
> +		return -ENOMEM;
>  	}
> 
...

what gives?

johannes
