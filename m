Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:18363 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbYIWVYR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2008 17:24:17 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 23 Sep 2008 14:24:17 -0700
Date: Tue, 23 Sep 2008 13:40:38 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org, Steven Noonan"
	<steven@uplinklabs.net>
Subject: Re: [PATCH v2] ath9k: disable MIB interrupts to fix interrupt storm
Message-ID: <20080923204038.GJ6311@tesla> (sfid-20080923_232422_615906_62C520C7)
References: <1222200114-8690-1-git-send-email-lrodriguez@atheros.com> <20080923201631.GE26219@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20080923201631.GE26219@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 23, 2008 at 01:16:31PM -0700, John W. Linville wrote:
> On Tue, Sep 23, 2008 at 01:01:54PM -0700, Luis R. Rodriguez wrote:
> > For AR5416 enabling the MIB interrupts has proven to cause an
> > interrupt storm after 7 hours of run. We will make use of the
> > MIB interrupt once we have ANI supported added so for now
> > to cure this we disable the interrupt.
> 
> Could we have a comment in the code at the point of the "#if 0"
> to explain there why it is being commented out?

Absolutely, I didn't include the statistics in the comments,
how's this?

[PATCH] ath9k: disable MIB interrupts to fix interrupt storm

Enabling the MIB interrupts has proven to cause an
interrupt storm after 7 hours of run. We will make use of the
MIB interrupt once we have ANI supported added so for now
to cure this we disable the interrupt.

The interrupt storm can be seen as follows after 7 hours of run
as reported by  Steven Noonan <steven@uplinklabs.net>:

18:28:38          sum   1106.00
18:28:39          sum   1037.62
18:28:40          sum   1069.00
18:28:41          sum   1167.00
18:28:42          sum   1155.00
18:28:43          sum   1339.00
18:28:44          sum  18355.00
18:28:45          sum  17845.45
18:28:46          sum  15285.00
18:28:47          sum  17511.00
18:28:48          sum  17568.69
18:28:49          sum  17704.04
18:28:50          sum  18566.67
18:28:51          sum  18913.13

at 18:28:44 the MIB interrupt kicked off and caused huge
latency which can be seen even on a video he submitted:

http://www.youtube.com/watch?v=4GeCx1gZMpA

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/core.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index f6c4528..d26d888 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -797,6 +797,14 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)
 		sc->sc_imask |= ATH9K_INT_CST;
 
+	
+	/* Note: We disable MIB interrupts for now as we don't yet
+	 * handle processing ANI, otherwise you will get an interrupt
+	 * storm after about 7 hours of usage making the system unusable
+	 * with huge latency. Once we do have ANI processing included
+	 * we can re-enable this interrupt. */
+#if 0
+	
 	/*
 	 * Enable MIB interrupts when there are hardware phy counters.
 	 * Note we only do this (at the moment) for station mode.
@@ -804,6 +812,7 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	if (ath9k_hw_phycounters(ah) &&
 	    ((sc->sc_opmode == ATH9K_M_STA) || (sc->sc_opmode == ATH9K_M_IBSS)))
 		sc->sc_imask |= ATH9K_INT_MIB;
+#endif
 	/*
 	 * Some hardware processes the TIM IE and fires an
 	 * interrupt when the TIM bit is set.  For hardware
-- 
1.5.6.rc2.15.g457bb.dirty

