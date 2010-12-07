Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26562 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab0LGV2d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 16:28:33 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 13:28:18 -0800
Date: Tue, 7 Dec 2010 13:28:31 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amod Bodas <Amod.Bodas@Atheros.com>,
	"pstew@google.com" <pstew@google.com>,
	"stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH 5/5] mac80211: fix issuing idle calls when device open
 count is 0
Message-ID: <20101207212831.GC2582@tux>
References: <AANLkTimiw074uXxe3nPTNZ0j+NtZbHJU1bwiGsFUXMJ4@mail.gmail.com>
 <1291737298.3607.48.camel@jlt3.sipsolutions.net>
 <20101207155916.GA1855@tux>
 <1291743121.3607.50.camel@jlt3.sipsolutions.net>
 <AANLkTi=Sj7YpKzFHQtf2MdUcRDTzfXszbK7gGg_yup1Y@mail.gmail.com>
 <1291745567.3607.52.camel@jlt3.sipsolutions.net>
 <AANLkTimfLGj1=BnRGvJVkP_Ge6KYAtCLcDpBsVoj9o_T@mail.gmail.com>
 <1291755274.3607.59.camel@jlt3.sipsolutions.net>
 <AANLkTik-H0WXWjGjMuc_pE1vvbxFSoD2BoXVG3Wqcorw@mail.gmail.com>
 <1291755472.3607.60.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1291755472.3607.60.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 07, 2010 at 12:57:52PM -0800, Johannes Berg wrote:
> On Tue, 2010-12-07 at 12:56 -0800, Luis R. Rodriguez wrote:
> 
> > > Not really, since we do scan_cancel() within suspend()... I guess I'd
> > > like to find out why that doesn't do what I think it does.
> > 
> > Well lets see, this is only reproducible with the new DBUS APIs, and
> > frankly I am not sure what these things do. Is it possible we have a
> > race between how it brings down an interface for suspend and canceling
> > a scan?
> 
> But both suspend and do_stop should run under RTNL.

Paul, can you try this instead of these two patches. What this
does is it assumes mac80211 will tell us that stop() implies
to disable the radio as explained in the documentation and that
any further operations will not happen, and that idle settings
prior to mac80211 issuing a start() callback are the responsibility
of the driver to ensure integrity on. Because of this we ensure
idle on stop() as no other interfaces are possible enabled and
we also ensure it to be idle on resume.

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 97ddb32..eb98f7f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1337,8 +1337,8 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	ath9k_ps_restore(sc);
 
-	/* Finally, put the chip in FULL SLEEP mode */
-	ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);
+	sc->ps_idle = true;
+	ath_radio_disable(sc, hw);
 
 	sc->sc_flags |= SC_OP_INVALID;
 
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 09f69a9..47334f3 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -297,6 +297,9 @@ static int ath_pci_resume(struct device *device)
 			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
 
+	sc->ps_idle = true;
+	ath_radio_disable(sc, hw);
+
 	return 0;
 }
 
