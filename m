Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43615 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab2DCDxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 23:53:45 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20346.29723.444267.19298@gargle.gargle.HOWL> (sfid-20120403_055349_380623_F6BD72CD)
Date: Tue, 3 Apr 2012 09:22:59 +0530
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: deadlock in ath9k, 3.3.0+ kernel.
In-Reply-To: <4F79DAAC.6080705@candelatech.com>
References: <4F79D0C5.6090601@candelatech.com>
	<506697F5827BD842B7CB80D046EBE618929925@aphydexd01b>
	<4F79DAAC.6080705@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> On 04/02/2012 09:34 AM, Manoharan, Sujith wrote:
> > Patch sent:  http://marc.info/?l=linux-wireless&m=133282325727326&w=2
> 
> My 3.3.0 ath9k code doesn't look like that patch at all.  Is some
> extra back-porting needed for 3.3.0???
> 
> 
> static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
> 			    struct ieee80211_vif *vif)
> {
> 	struct ath_node *an;
> 	an = (struct ath_node *)sta->drv_priv;
> 
> #ifdef CONFIG_ATH9K_DEBUGFS
> 	spin_lock(&sc->nodes_lock);
> 	list_add(&an->list, &sc->nodes);
> 	spin_unlock(&sc->nodes_lock);
> #endif
> 	an->sta = sta;
> 	an->vif = vif;
> 	if (sc->sc_flags & SC_OP_TXAGGR) {
> 		ath_tx_node_init(sc, an);
> 		an->maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
> 				     sta->ht_cap.ampdu_factor);
> 		an->mpdudensity = parse_mpdudensity(sta->ht_cap.ampdu_density);
> 	}
> }

Yeah, this looks like a different issue. What does decodecode (in scripts/ in the kernel
source tree) show ?

Sujith
