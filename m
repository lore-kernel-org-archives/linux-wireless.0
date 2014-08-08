Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev-nolb.cloudtrax.com ([54.203.245.161]:35486 "EHLO
	dev-nolb.cloudtrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaHHLXa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2014 07:23:30 -0400
Message-ID: <53E4B305.8050500@open-mesh.com> (sfid-20140808_132334_240438_62BD7D30)
Date: Fri, 08 Aug 2014 13:22:45 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH] ath9k: fix aggregation session lockup
References: <1406122854-60239-1-git-send-email-nbd@openwrt.org> <53D6B87D.6080007@candelatech.com> <53D6BC7F.2020002@openwrt.org> <53D7C661.2040107@candelatech.com> <53DF8A36.1040402@open-mesh.com> <53DFE9B5.8040706@candelatech.com>
In-Reply-To: <53DFE9B5.8040706@candelatech.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="N13MQghfN5OaOJvqlLdCinU8jWvpDoIEo"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--N13MQghfN5OaOJvqlLdCinU8jWvpDoIEo
Content-Type: multipart/mixed;
 boundary="------------060001030401040003030306"

This is a multi-part message in MIME format.
--------------060001030401040003030306
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/08/14 22:14, Ben Greear wrote:
> On 08/04/2014 06:27 AM, Antonio Quartulli wrote:
>=20
>=20
>> On 29/07/14 18:05, Ben Greear wrote:
>>> On 07/28/2014 02:11 PM, Felix Fietkau wrote:
>>>> Interesting. Maybe you should ask Antonio for an updated version of =
the patch that he used to debug this issue. If you give me the output of =
it while
>>>> it's locked up, I might be able to figure out what's going on in you=
r setup.
>>>
>>> What is the easiest upstream tree for you to debug?
>=20
>> Sorry for the late reply but I was pretty "disconnected" in the last d=
ays.
>=20
>> Is the debugging patch still required? If so, I can dig in my buildroo=
t and retrieve it.
>=20
> I would appreciate it if you could post the patch.  I'd like to
> see if I can get the bug fixed once and for all.....
>=20
> Thanks,
> Ben

Ben,

attached you have the patches we have been using during our debug.

They create a new debugfs file that you can read when the wifi is stuck
in order to gather some information about the queues/tids status. The
file is located in the ath9k debugfs folder and its name is "nodes".

I hope it can help.

Cheers,

--=20
Antonio Quartulli

--------------060001030401040003030306
Content-Type: text/x-patch;
 name="921-debug.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="921-debug.patch"

diff -urw compat-wireless-2014-05-22.orig/drivers/net/wireless/ath/ath9k/=
ath9k.h compat-wireless-2014-05-22/drivers/net/wireless/ath/ath9k/ath9k.h=

--- compat-wireless-2014-05-22.orig/drivers/net/wireless/ath/ath9k/ath9k.=
h	2014-07-21 15:29:29.032197395 +0200
+++ compat-wireless-2014-05-22/drivers/net/wireless/ath/ath9k/ath9k.h	201=
4-07-21 15:49:42.032167390 +0200
@@ -22,6 +22,7 @@
 #include <linux/interrupt.h>
 #include <linux/leds.h>
 #include <linux/completion.h>
+#include <linux/types.h>
 #include <net/mac80211.h>
=20
 #include "common.h"
@@ -281,6 +282,7 @@
 	u8 key_idx[4];
=20
 	atomic_t decrypt_errors;
+	struct hlist_node list;
 };
