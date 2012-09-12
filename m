Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43350 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756Ab2ILHJW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2012 03:09:22 -0400
Message-ID: <1347433797.4293.2.camel@jlt4.sipsolutions.net> (sfid-20120912_090926_123126_36422384)
Subject: Re: [PATCH] carl9170: fix spurious transmissions in sniffer mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Richard Farina <sidhayn@gmail.com>, linux-wireless@vger.kernel.org,
	scchen@qca.qualcomm.com, linville@tuxdriver.com,
	marco@tampabay.rr.com, janusz.dziedzic@gmail.com
Date: Wed, 12 Sep 2012 09:09:57 +0200
In-Reply-To: <201209120308.30985.chunkeey@googlemail.com> (sfid-20120912_030846_969448_7F6F8B63)
References: <201209112318.35334.chunkeey@googlemail.com>
	 <201209120126.31312.chunkeey@googlemail.com> <504FCD39.80705@gmail.com>
	 <201209120308.30985.chunkeey@googlemail.com>
	 (sfid-20120912_030846_969448_7F6F8B63)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-09-12 at 03:08 +0200, Christian Lamparter wrote:

> Anyway, now the hardware will only react to frames that
> are "directed" (DA matches either the main, or one of
> the 8 vif mac addresses) to it (is this now sane or
> not?).

That's reasonable. A lot of hardware behaves that way, and for many
injection use cases it is actually desired while normal monitoring use
cases aren't really affected. If you'd want to not have this you could
inject with a different MAC address, so it's still fine.

> (BTW: wasn't there once some sort of a "tx ack" control
> interface in mac80211 debugfs path? Does anybody know
> what happend to it?)

It moved into cfg80211/nl80211, but it's only applicable for properly
transmitted QoS frames anyway.

johannes

