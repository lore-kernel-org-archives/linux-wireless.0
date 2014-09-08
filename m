Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39566 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874AbaIHNPa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 09:15:30 -0400
Message-ID: <1410182120.7983.12.camel@jlt4.sipsolutions.net> (sfid-20140908_151533_664013_7078A1EF)
Subject: Re: [PATCH] {nl, cfg, mac}80211: Implement hidden mesh ID
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Date: Mon, 08 Sep 2014 15:15:20 +0200
In-Reply-To: <20140908122454.GA29495@localhost> (sfid-20140908_142549_984867_17DF5DF0)
References: <1410156082-17313-1-git-send-email-yeohchunyeow@gmail.com>
	 <20140908122454.GA29495@localhost> (sfid-20140908_142549_984867_17DF5DF0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-09-08 at 08:24 -0400, Bob Copeland wrote:
> On Mon, Sep 08, 2014 at 02:01:22PM +0800, Chun-Yeow Yeoh via Devel wrote:
> > The hidden mesh ID is use to enhance the security of
> > open mesh and possible secured mesh later on by not
> > advertising the mesh ID during beacon generation,
> > similar to hidden SSID implemented in AP mode.
> 
> I'm unconvinced - hidden SSID is not much of a security feature and it
> seems like this would break all manner of things.  Is it really worth
> the pain when people can just use a secure mesh instead?

It's certainly not a security feature at all.

So why bother introducing the old hidden SSID mistake again in a new
protocol? It caused all kinds of pain there, and almost certainly will,
and there already are few implementations to interoperate with and this
is likely to not interoperate at all, right?

I really don't think we should allow this. If you need to hide the
network name then maybe just give it a random/useless name?

johannes

