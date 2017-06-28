Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59738 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751501AbdF1PEB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 11:04:01 -0400
Message-ID: <1498662237.12531.7.camel@sipsolutions.net> (sfid-20170628_170404_911473_05101DD4)
Subject: Re: [PATCH] mac80211_hwsim: use dyndbg for debug messages
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>, Lubomir Rintel <lkundrak@v3.sk>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 28 Jun 2017 17:03:57 +0200
In-Reply-To: <1498657062.8633.1.camel@perches.com>
References: <20170628131726.15528-1-lkundrak@v3.sk>
         <1498657062.8633.1.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-06-28 at 06:37 -0700, Joe Perches wrote:
> On Wed, 2017-06-28 at 15:17 +0200, Lubomir Rintel wrote:
> > The mac80211_hwsim doesn't offer a way to disable the debugging
> > output.
> > Unfortunately, it's pretty chatty, dumping a  lot of stuff into the
> > message
> > buffer.
> > 
> > This patch changes it to use dyndbg for controlling the debug
> > output.
> > It's disabled by default, but can be enabled by a module parameter
> > (1),
> > at runtime (2) or persisted in modprobe.conf (3).
> > 
> >   (1) modprobe mac80211_hwsim dyndbg=+p
> >   (2) echo "module mac80211_hwsim +p"
> > >/sys/kernel/debug/dynamic_debug/control
> >   (3) echo "options mac80211_hwsim dyndbg=+p"
> > >>/etc/modprobe.d/my.conf
> 
> I wonder about the value at all of the 2 forms:
> 
> wiphy_dbg	-> only with #define DEBUG or dynamic_debug
> wiphy_debug	-> always emitted at KERN_DEBUG
> 
> Is there any real value in wiphy_debug?
> 
> Should it just be converted to
> 
> #define wiphy_debug	wiphy_dbg

I don't think it should, there are some messages that we'd probably
just have to give a higher priority if we did this.

johannes
