Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mundo.umh.es ([193.147.147.4]:56064 "EHLO mundo.umh.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757129Ab0HJLfE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 07:35:04 -0400
Received: from uwicorejohn (unknown [10.1.60.4])
	by mundo.umh.es (Postfix) with ESMTP id 4DBA928DB8F
	for <linux-wireless@vger.kernel.org>; Tue, 10 Aug 2010 13:35:02 +0200 (CEST)
From: =?iso-8859-1?Q?J=F3natan_Mu=F1oz?= <jmunoz@umh.es>
To: <linux-wireless@vger.kernel.org>
Subject: mac80211: Beaconing adhoc process (ar9170 & ath9k)
Date: Tue, 10 Aug 2010 13:35:13 +0200
Message-ID: <001101cb3880$19129a50$4b37cef0$@es>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I am modifying the beaconing system of adhoc mode for ath9k and ar9170.
Until now I change /net/mac80211/ibss.

static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
				      const u8 *bssid, const int beacon_int,
				      struct ieee80211_channel *chan,
				      const u32 basic_rates,
				      const u16 capability, u64 tsf)
{

.....

if (ifibss->ie_len)
		memcpy(skb_put(skb, ifibss->ie_len),
		       ifibss->ie, ifibss->ie_len);

	rcu_assign_pointer(ifibss->presp, skb);

-	sdata->vif.bss_conf.beacon_int = beacon_int;
-	bss_change = BSS_CHANGED_BEACON_INT;
-	bss_change |= ieee80211_reset_erp_info(sdata);
+	bss_change = ieee80211_reset_erp_info(sdata);
	bss_change |= BSS_CHANGED_BSSID;
	bss_change |= BSS_CHANGED_BEACON;
	bss_change |= BSS_CHANGED_BEACON_ENABLED;
	bss_change |= BSS_CHANGED_IBSS;
	sdata->vif.bss_conf.ibss_joined = true;
	ieee80211_bss_info_change_notify(sdata, bss_change);

	ieee80211_sta_def_wmm_params(sdata, sband->n_bitrates, supp_rates);

	ifibss->state = IEEE80211_IBSS_MLME_JOINED;
	mod_timer(&ifibss->timer,
		  round_jiffies(jiffies + IEEE80211_IBSS_MERGE_INTERVAL));

	bss = cfg80211_inform_bss_frame(local->hw.wiphy,
local->hw.conf.channel,
					mgmt, skb->len, 0, GFP_KERNEL);
	cfg80211_put_bss(bss);
	cfg80211_ibss_joined(sdata->dev, ifibss->bssid, GFP_KERNEL);
}

I pretend that each node in an adhoc network send periodically beacons every
100ms. Until now I get that two nodes, one with driver ath9k and the other
one with ar9170, send their beacons in the way I want. But if another node
with ar9170 or ath9k driver is added to the network, the nodes with the same
driver send one beacon every 100ms in total, not each one as I wish. Is
there something more that I must to change?

I hope you bring me some ligth in this darkness.

Thanks in advance

John
------------------------------------------
Jónatan Muñoz
Email: jmunoz@umh.es
Ubiquitous Wireless Communications Research Laboratory 
Uwicore, http://www.uwicore.umh.es 
Signal Theory and Communications Division 
University Miguel Hernández of Elche 

Avenida de la Universidad s/n 
Edificio Quorum V P2 012
03202, Elche (Alicante) 
Spain 
Tel: +34 96522 2031 /+34 669256708
Fax: +34 96665 8903 
------------------------------------------



