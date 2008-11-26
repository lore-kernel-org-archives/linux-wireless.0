Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50591 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbYKZRez (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 12:34:55 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 09:34:55 -0800
Date: Wed, 26 Nov 2008 09:34:53 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Andrey Vul <andrey.vul@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: cannot compile compat-wireless-2.6-old
Message-ID: <20081126173453.GC6515@tesla> (sfid-20081126_183500_321813_34C0FAD7)
References: <e38d12ff0811250953p4dca0fe2kbc378f0184d4d4fa@mail.gmail.com> <e38d12ff0811250957y16078303g8f8346d60c92ff4c@mail.gmail.com> <20081125203244.GD5950@tesla> <e38d12ff0811251330x2b2d9a35h608b1619441f1252@mail.gmail.com> <e38d12ff0811251651k32a66cd5r3de7f1d504b4723@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <e38d12ff0811251651k32a66cd5r3de7f1d504b4723@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 25, 2008 at 04:51:48PM -0800, Andrey Vul wrote:
> On Tue, Nov 25, 2008 at 16:30, Andrey Vul <andrey.vul@gmail.com> wrote:
> > On Tue, Nov 25, 2008 at 15:32, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
> >> On Tue, Nov 25, 2008 at 09:57:57AM -0800, Andrey Vul wrote:
> >>> I cannot compile the current compat tarball.
> >>> Make log:
> >>> ./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
> >>> make -C /usr/src/linux-2.6.26.6-rt11/ M=/root/compat-wireless-2.6-old modules
> >>> make[1]: Entering directory `/usr/src/linux-2.6.26.6-rt11'
> >>>  CC [M]  /root/compat-wireless-2.6-old/drivers/net/wireless/mac80211_hwsim.o
> >>> In file included from <command-line>:0:
> >>> /root/compat-wireless-2.6-old/include/net/compat.h:877: error:
> >>> redefinition of 'list_splice_tail'
> >>> include/linux/list.h:356: error: previous definition of
> >>> 'list_splice_tail' was here
> >>> /root/compat-wireless-2.6-old/include/net/compat.h:892: error:
> >>> redefinition of 'list_splice_tail_init'
> >>> include/linux/list.h:379: error: previous definition of
> >>> 'list_splice_tail_init' was here
> >>
> >> list_splice_tail was added as of 2.6.27, and you have 2.6.26. Which
> >> means your kernel headers for your box are completely messed up. This
> >> means you can expect a kernel panic if you were to successfully
> >> compile external modules. Go fix that first.
> >>
> I have $(uname -r)/include/linux/list.h containing list_splice_tail,
> where uname -r is 2.6.26.5-rt9.
> Frankly, I need rt and the code for my wifi card is only in the compat tarball.
> Is this a problem with .[56] or with -rt?

Ah, yeah RT had their own list_splice_tail(), try this. BTW what driver
are you going to be using?

diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 3fc6641..6562dae 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -80,7 +80,7 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc,
 
 	bf = list_first_entry(head, struct ath_buf, list);
 
-	list_splice_tail_init(head, &txq->axq_q);
+	list_splice_tail_init_27(head, &txq->axq_q);
 	txq->axq_depth++;
 	txq->axq_totalqueued++;
 	txq->axq_linkbuf = list_entry(txq->axq_q.prev, struct ath_buf, list);
@@ -426,7 +426,7 @@ static void ath_tx_complete_buf(struct ath_softc *sc,
 	 * Return the list of ath_buf of this mpdu to free queue
 	 */
 	spin_lock_bh(&sc->sc_txbuflock);
-	list_splice_tail_init(bf_q, &sc->sc_txbuf);
+	list_splice_tail_init_27(bf_q, &sc->sc_txbuf);
 	spin_unlock_bh(&sc->sc_txbuflock);
 }
 
@@ -1084,7 +1084,7 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 			 * Put this buffer to the temporary pending
 			 * queue to retain ordering
 			 */
-			list_splice_tail_init(&bf_head, &bf_pending);
+			list_splice_tail_init_27(&bf_head, &bf_pending);
 		}
 
 		bf = bf_next;
@@ -1423,7 +1423,7 @@ static int ath_tx_send_ampdu(struct ath_softc *sc,
 		 * Add this frame to software queue for scheduling later
 		 * for aggregation.
 		 */
-		list_splice_tail_init(bf_head, &tid->buf_q);
+		list_splice_tail_init_27(bf_head, &tid->buf_q);
 		ath_tx_queue_tid(txq, tid);
 		return 0;
 	}
@@ -1682,7 +1682,7 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		/*
 		 * link buffers of this frame to the aggregate
 		 */
-		list_splice_tail_init(&bf_head, bf_q);
+		list_splice_tail_init_27(&bf_head, bf_q);
 		nframes++;
 
 		if (bf_prev) {
diff --git a/include/net/compat.h b/include/net/compat.h
index 0ccabcd..7baae3f 100644
--- a/include/net/compat.h
+++ b/include/net/compat.h
@@ -869,12 +869,18 @@ static inline void __compat_list_splice_new_27(const struct list_head *list,
 	next->prev = last;
 }
 
+/* This is how we ended up implementing list_splice_tail on >= 2.6.27,
+ * note that the realtime kernel has their own list_splice_tail(), IIRC
+ * its the same, but lets just call it separately, just to be sure,
+ * and to avoid conflicts with the Realtime kernels. On >= 2.6.27
+ * this should not be an issue */
+
 /**
- * list_splice_tail - join two lists, each list being a queue
+ * list_splice_tail_27 - join two lists, each list being a queue
  * @list: the new list to add.
  * @head: the place to add it in the first list.
  */
-static inline void list_splice_tail(struct list_head *list,
+static inline void list_splice_tail_27(struct list_head *list,
 				struct list_head *head)
 {
 	if (!list_empty(list))
@@ -882,14 +888,14 @@ static inline void list_splice_tail(struct list_head *list,
 }
 
 /**
- * list_splice_tail_init - join two lists and reinitialise the emptied list
+ * list_splice_tail_init_27 - join two lists and reinitialise the emptied list
  * @list: the new list to add.
  * @head: the place to add it in the first list.
  *
  * Each of the lists is a queue.
  * The list at @list is reinitialised
  */
-static inline void list_splice_tail_init(struct list_head *list,
+static inline void list_splice_tail_init_27(struct list_head *list,
 					 struct list_head *head)
 {
 	if (!list_empty(list)) {
