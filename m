Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43482 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933903AbcJUVYR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 17:24:17 -0400
Message-ID: <1477085053.4068.65.camel@sipsolutions.net> (sfid-20161021_232421_739896_FF354A9A)
Subject: Re: cfg80211: race problem between suspend and disconnect event
From: Johannes Berg <johannes@sipsolutions.net>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@google.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Ganapathi Bhat <gbhat@marvell.com>
Date: Fri, 21 Oct 2016 23:24:13 +0200
In-Reply-To: <7af766c43f2f426b8db177f8d4e67031@SC-EXCH04.marvell.com>
References: <67400d1c5c2141b3af75bdce9ec43840@SC-EXCH04.marvell.com>
         <1476989132.14078.12.camel@sipsolutions.net>
         <7af766c43f2f426b8db177f8d4e67031@SC-EXCH04.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Yes. In our case, *802_11_DEAUTHENTICATE command downloaded to
> firmware takes care of flushing the keys.
> 
> I can see below code in cfg80211's disconnect handling. It seems to
> be there for long time.

Yeah, I saw it, but it's not clear to me that there's much point in it.
In any case, that's an unrelated question in a way, because there
definitely are things happening here that should be "more synchronous",
regardless of whether or not the key deletion makes sense.

> I think, your cfg80211 change will help. We do ensure that
> cfg80211_disconnected() is called before exiting
> mwifiex_cfg80211_disconnect().
> Sending HostCmd_CMD_802_11_DEAUTHENTICATE command to firmware is a
> blocking call. cfg80211_disconnected() is called while handling that
> command's response. 

Ah ok, I missed that - I thought it was asynchronous.

> > So somehow you'd have to synchronize with the firmware as well, to
> > process all those things before suspend, I guess?
> > 
[...]
> This would not be needed. 

Right. Care to test my patch before I properly submit it?

johannes
