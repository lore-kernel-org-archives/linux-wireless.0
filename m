Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:33814 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbcF0LVQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 07:21:16 -0400
Received: by mail-lf0-f44.google.com with SMTP id h129so154253099lfh.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2016 04:21:15 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: kvalo@qca.qualcomm.com
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFT] mac80211: fix fq lockdep warnings
Date: Mon, 27 Jun 2016 13:22:49 +0200
Message-Id: <1467026569-19329-1-git-send-email-michal.kazior@tieto.com> (sfid-20160627_132119_926190_9A2B487A)
In-Reply-To: <878txzo7c6.fsf@kamboji.qca.qualcomm.com>
References: <878txzo7c6.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some lockdep assertions were not fulfilled and
resulted in a kernel warning/call trace.

Existing code sequences should've guranteed safety
but it's always good to be extra careful.

The call trace could look like this:

 [ 237.335805] ------------[ cut here ]------------
 [ 237.335852] WARNING: CPU: 3 PID: 1921 at include/net/fq_impl.h:22 fq_flow_dequeue+0xed/0x140 [mac80211]
 [ 237.335855] Modules linked in: ath10k_pci(E-) ath10k_core(E) ath(E) mac80211(E) cfg80211(E)
 [ 237.335913] CPU: 3 PID: 1921 Comm: rmmod Tainted: G        W   E   4.7.0-rc4-wt-ath+ #1377
 [ 237.335916] Hardware name: Hewlett-Packard HP ProBook 6540b/1722, BIOS 68CDD Ver. F.04 01/27/2010
 [ 237.335918]  00200286 00200286 eff85dac c14151e2 f901574e 00000000 eff85de0 c1081075
 [ 237.335928]  c1ab91f0 00000003 00000781 f901574e 00000016 f8fbabad f8fbabad 00000016
 [ 237.335938]  eb24ff60 00000000 ef3886c0 eff85df4 c10810ba 00000009 00000000 00000000
 [ 237.335948] Call Trace:
 [ 237.335953]  [<c14151e2>] dump_stack+0x76/0xb4
 [ 237.335957]  [<c1081075>] __warn+0xe5/0x100
 [ 237.336002]  [<f8fbabad>] ? fq_flow_dequeue+0xed/0x140 [mac80211]
 [ 237.336046]  [<f8fbabad>] ? fq_flow_dequeue+0xed/0x140 [mac80211]
 [ 237.336053]  [<c10810ba>] warn_slowpath_null+0x2a/0x30
 [ 237.336095]  [<f8fbabad>] fq_flow_dequeue+0xed/0x140 [mac80211]
 [ 237.336137]  [<f8fbc67a>] fq_flow_reset.constprop.56+0x2a/0x90 [mac80211]
 [ 237.336180]  [<f8fbc79a>] fq_reset.constprop.59+0x2a/0x50 [mac80211]
 [ 237.336222]  [<f8fc04e8>] ieee80211_txq_teardown_flows+0x38/0x40 [mac80211]
 [ 237.336258]  [<f8f7c1a4>] ieee80211_unregister_hw+0xe4/0x120 [mac80211]
 [ 237.336275]  [<f933f536>] ath10k_mac_unregister+0x16/0x50 [ath10k_core]
 [ 237.336292]  [<f934592d>] ath10k_core_unregister+0x3d/0x90 [ath10k_core]
 [ 237.336301]  [<f85f8836>] ath10k_pci_remove+0x36/0xa0 [ath10k_pci]
 [ 237.336307]  [<c1470388>] pci_device_remove+0x38/0xb0
 ...

Fixes: 5caa328e3811 ("mac80211: implement codel on fair queuing flows")
Fixes: fa962b92120b ("mac80211: implement fair queueing per txq")
Reported-by: Valo, Kalle <kvalo@qca.qualcomm.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Hi Kalle,

Can you verify this fixes call traces you're
seeing, please?


 net/mac80211/tx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 44ec605a5682..1975c22132c6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1445,7 +1445,9 @@ int ieee80211_txq_setup_flows(struct ieee80211_local *local)
 	local->cvars = kcalloc(fq->flows_cnt, sizeof(local->cvars[0]),
 			       GFP_KERNEL);
 	if (!local->cvars) {
+		spin_lock_bh(&fq->lock);
 		fq_reset(fq, fq_skb_free_func);
+		spin_unlock_bh(&fq->lock);
 		return -ENOMEM;
 	}
 
@@ -1465,7 +1467,9 @@ void ieee80211_txq_teardown_flows(struct ieee80211_local *local)
 	kfree(local->cvars);
 	local->cvars = NULL;
 
+	spin_lock_bh(&fq->lock);
 	fq_reset(fq, fq_skb_free_func);
+	spin_unlock_bh(&fq->lock);
 }
 
 struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
-- 
2.1.4

