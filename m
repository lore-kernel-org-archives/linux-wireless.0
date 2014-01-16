Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:41645 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaAPLLq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 06:11:46 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	 boundary="n17Fx5K8ID"
Message-ID: <21207.48441.292580.481850@gargle.gargle.HOWL> (sfid-20140116_121150_418356_D92E0589)
Date: Thu, 16 Jan 2014 16:36:33 +0530
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath9k: Fix TX IQ calibration for SoC chips
In-Reply-To: <52D6472B.2060207@neratec.com>
References: <1384665016-12022-1-git-send-email-sujith@msujith.org>
	<1384665016-12022-5-git-send-email-sujith@msujith.org>
	<52CE934D.1020400@neratec.com>
	<21198.40916.260973.48444@gargle.gargle.HOWL>
	<52CEA5A3.2040308@neratec.com>
	<21198.43395.235654.597422@gargle.gargle.HOWL>
	<52CEAB24.5090700@neratec.com>
	<52D3F962.1010302@neratec.com>
	<21204.319.492595.58625@gargle.gargle.HOWL>
	<52D402C3.3070606@neratec.com>
	<21204.1991.201080.986559@gargle.gargle.HOWL>
	<21204.2384.710460.402183@gargle.gargle.HOWL>
	<21204.3832.404821.109119@gargle.gargle.HOWL>
	<52D63EBB.7020607@neratec.com>
	<21206.17284.157496.206327@gargle.gargle.HOWL>
	<52D6472B.2060207@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--n17Fx5K8ID
Content-Type: text/plain; charset=us-ascii
Content-Description: message body text
Content-Transfer-Encoding: 7bit

Wojciech Dubowik wrote:
> I have seen the wrong rssi in scan results but I just don't have yet 
> have a proof on clean
> wireless testing. It seems that when I put a lot of printk I don't see 
> the problem because
> maybe scanning/calibration/etc. is shifted more away. Anyway it's just a 
> guess so I will dig
> further.

I think the initial skew in RSSI right after association happens because
NF calibration hasn't completed yet. After doing the first scan, we reset
to the home/operating channel before initiating the association procedure.

When we do this, the history is reset for the operating channel using
ath9k_init_nfcal_hist_buffer() and then after the chip/phy is reset, NF cal
is started - at the end of ath9k_hw_reset() using ath9k_hw_start_nfcal().

But, we don't wait for the NF-cal to complete and neither do we poll for
the calibration status. In this small window, any beacons that are received show
a skewed RSSI. We receive about two beacons in this period, after
which the RSSI becomes normal.

If we wait explicitly for NF-cal to complete, the issue is fixed and the
reported RSSI is normal. (See the attached hacky patch).

For example, the current behavior is:


[ 9071.755238] wlan0: Inserted STA 00:03:7f:42:08:56
[ 9071.755242] wlan0: send auth to 00:03:7f:42:08:56 (try 1/3)
[ 9071.756735] NF cal not completed
[ 9071.756743] NOISE/RSSI/SIGNAL for 00:03:7f:42:08:56: -92/68/-24
[ 9071.756829] wlan0: authenticated
[ 9071.756836] wlan0: moving STA 00:03:7f:42:08:56 to state 2
[ 9071.766123] wlan0: associate with 00:03:7f:42:08:56 (try 1/3)
[ 9071.767920] NF cal not completed
[ 9071.767925] NOISE/RSSI/SIGNAL for 00:03:7f:42:08:56: -92/68/-24
[ 9071.767960] wlan0: RX AssocResp from 00:03:7f:42:08:56 (capab=0x401 status=0 aid=1)
[ 9071.768399] wlan0: associated

...

[ 9071.777816] cfg80211: Regulatory domain changed to country: US
[ 9071.777819] cfg80211:  DFS Master region: unset
[ 9071.777821] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 9071.777825] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 3000 mBm)
[ 9071.777828] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 1700 mBm)
[ 9071.777830] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz), (N/A, 2300 mBm)
[ 9071.777833] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 3000 mBm)
[ 9071.777836] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
[ 9071.787601] NF cal completed
[ 9071.787608] NOISE/RSSI/SIGNAL for 00:03:7f:46:06:49: -92/60/-32
[ 9071.823292] NF cal completed
[ 9071.823330] NOISE/RSSI/SIGNAL for 00:03:7f:42:08:56: -92/59/-33


