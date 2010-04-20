Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63414 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab0DTQyD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 12:54:03 -0400
Subject: Re: iwl3945: Error sending REPLY_{RXON|SCAN_CMD|TX_PWR_TABLE_CMD}
 time out after 500ms
From: reinette chatre <reinette.chatre@intel.com>
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	"Berg, Johannes" <johannes.berg@intel.com>
In-Reply-To: <n2g2d0a357f1004170705j6d0750fdkc4784f86aab51c97@mail.gmail.com>
References: <n2g2d0a357f1004170705j6d0750fdkc4784f86aab51c97@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Apr 2010 09:54:02 -0700
Message-ID: <1271782442.14052.19698.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sat, 2010-04-17 at 07:05 -0700, Sedat Dilek wrote:
> I have already sent an bug-report "iwl3945: Network dropouts w/
> flash-stream in firefox" in [1].
> Unfortunately, the problem still remains, especially when
> fast-forwarding flash movies in firefox-3.6.3.
> It seems the wifi-card is hanging and my system needs a coldstart.

Is this a recent problem? How regularly do you update your kernel?

> 
> The kernel I use is a Linux-2.6.34-rc4-git4 with these 3 patches in addition:

Where can I access this kernel's git repo?

> According to Johannes (on IRC) iwl3945 doesn't use internal scans yet
> (see my patch below).
> Thus, I am not sure if this needs to be fixed separately for iwl3945
> and if I ran into a scan race condition here.

Does this patch make any difference for you?


> Hope, this helps.

It does. Thank you. As a sanity check, could you please try this patch? 

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c8cd169..1ad15bd 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -814,7 +814,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata)
 	changed |= BSS_CHANGED_ASSOC;
 	sdata->vif.bss_conf.assoc = false;
 
-	ieee80211_set_wmm_default(sdata);
+	/*ieee80211_set_wmm_default(sdata);*/
 
 	/* channel(_type) changes are handled by ieee80211_hw_config */
 	local->oper_channel_type = NL80211_CHAN_NO_HT;


