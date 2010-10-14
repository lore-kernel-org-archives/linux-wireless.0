Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:18852 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab0JNWvw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 18:51:52 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 15:51:42 -0700
Date: Thu, 14 Oct 2010 15:51:50 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
Message-ID: <20101014225150.GB15740@tux>
References: <AANLkTimPEg3ZU8CQUXfdpGdfbmhdE9O=GNY=g9gysTo4@mail.gmail.com>
 <4CB4AA89.1070009@candelatech.com>
 <20101013053141.GA15798@vasanth-laptop>
 <4CB5E0A8.5020502@candelatech.com>
 <AANLkTimp_GSwwX_RnQSyN9QNe55HQ+0HZJ1yd8Xp+dWG@mail.gmail.com>
 <AANLkTinyVqdgPqzpyihuaPtVVqDmzj-ZbXzQ-4qdA2yH@mail.gmail.com>
 <4CB77EA0.1000005@candelatech.com>
 <AANLkTimC0+6PiqWO+LmtBV7uKCVpZueAQs6m_6kAnbq9@mail.gmail.com>
 <AANLkTi=1oOCcdvBHo+8WAVHv-M8tE14ntmK4M_09SWh5@mail.gmail.com>
 <AANLkTi=pp2Ob06YCi6GsR9rtRaDWPP95n2M72qWLdbwM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <AANLkTi=pp2Ob06YCi6GsR9rtRaDWPP95n2M72qWLdbwM@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 14, 2010 at 03:35:34PM -0700, Luis R. Rodriguez wrote:
> On Thu, Oct 14, 2010 at 3:29 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> > Fun enough if I just create one monitor interface and loop quickly
> > over some 2 GHz channels where I know I have traffic nearby I don't
> > see the poison. So channel changes don't seem to do much because this
> > is changing channels as fast as possible from userspace. I also can
> > confirm that I see frames from the different channels as I move along.
> 
> Even forcing a band change doesn't help trigger it with just one mon0
> and one regular device scanning in a loop;
> 
> while true; do for i in 2412 5745 2417 5745 2422 5745 2427 5745 2432
> 5745 2442; do echo $i iw dev mon0 set freq $i; done; done
> while true; do iw dev wlan0 scan; done

OK so just so you know where I'm poking, this is what I have so far. The
ath9k_hw_rxprocdesc() suggestion came from Jouni but it didn't seem to help.
I'm disabling HT as I want to rule out things step by step. I haven't yet
ruled out TX as haven't been able to trigger this poison yet just based
on monitor interfaces and no frame TX's, I needed at probe requests sent
by one STA.

So the script I used was:

#!/usr/bin/perl

use strict;

my $iw = "/usr/sbin/iw";
my $ip = "/sbin/ip";

my $phy = "phy0";
my $max = 300;
my $i;
my $cmd;

# Create stations
for ($i = 0; $i<$max; $i++) {
 runCmd("$iw phy $phy interface add mon$i type monitor");
 runCmd("$ip link set dev mon$i up");
}

sub runCmd {
 my $cmd = shift;
 print "$cmd\n";
 `$cmd`;
}

And what I have on top of my tree right now, after your two new patches:
I should note I never hit the WARN_ON() nor the printks, so that rules
those out.

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index a4c5ed4..cd61727 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -192,6 +192,7 @@ static void setup_ht_cap(struct ath_softc *sc,
 	int i, max_streams;
 
 	ht_info->ht_supported = true;
+	ht_info->ht_supported = false;
 	ht_info->cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
 		       IEEE80211_HT_CAP_SM_PS |
 		       IEEE80211_HT_CAP_SGI_40 |
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 8c13479..a96327e 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -639,6 +639,10 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 	if ((adsp->ds_rxstatus8 & AR_RxDone) == 0)
 		return -EINPROGRESS;
 
+	ds->ds_data = 0;
+	ds->ds_vdata = 0;
+	wmb();
+
 	ads.u.rx = adsp->u.rx;
 
 	rs->rs_status = 0;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index bcd3892..b31b5fe 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1243,6 +1243,10 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 	int padpos, padsize;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	int qnum;
+	struct sk_buff *tmp_skb;
+
+	tmp_skb = skb_copy(skb, GFP_ATOMIC);
+	dev_kfree_skb_any(tmp_skb);
 
 	if (aphy->state != ATH_WIPHY_ACTIVE && aphy->state != ATH_WIPHY_SCAN) {
 		ath_print(common, ATH_DBG_XMIT,
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index fe73fc5..8348199 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -502,6 +502,9 @@ int ath_startrecv(struct ath_softc *sc)
 		goto start_recv;
 
 	bf = list_first_entry(&sc->rx.rxbuf, struct ath_buf, list);
+	/* This is fishy, what if the bf->bf_daddr is not valid ? */
+	if (!bf->bf_daddr)
+		printk("= hah bf->bf_daddr is 0!\n");
 	ath9k_hw_putrxbuf(ah, bf->bf_daddr);
 	ath9k_hw_rxena(ah);
 
@@ -663,6 +666,12 @@ static void ath_rx_send_to_mac80211(struct ieee80211_hw *hw,
 				    struct ieee80211_rx_status *rxs)
 {
 	struct ieee80211_hdr *hdr;
+	struct sk_buff *tmp_skb;
+
+	if (1) {
+		tmp_skb = skb_copy(skb, GFP_ATOMIC);
+		dev_kfree_skb_any(tmp_skb);
+	}
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 
@@ -815,11 +821,17 @@ static struct ath_buf *ath_get_next_rx_buf(struct ath_softc *sc,
 		ret = ath9k_hw_rxprocdesc(ah, tds, &trs, 0);
 		if (ret == -EINPROGRESS)
 			return NULL;
+		WARN_ON(1);
 	}
 
 	if (!bf->bf_mpdu)
 		return bf;
 
+	if (!bf->bf_buf_addr)
+		printk("bf->bf_buf_addr = 0\n");
 	/*
 	 * Synchronize the DMA transfer with CPU before
 	 * 1. accessing the frame
