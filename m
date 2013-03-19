Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56331 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771Ab3CSPiW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 11:38:22 -0400
Received: by mail-ie0-f174.google.com with SMTP id k10so746036iea.5
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 08:38:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1363638107.8260.24.camel@jlt4.sipsolutions.net>
References: <3078A9B976EF864C8DDD0C499FFD07912FA1693F2A@EXMB01.eu.tieto.com>
	<1363361717.8656.18.camel@jlt4.sipsolutions.net>
	<CAFED-jmGRNFDHBvZQV=t7ETQa=yk4bZMjt1N8KckKweDLZE3uA@mail.gmail.com>
	<1363638107.8260.24.camel@jlt4.sipsolutions.net>
Date: Tue, 19 Mar 2013 16:38:21 +0100
Message-ID: <CAFED-jndqjMFjNLBadFV1W9+5QZJF649BhFKy5zSjw3pnSQh1w@mail.gmail.com> (sfid-20130319_163831_465521_E98AA722)
Subject: Re: [RFC 3/3] mac80211: P2P add NOA settings
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz.Dziedzic@tieto.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/18 Johannes Berg <johannes@sipsolutions.net>:
>
>> -     u8 p2p_ctwindow;
>> -     bool p2p_oppps;
>> +     struct ieee80211_p2p_noa_attr p2p_noa_attr;
>
> Shouldn't you also remove sdata.u.mgd.p2p_noa_index? Actually, maybe
> not, since that needs to be -1 in some cases, so n/m.
>
>> -     if (params->p2p_opp_ps >= 0) {
>> -             sdata->vif.bss_conf.p2p_oppps = params->p2p_opp_ps;
>> +     if (params->p2p_opp_ps > 0) {
>> +             sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow |= BIT(8);
>> +             changed |= BSS_CHANGED_P2P_PS;
>> +     } else if (params->p2p_opp_ps == 0) {
>> +             sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow &= ~BIT(8);
>>               changed |= BSS_CHANGED_P2P_PS;
>
> BIT(8) can't be right -- you mean 7?
>
> Maybe also time to introduce a constant for this so drivers can use it
> as well?
>
>>       if (sdata->vif.p2p) {
>> -             struct ieee80211_p2p_noa_attr noa;
>>               int ret;
>> -
>> +             struct ieee80211_p2p_noa_attr noa = {};
>> +             /* We have to handle here such cases:
>> +                - p2p_attr disapear
>
> got catch, I guess I never noticed that -- also typo ("disappears" or
> "disappeared")
>
> wrong comment style though
>
>> +             /* We can memcmp() here in case will find broken GO */
>> +             if (sdata->u.mgd.p2p_noa_index != noa.index) {
>>                       sdata->u.mgd.p2p_noa_index = noa.index;
>> +                     memcpy(&bss_conf->p2p_noa_attr, &noa, sizeof(noa));
>> +                     changed |= BSS_CHANGED_P2P_PS;
>>                       /*
>>                        * make sure we update all information, the CRC
>>                        * mechanism doesn't look at P2P attributes.
>>                        */
>>                       ifmgd->beacon_crc_valid = false;
>>               }
>> +
>> +             /* Or different handling:
>> +
>> +             // Version 2:
>
> Are you asking me to pick version? I guess the first one above doesn't
> handle the disappearance case very well?
>
>> +             int ret;
>> +             struct ieee80211_p2p_noa_attr noa = {};
>> +             ret = cfg80211_get_p2p_attr(mgmt->u.beacon.variable,
>> +                                         len - baselen,
>> +                                         IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
>> +                                         (u8 *) &noa, 2);
>
> why 2 now?
>
>> +             if (ret <= 0) {
>> +                     if (sdata->u.mgd.p2p_noa_index) {
>> +                             // NOA attr disapear
>> +                             sdata->u.mgd.p2p_noa_index = 0;
>> +                             memset(&bss_conf->p2p_noa_attr, 0,
>> +                                    sizeof(bss_conf->p2p_noa_attr));
>> +                             changed |= BSS_CHANGED_P2P_PS;
>> +                             ifmgd->beacon_crc_valid = false;
>> +                     }
>> +             } else if (sdata->u.mgd.p2p_noa_index != noa.index) {
>> +                     // NOA changed, noa desc(s) could disapear
>> +                     memset(&bss_conf->p2p_noa_attr, 0,
>> +                            sizeof(bss_conf->p2p_noa_attr);
>> +                     ret = cfg80211_get_p2p_attr(mgmt->u.beacon.variable,
>> +                                                 len - baselen,
>> +                                                 IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
>> +                                                 (u8 *) &bss_conf->p2p_noa_attr,
>> +                                                 sizeof(bss_conf->p2p_noa_attr));
>
> I don't see why you'd want to retrieve it twice? It will only copy as
> much as is present and return the data length.
>
>> +             // Version 3:
>> +             int ret;
>> +             memset(&bss_conf->p2p_noa_attr, 0, sizeof(bss_conf->p2p_noa_attr));
>> +             ret = cfg80211_get_p2p_attr(mgmt->u.beacon.variable,
>> +                                         len - baselen,
>> +                                         IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
>> +                                         (u8 *) &bss_conf->p2p_noa_attr,
>> +                                         sizeof(bss_conf->p2p_noa_attr));
>> +             if (sdata->u.mgd.p2p_noa_index != noa.index) {
>> +                     sdata->u.mgd.p2p_noa_index = noa.index;
>> +                     changed |= BSS_CHANGED_P2P_PS;
>> +                     ifmgd->beacon_crc_valid = false;
>> +             }
>
> Here you didn't check "ret", so the "disappeared entirely" case isn't
> handled?
>
> Seems like it should be like this:
>
> ret = get_p2p_attr(...)
> if (sdata->u.mgd.p2p_noa_index != noa.index || !ret) {
>   if (ret)
>     p2p_noa_index = noa.index
>   else
>     p2p_noa_index = -1;
>   changed |= ...
>   crc_valid = false;
> }
>
> to handle all the cases, including dis- and reappearance?
>

Added changes. Seems sdata->u.mgd.p2p_noa_index is required while
noa.index valid range is 0-255 and decide base on index.
I think code cover now all cases.

---
 include/net/mac80211.h     |    3 +--
 net/mac80211/cfg.c         |   19 ++++++++++++++-----
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/mlme.c        |   42 ++++++++++++++++++++++++++----------------
 net/mac80211/trace.h       |    6 ++----
 5 files changed, 44 insertions(+), 28 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cdd7cea..582e743 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -363,8 +363,7 @@ struct ieee80211_bss_conf {
 	size_t ssid_len;
 	bool hidden_ssid;
 	int txpower;
-	u8 p2p_ctwindow;
-	bool p2p_oppps;
+	struct ieee80211_p2p_noa_attr p2p_noa_attr;
 };

 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1d1ddab..6dc592b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -960,8 +960,12 @@ static int ieee80211_start_ap(struct wiphy
*wiphy, struct net_device *dev,
 	sdata->vif.bss_conf.hidden_ssid =
 		(params->hidden_ssid != NL80211_HIDDEN_SSID_NOT_IN_USE);

-	sdata->vif.bss_conf.p2p_ctwindow = params->p2p_ctwindow;
-	sdata->vif.bss_conf.p2p_oppps = params->p2p_opp_ps;
+	sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow =
+						params->p2p_ctwindow & 0x7F;
+	if (params->p2p_opp_ps)
+		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow |= BIT(7);
+	else
+		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow &= ~BIT(7);

 	err = ieee80211_assign_beacon(sdata, &params->beacon);
 	if (err < 0)
@@ -1956,12 +1960,17 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 	}

 	if (params->p2p_ctwindow >= 0) {
-		sdata->vif.bss_conf.p2p_ctwindow = params->p2p_ctwindow;
+		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow &= ~0x7f;
+		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow |=
+						params->p2p_ctwindow & 0x7f;
 		changed |= BSS_CHANGED_P2P_PS;
 	}

-	if (params->p2p_opp_ps >= 0) {
-		sdata->vif.bss_conf.p2p_oppps = params->p2p_opp_ps;
+	if (params->p2p_opp_ps > 0) {
+		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow |= BIT(7);
+		changed |= BSS_CHANGED_P2P_PS;
+	} else if (params->p2p_opp_ps == 0) {
+		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow &= ~BIT(7);
 		changed |= BSS_CHANGED_P2P_PS;
 	}

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f4433f0..11451ee 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -442,7 +442,7 @@ struct ieee80211_if_managed {

 	u8 use_4addr;

-	u8 p2p_noa_index;
+	s16 p2p_noa_index;

 	/* Signal strength from the last Beacon frame in the current BSS. */
 	int last_beacon_signal;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4fecfb8..252f4a0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1655,18 +1655,17 @@ static void ieee80211_set_associated(struct
ieee80211_sub_if_data *sdata,
 		rcu_read_lock();
 		ies = rcu_dereference(cbss->ies);
 		if (ies) {
-			struct ieee80211_p2p_noa_attr noa;
 			int ret;

 			ret = cfg80211_get_p2p_attr(
 					ies->data, ies->len,
 					IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
-					(u8 *) &noa, sizeof(noa));
+					(u8 *) &bss_conf->p2p_noa_attr,
+					sizeof(bss_conf->p2p_noa_attr));
 			if (ret >= 2) {
-				bss_conf->p2p_oppps = noa.oppps_ctwindow & 0x80;
-				bss_conf->p2p_ctwindow = noa.oppps_ctwindow & 0x7f;
+				sdata->u.mgd.p2p_noa_index =
+					bss_conf->p2p_noa_attr.index;
 				bss_info_changed |= BSS_CHANGED_P2P_PS;
-				sdata->u.mgd.p2p_noa_index = noa.index;
 			}
 		}
 		rcu_read_unlock();
@@ -1791,8 +1790,9 @@ static void ieee80211_set_disassoc(struct
ieee80211_sub_if_data *sdata,
 	changed |= BSS_CHANGED_ASSOC;
 	sdata->vif.bss_conf.assoc = false;

-	sdata->vif.bss_conf.p2p_ctwindow = 0;
-	sdata->vif.bss_conf.p2p_oppps = false;
+	ifmgd->p2p_noa_index = -1;
+	memset(&sdata->vif.bss_conf.p2p_noa_attr, 0,
+	       sizeof(sdata->vif.bss_conf.p2p_noa_attr));

 	/* on the next assoc, re-program HT/VHT parameters */
 	memset(&ifmgd->ht_capa, 0, sizeof(ifmgd->ht_capa));
@@ -2953,22 +2953,31 @@ ieee80211_rx_mgmt_beacon(struct
ieee80211_sub_if_data *sdata,
 	}

 	if (sdata->vif.p2p) {
-		struct ieee80211_p2p_noa_attr noa;
+		struct ieee80211_p2p_noa_attr noa = {};
 		int ret;

 		ret = cfg80211_get_p2p_attr(mgmt->u.beacon.variable,
 					    len - baselen,
 					    IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
 					    (u8 *) &noa, sizeof(noa));
-		if (ret >= 2 && sdata->u.mgd.p2p_noa_index != noa.index) {
-			bss_conf->p2p_oppps = noa.oppps_ctwindow & 0x80;
-			bss_conf->p2p_ctwindow = noa.oppps_ctwindow & 0x7f;
+
+		if (ret >= 2) {
+			if (sdata->u.mgd.p2p_noa_index != noa.index) {
+				/* valid noa_attr and index changed */
+				sdata->u.mgd.p2p_noa_index = noa.index;
+				memcpy(&bss_conf->p2p_noa_attr, &noa, sizeof(noa));
+				changed |= BSS_CHANGED_P2P_PS;
+				/*
+				 * make sure we update all information, the CRC
+				 * mechanism doesn't look at P2P attributes.
+				 */
+				ifmgd->beacon_crc_valid = false;
+			}
+		} else if (sdata->u.mgd.p2p_noa_index != -1) {
+			/* noa_attr not found and we had valid noa_attr before */
+			sdata->u.mgd.p2p_noa_index = -1;
+			memset(&bss_conf->p2p_noa_attr, 0, sizeof(bss_conf->p2p_noa_attr));
 			changed |= BSS_CHANGED_P2P_PS;
-			sdata->u.mgd.p2p_noa_index = noa.index;
-			/*
-			 * make sure we update all information, the CRC
-			 * mechanism doesn't look at P2P attributes.
-			 */
 			ifmgd->beacon_crc_valid = false;
 		}
 	}
@@ -3511,6 +3520,7 @@ void ieee80211_sta_setup_sdata(struct
ieee80211_sub_if_data *sdata)
 	ifmgd->powersave = sdata->wdev.ps;
 	ifmgd->uapsd_queues = IEEE80211_DEFAULT_UAPSD_QUEUES;
 	ifmgd->uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;
+	ifmgd->p2p_noa_index = -1;

 	mutex_init(&ifmgd->mtx);

diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index e7db2b8..b9322b5 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -359,8 +359,7 @@ TRACE_EVENT(drv_bss_info_changed,
 		__dynamic_array(u8, ssid, info->ssid_len);
 		__field(bool, hidden_ssid);
 		__field(int, txpower)
-		__field(u8, p2p_ctwindow)
-		__field(bool, p2p_oppps)
+		__field(u8, p2p_oppps_ctwindow)
 	),

 	TP_fast_assign(
@@ -400,8 +399,7 @@ TRACE_EVENT(drv_bss_info_changed,
 		memcpy(__get_dynamic_array(ssid), info->ssid, info->ssid_len);
 		__entry->hidden_ssid = info->hidden_ssid;
 		__entry->txpower = info->txpower;
-		__entry->p2p_ctwindow = info->p2p_ctwindow;
-		__entry->p2p_oppps = info->p2p_oppps;
+		__entry->p2p_oppps_ctwindow = info->p2p_noa_attr.oppps_ctwindow;
 	),

 	TP_printk(
-- 
1.7.9.5
