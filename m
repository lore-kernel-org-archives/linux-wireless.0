Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62049 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759955Ab0I0Rgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 13:36:35 -0400
Received: by fxm3 with SMTP id 3so2037352fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 10:36:34 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ignacy Gawedzki <i@lri.fr>
Subject: Re: A few questions about modifications in carl9170
Date: Mon, 27 Sep 2010 19:36:21 +0200
Cc: linux-wireless@vger.kernel.org
References: <20100927132957.GA2977@qubit.lri.fr> <201009271737.16603.chunkeey@googlemail.com> <20100927160557.GA5121@qubit.lri.fr>
In-Reply-To: <20100927160557.GA5121@qubit.lri.fr>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_WYNoMvM0MjHKU/1"
Message-Id: <201009271936.22261.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_WYNoMvM0MjHKU/1
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit

On Monday 27 September 2010 18:05:57 Ignacy Gawedzki wrote:
> On Mon, Sep 27, 2010 at 05:37:16PM +0200, thus spake Christian Lamparter:
> > [...]
> > without any problems. The device was able to connect and send a few gigs.
> > Maybe you should be a bit more "precise" about your changes ;).
> 
> Sure, see the attached diff.  The idea is to simply use the local TSF counter
> to measure the service time.  I know that the TSF gets updated in IBSS pretty
> regularly, but still, the measurements seem accurate enough.
Sure, but why when you have a monotonic 40 MHz timer?

(It isn't so much what you do in the firmware, as long as you don't put
printk into the drivers hot-paths)

> > (Haven't seen the WARN before, kernel/workqueue.c code has changed a lot
> > and flush_cpu_workqueue is no more...)
> 
> OK, I'll stick with the latest wireless-testing then.  BTW, I noticed that the
> FW API is 1.8.8.2, while driver API in wireless-testing is still 1.8.8.1.
Actually, the firmware is already at 1.8.8.3-pre. But it shouldn't matter if
what API "version" you are using, as long as the firmware descriptors and
command interface structs are the same.

> Having some stability issues with this combination, I reverted the last few
> commits in the FW's git back to API 1.8.8.1.  Are these different numbers
> nevertheless compatible with each other?
"Stability issues"? Again, a "vague" and stretchy term. Do you have "Oops" -
reports or something like that? 

Regards,
	Chr

--Boundary-00=_WYNoMvM0MjHKU/1
Content-Type: text/x-patch;
  charset="UTF-8";
  name="carl9170-tx-measure.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="carl9170-tx-measure.diff"

diff --git a/carlfw/src/wlan.c b/carlfw/src/wlan.c
index b6c0e34..d76d635 100644
--- a/carlfw/src/wlan.c
+++ b/carlfw/src/wlan.c
@@ -156,6 +156,8 @@ static struct carl9170_tx_status *wlan_get_tx_status_buffer(void)
 	return tmp;
 }
 
+static unsigned int comp_tsf;
+
 /* generate _aggregated_ tx_status for the host */
 static void wlan_tx_complete(struct carl9170_tx_superframe *super,
 			     bool txs)
@@ -178,6 +180,9 @@ static void wlan_tx_complete(struct carl9170_tx_superframe *super,
 	status->rix = super->s.rix;
 	status->tries = super->s.cnt;
 	status->success = (txs) ? 1 : 0;
+
+	/* jup, no fancy rollover stuff */
+	status->duration = comp_tsf - super->s.tsfl;
 }
 
 static bool wlan_tx_consume_retry(struct carl9170_tx_superframe *super)
@@ -253,6 +258,8 @@ static void __wlan_tx(struct dma_desc *desc)
 	BUG_ON(fw.phy.psm.state != CARL9170_PSM_WAKE);
 # endif /* CONFIG_CARL9170FW_DEBUG && CONFIG_CARL9170FW_PSM */
 
+	super->s.tsfl = get_clock_counter();
+
 	/* insert desc into the right queue */
 	dma_put(&fw.wlan.tx_queue[queue], desc);
 	wlan_trigger(BIT(queue));
@@ -328,6 +335,8 @@ static bool wlan_tx_status(struct dma_queue *queue,
 				/* demise descriptor ownership back to the hardware */
 				dma_rearm(desc);
 
+				super->s.tsfl = get_clock_counter();
+
 				/*
 				 * And this will get the queue going again.
 				 * To understand why: you have to get the HW
@@ -399,6 +408,8 @@ static void handle_tx_completion(void)
 	struct dma_desc *desc;
 	unsigned int i;
 
+	comp_tsf = get_clock_counter();
+
 	for (i = 0; i < __AR9170_NUM_TX_QUEUES; i++) {
 		__while_desc_bits(desc, &fw.wlan.tx_queue[i], AR9170_OWN_BITS_SW) {
 			if (!wlan_tx_status(&fw.wlan.tx_queue[i], desc)) {
diff --git a/include/shared/fwcmd.h b/include/shared/fwcmd.h
index d4a4e1d..248b34d 100644
--- a/include/shared/fwcmd.h
+++ b/include/shared/fwcmd.h
@@ -215,6 +215,8 @@ struct carl9170_tx_status {
 	u8 rix:2;
 	u8 tries:3;
 	u8 success:1;
+
+	__le32 duration;
 } __packed;
 struct _carl9170_tx_status {
 	/*
@@ -223,8 +225,10 @@ struct _carl9170_tx_status {
 
 	u8 cookie;
 	u8 info;
+
+	__le32 duration;
 } __packed;
-#define CARL9170_TX_STATUS_SIZE		2
+#define CARL9170_TX_STATUS_SIZE		6
 
 #define	CARL9170_RSP_TX_STATUS_NUM	(CARL9170_MAX_CMD_PAYLOAD_LEN /	\
 					 sizeof(struct _carl9170_tx_status))
diff --git a/include/shared/wlan.h b/include/shared/wlan.h
index 48ead22..074c641 100644
--- a/include/shared/wlan.h
+++ b/include/shared/wlan.h
@@ -254,6 +254,7 @@ struct carl9170_tx_superdesc {
 	u8 fill_in_tsf:1;
 	u8 cab:1;
 	u8 padding2;
+	u32 tsfl;
 	struct ar9170_tx_rate_info ri[CARL9170_TX_MAX_RATES];
 	struct ar9170_tx_hw_phy_control rr[CARL9170_TX_MAX_RETRY_RATES];
 } __packed;
@@ -317,6 +318,7 @@ struct _carl9170_tx_superdesc {
 	u8 ampdu_settings;
 	u8 misc;
 	u8 padding;
+	__le32 tsfl;
 	u8 ri[CARL9170_TX_MAX_RATES];
 	__le32 rr[CARL9170_TX_MAX_RETRY_RATES];
 } __packed;
@@ -327,7 +329,7 @@ struct _carl9170_tx_superframe {
 	u8 frame_data[0];
 } __packed;
 
-#define	CARL9170_TX_SUPERDESC_LEN		24
+#define	CARL9170_TX_SUPERDESC_LEN		28
 #define	AR9170_TX_HWDESC_LEN			8
 #define	AR9170_TX_SUPERFRAME_LEN		(CARL9170_TX_HWDESC_LEN + \
 						 AR9170_TX_SUPERDESC_LEN)

--Boundary-00=_WYNoMvM0MjHKU/1--
