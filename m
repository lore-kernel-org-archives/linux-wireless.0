Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:49695 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab1EIM1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 08:27:50 -0400
Received: from zenon.in.qult.net ([192.168.128.3])
	by qult.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <i@lri.fr>)
	id 1QJOuY-00033E-BT
	for linux-wireless@vger.kernel.org; Mon, 09 May 2011 13:46:02 +0200
Received: from ig by zenon.in.qult.net with local (Exim 4.74)
	(envelope-from <i@lri.fr>)
	id 1QJOuX-0007Du-Dj
	for linux-wireless@vger.kernel.org; Mon, 09 May 2011 13:46:01 +0200
Date: Mon, 9 May 2011 13:46:01 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: linux-wireless@vger.kernel.org
Subject: Re: compile-error agg-tx.c: =?utf-8?Q?erro?=
 =?utf-8?Q?r=3A_implicit_declaration_of_function_=E2=80=98kfree=5Frcu?=
 =?utf-8?B?4oCZ?=
Message-ID: <20110509114601.GA27067@zenon.in.qult.net> (sfid-20110509_142755_997953_CBC8FF86)
References: <4DC2C743.9060004@01019freenet.de>
 <BANLkTi=V2=UpZENHek37q2D43KZyeAiO-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
In-Reply-To: <BANLkTi=V2=UpZENHek37q2D43KZyeAiO-Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 06, 2011 at 10:35:08AM +0530, thus spake Mohammed Shafi:
> On Thu, May 5, 2011 at 9:20 PM, Andreas Hartmann
> <andihartmann@01019freenet.de> wrote:
> > Hello,
> >
> > since May, there is a compile error in compat-wireless (against kernel
> > 2.6.34):

I, as it appears with many others, have the same kind of trouble compiling the
latests compat-wireless snapshots on some kernels (2.6.38 for me).

Obviously the kfree_rcu machinery should go into some compat/ source file.  In
the meantime, I personnaly reverted these changes (see attached patch) and it
works just fine.

-- 
/* This is not a comment */

--oyUTqETQ0mS9luUI
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="compat-wireless-no-kfree-rcu.patch"

diff --git b/net/mac80211/agg-tx.c a/net/mac80211/agg-tx.c
index 53defaf..63d852c 100644
--- b/net/mac80211/agg-tx.c
+++ a/net/mac80211/agg-tx.c
@@ -136,6 +136,14 @@ void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid, u1
 	ieee80211_tx_skb(sdata, skb);
 }
 
+static void kfree_tid_tx(struct rcu_head *rcu_head)
+{
+	struct tid_ampdu_tx *tid_tx =
+	    container_of(rcu_head, struct tid_ampdu_tx, rcu_head);
+
+	kfree(tid_tx);
+}
+
 int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 				    enum ieee80211_back_parties initiator,
 				    bool tx)
@@ -155,7 +163,7 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 		/* not even started yet! */
 		rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], NULL);
 		spin_unlock_bh(&sta->lock);
-		kfree_rcu(tid_tx, rcu_head);
+		call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
 		return 0;
 	}
 
@@ -314,7 +322,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 		spin_unlock_bh(&sta->lock);
 
 		ieee80211_wake_queue_agg(local, tid);
-		kfree_rcu(tid_tx, rcu_head);
+		call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
 		return;
 	}
 
@@ -693,7 +701,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid)
 
 	ieee80211_agg_splice_finish(local, tid);
 
-	kfree_rcu(tid_tx, rcu_head);
+	call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
 
  unlock_sta:
 	spin_unlock_bh(&sta->lock);
diff --git b/net/mac80211/work.c a/net/mac80211/work.c
index d2e7f0e..a94b312 100644
--- b/net/mac80211/work.c
+++ a/net/mac80211/work.c
@@ -65,9 +65,17 @@ static void run_again(struct ieee80211_local *local,
 		mod_timer(&local->work_timer, timeout);
 }
 
+static void work_free_rcu(struct rcu_head *head)
+{
+	struct ieee80211_work *wk =
+		container_of(head, struct ieee80211_work, rcu_head);
+
+	kfree(wk);
+}
+
 void free_work(struct ieee80211_work *wk)
 {
-	kfree_rcu(wk, rcu_head);
+	call_rcu(&wk->rcu_head, work_free_rcu);
 }
 
 static int ieee80211_compatible_rates(const u8 *supp_rates, int supp_rates_len,

--oyUTqETQ0mS9luUI--
