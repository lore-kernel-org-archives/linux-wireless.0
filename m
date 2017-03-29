Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41704 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753643AbdC2Hey (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 03:34:54 -0400
Message-ID: <1490772890.18052.8.camel@sipsolutions.net> (sfid-20170329_093508_848242_9A16320D)
Subject: Re: wlan0 keeps deauthenticating DEAUTH_LEAVING about every minute
From: Johannes Berg <johannes@sipsolutions.net>
To: Dennis New <dennisn@dennisn.mooo.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 29 Mar 2017 09:34:50 +0200
In-Reply-To: <20170324213237.6f122a9173fa464a5d936f9d@dennisn.mooo.com> (sfid-20170325_024055_755712_8E7A9C9D)
References: <20170324213237.6f122a9173fa464a5d936f9d@dennisn.mooo.com>
         (sfid-20170325_024055_755712_8E7A9C9D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-03-24 at 21:32 -0400, Dennis New wrote:
> Ever since I upgraded to the 4.10 kernels (I don't think this
> behavior existed in the 4.8 series), after I startup my laptop
> (either from cold boot, or from standby), my wlan0 interface keeps
> deauthenticating

> ...
> 19:23:29 kernel: wlan0: authenticate with 00:11:22:33:44:55
> 19:23:29 kernel: ------------[ cut here ]------------
> 19:23:29 kernel: WARNING: CPU: 0 PID: 18925 at
> net/mac80211/mlme.c:287 ieee80211_determine_chantype+0x12e/0x380

This is already indicating a severe problem. I don't know how you end
up in this situation with b43, since that doesn't have any regulatory
magic afaict.

> 19:23:29 kernel: wlan0: associated
> 
> 19:24:29 kernel: wlan0: deauthenticating from 00:11:22:33:44:55 by
> local choice (Reason: 3=DEAUTH_LEAVING)
> 

I'm convinced that this comes from reg_check_channels().

The above WARN_ON() already told you that the channel was considered
invalid.

Do you know what channel your AP is on? Perhaps show the output of "iw
wlan0 scan dump" while it's connected (you have 60 seconds :P)

Can you please show the output of "iw list" and "iw phy0 channels"?

johannes
