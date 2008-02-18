Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:30827 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753076AbYBRCVt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2008 21:21:49 -0500
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 3/3] mac80211: enable IBSS merging
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, flamingice@sourmilk.net, jbenc@suse.cz
Date: Mon, 18 Feb 2008 11:21:36 +0900
Message-ID: <20080218022136.5488.40580.stgit@one> (sfid-20080218_022153_780912_B3E50F97)
In-Reply-To: <20080218021448.5488.10305.stgit@one>
References: <20080218021448.5488.10305.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

enable IBSS cell merging. if an IBSS beacon with the same channel, same=
 ESSID
and a TSF higher than the local TSF (mactime) is received, we have to j=
oin its
BSSID. while this might not be immediately apparent from reading the 80=
2.11
standard it is compliant and necessary to make IBSS mode functional in =
many
cases. most drivers have a similar behaviour.

* move the relevant code section (previously only containing debug code=
) down
to the end of the function, so we can reuse the bss structure.

* we have to compare the mactime (TSF at the time of packet receive) ra=
ther
than the current TSF. since mactime is defined as the time the first da=
ta
symbol arrived we add the time until byte 24 where the timestamp reside=
s, since
this is how the beacon timestamp is defined. as some some drivers are n=
ot able
to give a reliable mactime we fall back to use the current TSF, which w=
ill be
enough to catch most (but not all) cases where an IBSS merge is necessa=
ry.

* in IBSS mode we want to allow beacons to override probe response info=
 so we
can correctly do merges.

* we don't only configure beacons based on scan results, so change that
message.

* to enable this we have to let all beacons thru in IBSS mode, even if =
they
have a different BSSID.

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---

 include/net/mac80211.h       |    3 +
 net/mac80211/ieee80211_sta.c |   90 ++++++++++++++++++++++++++++------=
--------
 net/mac80211/rx.c            |    5 ++
 3 files changed, 67 insertions(+), 31 deletions(-)


diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1b807f4..c634607 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -276,7 +276,8 @@ struct ieee80211_tx_control {
  * @RX_FLAG_FAILED_PLCP_CRC: Set this flag if the PCLP check failed on
  *	the frame.
  * @RX_FLAG_TSFT: The timestamp passed in the RX status (@mactime fiel=
d)
- *	is valid.
+ *	is valid. This is useful in monitor mode and necessary for beacon f=
rames
+ *	to enable IBSS merging.
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR	=3D 1<<0,
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.=
c
index 72d7a86..fb96b51 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2202,7 +2202,7 @@ static void ieee80211_rx_bss_info(struct net_devi=
ce *dev,
 	struct ieee80211_sta_bss *bss;
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
-	u64 timestamp;
+	u64 beacon_timestamp, rx_timestamp;
 	DECLARE_MAC_BUF(mac);
 	DECLARE_MAC_BUF(mac2);
=20
@@ -2219,31 +2219,7 @@ static void ieee80211_rx_bss_info(struct net_dev=
ice *dev,
 	if (baselen > len)
 		return;
=20
-	timestamp =3D le64_to_cpu(mgmt->u.beacon.timestamp);
-
-	if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_IBSS && beacon &&
-	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) =3D=3D 0) {
-#ifdef CONFIG_MAC80211_IBSS_DEBUG
-		static unsigned long last_tsf_debug =3D 0;
-		u64 tsf;
-		if (local->ops->get_tsf)
-			tsf =3D local->ops->get_tsf(local_to_hw(local));
-		else
-			tsf =3D -1LLU;
-		if (time_after(jiffies, last_tsf_debug + 5 * HZ)) {
-			printk(KERN_DEBUG "RX beacon SA=3D%s BSSID=3D"
-			       "%s TSF=3D0x%llx BCN=3D0x%llx diff=3D%lld "
-			       "@%lu\n",
-			       print_mac(mac, mgmt->sa), print_mac(mac2, mgmt->bssid),
-			       (unsigned long long)tsf,
-			       (unsigned long long)timestamp,
-			       (unsigned long long)(tsf - timestamp),
-			       jiffies);
-			last_tsf_debug =3D jiffies;
-		}
-#endif /* CONFIG_MAC80211_IBSS_DEBUG */
-	}
-
+	beacon_timestamp =3D le64_to_cpu(mgmt->u.beacon.timestamp);
 	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems=
);
=20
 	if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_IBSS && elems.supp_rates=
 &&