But, when we wait for NF-cal to complete after initiating it:


[ 9140.932811] wlan0: Inserted STA 00:03:7f:42:08:56
[ 9140.932814] wlan0: send auth to 00:03:7f:42:08:56 (try 1/3)
[ 9140.934368] NF cal completed
[ 9140.934403] NOISE/RSSI/SIGNAL for 00:03:7f:42:08:56: -94/60/-34
[ 9140.934453] wlan0: authenticated
[ 9140.934457] wlan0: moving STA 00:03:7f:42:08:56 to state 2
[ 9140.940706] wlan0: associate with 00:03:7f:42:08:56 (try 1/3)
[ 9140.942575] NF cal completed
[ 9140.942588] NOISE/RSSI/SIGNAL for 00:03:7f:42:08:56: -94/61/-33
[ 9140.942643] wlan0: RX AssocResp from 00:03:7f:42:08:56 (capab=0x401 status=0 aid=1)
[ 9140.942728] wlan0: associated

...

[ 9140.948155] cfg80211: Regulatory domain changed to country: US
[ 9140.948156] cfg80211:  DFS Master region: unset
[ 9140.948158] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 9140.948160] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 3000 mBm)
[ 9140.948161] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 1700 mBm)
[ 9140.948162] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz), (N/A, 2300 mBm)
[ 9140.948164] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 3000 mBm)
[ 9140.948165] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
[ 9140.962224] NF cal completed
[ 9140.962258] NOISE/RSSI/SIGNAL for 00:03:7f:46:06:49: -94/59/-35
[ 9141.010795] NF cal completed
[ 9141.010822] NOISE/RSSI/SIGNAL for 00:03:7f:42:08:56: -94/61/-33


We could fix this by checking if we are initializing the history for the operating
channel and waiting for NF-cal completion, but I am not sure if this needs
to be done. The window is really small and subsequent NF calibrations using
the ANI routine work properly.

The only problem that I can see if running a scan when associated distorts the
reported RSSI, but I can't see such an issue. If you can provide logs for this
case, it would be helpful.

Sujith


--n17Fx5K8ID
Content-Type: text/plain;
	 name="rssi.patch"
Content-Description: patch
Content-Disposition: inline;
	 filename="rssi.patch"
Content-Transfer-Encoding: 7bit

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 278365b..84e93d5 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -218,6 +218,8 @@ EXPORT_SYMBOL(ath9k_hw_reset_calvalid);
 
 void ath9k_hw_start_nfcal(struct ath_hw *ah, bool update)
 {
+	int j;
+
 	if (ah->caldata)
 		set_bit(NFCAL_PENDING, &ah->caldata->cal_flags);
 
@@ -232,6 +234,13 @@ void ath9k_hw_start_nfcal(struct ath_hw *ah, bool update)
 		    AR_PHY_AGC_CONTROL_NO_UPDATE_NF);
 
 	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_NF);
+
+	for (j = 0; j < 10000; j++) {
+		if ((REG_READ(ah, AR_PHY_AGC_CONTROL) &
+		     AR_PHY_AGC_CONTROL_NF) == 0)
+			break;
+		udelay(10);
+	}
 }
 
 void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 5bf3243..e017b01 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1088,6 +1088,14 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 
 	ath9k_process_rssi(common, hw, rx_stats, rx_status);
 
+	if ((REG_READ(ah, AR_PHY_AGC_CONTROL) & AR_PHY_AGC_CONTROL_NF) != 0)
+		printk("NF cal not completed\n");
+	else
+		printk("NF cal completed\n");
+
+	printk("NOISE/RSSI/SIGNAL for %pM: %d/%d/%d\n",
+	       hdr->addr3, ah->noise, rx_stats->rs_rssi, rx_status->signal);
+
 	rx_status->band = ah->curchan->chan->band;
 	rx_status->freq = ah->curchan->chan->center_freq;
 	rx_status->antenna = rx_stats->rs_antenna;

--n17Fx5K8ID--