=20
 struct ath_tx_control {
@@ -862,4 +864,9 @@
 static inline void ath_ahb_exit(void) {};
 #endif
=20
+
+extern struct hlist_head an_list;
+extern spinlock_t an_list_lock;
+struct ath_frame_info *get_frame_info(struct sk_buff *skb);
+
 #endif /* ATH9K_H */
diff -urw compat-wireless-2014-05-22.orig/drivers/net/wireless/ath/ath9k/=
debug.c compat-wireless-2014-05-22/drivers/net/wireless/ath/ath9k/debug.c=

--- compat-wireless-2014-05-22.orig/drivers/net/wireless/ath/ath9k/debug.=
c	2014-07-21 15:29:29.034197395 +0200
+++ compat-wireless-2014-05-22/drivers/net/wireless/ath/ath9k/debug.c	201=
4-07-21 15:50:22.406166391 +0200
@@ -18,6 +18,7 @@
 #include <linux/vmalloc.h>
 #include <linux/export.h>
 #include <asm/unaligned.h>
+#include <net/mac80211.h>
=20
 #include "ath9k.h"
=20
@@ -26,6 +27,9 @@
 #define REG_READ_D(_ah, _reg) \
 	ath9k_hw_common(_ah)->ops->read((_ah), (_reg))
=20
+static unsigned int nodes_len, nodes_size =3D 1024 * 1024;
+static char *nodes_buf;
+
 void ath9k_debug_sync_cause(struct ath_softc *sc, u32 sync_cause)
 {
 	if (sync_cause)
@@ -709,6 +713,134 @@
 	return len;
 }
=20
+static void ath9k_debug_print_skb(struct sk_buff_head *skb_head)
+{
+	struct ath_frame_info *fi;
+	struct ath_buf *bf;
+	struct sk_buff *skb;
+
+	skb_queue_walk(skb_head, skb) {
+		fi =3D get_frame_info(skb);
+		bf =3D fi->bf;
+
+		if (!bf) {
+			nodes_len +=3D snprintf(nodes_buf + nodes_len, nodes_size - nodes_len=
, "no bf\n");
+			continue;
+		}
+
+		nodes_len +=3D snprintf(nodes_buf + nodes_len,
+				      nodes_size - nodes_len,
+				      "bf->bf_state.seqno:%d fi->baw_tracked:%d fi->retries:%hhu fi-=
>framelen:%d\n",
+				      bf->bf_state.seqno, fi->baw_tracked,
+				      fi->retries, fi->framelen);
+	}
+}
+
+static void ath9k_debug_print_tid(struct ath_atx_tid *tid, int idx)
+{
+	int i;
+
+	nodes_len +=3D snprintf(nodes_buf + nodes_len, nodes_size - nodes_len,
+			      "TID: %d AC: %p\n", idx, tid->ac);
+
+	nodes_len +=3D snprintf(nodes_buf + nodes_len, nodes_size - nodes_len,
+			      "buf_q list begin.\n");
+	ath9k_debug_print_skb(&tid->buf_q);
+	nodes_len +=3D snprintf(nodes_buf + nodes_len, nodes_size - nodes_len,
+			      "buf_q list end.\n");
+
+	nodes_len +=3D snprintf(nodes_buf + nodes_len, nodes_size - nodes_len,
+			      "retry_q list begin.\n");
+	ath9k_debug_print_skb(&tid->retry_q);
+	nodes_len +=3D snprintf(nodes_buf + nodes_len, nodes_size - nodes_len,
+			      "retry_q list end.\n");
+
+	for (i =3D 0; i < BITS_TO_LONGS(ATH_TID_MAX_BUFS); i++) {
+		nodes_len +=3D snprintf(nodes_buf + nodes_len,
+				      nodes_size - nodes_len, "tx_buf %d: %lu\n",
+				      i, tid->tx_buf[i]);
+	}
+
+	nodes_len +=3D snprintf(nodes_buf + nodes_len, nodes_size - nodes_len,
+			"seq_start:%hu seq_next:%hu baw_size:%hu tidno:%hhu baw_head:%d baw_t=
ail:%d bar_index:%hhd sched:%hhu active:%hhu\n",
+			tid->seq_start, tid->seq_next,
+			tid->baw_size, tid->tidno, tid->baw_head, tid->baw_tail,
+			tid->bar_index, tid->sched, tid->active);
+}
+
+static void ath9k_debug_print_ac(struct ath_atx_ac *ac, int idx)
+{
+	nodes_len +=3D snprintf(nodes_buf + nodes_len, nodes_size - nodes_len,
+			      "AC: %i (%p) sched:%hhu clear_ps_filter:%hhu is_empty(tid_q):%h=
hu\n",
+			      idx, ac, ac->sched, ac->clear_ps_filter,
+			      list_empty(&ac->tid_q));
+}
+
+static void ath9k_debug_print_node(struct ath_node *an)
+{
+	struct ath_atx_tid *tid;
+	struct ath_atx_ac *ac;
+	int i;
+
+	if (an->sta) {
+		nodes_len +=3D snprintf(nodes_buf + nodes_len,
+				      nodes_size - nodes_len,
+				      "STA MAC: %pM ", an->sta->addr);
+	}
+
+	nodes_len +=3D snprintf(nodes_buf + nodes_len, nodes_size - nodes_len,
+			      "an->sleeping: %d\n", an->sleeping);
+
+	for (i =3D 0; i < IEEE80211_NUM_TIDS; i++) {
+		tid =3D &an->tid[i];
+		ath9k_debug_print_tid(tid, i);
+	}
+
+	for (i =3D 0; i < IEEE80211_NUM_ACS; i++) {
+		ac =3D &an->ac[i];
+		ath9k_debug_print_ac(ac, i);
+	}
+}
+
+static void ath9k_debug_print_mcast_node(void *data, u8 *mac,
+					 struct ieee80211_vif *vif)
+{
+	struct ath_vif *avif =3D (struct ath_vif *)vif->drv_priv;
+
+	nodes_len +=3D snprintf(nodes_buf + nodes_len, nodes_size - nodes_len,
+			      "VIF %pM\n", vif->addr);
+
+	ath9k_debug_print_node(&avif->mcast_node);
+}
+
+static ssize_t read_file_nodes(struct file *file, char __user *user_buf,=

+			       size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc =3D file->private_data;
+	struct ath_node *an;
+	int retval =3D 0;
+
+	nodes_len =3D 0;
+	nodes_buf =3D kzalloc(nodes_size, GFP_KERNEL);
+	if (!nodes_buf)
+		return -ENOMEM;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(an, &an_list, list) {
+		ath9k_debug_print_node(an);
+	}
+	rcu_read_unlock();
+
+	ieee80211_iterate_active_interfaces(sc->hw, 0,
+					    ath9k_debug_print_mcast_node, NULL);
+
+	retval =3D simple_read_from_buffer(user_buf, count, ppos, nodes_buf,
+					 nodes_len);
+	kfree(nodes_buf);
+
+	return retval;
+}
+
 static ssize_t read_file_queues(struct file *file, char __user *user_buf=
,
 				size_t count, loff_t *ppos)
 {
@@ -931,6 +1063,13 @@
 	.llseek =3D default_llseek,
 };
=20
+static const struct file_operations fops_nodes =3D {
+	.read =3D read_file_nodes,
+	.open =3D simple_open,
+	.owner =3D THIS_MODULE,
+	.llseek =3D default_llseek,
+};
+
 static const struct file_operations fops_queues =3D {
 	.read =3D read_file_queues,
 	.open =3D simple_open,
@@ -1522,6 +1661,8 @@
 			    &fops_xmit);
 	debugfs_create_file("queues", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_queues);
+	debugfs_create_file("nodes", S_IRUSR, sc->debug.debugfs_phy, sc,
+			    &fops_nodes);
 	debugfs_create_u32("qlen_bk", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,=

 			   &sc->tx.txq_max_pending[IEEE80211_AC_BK]);
 	debugfs_create_u32("qlen_be", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,=

diff -urw compat-wireless-2014-05-22.orig/drivers/net/wireless/ath/ath9k/=
main.c compat-wireless-2014-05-22/drivers/net/wireless/ath/ath9k/main.c
--- compat-wireless-2014-05-22.orig/drivers/net/wireless/ath/ath9k/main.c=
	2014-07-21 15:29:29.031197395 +0200
+++ compat-wireless-2014-05-22/drivers/net/wireless/ath/ath9k/main.c	2014=
-07-21 15:49:42.033167390 +0200
@@ -16,10 +16,14 @@
=20
 #include <linux/nl80211.h>
 #include <linux/delay.h>
+#include <linux/rculist.h>
 #include <net/mac80211.h>
 #include "ath9k.h"
 #include "btcoex.h"
=20
+struct hlist_head an_list;
+spinlock_t an_list_lock;
+
 static void ath9k_set_assoc_state(struct ath_softc *sc,
 				  struct ieee80211_vif *vif);
=20
@@ -429,12 +433,20 @@
 	memset(&an->key_idx, 0, sizeof(an->key_idx));
=20
 	ath_tx_node_init(sc, an);
+
+	spin_lock_bh(&an_list_lock);
+	hlist_add_head_rcu(&an->list, &an_list);
+	spin_unlock_bh(&an_list_lock);
 }
=20
 static void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *=
sta)
 {
 	struct ath_node *an =3D (struct ath_node *)sta->drv_priv;
 	ath_tx_node_cleanup(sc, an);
+
+	spin_lock_bh(&an_list_lock);
+	hlist_del_rcu(&an->list);
+	spin_unlock_bh(&an_list_lock);
 }
