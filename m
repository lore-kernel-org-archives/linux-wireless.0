Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:56790 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3BMVgg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 16:36:36 -0500
Date: Wed, 13 Feb 2013 15:36:25 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	Luciano Coelho <coelho@ti.com>, ath9k-devel@venema.h4ckr.net,
	brcm80211-dev-list@broadcom.com, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 1/4] mac80211: Convert PS configuration from a binary
 flag to a set of modes
Message-ID: <20130213213625.GF22867@thinkpad-t410> (sfid-20130213_223643_775394_E693CE33)
References: <1360184478-31481-1-git-send-email-seth.forshee@canonical.com>
 <1360184478-31481-2-git-send-email-seth.forshee@canonical.com>
 <1360767970.8868.24.camel@jlt4.sipsolutions.net>
 <20130213170445.GC22867@thinkpad-t410>
 <511BE15B.8090507@broadcom.com>
 <20130213192519.GD22867@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130213192519.GD22867@thinkpad-t410>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 13, 2013 at 01:25:19PM -0600, Seth Forshee wrote:
> On Wed, Feb 13, 2013 at 07:54:19PM +0100, Arend van Spriel wrote:
> > On 02/13/2013 06:04 PM, Seth Forshee wrote:
> > >> Is all this really worth it? It seems a quick fix for brcmsmac might be
> > >> > to always set the powersave bit when IEEE80211_CONF_OFFCHANNEL is
> > >> > enabled in the config, and then go implement a real solution like I
> > >> > described earlier with powersave being separated out of the core
> > >> > mac80211 routines, and actually made possible for multiple interfaces?
> > > Using IEEE80211_CONF_OFFCHANNEL won't work. When the nullfunc to enable
> > > PS is sent the flag won't be set, as we're still on the operating
> > > channel. When we're actually off-channel the value of PM doesn't matter
> > > for the types of frames which are being sent. The only quick fix I've
> > > found is to watch out for frames with PM set and set the powersave bit
> > > while they're being transmitted.
> > 
> > I actually don't see that one fly. The frames are posted on a DMA fifo
> > towards the hardware so in the driver we have no clue when that frame is
> > being processes/transmitted hence no way of knowing when to write the
> > register(s).
> 
> There's a couple of ways of doing it. I had a working patch at one point
> but can't seem to find it now, so I'm not sure which way I used. You're
> right though that we can't tell when the hardware is actually processing
> or transmitting the frame, so in either case MCTL_HPS has to be set
> before you put the frame in the tx fifo.
> 
> The first option is that for any frame with PM set, set MCTL_HPS when
> mac80211 hands off the frame and clear it once it has finished
> transmitting.
> 
> The second option is to look specifically for nullfunc frames and set or
> clear MCTL_HPS based on the value of PM.
> 
> Either of these should work fine with the current mac80211 code, but
> overall the second one is probably a little safer.

Aha, found the patch. It looks like it's the first option. I've pasted
it below. The changes look rather larger than they are in reality due to
shuffling some code around.


diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 8d560b6..d1c6db6 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -825,6 +825,72 @@ static u32 brcms_c_setband_inact(struct brcms_c_info *wlc, uint bandunit)
 	return macintmask;
 }
 
+static void brcms_b_wait_for_wake(struct brcms_hardware *wlc_hw)
+{
+	/* delay before first read of ucode state */
+	udelay(40);
+
+	/* wait until ucode is no longer asleep */
+	SPINWAIT((brcms_b_read_shm(wlc_hw, M_UCODE_DBGST) ==
+		  DBGST_ASLEEP), wlc_hw->wlc->fastpwrup_dly);
+}
+
+/*
+ * conditions under which the PM bit should be set in outgoing frames
+ * and STAY_AWAKE is meaningful
+ */
+static bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
+{
+	struct brcms_bss_cfg *cfg = wlc->bsscfg;
+
+	/* disallow PS when one of the following global conditions meets */
+	if (!wlc->pub->associated)
+		return false;
+
+	/* disallow PS when one of these meets when not scanning */
+	if (wlc->filter_flags & FIF_PROMISC_IN_BSS)
+		return false;
+
+	if (cfg->associated) {
+		/*
+		 * disallow PS when one of the following
+		 * bsscfg specific conditions meets
+		 */
+		if (!cfg->BSS)
+			return false;
+
+		return false;
+	}
+
+	return true;
+}
+
+/* push sw hps and wake state through hardware */
+static void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc, bool force_hps)
+{
+	u32 v1, v2;
+	bool hps = true;
+	bool awake_before;
+
+	if (!force_hps)
+		hps = brcms_c_ps_allowed(wlc);
+
+	brcms_dbg_mac80211(wlc->hw->d11core, "wl%d: hps %d\n", wlc->pub->unit,
+			   hps);
+
+	v1 = bcma_read32(wlc->hw->d11core, D11REGOFFS(maccontrol));
+	v2 = MCTL_WAKE;
+	if (hps)
+		v2 |= MCTL_HPS;
+
+	brcms_b_mctrl(wlc->hw, MCTL_WAKE | MCTL_HPS, v2);
+
+	awake_before = ((v1 & MCTL_WAKE) || ((v1 & MCTL_HPS) == 0));
+
+	if (!awake_before)
+		brcms_b_wait_for_wake(wlc->hw);
+}
+
 /* process an individual struct tx_status */
 static bool
 brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
