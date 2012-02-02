Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41197 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab2BBDtI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 22:49:08 -0500
Date: Thu, 2 Feb 2012 09:19:21 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Paul Stewart <pstew@google.com>
Subject: Re: [PATCH 1/2] ath9k: recover the chip from tx/rx stuck
Message-ID: <20120202034920.GA25988@vmraj-lnx.users.atheros.com> (sfid-20120202_044913_157081_5E4AE464)
References: <1328112335-19265-1-git-send-email-rmanohar@qca.qualcomm.com>
 <4F2993F1.1020203@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4F2993F1.1020203@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 01, 2012 at 11:35:13AM -0800, Ben Greear wrote:
> On 02/01/2012 08:05 AM, Rajkumar Manoharan wrote:
> 
> Some more comments below.....
> 
> 
> >+static bool ath9k_check_dcu_chain_state(u32 dma_dbg, int max_limit,
> >+					int *hang_state, int *hang_pos)
> >+{
> >+	static u32 hang_sign[] = {5, 6, 9};
> >+	u32 chain_state, dcs_pos, i;
> >+
> >+	for (dcs_pos = 0; dcs_pos<  max_limit; dcs_pos++) {
> >+		chain_state = (dma_dbg>>  (5 * dcs_pos))&  0x1f;
> >+		for (i = 0; i<  3; i++) {
> >+			if (chain_state == hang_sign[i]) {
> >+				*hang_state = chain_state;
> >+				*hang_pos = dcs_pos;
> >+				return true;
> >+			}
> >+		}
> >+	}
> >+	return false;
> >+}
> 
> Perhaps you could add some comments to the code above to describe
> what the '5, 6, 9' and other constants mean?
>
sure. these are the dcu_chain_state values. will update the variable name.
> >+#define DCU_COMPLETE_STATE  1
> >+#define NUM_STATUS_READS    50
> >+static bool ath9k_detect_mac_hang(struct ath_hw *ah)
> >+{
> >+	u32 chain_state, comp_state, dcs_reg = AR_DMADBG_4;
> >+	u32 i, hang_pos, hang_state;
> >+
> >+	comp_state = REG_READ(ah, AR_DMADBG_6);
> >+
> >+	if ((comp_state&  0x3) != DCU_COMPLETE_STATE) {
> >+		ath_dbg(ath9k_hw_common(ah), RESET,
> >+			"MAC Hang signature not found at DCU complete\n");
> >+		return false;
> >+	}
> 
> Same with the 0x3 (maybe #define what those bits mean and or them together instead
> of using the 0x3?)
> 
ok.
> >+
> >+	chain_state = REG_READ(ah, dcs_reg);
> >+	if (ath9k_check_dcu_chain_state(chain_state, 6,&hang_state,&hang_pos))
> >+		goto hang_check_iter;
> 
> And why did you choose a '6' here?
> 
number of dcu chain states consisted in that dma_dbg register. I'll update in the
function prototype.
> >+
> >+	dcs_reg = AR_DMADBG_5;
> >+	chain_state = REG_READ(ah, dcs_reg);
> >+	if (ath9k_check_dcu_chain_state(chain_state, 4,&hang_state,&hang_pos))
> >+		goto hang_check_iter;
> 
> And the '4'?
> 
same as above.
> >+void ath_start_rx_poll(struct ath_softc *sc, const u32 msec)
> >+{
> >+	if (!AR_SREV_9300_20_OR_LATER(sc->sc_ah))
> >+		return;
> >+
> >+	if (!(sc->sc_flags&  SC_OP_PRIM_STA_VIF))
> >+		return;
> >+
> >+	mod_timer(&sc->rx_poll_timer, jiffies + msecs_to_jiffies(msec));
> >+}
> 
> Since the rx-poll timer isn't started when SC_OP_PRIM_STA_VIF is
> not set, should you always call the ath_start_rx_poll method
> even if ani is disabled in the ath9k_bss_iter method since
> the PRIM_STA_VIF flag is set earlier in that code)?
> 
Goog catch. it should be out of ani check.
> >  static int ath9k_add_interface(struct ieee80211_hw *hw,
> >  			       struct ieee80211_vif *vif)
> >@@ -1948,6 +2086,8 @@ static void ath9k_bss_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
> >  		if (!common->disable_ani) {
> >  			sc->sc_flags |= SC_OP_ANI_RUN;
> >  			ath_start_ani(common);
> >+			sc->rx.stop_rx_poll = false;
> >+			ath_start_rx_poll(sc, 300);

Thanks for your comments.

--
Rajkumar