=20
 void ath9k_tasklet(unsigned long data)
@@ -726,6 +738,9 @@
 	struct ath9k_channel *init_channel;
 	int r;
=20
+	INIT_HLIST_HEAD(&an_list);
+	spin_lock_init(&an_list_lock);
+
 	ath_dbg(common, CONFIG,
 		"Starting driver with initial channel: %d MHz\n",
 		curchan->center_freq);
diff -urw compat-wireless-2014-05-22.orig/drivers/net/wireless/ath/ath9k/=
xmit.c compat-wireless-2014-05-22/drivers/net/wireless/ath/ath9k/xmit.c
--- compat-wireless-2014-05-22.orig/drivers/net/wireless/ath/ath9k/xmit.c=
	2014-07-21 15:29:29.034197395 +0200
+++ compat-wireless-2014-05-22/drivers/net/wireless/ath/ath9k/xmit.c	2014=
-07-21 15:49:42.033167390 +0200
@@ -120,7 +120,7 @@
 	list_add_tail(&ac->list, &txq->axq_acq);
 }
=20
-static struct ath_frame_info *get_frame_info(struct sk_buff *skb)
+struct ath_frame_info *get_frame_info(struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *tx_info =3D IEEE80211_SKB_CB(skb);
 	BUILD_BUG_ON(sizeof(struct ath_frame_info) >

--------------060001030401040003030306
Content-Type: text/x-patch;
 name="923-ath9k-queue-debug.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="923-ath9k-queue-debug.patch"

=46rom 3d06af34b48677146f9f0bdf4a3db29f3c195b39 Mon Sep 17 00:00:00 2001
From: Simon Wunderlich <sw@simonwunderlich.de>
Date: Tue, 22 Jul 2014 12:23:00 +0200
Subject: [PATCH] ath9k: queue debug

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless=
/ath/ath9k/xmit.c
index e9ad59b..41e9169 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1813,8 +1813,14 @@ void ath_txq_schedule(struct ath_softc *sc, struct=
 ath_txq *txq)
 	bool sent =3D false;
=20
 	if (test_bit(ATH_OP_HW_RESET, &common->op_flags) ||
-	    list_empty(&txq->axq_acq))
+	    list_empty(&txq->axq_acq)) {
+		ath_dbg(common, QUEUE, "%s %d queue qnum: %d is empty, not processing\=
n",
+			__func__, __LINE__, txq->axq_qnum);
 		return;
+	}
+
+	ath_dbg(common, QUEUE, "%s %d queue qnum: %d, txq depth: %d\n",
+		__func__, __LINE__, txq->axq_qnum, txq->axq_depth);
=20
 	rcu_read_lock();
=20
@@ -1826,6 +1832,8 @@ void ath_txq_schedule(struct ath_softc *sc, struct =
ath_txq *txq)
 		last_tid =3D list_entry(ac->tid_q.prev, struct ath_atx_tid, list);
 		list_del(&ac->list);
 		ac->sched =3D false;
+		ath_dbg(common, QUEUE, "%s %d processing ac %p, list_empty(&ac->tid_q)=
: %d\n",
+			__func__, __LINE__, ac, list_empty(&ac->tid_q));
=20
 		while (!list_empty(&ac->tid_q)) {
=20
--=20
1.9.1


--------------060001030401040003030306
Content-Type: text/x-patch;
 name="924-ath9k-more-debug-output.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="924-ath9k-more-debug-output.patch"

=46rom 818253338aec9ce33c83b4d2e839520ae406d5ce Mon Sep 17 00:00:00 2001
From: Simon Wunderlich <sw@simonwunderlich.de>
Date: Tue, 22 Jul 2014 18:48:59 +0200
Subject: [PATCH] ath9k: more debug output

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless=
/ath/ath9k/xmit.c
index 41e9169..b75e9f7 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1327,7 +1327,7 @@ ath_tx_form_burst(struct ath_softc *sc, struct ath_=
txq *txq,
 }
=20
 static bool ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,=

-			      struct ath_atx_tid *tid, bool *stop)
+			      struct ath_atx_tid *tid, bool *stop, int *step)
 {
 	struct ath_buf *bf;
 	struct ieee80211_tx_info *tx_info;
@@ -1336,15 +1336,18 @@ static bool ath_tx_sched_aggr(struct ath_softc *s=
c, struct ath_txq *txq,
 	int aggr_len =3D 0;
 	bool aggr, last =3D true;
=20
+	*step =3D 0;
 	if (!ath_tid_has_buffered(tid))
 		return false;
=20
 	INIT_LIST_HEAD(&bf_q);
+	*step =3D 1;
=20
 	bf =3D ath_tx_get_tid_subframe(sc, txq, tid, &tid_q);
 	if (!bf)
 		return false;
=20
+	*step =3D 2;
 	tx_info =3D IEEE80211_SKB_CB(bf->bf_mpdu);
 	aggr =3D !!(tx_info->flags & IEEE80211_TX_CTL_AMPDU);
 	if ((aggr && txq->axq_ampdu_depth >=3D ATH_AGGR_MIN_QDEPTH) ||
@@ -1353,6 +1356,7 @@ static bool ath_tx_sched_aggr(struct ath_softc *sc,=
 struct ath_txq *txq,
 		return false;
 	}
=20
+	*step =3D 3;
 	ath_set_rates(tid->an->vif, tid->an->sta, bf);
 	if (aggr)
 		last =3D ath_tx_form_aggr(sc, txq, tid, &bf_q, bf,
@@ -1360,13 +1364,16 @@ static bool ath_tx_sched_aggr(struct ath_softc *s=
c, struct ath_txq *txq,
 	else
 		ath_tx_form_burst(sc, txq, tid, &bf_q, bf, tid_q);
=20
+	*step =3D 4;
 	if (list_empty(&bf_q))
 		return false;
=20
+	*step =3D 5;
 	if (tid->ac->clear_ps_filter || tid->an->no_ps_filter) {
 		tid->ac->clear_ps_filter =3D false;
 		tx_info->flags |=3D IEEE80211_TX_CTL_CLEAR_PS_FILT;
 	}
+	*step =3D 6;
=20
 	ath_tx_fill_desc(sc, bf, txq, aggr_len);
 	ath_tx_txqaddbuf(sc, txq, &bf_q, false);
@@ -1836,22 +1843,32 @@ void ath_txq_schedule(struct ath_softc *sc, struc=
t ath_txq *txq)
 			__func__, __LINE__, ac, list_empty(&ac->tid_q));
=20
 		while (!list_empty(&ac->tid_q)) {
+			int ret, step;
=20
 			tid =3D list_first_entry(&ac->tid_q, struct ath_atx_tid,
 					       list);
 			list_del(&tid->list);
 			tid->sched =3D false;
=20
-			if (ath_tx_sched_aggr(sc, txq, tid, &stop))
+			ret =3D ath_tx_sched_aggr(sc, txq, tid, &stop, &step);
+			if (ret)
 				sent =3D true;
+			ath_dbg(common, QUEUE, "%s %d tid %d of ac %p: ath_tx_sched_aggr retu=
rned %d, stop =3D %d, last_tid =3D %d, step =3D %d\n",
+				__func__, __LINE__, tid->tidno, ac, ret, stop, last_tid->tidno, step=
);
=20
 			/*
 			 * add tid to round-robin queue if more frames
 			 * are pending for the tid
 			 */
-			if (ath_tid_has_buffered(tid))
+			ret =3D ath_tid_has_buffered(tid);
+			if (ret)
 				ath_tx_queue_tid(txq, tid);
=20
+			ath_dbg(common, QUEUE, "%s %d tid %d of ac %p: ath_tid_has_buffered r=
eturned %d\n",
+				__func__, __LINE__, tid->tidno, ac, ret);
+
+
+
 			if (stop || tid =3D=3D last_tid)
 				break;
 		}
--=20
1.9.1


--------------060001030401040003030306
Content-Type: text/x-patch;
 name="925-ath9k-print-tx_info.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="925-ath9k-print-tx_info.patch"

diff -urw compat-wireless-2014-05-22.orig/drivers/net/wireless/ath/ath9k/=
debug.c compat-wireless-2014-05-22/drivers/net/wireless/ath/ath9k/debug.c=

--- compat-wireless-2014-05-22.orig/drivers/net/wireless/ath/ath9k/debug.=
c	2014-07-23 00:44:26.713083838 +0200
+++ compat-wireless-2014-05-22/drivers/net/wireless/ath/ath9k/debug.c	201=
4-07-23 00:56:13.615066352 +0200
@@ -715,14 +715,20 @@
=20
 static void ath9k_debug_print_skb(struct sk_buff_head *skb_head)
 {
+	struct ieee80211_tx_info *tx_info;
 	struct ath_frame_info *fi;
 	struct ath_buf *bf;
 	struct sk_buff *skb;
=20
 	skb_queue_walk(skb_head, skb) {
+		tx_info =3D IEEE80211_SKB_CB(skb);
+		nodes_len +=3D snprintf(nodes_buf + nodes_len,
+				      nodes_size - nodes_len,
+				      "skb tx_info->flags =3D %#.8x\n",
+				      tx_info->flags);
+
 		fi =3D get_frame_info(skb);
 		bf =3D fi->bf;
-
 		if (!bf) {
 			nodes_len +=3D snprintf(nodes_buf + nodes_len, nodes_size - nodes_len=
, "no bf\n");
 			continue;

--------------060001030401040003030306--

--N13MQghfN5OaOJvqlLdCinU8jWvpDoIEo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJT5LMJAAoJEJgn97Bh2u9eU2kP/0rcVOafuowMlr61vQKEO55a
WWwJXZN4PZ1d3+PJ2qx1F7NHLwck+sLmCR/dLRFAtoBX/oE7CEyvsPBIOBdvwgBa
/iv0vdLogjnzNUoSCLzSxn30G2fXNOBv+X8F0wAhRizMByiGMHnLlYLrxhR6BIUX
wtFNH1nY+QyONsEIUJG0sVvXZyy2fsjaTdAPoeP/M8L4JmlmmL3BqUJGRqM8xUOC
so49Wkq+PdC6MzXelWgScGdOZS4DoGdHQUrtbFPYbg9h9t+UOvPeVVpZLrb1hY01
vtVCObTyfdF65HsFSZ/2ODjSys27Il2FnARU9hZP6SWWRSBMn7swnqS66YDMXzkS
k90FcrPhUo47wiIDU/wRdqVjisUZ6JBOUUE/hinkijVvc8V+Au6/jrXG1ZVBH9xT
VT0dzD5CQEOMvSF+fgFS44akAjbYumTdbMk1Wny4HClYbOnkHXDqEZYYBu01dRpg
TPWSmZPHPqDsESCDCpFcidLxNT4M1HLhN0JSTKYKU7kJ7lQ7tWtX9U4icJwImBNm
MP7MGtf0YcVNSS3VWy0l5rvp6wRI5tEDra3tRm2uUY3A+VNDSqnG4Df6Qdk3e+R1
PRETYV+V7slNtAcLYouvPA8WlAIUMqTezpnwcb+AJTR5zEGD322WEXiEkojYAmQH
8B/43i8qEQfjhZpfZACu
=6eAQ
-----END PGP SIGNATURE-----

--N13MQghfN5OaOJvqlLdCinU8jWvpDoIEo--
