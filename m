Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:57075 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670Ab3KVOGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Nov 2013 09:06:14 -0500
Received: by mail-we0-f180.google.com with SMTP id u56so1158599wes.25
        for <linux-wireless@vger.kernel.org>; Fri, 22 Nov 2013 06:06:13 -0800 (PST)
Date: Fri, 22 Nov 2013 15:05:33 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] mac80211_hwsim: claim CSA support for AP
Message-ID: <20131122140533.GA24796@magnum.frso.rivierawaves.com> (sfid-20131122_150617_832704_8768DC82)
References: <1385111186-19551-1-git-send-email-karl.beldan@gmail.com>
 <20131122104527.GD8527@magnum.frso.rivierawaves.com>
 <201311221308.11994.sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <201311221308.11994.sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 22, 2013 at 01:08:11PM +0100, Simon Wunderlich wrote:
> Hello Karl,
> 
> > 
> > Hmm, I thought the CSA code would make ieee80211_beacon_get_tim return
> > NULL (or do something alike) after the last ieee80211_beacon_get_tim
> > returned a beacon with a null CSA count until the config is done - but
> > it seems it doesn't - in that case this change would be race prone.
> > Did I miss something ?
> 
> No, you have to do the check yourself (as you appearently did). In ath9k I'm 
> checking if the CSA finished before scheduling the next beacon. Can you do the 
> same for hwsim? Where do you see the race?
> 
Hi Simon,

I would see a race in such scenario: {{{
cmd: stack/channel_switch(count=1);

bcn-intr: driver/beacon_get();
	vif->csa_active  == true
	ieee80211_csa_is_complete(); // == true
		ieee80211_csa_finish(); // schedules csa work

bcn-intr: driver/beacon_get(); // beacon but on the old channel
	vif->csa_active  still true
	ieee80211_csa_is_complete(); // still true

csa worker: csa_finalize_work(); ----> too late
		change_channel(); ----> too late
}}}

To prevent this, I thought that there was something like : {{{

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3e2dfcb..97b0382 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2405,7 +2405,7 @@ void ieee80211_csa_finish(struct ieee80211_vif *vif)
 }
 EXPORT_SYMBOL(ieee80211_csa_finish);
 
-static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
+static bool ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
 				 struct beacon_data *beacon)
 {
 	struct probe_resp *resp;
@@ -2428,14 +2428,14 @@ static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
 		beacon_data_len = beacon->head_len;
 		break;
 	default:
-		return;
+		return false;
 	}
 	if (WARN_ON(counter_offset_beacon >= beacon_data_len))
-		return;
+		return false;
 
 	/* warn if the driver did not check for/react to csa completeness */
 	if (WARN_ON(beacon_data[counter_offset_beacon] == 0))
-		return;
+		return false;
 
 	beacon_data[counter_offset_beacon]--;
 
@@ -2446,11 +2446,13 @@ static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
 		/* if nl80211 accepted the offset, this should not happen. */
 		if (WARN_ON(!resp)) {
 			rcu_read_unlock();
-			return;
+			return true;
 		}
 		resp->data[counter_offset_presp]--;
 		rcu_read_unlock();
 	}
+
+	return true;
 }
 
 bool ieee80211_csa_is_complete(struct ieee80211_vif *vif)
@@ -2540,7 +2542,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 
 		if (beacon) {
 			if (sdata->vif.csa_active)
-				ieee80211_update_csa(sdata, beacon);
+				if (!ieee80211_update_csa(sdata, beacon))
+					goto out;
 
 ... blah blah for mesh .. ibss ..
}}}
..  Of course there are other means to achieve this, just an example.

However I might have overlooked some things in the CSA code so ..


> Simon
> 
> P.S.: Please use my new e-mail address, the old one will go out of service by 
> end of the year.
Sure
 
Karl
