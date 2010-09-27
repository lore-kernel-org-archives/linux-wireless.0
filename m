Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ext.lri.fr ([129.175.15.4]:60385 "EHLO ext.lri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420Ab0I0QGB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 12:06:01 -0400
Date: Mon, 27 Sep 2010 18:05:57 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: A few questions about modifications in carl9170
Message-ID: <20100927160557.GA5121@qubit.lri.fr>
References: <20100927132957.GA2977@qubit.lri.fr>
 <201009271737.16603.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XsQoSWH+UP9D9v3l"
In-Reply-To: <201009271737.16603.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 27, 2010 at 05:37:16PM +0200, thus spake Christian Lamparter:
> Sounds familiar, David H. Lynch Jr. <dhlii@dlasys.net> wanted to do the same,
> on the same hardware with same software kit. But as far as I know he abandoned
> the project because the hardware does support the RT interrupts he was
> hoping for. 

Yes, i read the whole thread at the time with some interest, as I then noticed
the existence of carl9170. =)

> [...]
> without any problems. The device was able to connect and send a few gigs.
> Maybe you should be a bit more "precise" about your changes ;).

Sure, see the attached diff.  The idea is to simply use the local TSF counter
to measure the service time.  I know that the TSF gets updated in IBSS pretty
regularly, but still, the measurements seem accurate enough.

> Wait, wait wait 2.6.35? Every kernel before 2.6.35.2 (and a few other
> -stable release) have a serious threading-bug in the usb subsystem.
> I strongly recommend that you update your code-base to the
> latest wireless-testing.

I tried many different versions.  Until recently, I was used to getting the
latest wireless-testing revision, apply the patches and compile a fresh
kernel.  Now I simply get the latest wireless-testing since carl9170 is now
included in there.  The exerpt is from a test in which I took the Ubuntu
Maverick kernel and compiled the latest compat-wireless package after applying
my own modifications.

> (Haven't seen the WARN before, kernel/workqueue.c code has changed a lot
> and flush_cpu_workqueue is no more...)

OK, I'll stick with the latest wireless-testing then.  BTW, I noticed that the
FW API is 1.8.8.2, while driver API in wireless-testing is still 1.8.8.1.
Having some stability issues with this combination, I reverted the last few
commits in the FW's git back to API 1.8.8.1.  Are these different numbers
nevertheless compatible with each other?

Thanks so much for your help.

Best regards,

Ignacy

-- 
I used to have a sig, but I've stopped smoking now.

--XsQoSWH+UP9D9v3l
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="carl9170-athstats.diff"

--- a/carlfw/src/wlan.c
+++ b/carlfw/src/wlan.c
@@ -161,6 +161,12 @@ static void wlan_tx_complete(struct carl9170_tx_superframe *super,
 			     bool txs)
 {
 	struct carl9170_tx_status *status;
+	union {
+	  uint64_t	tsf;
+	  uint32_t	tsfa[2];
+	} tsf;
+	static uint64_t	old_tsf = 0;
+	uint64_t	new_tsf;
 
 	status = wlan_get_tx_status_buffer();
 
@@ -178,6 +184,15 @@ static void wlan_tx_complete(struct carl9170_tx_superframe *super,
 	status->rix = super->s.rix;
 	status->tries = super->s.cnt;
 	status->success = (txs) ? 1 : 0;
+	read_tsf(tsf.tsfa);
+	new_tsf = (tsf.tsf & 0xffffffff00000000) | super->s.timestamp;
+	if (new_tsf > tsf.tsf)
+	  new_tsf -= 0x100000000;
+	if (new_tsf < old_tsf)
+	  status->duration = (uint32_t)(tsf.tsf - old_tsf);
+	else
+	  status->duration = (uint32_t)(tsf.tsf - new_tsf);
+	old_tsf = tsf.tsf;
 }
 
 static bool wlan_tx_consume_retry(struct carl9170_tx_superframe *super)
@@ -219,6 +234,13 @@ static void __wlan_tx(struct dma_desc *desc)
 #ifdef CONFIG_CARL9170FW_NORMAL_TX_RX
 	unsigned int queue = super->s.queue;
 #endif /* CONFIG_CARL9170FW_LOOPBACK */
+	union {
+	  uint64_t now;
+	  uint32_t nowa[2];
+	} now;
+
+	read_tsf(now.nowa);
+	super->s.timestamp = now.now & 0xffffffff;
 
 	if (unlikely(super->s.fill_in_tsf)) {
 		struct ieee80211_mgmt *mgmt = (void *) &super->f.data.i3e;
--- a/include/shared/fwcmd.h
+++ b/include/shared/fwcmd.h
@@ -215,6 +215,7 @@ struct carl9170_tx_status {
 	u8 rix:2;
 	u8 tries:3;
 	u8 success:1;
+        u32 duration;
 } __packed;
 struct _carl9170_tx_status {
 	/*
@@ -223,8 +224,9 @@ struct _carl9170_tx_status {
 
 	u8 cookie;
 	u8 info;
+        u32 duration;
 } __packed;
-#define CARL9170_TX_STATUS_SIZE		2
+#define CARL9170_TX_STATUS_SIZE		6
 
 #define	CARL9170_RSP_TX_STATUS_NUM	(CARL9170_MAX_CMD_PAYLOAD_LEN /	\
 					 sizeof(struct _carl9170_tx_status))
--- a/include/shared/wlan.h
+++ b/include/shared/wlan.h
@@ -254,6 +254,7 @@ struct carl9170_tx_superdesc {
 	u8 fill_in_tsf:1;
 	u8 cab:1;
 	u8 padding2;
+        u32 timestamp;
 	struct ar9170_tx_rate_info ri[CARL9170_TX_MAX_RATES];
 	struct ar9170_tx_hw_phy_control rr[CARL9170_TX_MAX_RETRY_RATES];
 } __packed;
@@ -317,6 +318,7 @@ struct _carl9170_tx_superdesc {
 	u8 ampdu_settings;
 	u8 misc;
 	u8 padding;
+        u32 timestamp;
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

--XsQoSWH+UP9D9v3l--
