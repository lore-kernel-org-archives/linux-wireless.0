Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59336 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1426641AbcFIFHJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 01:07:09 -0400
Date: Thu, 9 Jun 2016 10:36:58 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Sven Eckelmann <sven.eckelmann@open-mesh.com>
Cc: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	marek.lindner@open-mesh.com
Subject: Re: [PATCH 0/2] ath10k: Add support for QCA9887
Message-ID: <20160609050657.GA31330@atheros-ThinkPad-T61> (sfid-20160609_070723_459522_78363082)
References: <1568876.Six5hABE57@bentobox>
 <2262792.6VVL0Htyzj@bentobox>
 <20160607145002.GB11250@atheros-ThinkPad-T61>
 <2104766.hdzL6bzVNd@bentobox>
 <20160607171110.GA13293@atheros-ThinkPad-T61>
 <20160608124308.GB29340@atheros-ThinkPad-T61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160608124308.GB29340@atheros-ThinkPad-T61>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sven,

i have something like this as of now(generically
disabling TX-STBC for streams <= 1 just like ath9k
does

--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4194,6 +4194,9 @@ static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
 			mcs_map |= IEEE80211_VHT_MCS_NOT_SUPPORTED << (i * 2);
 	}
 
+	if (ar->cfg_tx_chainmask <= 1)
+		vht_cap.cap &= ~IEEE80211_VHT_CAP_TXSTBC;
+
 	vht_cap.vht_mcs.rx_mcs_map = cpu_to_le16(mcs_map);
 	vht_cap.vht_mcs.tx_mcs_map = cpu_to_le16(mcs_map);
 
@@ -4231,7 +4234,7 @@ static struct ieee80211_sta_ht_cap ath10k_get_ht_cap(struct ath10k *ar)
 		ht_cap.cap |= smps;
 	}
 
-	if (ar->ht_cap_info & WMI_HT_CAP_TX_STBC)
+	if (ar->ht_cap_info & WMI_HT_CAP_TX_STBC && (ar->cfg_tx_chainmask > 1))
 		ht_cap.cap |= IEEE80211_HT_CAP_TX_STBC;
 
 	if (ar->ht_cap_info & WMI_HT_CAP_RX_STBC) {
-- 

regards,
shafi

On Wed, Jun 08, 2016 at 06:13:08PM +0530, Mohammed Shafi Shajakhan wrote:
> On Tue, Jun 07, 2016 at 10:41:48PM +0530, Mohammed Shafi Shajakhan wrote:
> > Hi Sven,
> > 
> > On Tue, Jun 07, 2016 at 06:54:54PM +0200, Sven Eckelmann wrote:
> > > On Tuesday 07 June 2016 20:20:02 Mohammed Shafi Shajakhan wrote:
> > > [...]
> > > > [shafi] it would be helpful if you can share your basic test results (if its
> > > > possible to share). Have you tried to bring up the card in 5ghz (or) 2ghz.
> > > > Or both of them were tried ?
> > > 
> > > * 5GHz-only (I have no 2.4GHz capable card)
> > > * card is able to scan
> > > * card is able to create an AP
> > > * data can be transferred via AP and client (bidirectional connection)
> > > * performance was more like 15 Mibit/s for 1x1 HT20 11n devices instead of
> > >   something like 35-40 Mibit/s
> > 
> > [shafi] sure thanks a lot, this is a good start, i will keep you posted
> > with my findings and results.
> 
> [shafi] request if you can disable TX-STBC for both HT and VHT, it helped
> me though. Will keep you posted with more updates.
> 
> > 
> > > 
> > > I cannot give you any more detailed, current performance test results because
> > > they were done months ago and are most likely not relevant to describe the
> > > current state. Please ask Kalle if you want to know why the old tests were
> > > done many, many months ago.
> > 
> > [shafi] sure, hopefully we can get this sorted out. Thank you for the patches
> > and support.
> > 
> > > 
> > > Please ask Marek when you want to have tests done with the current
> > > mac8011+ath10k.
> > 
> > [shafi] thanks
> > 
> > > 
> > > Kind regards,
> > > 	Sven
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
