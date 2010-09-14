Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:16273 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776Ab0INUGM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 16:06:12 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 13:06:06 -0700
Date: Tue, 14 Sep 2010 13:06:10 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"stable@kernel.org" <stable@kernel.org>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <Amod.Bodas@Atheros.com>
Subject: Re: [PATCH v2 02/10] ath9k: fix regression on beacon loss after
 bgscan
Message-ID: <20100914200610.GA2585@tux>
References: <1284476419-13687-1-git-send-email-lrodriguez@atheros.com>
 <AANLkTimGkhOpkBU2mNxa7i7uCc_jNGjGMoeqckna0fbr@mail.gmail.com>
 <AANLkTinh-USTF3pYxa2tOxRZdU44sJXV=v-HQgJ_77HF@mail.gmail.com>
 <AANLkTimPa8dR8wNx6a-FtUiYr34wsyPgpA7jnpnXcPas@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <AANLkTimPa8dR8wNx6a-FtUiYr34wsyPgpA7jnpnXcPas@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 14, 2010 at 10:56:14AM -0700, Luis R. Rodriguez wrote:
> On Tue, Sep 14, 2010 at 9:42 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Tue, Sep 14, 2010 at 9:39 AM, Luis R. Rodriguez
> > <lrodriguez@atheros.com> wrote:
> >> On Tue, Sep 14, 2010 at 8:00 AM, Luis R. Rodriguez
> >> <lrodriguez@atheros.com> wrote:
> >>> When we return to the home channel we were never reseting our beacon
> >>> timers, this was casued by the fact that the scanning flag was still
> >>> on even after we returned to our home channel. There are also other
> >>> reasons why we would get a reset and if we are not off channel
> >>> we always need to resynch our beacon timers, because a reset will
> >>> clear them.
> >>>
> >>> For more details refer to:
> >>>
> >>> http://code.google.com/p/chromium-os/issues/detail?id=5715
> >>>
> >>> This bug is a regression introduced on 2.6.36. The order of the
> >>> changes are as follows:
> >>>
> >>> 5ee08656 - Sat Jul 31 - ath9k: prevent calibration during off-channel activity
> >>> a0daa0e7 - Tue Jul 27 - Revert "mac80211: fix sw scan bracketing"
> >>> 543708be - Fri Jun 18 - mac80211: fix sw scan bracketing
> >>>
> >>> mcgrof@tux ~/linux-2.6-allstable (git::master)$ git describe \
> >>>        --contains 5ee0865615f65f84e6ee9174771a6716c29e08e1
> >>> v2.6.36-rc1~43^2~34^2~22
> >>>
> >>> mcgrof@tux ~/linux-2.6-allstable (git::master)$ git describe \
> >>>        --contains a0daa0e7592ada797d6835f11529097aabc27ad2
> >>> v2.6.36-rc1~571^2~64^2~13
> >>>
> >>> mcgrof@tux ~/linux-2.6-allstable (git::master)$ git describe \
> >>>        --contains 543708be320d7df692d24b349ca01a947b340764
> >>> v2.6.36-rc1~571^2~107^2~187
> >>>
> >>> So 5ee08656 would have worked if a0daa0e7 was not committed but
> >>> it was so this means 5ee08656 was broken since it assumed that
> >>> when we were in the channel change routine the scan flag would
> >>> be lifted. As it turns out the scan flag will be set when we
> >>> are already on the home channel.
> >>>
> >>> These issues will need to be considered for our solution on
> >>> reshifting the scan complete callback location on mac80211 on
> >>> current development kernel work.
> >>>
> >>> This patch has stable fixes which apply down to [2.6.36+]
> >>>
> >>> Cc: stable@kernel.org
> >>> Cc: Paul Stewart <pstew@google.com>
> >>> Cc: Amod Bodas <amod.bodas@atheros.com>
> >>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> >>> ---
> >>>
> >>> This v2 clarifies the second to last sentence, on the v1 this
> >>> was just jiberish on my first read.. this should clarify what
> >>> I meant.
> >>>
> >>>  drivers/net/wireless/ath/ath9k/main.c |    6 ++++--
> >>>  1 files changed, 4 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> >>> index ba029b2..e349619 100644
> >>> --- a/drivers/net/wireless/ath/ath9k/main.c
> >>> +++ b/drivers/net/wireless/ath/ath9k/main.c
> >>> @@ -258,9 +258,11 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
> >>>        if (!(sc->sc_flags & (SC_OP_OFFCHANNEL | SC_OP_SCANNING))) {
> >>>                ath_start_ani(common);
> >>>                ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
> >>> -               ath_beacon_config(sc, NULL);
> >>>        }
> >>>
> >>> +       if (!(sc->sc_flags & (SC_OP_OFFCHANNEL)))
> >>> +               ath_beacon_config(sc, NULL);
> >>> +
> >>
> >> Upon further thought this change should just remove the SC_OP_SCANNING
> >> flag from above and let the code there run when we are not off
> >> channel. Reason is that as I noted above on the commit log entry the
> >> scan flag will be set even when we return to the home channel due to
> >> the races in mac80211 that were actually fixed by Johannes but later
> >> reverted due to issues. Doing the fix this way would also let us
> >> re-arm ANI and the tx completion monitor, this was also broken! I'll
> >> respin this patch shortly after some basic testing.
> >
> > I should also note that this patch fixes the issue of reseting the
> > beacon timers upon a reset, likely when the tx monitor hits -- I
> > suspect that when that currently would hit we'd actually be out of
> > synch with the AP and disconnect. This patch fixes that, but I just
> > reviewed older kernels and the offchannel flag was not available prior
> > to 2.6.36 so we can only fix this properly on >= 2.6.36 unless we
> > figure out a way to annotate we're on the home channel. If we do we
> > can potentially propagate a fix down to older kernels than 2.6.36
> > eventually.
> 
> Fun, just noticed these would be busted too :)
> 
>         ath9k_hw_startpcureceive(ah, (sc->sc_flags & SC_OP_SCANNING));
> 
> Ah, joy.