@@ -983,6 +1049,9 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 
 		if (txs->status & TX_STATUS_ACK_RCV)
 			tx_info->flags |= IEEE80211_TX_STAT_ACK;
+
+		if (h->frame_control & cpu_to_le16(IEEE80211_FCTL_PM))
+			brcms_c_set_ps_ctrl(wlc, false);
 	}
 
 	totlen = p->len;
@@ -1226,16 +1295,6 @@ static void brcms_b_info_init(struct brcms_hardware *wlc_hw)
 	wlc_hw->chanspec = ch20mhz_chspec(1);
 }
 
-static void brcms_b_wait_for_wake(struct brcms_hardware *wlc_hw)
-{
-	/* delay before first read of ucode state */
-	udelay(40);
-
-	/* wait until ucode is no longer asleep */
-	SPINWAIT((brcms_b_read_shm(wlc_hw, M_UCODE_DBGST) ==
-		  DBGST_ASLEEP), wlc_hw->wlc->fastpwrup_dly);
-}
-
 /* control chip clock to save power, enable dynamic clock or force fast clock */
 static void brcms_b_clkctl_clk(struct brcms_hardware *wlc_hw, enum bcma_clkmode mode)
 {
@@ -3039,36 +3098,6 @@ static void brcms_b_antsel_set(struct brcms_hardware *wlc_hw, u32 antsel_avail)
 	wlc_hw->antsel_avail = antsel_avail;
 }
 
-/*
- * conditions under which the PM bit should be set in outgoing frames
- * and STAY_AWAKE is meaningful
- */
-static bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
-{
-	struct brcms_bss_cfg *cfg = wlc->bsscfg;
-
-	/* disallow PS when one of the following global conditions meets */
-	if (!wlc->pub->associated)
-		return false;
-
-	/* disallow PS when one of these meets when not scanning */
-	if (wlc->filter_flags & FIF_PROMISC_IN_BSS)
-		return false;
-
-	if (cfg->associated) {
-		/*
-		 * disallow PS when one of the following
-		 * bsscfg specific conditions meets
-		 */
-		if (!cfg->BSS)
-			return false;
-
-		return false;
-	}
-
-	return true;
-}
-
 static void brcms_c_statsupd(struct brcms_c_info *wlc)
 {
 	int i;
@@ -3739,31 +3768,6 @@ brcms_c_duty_cycle_set(struct brcms_c_info *wlc, int duty_cycle, bool isOFDM,
 	return 0;
 }
 
-/* push sw hps and wake state through hardware */
-static void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc)
-{
-	u32 v1, v2;
-	bool hps;
-	bool awake_before;
-
-	hps = brcms_c_ps_allowed(wlc);
-
-	brcms_dbg_mac80211(wlc->hw->d11core, "wl%d: hps %d\n", wlc->pub->unit,
-			   hps);
-
-	v1 = bcma_read32(wlc->hw->d11core, D11REGOFFS(maccontrol));
-	v2 = MCTL_WAKE;
-	if (hps)
-		v2 |= MCTL_HPS;
-
-	brcms_b_mctrl(wlc->hw, MCTL_WAKE | MCTL_HPS, v2);
-
-	awake_before = ((v1 & MCTL_WAKE) || ((v1 & MCTL_HPS) == 0));
-
-	if (!awake_before)
-		brcms_b_wait_for_wake(wlc->hw);
-}
-
 /*
  * Write this BSS config's MAC address to core.
  * Updates RXE match engine.
@@ -3884,7 +3888,7 @@ static void brcms_c_setband(struct brcms_c_info *wlc,
 		return;
 
 	/* wait for at least one beacon before entering sleeping state */
-	brcms_c_set_ps_ctrl(wlc);
+	brcms_c_set_ps_ctrl(wlc, false);
 
 	/* band-specific initializations */
 	brcms_c_bsinit(wlc);
@@ -6868,6 +6872,7 @@ static int brcms_c_tx(struct brcms_c_info *wlc, struct sk_buff *skb)
 	int fifo, ret = -ENOSPC;
 	struct d11txh *txh;
 	u16 frameid = INVALIDFID;
+	struct ieee80211_hdr *hdr;
 
 	fifo = brcms_ac_to_fifo(skb_get_queue_mapping(skb));
 	dma = wlc->hw->di[fifo];
@@ -6905,6 +6910,14 @@ static int brcms_c_tx(struct brcms_c_info *wlc, struct sk_buff *skb)
 		brcms_b_write_shm(wlc->hw, M_BCMC_FID, frameid);
 	}
 
+	/*
+	 * When PM is set in frame_control, force MCTL_HPS to be set so
+	 * that PM isn't cleared by the hardware.
+	 */
+	hdr = (struct ieee80211_hdr *)skb->data;
+	if (hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_PM))
+		brcms_c_set_ps_ctrl(wlc, true);
+
 	ret = brcms_c_txfifo(wlc, fifo, skb);
 	/*
 	 * The only reason for brcms_c_txfifo to fail is because
@@ -7790,7 +7803,7 @@ void brcms_c_init(struct brcms_c_info *wlc, bool mute_tx)
 			     bi << CFPREP_CBI_SHIFT);
 
 		/* Update maccontrol PM related bits */
-		brcms_c_set_ps_ctrl(wlc);
+		brcms_c_set_ps_ctrl(wlc, false);
 	}
 
 	brcms_c_bandinit_ordered(wlc, chanspec);
-- 
1.7.9.5

