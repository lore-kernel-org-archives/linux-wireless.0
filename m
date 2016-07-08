Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56020 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755691AbcGHP0o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 11:26:44 -0400
Message-ID: <1467991593.4837.7.camel@sipsolutions.net> (sfid-20160708_172734_830413_2B86028B)
Subject: Re: [PATCH 0/5] Improve wireless netdev detection
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Fri, 08 Jul 2016 17:26:33 +0200
In-Reply-To: <577FC51E.7010901@gmail.com> (sfid-20160708_172209_534342_D9E86FEB)
References: <1467875330-7835-1-git-send-email-denkenz@gmail.com>
 <1467973953.4837.3.camel@sipsolutions.net> <577FC51E.7010901@gmail.com>
	 (sfid-20160708_172209_534342_D9E86FEB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-07-08 at 10:22 -0500, Denis Kenzior wrote:
> 
> Apologies, I've only been looking at the kernel side for several
> days, so my understanding is still incomplete.
> 
> I was looking at mac80211/iface.c: ieee80211_if_add() which seems to 
> handle NL80211_IFTYPE_P2P_DEVICE specially by not
> creating/registering a 
> net_device object.  For some reason I thought that this object was 
> registered somewhere later, but my understanding was incorrect.  So
> the  entire 'side effect' paragraph above does not apply.

Ok, makes sense.

> Are you okay with the general approach? 

I see no issues with sending these events out. I'd like them to
actually be reliable (if present) though, not double as you'd implied -
but I didn't really understand in which cases you were expecting
issues, was it only P2P-Device?

>  Are there any locking issues I 
> might be overlooking?

Not that I'm aware of. All of the netdev/wdev handling should be
protected by RTNL.

johannes