More joy, so I tried this as an alternative:

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 5fe570b..ecd6724 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -563,7 +563,6 @@ struct ath_ant_comb {
 #define SC_OP_RXFLUSH                BIT(7)
 #define SC_OP_LED_ASSOCIATED         BIT(8)
 #define SC_OP_LED_ON                 BIT(9)
-#define SC_OP_SCANNING               BIT(10)
 #define SC_OP_TSF_RESET              BIT(11)
 #define SC_OP_BT_PRIORITY_DETECTED   BIT(12)
 #define SC_OP_BT_SCAN		     BIT(13)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index ba029b2..2207cf2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -255,7 +255,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	ath_update_txpow(sc);
 	ath9k_hw_set_interrupts(ah, ah->imask);
 
-	if (!(sc->sc_flags & (SC_OP_OFFCHANNEL | SC_OP_SCANNING))) {
+	if (!(sc->sc_flags & SC_OP_OFFCHANNEL)) {
 		ath_start_ani(common);
 		ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 		ath_beacon_config(sc, NULL);
@@ -957,7 +957,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 
 	ath_update_txpow(sc);
 
-	if (sc->sc_flags & SC_OP_BEACONS)
+	if ((sc->sc_flags & SC_OP_BEACONS) || !(sc->sc_flags & (SC_OP_OFFCHANNEL)))
 		ath_beacon_config(sc, NULL);	/* restart beacons */
 
 	ath9k_hw_set_interrupts(ah, ah->imask);
@@ -2042,7 +2042,6 @@ static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 
 	aphy->state = ATH_WIPHY_SCAN;
 	ath9k_wiphy_pause_all_forced(sc, aphy);
-	sc->sc_flags |= SC_OP_SCANNING;
 	mutex_unlock(&sc->mutex);
 }
 
@@ -2057,7 +2056,6 @@ static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
 
 	mutex_lock(&sc->mutex);
 	aphy->state = ATH_WIPHY_ACTIVE;
-	sc->sc_flags &= ~SC_OP_SCANNING;
 	mutex_unlock(&sc->mutex);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 87e02f5..6f7d4d1 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -301,7 +301,7 @@ static void ath_edma_start_recv(struct ath_softc *sc)
 
 	ath_opmode_init(sc);
 
-	ath9k_hw_startpcureceive(sc->sc_ah, (sc->sc_flags & SC_OP_SCANNING));
+	ath9k_hw_startpcureceive(sc->sc_ah, !!(sc->sc_flags & SC_OP_OFFCHANNEL));
 }
 
 static void ath_edma_stop_recv(struct ath_softc *sc)
@@ -507,7 +507,7 @@ int ath_startrecv(struct ath_softc *sc)
 start_recv:
 	spin_unlock_bh(&sc->rx.rxbuflock);
 	ath_opmode_init(sc);
-	ath9k_hw_startpcureceive(ah, (sc->sc_flags & SC_OP_SCANNING));
+	ath9k_hw_startpcureceive(ah, !!(sc->sc_flags & SC_OP_OFFCHANNEL));
 
 	return 0;
 }


But the harware goes nutty. Although technically it seems correct I believe the
issue is upon returning to the home channel we actually end up setting the
home channel twice!

Sep 14 13:00:03 tux kernel: [  309.560059] ath: Set channel: 5785 MHz
Sep 14 13:00:03 tux kernel: [  309.560067] ath: tx chmask: 3, rx chmask: 3
Sep 14 13:00:03 tux kernel: [  309.560191] ath: (5765 MHz) -> (5785 MHz), conf_is_ht40: 0 fastcc: 1
Sep 14 13:00:03 tux kernel: [  309.620100] ath: Set channel: 5785 MHz
Sep 14 13:00:03 tux kernel: [  309.620110] ath: tx chmask: 3, rx chmask: 3
Sep 14 13:00:03 tux kernel: [  309.620235] ath: (5785 MHz) -> (5785 MHz), conf_is_ht40: 1 fastcc: 0

Wow, double rainbow all the way [1]! I'll try to see if we can fix this
through a stable kernel, if not the patch I posted earlier is correct and
we'll need more work on this for >= 2.6.37.

[1] http://www.youtube.com/watch?v=OQSNhk5ICTI

  Luis
