Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:41922 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755849Ab1AaSsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:48:52 -0500
Subject: [PATCH 11/22] mac80211: fix race between next beacon dtim and
	ieee80211_get_buffered_bc
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 31 Jan 2011 20:48:44 +0200
Message-ID: <20110131184844.10044.33884.stgit@fate.lan>
In-Reply-To: <20110131184657.10044.98610.stgit@fate.lan>
References: <20110131184657.10044.98610.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Christian Lamparter <chunkeey@googlemail.com>

On review of 'zd1211rw: implement beacon fetching and handling
ieee80211_get_buffered_bc()', Christian Lamparter noted that [1]:

   Since zd_beacon_done also uploads the next beacon so long in advance,
   there could be an equally long race between the outdated state of the
   next beacon's DTIM broadcast traffic indicator (802.11-2007 7.3.2.6)
   which -in your case- was uploaded almost a beacon interval ago and
   the xmit of ieee80211_get_buffered_bc *now*.

   The dtim bc/mc bit might be not set, when a mc/bc arrived after the
   beacon was uploaded, but before the "beacon done event" from the
   hardware. So, dozing stations don't expect the broadcast traffic
   and of course, they might miss it completely.

   It's probably better to fix this in mac80211 (see the attached hack).

[1] http://marc.info/?l=linux-wireless&m=129435041117256&w=2

CC: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/tx.c          |    4 +++-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c47d7c0..f71ed31 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -225,6 +225,7 @@ struct ieee80211_if_ap {
 	struct sk_buff_head ps_bc_buf;
 	atomic_t num_sta_ps; /* number of stations in PS mode */
 	int dtim_count;
+	bool dtim_bc_mc;
 };
 
 struct ieee80211_if_wds {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ffc6749..1c8cf41 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2178,6 +2178,8 @@ static void ieee80211_beacon_add_tim(struct ieee80211_if_ap *bss,
 	if (bss->dtim_count == 0 && !skb_queue_empty(&bss->ps_bc_buf))
 		aid0 = 1;
 
+	bss->dtim_bc_mc = aid0 == 1;
+
 	if (have_bits) {
 		/* Find largest even number N1 so that bits numbered 1 through
 		 * (N1 x 8) - 1 in the bitmap are 0 and number N2 so that bits
@@ -2548,7 +2550,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 	if (sdata->vif.type != NL80211_IFTYPE_AP || !beacon || !beacon->head)
 		goto out;
 
-	if (bss->dtim_count != 0)
+	if (bss->dtim_count != 0 || !bss->dtim_bc_mc)
 		goto out; /* send buffered bc/mc only after DTIM beacon */
 
 	while (1) {

