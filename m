Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3689 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab1ILKPT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 06:15:19 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 03/20] staging: brcm80211: cleaned up brcmu_utils.h
 macro's
Date: Mon, 12 Sep 2011 12:14:47 +0200
Message-ID: <1315822504-24210-4-git-send-email-rvossen@broadcom.com> (sfid-20110912_121526_736628_B6C758CF)
In-Reply-To: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Substituted/removed macro's.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/ampdu.c       |    4 +
 drivers/staging/brcm80211/brcmsmac/main.c        |    6 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |   14 ++-
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c |    7 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |   17 ++-
 drivers/staging/brcm80211/brcmsmac/pub.h         |    6 +-
 drivers/staging/brcm80211/brcmsmac/types.h       |    2 +
 drivers/staging/brcm80211/include/brcmu_utils.h  |  161 +++++++++++-----------
 8 files changed, 115 insertions(+), 102 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index 9c1ae7c..efae10f 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -69,6 +69,10 @@
 	AMPDU_DELIMITER_LEN + 3\
 	+ DOT11_A4_HDR_LEN + DOT11_QOS_LEN + DOT11_IV_MAX_LEN)
 
+/* modulo add/sub, bound = 2^k */
+#define MODADD_POW2(x, y, bound) (((x) + (y)) & ((bound) - 1))
+#define MODSUB_POW2(x, y, bound) (((x) - (y)) & ((bound) - 1))
+
 /* structure to hold tx fifo information and pre-loading state
  * counters specific to tx underflows of ampdus
  * some counters might be redundant with the ones in wlc or ampdu structures.
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 7cd3b9e..51ad7f0 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -186,6 +186,8 @@
 
 #define	BRCMS_HWRXOFF		38	/* chip rx buffer offset */
 
+#define OSL_SYSUPTIME()		((u32)jiffies * (1000 / HZ))
+
 /*
  * driver maintains internal 'tick'(wlc->pub->now) which increments in 1s
  * OS timer(soft watchdog) it is not a wall clock and won't increment when
@@ -7863,8 +7865,8 @@ void brcms_c_send_q(struct brcms_c_info *wlc)
 		int prio;
 		for (prio = MAXPRIO; prio >= 0; prio--) {
 			if (brcms_c_txflowcontrol_prio_isset(wlc, qi, prio) &&
-			    (pktq_plen(q, wlc_prio2prec_map[prio]) <
-			    wlc->pub->tunables->datahiwat / 2))
+			    q->q[wlc_prio2prec_map[prio]].len <
+			    wlc->pub->tunables->datahiwat / 2)
 				brcms_c_txflowcontrol(wlc, qi, OFF, prio);
 		}
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index a159961..119a127 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -13,7 +13,7 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
-
+#include <linux/kernel.h>
 #include <linux/delay.h>
 
 #include <brcm_hw_ids.h>
@@ -37,6 +37,16 @@
 		(ISNPHY(pi) ? VALID_N_RADIO(radioid) : false) || \
 		(ISLCNPHY(pi) ? VALID_LCN_RADIO(radioid) : false))
 
+/* basic mux operation - can be optimized on several architectures */
+#define MUX(pred, true, false) ((pred) ? (true) : (false))
+
+/* modulo inc/dec - assumes x E [0, bound - 1] */
+#define MODINC(x, bound) MUX((x) == (bound) - 1, 0, (x) + 1)
+
+/* modulo inc/dec, bound = 2^k */
+#define MODDEC_POW2(x, bound) (((x) - 1) & ((bound) - 1))
+#define MODINC_POW2(x, bound) (((x) + 1) & ((bound) - 1))
+
 struct chan_info_basic {
 	u16 chan;
 	u16 freq;
@@ -2879,7 +2889,7 @@ u8 wlc_phy_nbits(s32 value)
 	s32 abs_val;
 	u8 nbits = 0;
 
-	abs_val = ABS(value);
+	abs_val = abs(value);
 	while ((abs_val >> nbits) > 0)
 		nbits++;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index fa21734..46661b8 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -14,6 +14,7 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/cordic.h>
 
@@ -3378,9 +3379,9 @@ wlc_lcnphy_start_tx_tone(struct brcms_phy *pi, s32 f_kHz, u16 max_val,
 		k = 1;
 		do {
 			bw = phy_bw * 1000 * k;
-			num_samps = bw / ABS(f_kHz);
+			num_samps = bw / abs(f_kHz);
 			k++;
-		} while ((num_samps * (u32) (ABS(f_kHz))) != bw);
+		} while ((num_samps * (u32) (abs(f_kHz))) != bw);
 	} else
 		num_samps = 2;
 
