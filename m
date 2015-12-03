Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60717 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760195AbbLCMpb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 07:45:31 -0500
Message-ID: <1449146726.31265.1.camel@sipsolutions.net> (sfid-20151203_134544_509442_ED9668C3)
Subject: Re: iw ignores channel switch
From: Johannes Berg <johannes@sipsolutions.net>
To: Reiner Karlsberg <karlsberg@softart-ge.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 03 Dec 2015 13:45:26 +0100
In-Reply-To: <5660210D.4090303@softart-ge.com> (sfid-20151203_121928_609938_D1109D00)
References: <5660210D.4090303@softart-ge.com>
	 (sfid-20151203_121928_609938_D1109D00)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-12-03 at 12:01 +0100, Reiner Karlsberg wrote:
> 
>          Interface wlan0
>                  ifindex 21                         #steadily
> increasing, not re-used ?

Correct. You'll eventually roll over after 2^32-1 ... this has nothing
to do with wifi btw - look at ethernet devices :)

[snip irrelevant use of the station interface]

> root@OpenWrt:/tmp# iw dev wmon0 set channel 1

Is 'wmon0' still up at that point? It should work then, not sure why it
wouldn't, but it's certainly not an iw problem but more likely a kernel
problem. Since openwrt also has a fair number of patches I'd ask you to
please retest on a regular kernel first, or report the bug to them.

johannes
