Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yumi.tdiedrich.de ([85.10.210.183]:52326 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756711Ab2EIK5X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 06:57:23 -0400
Date: Wed, 9 May 2012 12:57:19 +0200
From: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
To: Johannes Berg <johannes.berg@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	linux-wireless@vger.kernel.org
Subject: rt28xx AP-mode problem with commit
 3edaf3e61fda3aa9ff8d38445bf92f2bec23bf63 "mac80211: manage AP netdev
 carrier state"
Message-ID: <20120509105719.GA24457@yumi.tdiedrich.de> (sfid-20120509_125732_300096_BB4CA746)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've bisected a problem with running rt3052-based APs on recent
OpenWRT down to this commit: 3edaf3e61fda3aa9ff8d38445bf92f2bec23bf63
"mac80211: manage AP netdev carrier state"

If I revert this commit (and also fix the max_power issue), AP-mode
works fine, but if I leave it in, association to the AP times out.

(The AP-side hostapd claims WPA authentication was successful, but
the client never connects)

(Note: I haven't gotten around to testing a non-rt28xx based AP yet,
so I'm only assuming this affects only rt28xx, maybe it does affect
other chipsets as well)

See also "rt28xx: Revert eccc068e8e84c8fe997115629925e0422a98e4de
which causes txpower to be stuck at 0" on the openwrt list:
http://www.spinics.net/lists/linux-wireless/msg89732.html

Cheers,

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
