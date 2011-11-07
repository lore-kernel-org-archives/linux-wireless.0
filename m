Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab1KGPeL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 10:34:11 -0500
Date: Mon, 7 Nov 2011 16:34:10 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Lukasz Jagiello <jagiello.lukasz@gmail.com>
Subject: [PATCH v2] mac80211: disassociate when direct probe timed out
Message-ID: <20111107153410.GB5990@redhat.com> (sfid-20111107_163415_583142_C0044C05)
References: <20111107142620.GA5852@redhat.com>
 <20111107152859.GA5990@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111107152859.GA5990@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We disassociate only in cfg80211 and upper layers when direct probe
timed out. Mac80211 is not aware about connection problem until
ieee80211_sta_connection_lost() and operate in associate mode. If in
this time window, upper layers decide to change channel we can observe
warnings like below:

WARNING: at include/net/mac80211.h:3081 rate_control_send_low+0x8b/0x10f [mac80211]()
Call Trace:
 <IRQ>  [<ffffffff81054c2e>] warn_slowpath_common+0x83/0x9b
 [<ffffffff81054c60>] warn_slowpath_null+0x1a/0x1c
 [<ffffffffa025d5ff>] rate_control_send_low+0x8b/0x10f [mac80211]
 [<ffffffffa02ab306>] rs_get_rate+0x138/0x215 [iwlagn]
 [<ffffffffa025d993>] rate_control_get_rate+0x86/0x14c [mac80211]
 [<ffffffffa0265f18>] invoke_tx_handlers+0x829/0xe7d [mac80211]
 [<ffffffff8124bbf9>] ? swiotlb_unmap_page+0x9/0xb
 [<ffffffffa02bfc93>] ? pci_unmap_single+0x54/0x5b [iwlagn]
 [<ffffffffa02665d1>] ieee80211_tx+0x65/0x90 [mac80211]
 [<ffffffffa026675b>] ieee80211_xmit+0x15f/0x16e [mac80211]
 [<ffffffff813cfdd4>] ? __alloc_skb+0x8d/0x133
 [<ffffffffa02671cc>] ieee80211_tx_skb+0x56/0x5e [mac80211]
 [<ffffffffa02547ea>] ieee80211_send_bar+0xda/0xe9 [mac80211]
 [<ffffffffa024f5cf>] ieee80211_tx_status+0x1e1/0x706 [mac80211]
 [<ffffffff8148867c>] ? _raw_spin_unlock_irqrestore+0x17/0x19
 [<ffffffffa024eb5b>] ieee80211_tasklet_handler+0x5b/0xa8 [mac80211]

WARNING: at include/net/mac80211.h:3081 rate_control_send_low+0x8b/0x10f [mac80211]()
Call Trace:
 [<ffffffff81054c8e>] warn_slowpath_common+0x83/0x9b
 [<ffffffff81054cc0>] warn_slowpath_null+0x1a/0x1c
 [<ffffffffa0248627>] rate_control_send_low+0x8b/0x10f [mac80211]
 [<ffffffffa029d306>] rs_get_rate+0x138/0x215 [iwlagn]
 [<ffffffffa02489bb>] rate_control_get_rate+0x86/0x14c [mac80211]
 [<ffffffffa0250f2c>] invoke_tx_handlers+0x829/0xe7d [mac80211]
 [<ffffffffa02515e5>] ieee80211_tx+0x65/0x90 [mac80211]
 [<ffffffffa025176f>] ieee80211_xmit+0x15f/0x16e [mac80211]
 [<ffffffff813cf834>] ? __alloc_skb+0x8d/0x133
 [<ffffffffa02521e0>] ieee80211_tx_skb+0x56/0x5e [mac80211]
 [<ffffffffa023ef74>] ieee80211_send_delba+0x136/0x145 [mac80211]
 [<ffffffffa0240062>] ___ieee80211_stop_rx_ba_session+0xdc/0x10e [mac80211]
 [<ffffffffa02400e5>] __ieee80211_stop_rx_ba_session+0x51/0x68 [mac80211]
 [<ffffffffa023fc01>] ? ieee80211_start_tx_ba_cb+0x5b/0xd2 [mac80211]
 [<ffffffffa023ece5>] ieee80211_sta_tear_down_BA_sessions+0x50/0x5d [mac80211]
 [<ffffffffa0241be7>] ieee80211_set_disassoc+0xd1/0x1ee [mac80211]
 [<ffffffffa0241eb0>] ieee80211_sta_connection_lost+0x45/0x98 [mac80211]
 [<ffffffffa024450a>] ieee80211_sta_work+0x119/0x12c [mac80211]
 [<ffffffffa0247003>] ieee80211_iface_work+0x2af/0x2d2 [mac80211]

Lukasz, who can reproduce these warnings when switching between APs
confirmed patch fixes the problem in his setup.

Reported-and-tested-by: Lukasz Jagiello <jagiello.lukasz@gmail.com>
Cc: stable@vger.kernel.org # 3.0+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
Ccing to 3.0+ stable only because warnings showed up after update
to that kernel version. Even if problem existed before, it for some
reason did not manifest itself.

v1 -> v2 change order, first do mac80211 disassociate  

 net/mac80211/mlme.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 57fb58f..5147f38 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2379,8 +2379,14 @@ ieee80211_probe_auth_done(struct ieee80211_work *wk,
 			  struct sk_buff *skb)
 {
 	struct ieee80211_local *local = wk->sdata->local;
+	struct ieee80211_if_managed *ifmgd = &wk->sdata->u.mgd;
 
 	if (!skb) {
+		mutex_lock(&ifmgd->mtx);
+		if (ifmgd->associated)
+			ieee80211_set_disassoc(wk->sdata, true, false);
+		mutex_unlock(&ifmgd->mtx);
+
 		cfg80211_send_auth_timeout(wk->sdata->dev, wk->filter_ta);
 		goto destroy;
 	}
@@ -2390,9 +2396,9 @@ ieee80211_probe_auth_done(struct ieee80211_work *wk,
 		goto destroy;
 	}
 
-	mutex_lock(&wk->sdata->u.mgd.mtx);
+	mutex_lock(&ifmgd->mtx);
 	ieee80211_rx_mgmt_probe_resp(wk->sdata, skb);
-	mutex_unlock(&wk->sdata->u.mgd.mtx);
+	mutex_unlock(&ifmgd->mtx);
 
 	wk->type = IEEE80211_WORK_AUTH;
 	wk->probe_auth.tries = 0;
-- 
1.7.1