@@ -3894,7 +3895,7 @@ static void wlc_lcnphy_txpwrtbl_iqlo_cal(struct brcms_phy *pi)
 	}
 
 	wlc_lcnphy_get_radio_loft(pi, &ei0, &eq0, &fi0, &fq0);
-	if ((ABS((s8) fi0) == 15) && (ABS((s8) fq0) == 15)) {
+	if ((abs((s8) fi0) == 15) && (abs((s8) fq0) == 15)) {
 		if (CHSPEC_IS5G(pi->radio_chanspec)) {
 			target_gains.gm_gain = 255;
 			target_gains.pga_gain = 255;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index 7a50a23..58645d2 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -14,6 +14,7 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/cordic.h>
 
@@ -22648,7 +22649,7 @@ static void wlc_phy_rssi_cal_nphy_rev3(struct brcms_phy *pi)
 					poll_results[vcm_final][result_idx];
 				if (fine_digital_offset[result_idx] < 0) {
 					fine_digital_offset[result_idx] =
-						ABS(fine_digital_offset
+						abs(fine_digital_offset
 						    [result_idx]);
 					fine_digital_offset[result_idx] +=
 						(NPHY_RSSICAL_NPOLL / 2);
@@ -22727,7 +22728,7 @@ static void wlc_phy_rssi_cal_nphy_rev3(struct brcms_phy *pi)
 					if (fine_digital_offset[result_idx] <
 					    0) {
 						fine_digital_offset[result_idx]
-							= ABS(
+							= abs(
 							    fine_digital_offset
 							    [result_idx]);
 						fine_digital_offset[result_idx]
@@ -23004,7 +23005,7 @@ static void wlc_phy_rssi_cal_nphy_rev2(struct brcms_phy *pi, u8 rssi_type)
 		min_vcm = 0;
 		min_poll = NPHY_RSSICAL_MAXREAD * NPHY_RSSICAL_NPOLL + 1;
 		for (vcm = 0; vcm < 4; vcm++) {
-			curr_d = ABS(((rssi_type == NPHY_RSSI_SEL_NB) ?
+			curr_d = abs(((rssi_type == NPHY_RSSI_SEL_NB) ?
 				      poll_results[vcm][result_idx] :
 				      poll_miniq[vcm][result_idx / 2]) -
 				     (target_code * NPHY_RSSICAL_NPOLL));
@@ -23028,7 +23029,7 @@ static void wlc_phy_rssi_cal_nphy_rev2(struct brcms_phy *pi, u8 rssi_type)
 			poll_results[vcm_final[result_idx]][result_idx];
 		if (fine_digital_offset[result_idx] < 0) {
 			fine_digital_offset[result_idx] =
-				ABS(fine_digital_offset[result_idx]);
+				abs(fine_digital_offset[result_idx]);
 			fine_digital_offset[result_idx] +=
 				(NPHY_RSSICAL_NPOLL / 2);
 			fine_digital_offset[result_idx] /= NPHY_RSSICAL_NPOLL;
@@ -27422,9 +27423,9 @@ wlc_phy_rc_sweep_nphy(struct brcms_phy *pi, u8 core_idx, u8 loopback_type)
 
 		if (rccal_stepsize == -1) {
 			best_rccal_val =
-				(ABS((int)last_pwr_ratio -
+				(abs((int)last_pwr_ratio -
 				     (int)target_pwr_ratio) <
-				 ABS((int)pwr_ratio -
+				 abs((int)pwr_ratio -
 				     (int)target_pwr_ratio)) ? last_rccal_val :
 				rccal_val;
 
@@ -28324,10 +28325,10 @@ void wlc_phy_txpwr_papd_cal_nphy(struct brcms_phy *pi)
 		|| (wlc_phy_txpwr_ison_nphy(pi)
 		    &&
 		    (((u32)
-		      ABS(wlc_phy_txpwr_idx_cur_get_nphy(pi, 0) -
+		      abs(wlc_phy_txpwr_idx_cur_get_nphy(pi, 0) -
 			  pi->nphy_papd_tx_gain_at_last_cal[0]) >= 4)
 		     || ((u32)
-			 ABS(wlc_phy_txpwr_idx_cur_get_nphy(pi, 1) -
+			 abs(wlc_phy_txpwr_idx_cur_get_nphy(pi, 1) -
 			     pi->nphy_papd_tx_gain_at_last_cal[1]) >= 4)))))
 		wlc_phy_a4(pi, true);
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index f623d6e..381ddb4 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -237,11 +237,7 @@ struct brcms_pub {
 					 */
 	bool align_wd_tbtt;	/* Align watchdog with tbtt indication
 				 * handling. This flag is cleared by default
-				 * and is set by per port code explicitly and
-				 * you need to make sure the OSL_SYSUPTIME()
-				 * is implemented properly in osl of that port
-				 * when it enables this Power Save feature.
-				 */
+				 * and is set explicitly */
 
 	u16 boardrev;	/* version # of particular board */
 	u8 sromrev;		/* version # of the srom */
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index f9794dc..a3af57c 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -341,6 +341,8 @@ do {						\
 #define mboolisset(mb, bit)		(((mb) & (bit)) != 0)
 #define	mboolmaskset(mb, mask, val)	((mb) = (((mb) & ~(mask)) | (val)))
 
+#define CEIL(x, y)		(((x) + ((y)-1)) / (y))
+
 /* forward declarations */
 struct wiphy;
 struct ieee80211_sta;
diff --git a/drivers/staging/brcm80211/include/brcmu_utils.h b/drivers/staging/brcm80211/include/brcmu_utils.h
index de627c2..6339721 100644
--- a/drivers/staging/brcm80211/include/brcmu_utils.h
+++ b/drivers/staging/brcm80211/include/brcmu_utils.h
@@ -48,6 +48,34 @@ struct brcmu_strbuf {
 #define PKTQ_LEN_DEFAULT        128	/* Max 128 packets */
 #define PKTQ_MAX_PREC           16	/* Maximum precedence levels */
 
+#define BCME_STRLEN		64	/* Max string length for BCM errors */
+
+/* the largest reasonable packet buffer driver uses for ethernet MTU in bytes */
+#define	PKTBUFSZ	2048
+
+#ifndef setbit
+#ifndef NBBY			/* the BSD family defines NBBY */
+#define	NBBY	8		/* 8 bits per byte */
+#endif				/* #ifndef NBBY */
+#define	setbit(a, i)	(((u8 *)a)[(i)/NBBY] |= 1<<((i)%NBBY))
+#define	clrbit(a, i)	(((u8 *)a)[(i)/NBBY] &= ~(1<<((i)%NBBY)))
+#define	isset(a, i)	(((const u8 *)a)[(i)/NBBY] & (1<<((i)%NBBY)))
+#define	isclr(a, i)	((((const u8 *)a)[(i)/NBBY] & (1<<((i)%NBBY))) == 0)
+#endif				/* setbit */
+
+#define	NBITS(type)	(sizeof(type) * 8)
+#define NBITVAL(nbits)	(1 << (nbits))
+#define MAXBITVAL(nbits)	((1 << (nbits)) - 1)
+#define	NBITMASK(nbits)	MAXBITVAL(nbits)
+#define MAXNBVAL(nbyte)	MAXBITVAL((nbyte) * 8)
+
+/* crc defines */
+#define CRC16_INIT_VALUE 0xffff	/* Initial CRC16 checksum value */
+#define CRC16_GOOD_VALUE 0xf0b8	/* Good final CRC16 checksum value */
+
+/* 18-bytes of Ethernet address buffer length */
+#define ETHER_ADDR_STR_LEN	18
+
 struct pktq_prec {
 	struct sk_buff *head;	/* first packet to dequeue */
 	struct sk_buff *tail;	/* last packet to dequeue */
@@ -70,14 +98,35 @@ struct pktq {
 
 /* operations on a specific precedence in packet queue */
 
-#define pktq_psetmax(pq, prec, _max)    ((pq)->q[prec].max = (_max))
-#define pktq_plen(pq, prec)             ((pq)->q[prec].len)
-#define pktq_pavail(pq, prec)           ((pq)->q[prec].max - (pq)->q[prec].len)
-#define pktq_pfull(pq, prec)            ((pq)->q[prec].len >= (pq)->q[prec].max)
-#define pktq_pempty(pq, prec)           ((pq)->q[prec].len == 0)
+static inline int pktq_plen(struct pktq *pq, int prec)
+{
+	return pq->q[prec].len;
+}
 
-#define pktq_ppeek(pq, prec)            ((pq)->q[prec].head)
-#define pktq_ppeek_tail(pq, prec)       ((pq)->q[prec].tail)
+static inline int pktq_pavail(struct pktq *pq, int prec)
+{
+	return pq->q[prec].max - pq->q[prec].len;
+}
+
+static inline bool pktq_pfull(struct pktq *pq, int prec)
+{
+	return pq->q[prec].len >= pq->q[prec].max;
+}
+
+static inline bool pktq_pempty(struct pktq *pq, int prec)
+{
+	return pq->q[prec].len == 0;
+}
+
+static inline struct sk_buff *pktq_ppeek(struct pktq *pq, int prec)
+{
+	return pq->q[prec].head;
+}
+
+static inline struct sk_buff *pktq_ppeek_tail(struct pktq *pq, int prec)
+{
+	return pq->q[prec].tail;
+}
 
 extern struct sk_buff *brcmu_pktq_penq(struct pktq *pq, int prec,
 				 struct sk_buff *p);
@@ -103,19 +152,30 @@ extern struct sk_buff *brcmu_pktq_mdeq(struct pktq *pq, uint prec_bmp,
 
 /* operations on packet queue as a whole */
 
-#define pktq_len(pq)                    ((int)(pq)->len)
-#define pktq_max(pq)                    ((int)(pq)->max)
-#define pktq_avail(pq)                  ((int)((pq)->max - (pq)->len))
-#define pktq_full(pq)                   ((pq)->len >= (pq)->max)
-#define pktq_empty(pq)                  ((pq)->len == 0)
+static inline int pktq_len(struct pktq *pq)
+{
+	return (int)pq->len;
+}
+
+static inline int pktq_max(struct pktq *pq)
+{
+	return (int)pq->max;
+}
+
+static inline int pktq_avail(struct pktq *pq)
+{
+	return (int)(pq->max - pq->len);
+}
+
+static inline bool pktq_full(struct pktq *pq)
+{
+	return pq->len >= pq->max;
+}
 
-/* operations for single precedence queues */
-#define pktenq(pq, p)		brcmu_pktq_penq(((struct pktq *)pq), 0, (p))
-#define pktenq_head(pq, p)\
-	brcmu_pktq_penq_head(((struct pktq *)pq), 0, (p))
-#define pktdeq(pq)		brcmu_pktq_pdeq(((struct pktq *)pq), 0)
-#define pktdeq_tail(pq)		brcmu_pktq_pdeq_tail(((struct pktq *)pq), 0)
-#define pktqinit(pq, len)	brcmu_pktq_init(((struct pktq *)pq), 1, len)
+static inline bool pktq_empty(struct pktq *pq)
+{
+	return pq->len == 0;
+}
 
 extern void brcmu_pktq_init(struct pktq *pq, int num_prec, int max_len);
 /* prec_out may be NULL if caller is not interested in return value */
@@ -182,66 +242,6 @@ extern int brcmu_iovar_lencheck(const struct brcmu_iovar *table, void *arg,
 #define IOVT_INT32	6	/* int 32 bits */
 #define IOVT_UINT32	7	/* unsigned int 32 bits */
 #define IOVT_BUFFER	8	/* buffer is size-checked as per minlen */
-#define BCM_IOVT_VALID(type) (((unsigned int)(type)) <= IOVT_BUFFER)
-
-/* ** driver/apps-shared section ** */
-
-#define BCME_STRLEN		64	/* Max string length for BCM errors */
-
-#define	ABS(a)			(((a) < 0) ? -(a) : (a))
-
-#define CEIL(x, y)		(((x) + ((y)-1)) / (y))
-#define	ISPOWEROF2(x)		((((x)-1)&(x)) == 0)
-
-/* map physical to virtual I/O */
-#define REG_MAP(pa, size)       ioremap_nocache((unsigned long)(pa), \
-					(unsigned long)(size))
-
-/* the largest reasonable packet buffer driver uses for ethernet MTU in bytes */
-#define	PKTBUFSZ	2048
-
-#define OSL_SYSUPTIME()		((u32)jiffies * (1000 / HZ))
-
-#ifndef setbit
-#ifndef NBBY			/* the BSD family defines NBBY */
-#define	NBBY	8		/* 8 bits per byte */
-#endif				/* #ifndef NBBY */
-#define	setbit(a, i)	(((u8 *)a)[(i)/NBBY] |= 1<<((i)%NBBY))
-#define	clrbit(a, i)	(((u8 *)a)[(i)/NBBY] &= ~(1<<((i)%NBBY)))
-#define	isset(a, i)	(((const u8 *)a)[(i)/NBBY] & (1<<((i)%NBBY)))
-#define	isclr(a, i)	((((const u8 *)a)[(i)/NBBY] & (1<<((i)%NBBY))) == 0)
-#endif				/* setbit */
-
-#define	NBITS(type)	(sizeof(type) * 8)
-#define NBITVAL(nbits)	(1 << (nbits))
-#define MAXBITVAL(nbits)	((1 << (nbits)) - 1)
-#define	NBITMASK(nbits)	MAXBITVAL(nbits)
-#define MAXNBVAL(nbyte)	MAXBITVAL((nbyte) * 8)
-
-/* basic mux operation - can be optimized on several architectures */
-#define MUX(pred, true, false) ((pred) ? (true) : (false))
-
-/* modulo inc/dec - assumes x E [0, bound - 1] */
-#define MODDEC(x, bound) MUX((x) == 0, (bound) - 1, (x) - 1)
-#define MODINC(x, bound) MUX((x) == (bound) - 1, 0, (x) + 1)
-
-/* modulo inc/dec, bound = 2^k */
-#define MODDEC_POW2(x, bound) (((x) - 1) & ((bound) - 1))
-#define MODINC_POW2(x, bound) (((x) + 1) & ((bound) - 1))
-
-/* modulo add/sub - assumes x, y E [0, bound - 1] */
-#define MODADD(x, y, bound) \
-	MUX((x) + (y) >= (bound), (x) + (y) - (bound), (x) + (y))
-#define MODSUB(x, y, bound) \
-	MUX(((int)(x)) - ((int)(y)) < 0, (x) - (y) + (bound), (x) - (y))
-
-/* module add/sub, bound = 2^k */
-#define MODADD_POW2(x, y, bound) (((x) + (y)) & ((bound) - 1))
-#define MODSUB_POW2(x, y, bound) (((x) - (y)) & ((bound) - 1))
-
-/* crc defines */
-#define CRC16_INIT_VALUE 0xffff	/* Initial CRC16 checksum value */
-#define CRC16_GOOD_VALUE 0xf0b8	/* Good final CRC16 checksum value */
 
 /* brcmu_format_flags() bit description structure */
 struct brcmu_bit_desc {
@@ -256,9 +256,6 @@ struct brcmu_tlv {
 	u8 data[1];
 };
 
-/* 18-bytes of Ethernet address buffer length */
-#define ETHER_ADDR_STR_LEN	18
-
 /* externs */
 /* format/print */
 #if defined(BCMDBG)
-- 
1.7.4.1