@@ -2329,8 +2305,10 @@ static void ieee80211_rx_bss_info(struct net_dev=
ice *dev,
=20
 	bss->band =3D rx_status->band;
=20
-	if (bss->probe_resp && beacon) {
-		/* Do not allow beacon to override data from Probe Response. */
+	if (sdata->vif.type !=3D IEEE80211_IF_TYPE_IBSS &&
+	    bss->probe_resp && beacon) {
+		/* STA mode:
+		 * Do not allow beacon to override data from Probe Response. */
 		ieee80211_rx_bss_put(dev, bss);
 		return;
 	}
@@ -2427,13 +2405,67 @@ static void ieee80211_rx_bss_info(struct net_de=
vice *dev,
 		bss->ht_ie_len =3D 0;
 	}
=20
-	bss->timestamp =3D timestamp;
+	bss->timestamp =3D beacon_timestamp;
 	bss->last_update =3D jiffies;
 	bss->rssi =3D rx_status->ssi;
 	bss->signal =3D rx_status->signal;
 	bss->noise =3D rx_status->noise;
 	if (!beacon)
 		bss->probe_resp++;
+
+	/* check if we need to merge IBSS */
+	if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_IBSS && beacon &&
+	    !local->sta_sw_scanning && !local->sta_hw_scanning &&
+	    mgmt->u.beacon.capab_info & WLAN_CAPABILITY_IBSS &&
+	    bss->freq =3D=3D local->oper_channel->center_freq &&
+	    elems.ssid_len =3D=3D sdata->u.sta.ssid_len &&
+	    memcmp(elems.ssid, sdata->u.sta.ssid, sdata->u.sta.ssid_len) =3D=3D=
 0) {
+		if (rx_status->flag & RX_FLAG_TSFT) {
+			/* in order for correct IBSS merging we need mactime
+			 *
+			 * since mactime is defined as the time the first data
+			 * symbol of the frame hits the PHY, and the timestamp
+			 * of the beacon is defined as "the time that the data
+			 * symbol containing the first bit of the timestamp is
+			 * transmitted to the PHY plus the transmitting STA=E2=80=99s
+			 * delays through its local PHY from the MAC-PHY
+			 * interface to its interface with the WM"
+			 * (802.11 11.1.2) - equals the time this bit arrives at
+			 * the receiver - we have to take into account the
+			 * offset between the two.
+			 * e.g: at 1 MBit that means mactime is 192 usec earlier
+			 * (=3D24 bytes * 8 usecs/byte) than the beacon timestamp.
+			 */
+			int rate =3D local->hw.wiphy->bands[rx_status->band]->
+					bitrates[rx_status->rate_idx].bitrate;
+			rx_timestamp =3D rx_status->mactime + (24 * 8 * 10 / rate);
+		} else if (local && local->ops && local->ops->get_tsf)
+			/* second best option: get current TSF */
+			rx_timestamp =3D local->ops->get_tsf(local_to_hw(local));
+		else
+			/* can't merge without knowing the TSF */
+			rx_timestamp =3D -1LLU;
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+		printk(KERN_DEBUG "RX beacon SA=3D%s BSSID=3D"
+		       "%s TSF=3D0x%llx BCN=3D0x%llx diff=3D%lld @%lu\n",
+		       print_mac(mac, mgmt->sa),
+		       print_mac(mac2, mgmt->bssid),
+		       (unsigned long long)rx_timestamp,
+		       (unsigned long long)beacon_timestamp,
+		       (unsigned long long)(rx_timestamp - beacon_timestamp),
+		       jiffies);
+#endif /* CONFIG_MAC80211_IBSS_DEBUG */
+		if (beacon_timestamp > rx_timestamp) {
+			if (CONFIG_MAC80211_IBSS_DEBUG || net_ratelimit())
+				printk(KERN_DEBUG "%s: beacon TSF higher than "
+				       "local TSF - IBSS merge with BSSID %s\n",
+				       dev->name, print_mac(mac, mgmt->bssid));
+			ieee80211_sta_join_ibss(dev, &sdata->u.sta, bss);
+			ieee80211_ibss_add_sta(dev, NULL,
+					       mgmt->bssid, mgmt->sa);
+		}
+	}
+
 	ieee80211_rx_bss_put(dev, bss);
 }
=20
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b1fc112..064adda 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1694,7 +1694,10 @@ static int prepare_for_handlers(struct ieee80211=
_sub_if_data *sdata,
 	case IEEE80211_IF_TYPE_IBSS:
 		if (!bssid)
 			return 0;
-		if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid)) {
+		if ((rx->fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_MGMT &&
+		    (rx->fc & IEEE80211_FCTL_STYPE) =3D=3D IEEE80211_STYPE_BEACON)
+			return 1;
+		else if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid)) {
 			if (!(rx->flags & IEEE80211_TXRXD_RXIN_SCAN))
 				return 0;
 			rx->flags &=3D ~IEEE80211_TXRXD_RXRA_MATCH;

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
