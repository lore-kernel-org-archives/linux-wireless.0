Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59282 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759100Ab3GZOuR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 10:50:17 -0400
Message-ID: <1374850210.8248.59.camel@jlt4.sipsolutions.net> (sfid-20130726_165022_093524_79580FBA)
Subject: changing dev->needed_headroom/needed_tailroom?
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 26 Jul 2013 16:50:10 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Does it seem reasonable to change dev->needed_headroom and
dev->needed_tailroom on the fly?

We currently set needed_headroom to the max of what we need, but we
could do better like making it depend on the interface type (e.g. only
asking for mesh space on mesh interfaces). This would be done only when
the interface isn't connected, I can't promise it would be down but the
carrier would be off.

Another thing we might want to do is change it according to the
currently configured crypto (this would also affect
dev->needed_tailroom) since we actually only need tailroom when TKIP is
used. This could might be done on the fly, but could also be done when
the carrier is still down during connection establishment (which would
not be a complete optimisation but still be better than what we have
now)

Thoughts?

johannes

