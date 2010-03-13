Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40636 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab0CMFq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Mar 2010 00:46:58 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 00/12] ath9k_hw: complete support for AR9271
Date: Sat, 13 Mar 2010 00:46:44 -0500
Message-Id: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series completes support for AR9271 on the ath9k_hw
module. We had existing code on ath9k_hw for AR9271 but
it requires a little spit shine to get it completely functional.
This patch series just addresses support in the hardware code,
a new separate core driver is still required, which will be
submitted separately. The new patch for ath9k_htc is still
being baked based on feedback, on the next iteration we'll
also throwing in power save support and suspend/resumes support
so that we can support that properly through the stable series,
if merged on to 2.6.34.

I've split out the all-in-one hardware code patch into individual
patches for easier review. I am in hopes this clarifies this should
not introduce regressions on the existing ath9k or ath9k_hw modules
for the already supported chipsets. Hope this helps to identify
whether or not ath9k_htc qualifies for addition into 2.6.34.

Senthil, I've addressed these changes myself because I cannot
move ahead with ar93xx changes without this being in place. Otherwise
I have to rebase and I've done that 3 times now (with this patch).
With this in place I can move ahead on top of of wireless-testing
and hopefully we can all by in synch by the end of next week.

While working on splitting the large patch I actually spotted one
bug in the code submitted and also took the time to remove all
uncessary code. The details of my changes in this v3 are detailed
below. Please review and let me know if you agree with them.
I've tested this with AR9280 and AR9271.

John please merge if you get an ACK from Senthil, Vasanth, or Sujith.

  * Split the entire hardware code changes and provide better
    commit log entries

  * Fix a bug in the noisefloor calibration code for AR9271,
    in the previous patch series for hardware changes noisefloor
    information for some other chains were still being poked at for
    AR9271. We should only get noisefloor information for the
    first chain on both the control and extension channel, nothing
    more. The hardware patch on v2 did some of this but didn't do the
    full job.

  * removed pointless code revision checks where AR_SREV_9280_10_OR_LATER(ah)
    already includes AR9271 support. To be clear, for example,
    this hunk would be pointless:

@@ -1 +1 @@
-if (AR_SREV_9280_10_OR_LATER(ah)
+if (AR_SREV_9280_10_OR_LATER(ah) || AR_SREV_9271(ah))

  * Skip the byte swap hunk, I don't see what this fixes, if
    its a style fix we can submit it later, please review,
    I can't see what this fixes:

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 20392cf..9ca9c5a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2147,12 +2147,13 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		}
 	} else {
 		/* Configure AR9271 target WLAN */
-                if (AR_SREV_9271(ah))
+		if (AR_SREV_9271(ah)) {
 			REG_WRITE(ah, AR_CFG, AR_CFG_SWRB | AR_CFG_SWTB);
+		} else {
 #ifdef __BIG_ENDIAN
-                else
 			REG_WRITE(ah, AR_CFG, AR_CFG_SWTD | AR_CFG_SWRD);
 #endif
+		}
 	}
 
 	if (ah->btcoex_hw.enabled)
--

  * I spotted a check added to bail out for tweaking the ACK/CTS
    time out values -- this check should no longer be required
    since Felix sent a proper fix for this recenlty. I removed that
    hunk:

@@ -1210,6 +1195,9 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		REG_WRITE(ah, AR_PCU_MISC,
 			  REG_READ(ah, AR_PCU_MISC) | ah->misc_mode);
 
+	if (AR_SREV_9271(ah))
+		return;
+
 	if (conf->channel && conf->channel->band == IEEE80211_BAND_5GHZ)
 		sifstime = 16;
 	else
--

  * I removed this print hunk, if we really want it we can add it later:

@@ -815,6 +824,7 @@ static void ath9k_olc_temp_compensation(struct ath_hw *ah)
 
 static void ath9k_hw_9271_pa_cal(struct ath_hw *ah, bool is_reset)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	u32 regVal;
 	unsigned int i;
 	u32 regList [][2] = {
@@ -828,6 +838,8 @@ static void ath9k_hw_9271_pa_cal(struct ath_hw *ah, bool is_reset)
 		{ 0x7828, 0 } ,
 	};
 
+	ath_print(common, ATH_DBG_CALIBRATE, "Running PA Calibration\n");
+
 	for (i = 0; i < ARRAY_SIZE(regList); i++)
 		regList[i][1] = REG_READ(ah, regList[i][0]);
 
--

  * Lastly, I also removed the changes to files which only new lines or
    line removals. I'll skip elaborating on those.

Sujith (12):
  ath9k_hw: update initialization values for AR9271
  ath9k_hw: add GPIO setup code for AR9271
  ath9k_hw: skip chip tests for AR9271
  ath9k_hw: fix RF analog setup for AR9271
  ath9k_hw: fix TX descriptor setup for AR9271
  ath9k_hw: Fix full sleep setup for AR9271
  ath9k_hw: fix noisefloor history buffer usage on AR9271
  ath9k_hw: restrict valid nf readings for AR9271 to -114
  ath9k_hw: use the skip count for PA calibration on AR9271
  ath9k_hw: always set the core clock for AR9271
  ath9k_hw: add HTC init hardware call for special resets for AR9271
  ath9k_hw: fix hardware deinit

 drivers/net/wireless/ath/ath9k/calib.c    |   25 ++++--
 drivers/net/wireless/ath/ath9k/hw.c       |  140 +++++++++++++++--------------
 drivers/net/wireless/ath/ath9k/hw.h       |    8 ++
 drivers/net/wireless/ath/ath9k/init.c     |    3 +
 drivers/net/wireless/ath/ath9k/initvals.h |  141 +++++++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/mac.c      |    2 +-
 drivers/net/wireless/ath/ath9k/phy.c      |    6 +-
 drivers/net/wireless/ath/ath9k/reg.h      |    3 +
 8 files changed, 209 insertions(+), 119 deletions(-)

