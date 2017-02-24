Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42440 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750949AbdBXGmf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 01:42:35 -0500
Message-ID: <1487918553.2540.9.camel@sipsolutions.net> (sfid-20170224_074240_470028_BA473F7E)
Subject: Re: [PATCH 161/306] mac80211-hwsim: Improve logging.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Fri, 24 Feb 2017 07:42:33 +0100
In-Reply-To: <1487896109-23851-6-git-send-email-greearb@candelatech.com> (sfid-20170224_012924_068303_22EAD8CA)
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
         <1487896109-23851-6-git-send-email-greearb@candelatech.com>
         (sfid-20170224_012924_068303_22EAD8CA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +		static unsigned int cnt = 0;
> +		/* This is fairly common, and usually not a
> bug.  So, print errors
> +		   rarely. */
> +		if (((cnt++ & 0x3FF) == 0x3FF) && net_ratelimit())
> +			printk(KERN_DEBUG " hwsim rx-nl: radio %pM
> idle: %d or not started: %d cnt: %d\n",
> +			       dst, data2->idle, !data2->started,
> cnt);
>  		goto out;
>  	}

You just added that in the previous patch...

Please take a bit more care, or I'll eventually stop looking at your
patches since things like that seem to happen over and over again. I
don't get a feeling that you actually care about getting things
upstream much anyway.

johannes
