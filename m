Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f176.google.com ([209.85.210.176]:40029 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab3CQI0j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Mar 2013 04:26:39 -0400
Received: by mail-ia0-f176.google.com with SMTP id i18so4338110iac.7
        for <linux-wireless@vger.kernel.org>; Sun, 17 Mar 2013 01:26:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1363361717.8656.18.camel@jlt4.sipsolutions.net>
References: <3078A9B976EF864C8DDD0C499FFD07912FA1693F2A@EXMB01.eu.tieto.com>
	<1363361717.8656.18.camel@jlt4.sipsolutions.net>
Date: Sun, 17 Mar 2013 09:26:38 +0100
Message-ID: <CAFED-jmGRNFDHBvZQV=t7ETQa=yk4bZMjt1N8KckKweDLZE3uA@mail.gmail.com> (sfid-20130317_092703_119729_AFCD90F3)
Subject: Re: [RFC 3/3] mac80211: P2P add NOA settings
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz.Dziedzic@tieto.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/15 Johannes Berg <johannes@sipsolutions.net>:
> On Thu, 2013-03-14 at 09:33 +0200, Janusz.Dziedzic@tieto.com wrote:
>> Add P2P NOA settings for STA mode.
>
> First two patches are fine, here I have some concerns.
>
>> +/* struct p2p_noa_desc - holds Notice of Absence parameters
>> + *
>
> This isn't valid kernel-doc.
>
>> +struct p2p_noa_desc {
>
> However, in any case, I'd rather you remove this struct.
>
>> +     struct p2p_noa_desc p2p_noa_desc[IEEE80211_P2P_NOA_DESC_MAX];
>
> and use ieee80211_p2p_noa_desc here
>
>> +static u8 ieee80211_setup_noa_attr(struct ieee80211_bss_conf *bss_conf,
>> +                                struct ieee80211_p2p_noa_attr *noa)
>
> indentation is wrong, but you'll get rid of the function anyway :-)
>
>> +             bss_conf->p2p_noa_desc[i].duration =
>> +                             le32_to_cpu(noa->desc[i].duration);
>
> I don't see any need to do endian conversion here in mac80211 -- the
> driver can do it. Most drivers won't need it anyway, so this is just
> extra code/time spent.
>
>> -                     struct ieee80211_p2p_noa_attr noa;
>> +                     struct ieee80211_p2p_noa_attr noa = {0};
>
> Please just use = {}. Although ... see below
>
>> @@ -2953,18 +2976,17 @@ ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
>>       }
>>
>>       if (sdata->vif.p2p) {
>> -             struct ieee80211_p2p_noa_attr noa;
>> +             struct ieee80211_p2p_noa_attr noa = {0};
>>               int ret;
>>
>>               ret = cfg80211_get_p2p_attr(mgmt->u.beacon.variable,
>>                                           len - baselen,
>>                                           IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
>>                                           (u8 *) &noa, sizeof(noa));
>> -             if (ret >= 2 && sdata->u.mgd.p2p_noa_index != noa.index) {
>> -                     bss_conf->p2p_oppps = noa.oppps_ctwindow & 0x80;
>> -                     bss_conf->p2p_ctwindow = noa.oppps_ctwindow & 0x7f;
>> +             if (sdata->u.mgd.p2p_noa_index != noa.index) {
>> +                     sdata->u.mgd.p2p_noa_index =
>> +                                     ieee80211_setup_noa_attr(bss_conf, &noa);
>>                       changed |= BSS_CHANGED_P2P_PS;
>> -                     sdata->u.mgd.p2p_noa_index = noa.index;
>
> Now that we pretty much have *all* fields of the NoA attribute in
> bss_conf (except the index), why not just put the full struct there, and
> have cfg80211 read into that buffer directly? That way, we save all the
> copying. Yes, it would mean changing all the drivers (just one I guess)
> using it, but maybe that'd be better?
>
> Or do we expect broken GOs that change the contents w/o updating the
> index, and then things break or something?
>

Hello Johannes,

Added changes you suggest.
Added some comments/questions in the code.
Please review.

---
 include/net/mac80211.h |    3 +-
 net/mac80211/cfg.c     |   19 ++++++++----
 net/mac80211/mlme.c    |   76 +++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 78 insertions(+), 20 deletions(-)

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
index 1d1ddab..2a8be822 100644
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
+		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow |= BIT(8);
+	else
+		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow &= ~BIT(8);

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
+		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow |= BIT(8);
+		changed |= BSS_CHANGED_P2P_PS;
+	} else if (params->p2p_opp_ps == 0) {
+		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow &= ~BIT(8);
 		changed |= BSS_CHANGED_P2P_PS;
 	}

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4fecfb8..2681429 100644
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
@@ -1791,8 +1790,8 @@ static void ieee80211_set_disassoc(struct
ieee80211_sub_if_data *sdata,
 	changed |= BSS_CHANGED_ASSOC;
 	sdata->vif.bss_conf.assoc = false;

-	sdata->vif.bss_conf.p2p_ctwindow = 0;
-	sdata->vif.bss_conf.p2p_oppps = false;
+	memset(&sdata->vif.bss_conf.p2p_noa_attr, 0,
+	       sizeof(sdata->vif.bss_conf.p2p_noa_attr));

 	/* on the next assoc, re-program HT/VHT parameters */
 	memset(&ifmgd->ht_capa, 0, sizeof(ifmgd->ht_capa));
@@ -2953,24 +2952,75 @@ ieee80211_rx_mgmt_beacon(struct
ieee80211_sub_if_data *sdata,
 	}

 	if (sdata->vif.p2p) {
-		struct ieee80211_p2p_noa_attr noa;
 		int ret;
-
+		struct ieee80211_p2p_noa_attr noa = {};
+		/* We have to handle here such cases:
+		   - p2p_attr disapear
+		   - index changed, noa desc disapear but left oppps
+		 */
 		ret = cfg80211_get_p2p_attr(mgmt->u.beacon.variable,
 					    len - baselen,
 					    IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
 					    (u8 *) &noa, sizeof(noa));
-		if (ret >= 2 && sdata->u.mgd.p2p_noa_index != noa.index) {
-			bss_conf->p2p_oppps = noa.oppps_ctwindow & 0x80;
-			bss_conf->p2p_ctwindow = noa.oppps_ctwindow & 0x7f;
-			changed |= BSS_CHANGED_P2P_PS;
+
+		/* We can memcmp() here in case will find broken GO */
+		if (sdata->u.mgd.p2p_noa_index != noa.index) {
 			sdata->u.mgd.p2p_noa_index = noa.index;
+			memcpy(&bss_conf->p2p_noa_attr, &noa, sizeof(noa));
+			changed |= BSS_CHANGED_P2P_PS;
 			/*
 			 * make sure we update all information, the CRC
 			 * mechanism doesn't look at P2P attributes.
 			 */
 			ifmgd->beacon_crc_valid = false;
 		}
+
+		/* Or different handling:
+
+		// Version 2:
+		int ret;
+		struct ieee80211_p2p_noa_attr noa = {};
+		ret = cfg80211_get_p2p_attr(mgmt->u.beacon.variable,
+					    len - baselen,
+					    IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
+					    (u8 *) &noa, 2);
+		if (ret <= 0) {
+			if (sdata->u.mgd.p2p_noa_index) {
+				// NOA attr disapear
+				sdata->u.mgd.p2p_noa_index = 0;
+				memset(&bss_conf->p2p_noa_attr, 0,
+				       sizeof(bss_conf->p2p_noa_attr));
+				changed |= BSS_CHANGED_P2P_PS;
+				ifmgd->beacon_crc_valid = false;
+			}
+		} else if (sdata->u.mgd.p2p_noa_index != noa.index) {
+			// NOA changed, noa desc(s) could disapear
+			memset(&bss_conf->p2p_noa_attr, 0,
+			       sizeof(bss_conf->p2p_noa_attr);
+			ret = cfg80211_get_p2p_attr(mgmt->u.beacon.variable,
+						    len - baselen,
+						    IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
+						    (u8 *) &bss_conf->p2p_noa_attr,
+						    sizeof(bss_conf->p2p_noa_attr));
+			sdata->u.mgd.p2p_noa_index = noa.index;
+			changed |= BSS_CHANGED_P2P_PS;
+			ifmgd->beacon_crc_valid = false;
+		}
+
+		// Version 3:
+		int ret;
+		memset(&bss_conf->p2p_noa_attr, 0, sizeof(bss_conf->p2p_noa_attr));
+		ret = cfg80211_get_p2p_attr(mgmt->u.beacon.variable,
+					    len - baselen,
+					    IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
+					    (u8 *) &bss_conf->p2p_noa_attr,
+					    sizeof(bss_conf->p2p_noa_attr));
+		if (sdata->u.mgd.p2p_noa_index != noa.index) {
+			sdata->u.mgd.p2p_noa_index = noa.index;
+			changed |= BSS_CHANGED_P2P_PS;
+			ifmgd->beacon_crc_valid = false;
+		}
+		*/
 	}

 	if (ncrc == ifmgd->beacon_crc && ifmgd->beacon_crc_valid)
-- 
1.7.9.5

BR
Janusz
