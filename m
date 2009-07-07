Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43520 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbZGGCHl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 22:07:41 -0400
Message-Id: <20090707020236.921639975@sipsolutions.net>
Date: Tue, 07 Jul 2009 04:02:36 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi
Subject: [RFC 0/2] nl80211 key handling improvements
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I dislike the current situation in nl80211, you
cannot connect to any protected network without
wpa_supplicant, but nl80211 can't _properly_ be
used to set keys either...

These patches implement my new plan. According
to that plan, static key configuration is passed
directly to CONNECT or JOIN_IBSS along with the
privacy flag, or the privacy flag itself is used
to indicate that the application will later set
the keys appropriately.

Internally, we store all the keys and call the
add_key() function after we have joined the IBSS
or connected to the AP (this could be changed if
there are drivers that need static keys during
connect(), but that seems rather unlikely). The
only complication is shared key auth -- but this
can be handled by simply passing the required
WEP key directly to ->auth() or ->connect().

This might break iwm wrt. shared key auth if that
currently works, but I couldn't figure out how it
actually works now, if at all.

johannes

