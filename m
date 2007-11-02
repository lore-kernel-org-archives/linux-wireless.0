Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.233]:44503 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbXKBDLk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 23:11:40 -0400
Received: by wx-out-0506.google.com with SMTP id h31so733111wxd
        for <linux-wireless@vger.kernel.org>; Thu, 01 Nov 2007 20:11:39 -0700 (PDT)
Date: Thu, 1 Nov 2007 23:11:31 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH 7/7] ath5k: Add documentation for struct ath5k_rate
Message-ID: <20071102031131.GA4070@pogo> (sfid-20071102_031151_816812_48921F74)
References: <20071101043520.GC21987@pogo> <20071101043718.GD21987@pogo> <20071101043815.GE21987@pogo> <20071101043855.GF21987@pogo> <20071101043933.GG21987@pogo> <20071101044059.GH21987@pogo> <20071101215640.GE4182@pogo> <20071101150651.a61a6f0f.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071101150651.a61a6f0f.rdunlap@xenotime.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 01, 2007 at 03:06:51PM -0700, Randy Dunlap wrote:
> On Thu, 1 Nov 2007 17:56:40 -0400 Luis R. Rodriguez wrote:
> 
> > ** Resending after checkpatch.pl
> > 
> > This adds documentation for struct ath5k_rate. This also removes
> > some unused variables, lp_ack_duration and sp_ack_duration which
> > are simply unnecessary. We obviously have information about the rest
> > of the rate values, we can add more as we go, this just starts this up.
> > I'll next target cleaning up the RATE macros, think that may be there
> > the other G mode issues are in.
> 
> Thanks for doing this... but one more change, please:
> (just move lines around, see below)
> 
> > Changes to ath5k.h
> > Changes-licensed-under: ISC
> > 
> > Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
> > ---
> >  drivers/net/wireless/ath5k/ath5k.h |   58 +++++++++++++++++++++++++++++++----
> >  1 files changed, 51 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
> > index c8ab09a..7147fb4 100644
> > --- a/drivers/net/wireless/ath5k/ath5k.h
> > +++ b/drivers/net/wireless/ath5k/ath5k.h
> > @@ -549,17 +549,61 @@ struct ath5k_athchan_2ghz {
> >   * 	 used by the rate control algorytm on MadWiFi.
> >   */
> >  
> > -#define AR5K_MAX_RATES	32 /*max number of rates on the rate table*/
> > +/* Max number of rates on the rate table and what it seems
> > + * Atheros hardware supports */
> > +#define AR5K_MAX_RATES 32
> 
> As described in Documentation/kernel-doc-nano-HOWTO.txt, the
> structure fields/members should immediately follow the first line.
> After all of the fields/members, you can add general info, like
> the first paragraph that is here.
> 
> Example from that doc file:
> 
> 
> /**
>  * struct my_struct - short description
>  * @a: first member
>  * @b: second member
>  *
>  * Longer description
>  */

New patch, completes the docs and addresses Randy's points.

This adds documentation for struct ath5k_rate. This also removes
some unused variables, lp_ack_duration and sp_ack_duration which
are simply unnecessary.

We're now just missing information about rate hw values:

3-5
16
17-23
28-32

If anyone knows what those are, please let us know.

Changes to ath5k.h
Changes-licensed-under: ISC

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/ath5k.h |   58 +++++++++++++++++++++++++++++++----
 1 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index c8ab09a..72c24bc 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -549,17 +549,60 @@ struct ath5k_athchan_2ghz {
  * 	 used by the rate control algorytm on MadWiFi.
  */
 
-#define AR5K_MAX_RATES	32 /*max number of rates on the rate table*/
+/* Max number of rates on the rate table and what it seems
+ * Atheros hardware supports */
+#define AR5K_MAX_RATES 32
 
+/**
+ * struct ath5k_rate - rate structure
+ * @valid: is this a valid rate for the current mode
+ * @modulation: respective mac80211 modulation
+ * @rate_kbps: rate in kbit/s
+ * @rate_code: hardware rate value, used in &struct ath5k_desc, on RX on
+ *     &struct ath5k_rx_status.rs_rate and on TX on
+ *     &struct ath5k_tx_status.ts_rate. Seems the ar5xxx harware supports
+ *     up to 32 rates, indexed by 1-32. This means we really only need
+ *     6 bits for the rate_code.
+ * @dot11_rate: respective IEEE-802.11 rate value
+ * @control_rate: index of rate assumed to be used to send control frames.
+ *     This can be used to set override the value on the rate duration
+ *     registers. This is only useful if we can override in the harware at
+ *     what rate we want to send control frames at. Note that IEEE-802.11
+ *     Ch. 9.6 (after IEEE 802.11g changes) defines the rate at which we
+ *     should send ACK/CTS, if we change this value we can be breaking
+ *     the spec.
+ *
+ * This structure is used to get the RX rate or set the TX rate on the
+ * hardware descriptors. It is also used for internal modulation control
+ * and settings.
+ *
+ * On RX after the &struct ath5k_desc is parsed by the appropriate
+ * ah_proc_rx_desc() the respective hardware rate value is set in
+ * &struct ath5k_rx_status.rs_rate. On TX the desired rate is set in
+ * &struct ath5k_tx_status.ts_rate which is later used to setup the
+ * &struct ath5k_desc correctly. This is the hardware rate map we are
+ * aware of:
+ *
+ * rate_code   1       2       3       4       5       6       7       8
+ * rate_kbps   3000    1000    ?       ?       ?       2000    500     48000
+ *
+ * rate_code   9       10      11      12      13      14      15      16
+ * rate_kbps   24000   12000   6000    54000   36000   18000   9000    ?
+ *
+ * rate_code   17      18      19      20      21      22      23      24
+ * rate_kbps   ?       ?       ?       ?       ?       ?       ?       11000
+ *
+ * rate_code   25      26      27      28      29      30      31      32
+ * rate_kbps   5500    2000    1000    ?       ?       ?       ?       ?
+ *
+ */
 struct ath5k_rate {
-	u8	valid;		/* Valid for rate control */
+	u8	valid;
 	u32	modulation;
-	u16	rate_kbps;	/* Rate in kbps used in computetxtime */
-	u8	rate_code;	/* Rate mapping for h/w descriptors */
+	u16	rate_kbps;
+	u8	rate_code;
 	u8	dot11_rate;
-	u8	control_rate;	/* Rate for management frames -not used */
-	u16	lp_ack_duration;/* long preamble ACK duration -not used */
-	u16	sp_ack_duration;/* short preamble ACK duration -not used */
+	u8	control_rate;
 };
 
 /* XXX: GRR all this stuff to get leds blinking ??? (check out setcurmode) */
