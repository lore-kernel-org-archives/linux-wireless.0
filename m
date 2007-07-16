Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:39659 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757055AbXGPQqk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jul 2007 12:46:40 -0400
Date: Mon, 16 Jul 2007 18:46:53 +0200
From: Jiri Benc <jbenc@suse.cz>
To: David Miller <davem@davemloft.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH] mac80211: fix GCC warning on 64bit platforms
Message-ID: <20070716184653.355253bf@griffin.suse.cz>
In-Reply-To: <20070714.204116.23012949.davem@davemloft.net>
References: <20070712204137.GB14486@tuxdriver.com>
	<20070714.185935.18577806.davem@davemloft.net>
	<20070714.204116.23012949.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

net/mac80211/ieee80211.c: In function ieee80211_register_hw:
net/mac80211/ieee80211.c:4989: warning: comparison of distinct pointer types lacks a cast

Fix by casting from size_t to unsigned as size of ieee80211_tx_status_rtap_hdr
structure will never be greater than that.

Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

On Sat, 14 Jul 2007 20:41:16 -0700 (PDT), David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Sat, 14 Jul 2007 18:59:35 -0700 (PDT)
> 
> > From: "John W. Linville" <linville@tuxdriver.com>
> > Date: Thu, 12 Jul 2007 16:41:38 -0400
> > 
> > > This request is based off net-2.6, as it requires a patch that is in
> > > net-2.6 but not yet in Linus' tree (b3d88ad49a0623d09efcf998beb26288c8029f75).
> >  ...
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream-davem
> > 
> > Pulled, thanks John!
> 
> A warning to look into:
> 
> net/mac80211/ieee80211.c: In function $,1rxieee80211_register_hw$,1ry:
> net/mac80211/ieee80211.c:4989: warning: comparison of distinct pointer types lacks a cast

---
 net/mac80211/ieee80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mac80211-2.6.orig/net/mac80211/ieee80211.c
+++ mac80211-2.6/net/mac80211/ieee80211.c
@@ -4987,7 +4987,7 @@ int ieee80211_register_hw(struct ieee802
 	 * interfaces, but never both at the same time.
 	 */
 	local->tx_headroom = max(local->hw.extra_tx_headroom,
-				 sizeof(struct ieee80211_tx_status_rtap_hdr));
+				 (unsigned)sizeof(struct ieee80211_tx_status_rtap_hdr));
 
 	debugfs_hw_add(local);
 

-- 
Jiri Benc
SUSE Labs
