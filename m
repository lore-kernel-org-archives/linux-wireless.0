Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56169 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab2AJJuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 04:50:18 -0500
Received: by dajs34 with SMTP id s34so2717655daj.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jan 2012 01:50:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201201100803.q0A83nsQ003757@mail.maya.org>
References: <4EFF12D9.3010602@01019freenet.de>
	<2766356.70ylY68Gqi@helmutmobil.site>
	<4F040FEA.3080703@01019freenet.de>
	<1408490.qSFZVkU7fA@helmutmobil.site>
	<4F0562DF.3000200@dualc.maya.org>
	<CAGXE3d8b5qtbhesPjRy3EXvkiwshUg0eZqcDBzb1OhKK3j6z6A@mail.gmail.com>
	<4F0AEBAB.9020104@01019freenet.de>
	<CAGXE3d-cOeTEHugbgWMoz8-Dymw0=JHxykdK4ZkBmCJZ9tSPmg@mail.gmail.com>
	<201201100803.q0A83nsQ003757@mail.maya.org>
Date: Tue, 10 Jan 2012 10:50:16 +0100
Message-ID: <CAGXE3d_jW7NFnekMfwn6JPXX0xB4UWM3ttbRVLv-ZbsoMOoWEw@mail.gmail.com> (sfid-20120110_105023_633632_CD8FD555)
Subject: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 10, 2012 at 9:03 AM, Andreas Hartmann
<andihartmann@01019freenet.de> wrote:
> Meanwhile, I took a look at the tx_path with Felix patch applied. I'm
> getting this output:
>
>
> -> netperf start
>
> [38139.839028] Open BA session requested for 00:25:9c:de:4e:30 tid 0
> [38139.848151] IEEE80211_AMPDU_TX_START
> [38139.848157] activated addBA response timer on tid 0
> [38139.849723] switched off addBA timer for tid 0
> [38139.849728] Aggregation is on for tid 0
>
> -> stall
>
> [38161.686305] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 1
> [38161.698957] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 2
>
> [38161.698963] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4>
> [38161.699116] ieee80211_check_pending_bar() -> ieee80211_send_bar() true tid: 0 failed_bar_ssn: 65040
> [38161.710238] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 3
> [38161.710240] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4>
> [38161.710394] ieee80211_check_pending_bar() -> ieee80211_send_bar() true tid: 0 failed_bar_ssn: 65040
> [38161.724512] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 4
> [38161.724519] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4>
> [38161.724659] ieee80211_check_pending_bar() -> ieee80211_send_bar() true tid: 0 failed_bar_ssn: 65040
> [38161.735416] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 5
> [38161.735423] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4>
> [38161.735486] ieee80211_check_pending_bar() -> ieee80211_send_bar() true tid: 0 failed_bar_ssn: 65040
> [38161.747815] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 6
> [38161.747822] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4>
> [38161.747888] ieee80211_check_pending_bar() -> ieee80211_send_bar() true tid: 0 failed_bar_ssn: 65040
> [38161.755268] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 7
> [38161.755271] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4>
> [38161.758823] ieee80211_check_pending_bar() -> ieee80211_send_bar() true tid: 0 failed_bar_ssn: 65040
> [38161.772898] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 8
> [38161.772901] status.c ieee80211_tx_status() calls ieee80211_set_bar_pending. tid: <0> control: <4>
> [38161.773049] ieee80211_check_pending_bar() -> ieee80211_send_bar() true tid: 0 failed_bar_ssn: 65040
> [38161.789222] rt2x00lib_txdone - no success - low_level_stats.dot11ACKFailureCount: 9
> ...
>
> Looks as if sending of any package is reported as broken at some
> point of time and this circle cannot be left anymore.

Not necessarily since mac80211 will only retry the BAR if a data frame
transmission was successful. Hence, it seems as if only the BARs TX
status is reported incorrectly ...

I see two issues here:
1) rt2800pci seems to have problems delivering the BAR _or_ doesn't
   report the tx status correctly
2) If the same BAR fails consecutively we should maybe really tear down
   the BA session as it was done before

2 is done in the below untested patch and will also work around 1.
Mind to give it a try?

Thanks,
Helmut

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index a18f524..983994b 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -122,7 +122,7 @@ struct tid_ampdu_tx {
 	u8 buf_size;

 	u16 failed_bar_ssn;
-	bool bar_pending;
+	unsigned int bar_pending;
 };

 /**
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 30c265c..ea782f1 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -17,6 +17,7 @@
 #include "led.h"
 #include "wme.h"

+#define MAX_BAR_RETRIES 3

 void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
 				 struct sk_buff *skb)
@@ -171,8 +172,17 @@ static void ieee80211_check_pending_bar(struct
sta_info *sta, u8 *addr, u8 tid)
 	if (!tid_tx || !tid_tx->bar_pending)
 		return;

-	tid_tx->bar_pending = false;
-	ieee80211_send_bar(&sta->sdata->vif, addr, tid, tid_tx->failed_bar_ssn);
+	if (--tid_tx->bar_pending) {
+		ieee80211_send_bar(&sta->sdata->vif, addr, tid,
+				   tid_tx->failed_bar_ssn);
+		return;
+	}
+
+	/*
+	 * The same BAR failed multiple times, something is clearly wrong
+	 * -> Stop the BA session.
+	 */
+	ieee80211_stop_tx_ba_session(&sta->sta, tid);
 }

 static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
@@ -225,8 +235,16 @@ static void ieee80211_set_bar_pending(struct
sta_info *sta, u8 tid, u16 ssn)
 	if (!tid_tx)
 		return;

+	/*
+	 * A BAR for the same SSN is still pending, don't
+	 * update the pending count.
+	 */
+	if (tid_tx->failed_bar_ssn == ssn &&
+	    tid_tx->bar_pending)
+		return;
+
 	tid_tx->failed_bar_ssn = ssn;
-	tid_tx->bar_pending = true;
+	tid_tx->bar_pending = MAX_BAR_RETRIES;
 }

 static int ieee80211_tx_radiotap_len(struct ieee80211_tx_info *info)
