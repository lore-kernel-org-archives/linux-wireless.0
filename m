Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1240 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbZGWLZD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 07:25:03 -0400
Date: Thu, 23 Jul 2009 07:24:28 -0400
From: Bob Copeland <me@bobcopeland.com>
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Using compat-wireless w/ 2.6.27.26
Message-ID: <20090723112428.GC13742@hash.localnet>
References: <4A612514.4050708@redfish-solutions.com> <b6c5339f0907190638jc1bdacbo801adcd39a1cf5@mail.gmail.com> <4A635E04.4050204@redfish-solutions.com> <20090719203150.GA9972@hash.localnet> <4A63DF0B.4010801@redfish-solutions.com> <20090720115244.GC9972@hash.localnet> <4A64C283.6090205@redfish-solutions.com> <43e72e890907201247x7df76b75wf6ba2bc2260dbf7a@mail.gmail.com> <4A650331.9020409@redfish-solutions.com> <4A6620B9.4@redfish-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A6620B9.4@redfish-solutions.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 21, 2009 at 01:10:33PM -0700, Philip A. Prindeville wrote:
> A little progress:  I build 2009-07-10 with 2.6.27.26, and I can get the
> Vista box to associate, but not an iPhone running 3.0...

Here's a start, but I still need to find and fix another issue.

Ath5k seems to have had an implicit assumption that config() would
be called before beacon setup and the opmode would get set in HW then.
Not sure if the order changed when beacon stuff was moved to bss_conf,
but it's fragile anyway so I think we should configure the mode up
front so that the timers actually work.  Also we need to process all
of the TX queue's status descriptors.

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index c00f83f..168649d 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1117,6 +1117,8 @@ ath5k_mode_setup(struct ath5k_softc *sc)
 	struct ath5k_hw *ah = sc->ah;
 	u32 rfilt;
 
+	ah->ah_op_mode = sc->opmode;
+
 	/* configure rx filter */
 	rfilt = sc->filter_flags;
 	ath5k_hw_set_rx_filter(ah, rfilt);
@@ -1999,8 +2001,13 @@ static void
 ath5k_tasklet_tx(unsigned long data)
 {
 	struct ath5k_softc *sc = (void *)data;
+	int i;
 
-	ath5k_tx_processq(sc, sc->txq);
+	for (i=0; i < AR5K_NUM_TX_QUEUES; i++) {
+		if (!sc->txqs[i].setup)
+			continue;
+		ath5k_tx_processq(sc, sc->txq);
+	}
 }
 
 
@@ -2768,6 +2775,7 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
 	}
 
 	ath5k_hw_set_lladdr(sc->ah, conf->mac_addr);
+	ath5k_mode_setup(sc);
 
 	ret = 0;
 end:

-- 
Bob Copeland %% www.bobcopeland.com

