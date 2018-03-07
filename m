Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33738 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751234AbeCGM3i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Mar 2018 07:29:38 -0500
Date: Wed, 7 Mar 2018 13:29:35 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Enrico Mioso <mrkiko.rs@gmail.com>,
        Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>,
        Jamie Stuart <jamie@onebillion.org>,
        Mathias Kresin <dev@kresin.me>
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
Message-ID: <20180307122935.GB10584@redhat.com> (sfid-20180307_132942_315978_FB9D12B9)
References: <alpine.LNX.2.21.99.1712241311370.28605@localhost.localdomain>
 <20180103113540.GA10306@redhat.com>
 <alpine.LNX.2.21.99.1801031503370.8405@localhost.localdomain>
 <CAKR_QVLRwAA0NJSarX46J4A8XSp8h5SuTEtSBQ4ydpEPh_-aUw@mail.gmail.com>
 <alpine.LNX.2.21.99.1801220643400.32225@mStation.localdomain>
 <20180123132234.GC2520@redhat.com>
 <alpine.LNX.2.21.99.1801240917001.13679@mStation.localdomain>
 <20180124100316.GB3101@redhat.com>
 <20180301153006.GJ1233@makrotopia.org>
 <20180307122701.GA10584@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HcAYCG3uE/tztfnV"
In-Reply-To: <20180307122701.GA10584@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I forgot to attach the patches, do it now.

On Wed, Mar 07, 2018 at 01:27:01PM +0100, Stanislaw Gruszka wrote:
> On Thu, Mar 01, 2018 at 04:30:10PM +0100, Daniel Golle wrote:
> > [forwarding to all other involved players]
> > 
> > On Thu, Mar 01, 2018 at 05:50:51PM +0300, Jamie Stuart wrote:
> > > Hi Daniel,
> > > The driver seems much improved after this fix.
> > 
> > it's about those two
> > [PATCH 1/2] rt2x00: pause almost full queue early
> > [PATCH 2/2] rt2x00: do not pause queue unconditionally on error path
> > 
> > > Under very heavy load (30 clients downloading multi-GB files from SD card on the server concurrently), wifi dies with errors:
> 
> This is some testbed? Could you share how did you setup such
> environment and what are client devices ?
> 
> > > [ 7794.230376] ieee80211 phy0: rt2x00lib_rxdone_read_signal: Warning - Frame received with unrecognized signal, mode=0x0001, signal=0x010c, type=4
> 
> This is indicator that HW/FW has a problem. There could be various
> reasons for that. One possible I can also observe in my setup,is strange
> mishmash of seq  on frames which were not acked in BlockACK and
> had to be resent. This can happen when many frames are wrongly decoded
> (i.e. when there is bad radio condition or we have not correct low level
> RF/BBP setup for a Ralink device). To mitigate that problem we can
> limit length of agreggeted AMPDU frame.
> 
> I attached two patches which do that. One for RX side second for TX side.
> Please check if they make a diffrent. You can also hardcode ba_size = 0
> for those 30 clients setup.
> 
> Note the patches can cause (possibly small) perfromance degradation on
> good setups. 
> 
> Mathias, could you check them as well and see if they do not cause
> performance regression on your device ? Lastly when I changed ba_size
> setting, it was a problem on your setup.
> 
> > > Thu Mar  1 16:36:47 2018 kern.err kernel: [ 8702.146403] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2
> > > Thu Mar  1 16:36:47 2018 kern.err kernel: [ 8702.146403] Please file bug report to http://rt2x00.serialmonkey.com
> > > Thu Mar  1 16:36:48 2018 kern.err kernel: [ 8702.288149] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2
> > > Thu Mar  1 16:36:48 2018 kern.err kernel: [ 8702.288149] Please file bug report to http://rt2x00.serialmonkey.com
> > > Thu Mar  1 16:36:48 2018 kern.err kernel: [ 8702.380761] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2
> > > Thu Mar  1 16:36:48 2018 kern.err kernel: [ 8702.380761] Please file bug report to http://rt2x00.serialmonkey.com
> 
> For those errors I recommend to remove 
> 
> 600-23-rt2x00-rt2800mmio-add-a-workaround-for-spurious-TX_F.patch
> 
> patch. Whould be good if OpenWRT developers could apply this patch only
> on target where it is really needed, not for all rt2800 devices.
> 
> Thanks
> Stanislaw

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rt2800_change_rx_ampdu_factor.patch"

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index d2c289446c00..e68f7f9d48f8 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -9285,7 +9285,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 
 	spec->ht.cap |= rx_chains << IEEE80211_HT_CAP_RX_STBC_SHIFT;
 
-	spec->ht.ampdu_factor = (rx_chains > 1) ? 3 : 2;
+	spec->ht.ampdu_factor = 0;
 	spec->ht.ampdu_density = 4;
 	spec->ht.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 	if (tx_chains != rx_chains) {

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rt2800_change_ba_size.patch"

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
index a2c1ca5c76d1..66377f222300 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
@@ -305,12 +305,13 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 	struct ieee80211_tx_rate *txrate = &tx_info->control.rates[0];
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct rt2x00_sta *sta_priv = NULL;
-	u8 density = 0;
+	u8 density = 0, ba_size = 0;
 
 	if (sta) {
 		sta_priv = sta_to_rt2x00_sta(sta);
 		txdesc->u.ht.wcid = sta_priv->wcid;
 		density = sta->ht_cap.ampdu_density;
+		ba_size = (2 << sta->ht_cap.ampdu_factor) - 1;
 	}
 
 	/*
@@ -357,7 +358,7 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 	    !(tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)) {
 		__set_bit(ENTRY_TXD_HT_AMPDU, &txdesc->flags);
 		txdesc->u.ht.mpdu_density = density;
-		txdesc->u.ht.ba_size = 7; /* FIXME: What value is needed? */
+		txdesc->u.ht.ba_size = ba_size;
 	}
 
 	/*

--HcAYCG3uE/tztfnV--
