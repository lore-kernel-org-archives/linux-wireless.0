Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40604 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935008AbdAIMjh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 07:39:37 -0500
Message-ID: <1483965571.17582.35.camel@sipsolutions.net> (sfid-20170109_134126_078930_D5037A42)
Subject: Re: [PATCH] cfg80211: size various nl80211 messages correctly
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Date: Mon, 09 Jan 2017 13:39:31 +0100
In-Reply-To: <ec9fb205-91ca-9591-0b0b-92672d093395@broadcom.com> (sfid-20170109_133643_721177_F4ABE60E)
References: <20170109101042.23919-1-johannes@sipsolutions.net>
         <ec9fb205-91ca-9591-0b0b-92672d093395@broadcom.com>
         (sfid-20170109_133643_721177_F4ABE60E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > -	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> > +	msg = nlmsg_new(100 + ie_len, GFP_KERNEL);
> 
> Don't you want the '100' to be a define?

I didn't want to glorify it too much - some places may need more or
less over time. There's no significance to this number.

johannes
