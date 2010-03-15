Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13561 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965013Ab0COXtL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 19:49:11 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 16:49:11 -0700
Date: Mon, 15 Mar 2010 16:49:09 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	Vivek Natarajan <Vivek.Natarajan@Atheros.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH v3 00/12] ath9k_hw: complete support for AR9271
Message-ID: <20100315234909.GA2662@tux>
References: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
 <20100315214338.GB4000@tux>
 <43e72e891003151625t795b8ecdr2ce2e6927e8632a4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <43e72e891003151625t795b8ecdr2ce2e6927e8632a4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 15, 2010 at 04:25:14PM -0700, Luis R. Rodriguez wrote:
> On Mon, Mar 15, 2010 at 2:43 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Fri, Mar 12, 2010 at 09:46:44PM -0800, Luis R. Rodriguez wrote:
> >>   * I spotted a check added to bail out for tweaking the ACK/CTS
> >>     time out values -- this check should no longer be required
> >>     since Felix sent a proper fix for this recenlty. I removed that
> >>     hunk:
> >>
> >> @@ -1210,6 +1195,9 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
> >>               REG_WRITE(ah, AR_PCU_MISC,
> >>                         REG_READ(ah, AR_PCU_MISC) | ah->misc_mode);
> >>
> >> +     if (AR_SREV_9271(ah))
> >> +             return;
> >> +
> >>       if (conf->channel && conf->channel->band == IEEE80211_BAND_5GHZ)
> >>               sifstime = 16;
> >>       else
> >> --
> >
> > Turns out this hunk is required... but the rf changes are not (patch 4/12)
> > so I'll just respin and send a new series out.
> >
> > We should look for a better way to address this issue instead of the above hunk
> > otherwise we will be skipping all changes to the slot time from mac80211.
> > Right now ath9k_htc does not support this (BSS_CHANGED_ERP_SLOT) or a
> > set_coverage_class() callback.
> 
> We'll need to support at least BSS_CHANGED_ERP_SLOT in case the AP
> switches to compatibility mode.

How about something like this:

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 3b4c636..387eef9 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1438,6 +1438,14 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 		ath9k_htc_beacon_config(priv, vif, bss_conf);
 	}
 
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		if (bss_conf->use_short_slot)
+			ah->slottime = 9;
+		else
+			ah->slottime = 20;
+		ath9k_hw_init_global_settings(ah);
+	}
+
 	if (changed & BSS_CHANGED_BEACON)
 		ath9k_htc_beacon_update(priv, vif);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 00570fb..867cfaf 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -784,9 +784,6 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		REG_WRITE(ah, AR_PCU_MISC,
 			  REG_READ(ah, AR_PCU_MISC) | ah->misc_mode);
 
-	if (AR_SREV_9271(ah))
-		return;
-
 	if (conf->channel && conf->channel->band == IEEE80211_BAND_5GHZ)
 		sifstime = 16;
 	else
@@ -807,6 +804,10 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		acktimeout += 64 - sifstime - ah->slottime;
 
 	ath9k_hw_setslottime(ah, slottime);
+
+	if (AR_SREV_9271(ah))
+		return;
+
 	ath9k_hw_set_ack_timeout(ah, acktimeout);
 	ath9k_hw_set_cts_timeout(ah, acktimeout);
 	if (ah->globaltxtimeout != (u32) -1)
