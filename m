Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45627 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861AbZKBVmk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 16:42:40 -0500
Date: Mon, 2 Nov 2009 16:42:44 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re: [RFC] mac80211: make ieee80211_find_sta per virtual interface
Message-ID: <20091102214244.GA25479@bombadil.infradead.org>
References: <1256896722.3555.39.camel@johannes.local> <43e72e890910300802v25ba6211s4e9302dd1968230e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <43e72e890910300802v25ba6211s4e9302dd1968230e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 30, 2009 at 08:02:26AM -0700, Luis R. Rodriguez wrote:
> On Fri, Oct 30, 2009 at 2:58 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > Since we have a TODO item to make all station
> > management dependent on virtual interfaces, I
> > figured I'd start with pushing such a change
> > to drivers before more drivers use this kind
> > of functionality...
> >
> > The iwlwifi bits are easy, but I don't know
> > what to do about the ath9k bits. Any ideas?
> 
> > --- wireless-testing.orig/drivers/net/wireless/ath/ath9k/xmit.c 2009-10-30 10:54:10.000000000 +0100
> > +++ wireless-testing/drivers/net/wireless/ath/ath9k/xmit.c      2009-10-30 10:55:48.000000000 +0100
> > @@ -282,7 +282,7 @@ static void ath_tx_complete_aggr(struct
> >
> >        rcu_read_lock();
> >
> > -       sta = ieee80211_find_sta(sc->hw, hdr->addr1);
> > +       sta = ieee80211_find_sta(/*??????*/, hdr->addr1);
> 
> Not sure but I just wanted to point out the that the sc->hw above here
> was wrong anyway for virtual wiphy support, this should instead
> probably look for the aphy with ath_get_virt_hw() as is done with
> ath_rx_prepare().

And upon further investigation one way to do this is something as below. I did this
as a test as I needed to answer the question of "who does this skb belong to" for
virtual wiphy purposes. The question of who it belongs to is not that important but
the more important thing is to determine the appropriate ieee80211_hw and the mode
of operation the hw should use to behave for the skb. ath9k uses the sc->sc_ah->opmode
in many places and it was to be determined how we'd update this for virtual wiphys.
To answer that you need to determine either the minimum hw configuration your device
needs to operate under to allow all current virtual wiphys to operate properly
or just determine the vif we are to use. Either way it turns out these questions
are not easy to answer from the driver.

A simple question like: "do we have monitor vif?" is not an easy question to answer
for mac80211 drivers as such, as this patch should illustrate, we should perhaps
consider moving more of the virtual wiphy implementation to mac80211/cfg80211 or
as you have put it -- just bring the vif capability to be on its own channel.

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 330cd3b..9c41071 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -17,23 +17,29 @@
 #include "ath9k.h"
 
 static struct ieee80211_hw * ath_get_virt_hw(struct ath_softc *sc,
-					     struct ieee80211_hdr *hdr)
+					     struct ieee80211_hdr *hdr,
+					     struct ieee80211_vif **vif)
 {
 	struct ieee80211_hw *hw = sc->pri_wiphy->hw;
 	int i;
 
+	*vif = ieee80211_get_vif_by_mac_atomic(hw, hdr->addr1);
+	if (*vif)
+		return hw;
+
 	spin_lock_bh(&sc->wiphy_lock);
 	for (i = 0; i < sc->num_sec_wiphy; i++) {
 		struct ath_wiphy *aphy = sc->sec_wiphy[i];
-		if (aphy == NULL)
+		if (!aphy)
 			continue;
-		if (compare_ether_addr(hdr->addr1, aphy->hw->wiphy->perm_addr)
-		    == 0) {
+		*vif = ieee80211_get_vif_by_mac_atomic(aphy->hw, hdr->addr1);
+		if (*vif) {
 			hw = aphy->hw;
 			break;
 		}
 	}
 	spin_unlock_bh(&sc->wiphy_lock);
+
 	return hw;
 }
 
@@ -662,6 +668,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 	struct ieee80211_rx_status rx_status;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ieee80211_vif *vif;
 	/*
 	 * The hw can techncically differ from common->hw when using ath9k
 	 * virtual wiphy so to account for that we iterate over the active
@@ -748,7 +755,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 				DMA_FROM_DEVICE);
 
 		hdr = (struct ieee80211_hdr *) skb->data;
-		hw = ath_get_virt_hw(sc, hdr);
+		hw = ath_get_virt_hw(sc, hdr, &vif);
 
 		/*
 		 * If we're asked to flush receive queue, directly
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e12293e..1d2bb0a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1999,6 +1999,12 @@ void ieee80211_iterate_active_interfaces_atomic(struct ieee80211_hw *hw,
 						    struct ieee80211_vif *vif),
 						void *data);
 
+struct ieee80211_vif *ieee80211_get_vif_by_mac(struct ieee80211_hw *hw,
+					       u8 *mac);
+
+struct ieee80211_vif *ieee80211_get_vif_by_mac_atomic(struct ieee80211_hw *hw,
+					       u8 *mac);
+
 /**
  * ieee80211_queue_work - add work onto the mac80211 workqueue
  *
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index aedbaaa..f3f5a8b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -511,6 +511,107 @@ void ieee80211_iterate_active_interfaces_atomic(
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces_atomic);
 
+static struct ieee80211_vif *ieee80211_get_first_mon_vif(struct ieee80211_hw *hw)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_vif *vif = NULL;
+
+	if (likely(!local->monitors && local->cooked_mntrs++))
+		return NULL;
+
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (sdata->vif.type == NL80211_IFTYPE_MONITOR) {
+			vif = &sdata->vif;
+			break;
+		}
+	}
+
+	return vif;
+}
+
+struct ieee80211_vif *ieee80211_get_vif_by_mac(struct ieee80211_hw *hw,
+					       u8 *mac)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_vif *vif = NULL;
+
+	mutex_lock(&local->iflist_mtx);
+
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		switch (sdata->vif.type) {
+		case __NL80211_IFTYPE_AFTER_LAST:
+		case NL80211_IFTYPE_UNSPECIFIED:
+		case NL80211_IFTYPE_MONITOR:
+		case NL80211_IFTYPE_AP_VLAN:
+			continue;
+		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_STATION:
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_WDS:
+		case NL80211_IFTYPE_MESH_POINT:
+			break;
+		}
+
+		if (compare_ether_addr(mac, sdata->dev->dev_addr) == 0) {
+			vif = &sdata->vif;
+			break;
+		}
+	}
+
+	if (!vif) {
+		vif = ieee80211_get_first_mon_vif(hw);
+		WARN_ON(!vif);
+	}
+
+	mutex_unlock(&local->iflist_mtx);
+
+	return vif;
+}
+EXPORT_SYMBOL_GPL(ieee80211_get_vif_by_mac);
+
+struct ieee80211_vif *ieee80211_get_vif_by_mac_atomic(struct ieee80211_hw *hw,
+						      u8 *mac)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_vif *vif = NULL;
+
+	rcu_read_lock();
+
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		switch (sdata->vif.type) {
+		case __NL80211_IFTYPE_AFTER_LAST:
+		case NL80211_IFTYPE_UNSPECIFIED:
+		case NL80211_IFTYPE_MONITOR:
+		case NL80211_IFTYPE_AP_VLAN:
+			continue;
+		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_STATION:
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_WDS:
+		case NL80211_IFTYPE_MESH_POINT:
+			break;
+		}
+
+		if (compare_ether_addr(mac, sdata->dev->dev_addr) == 0) {
+			vif = &sdata->vif;
+			break;
+		}
+	}
+
+	if (!vif) {
+		vif = ieee80211_get_first_mon_vif(hw);
+		WARN_ON(!vif);
+	}
+
+	rcu_read_unlock();
+
+	return vif;
+}
+EXPORT_SYMBOL_GPL(ieee80211_get_vif_by_mac_atomic);
+
 /*
  * Nothing should have been stuffed into the workqueue during
  * the suspend->resume cycle. If this WARN is seen then there
