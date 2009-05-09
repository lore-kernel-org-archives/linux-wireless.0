Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:36764 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbZEIACb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 20:02:31 -0400
Subject: Re: Warning when terminating wpa_supplicant (wext driver)
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <1241705979.27208.31.camel@johannes.local>
References: <1241677107.2918.4.camel@localhost.localdomain>
	 <1241696104.27208.2.camel@johannes.local>
	 <1241704437.4903.15.camel@localhost.localdomain>
	 <1241705979.27208.31.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 08 May 2009 17:02:11 -0700
Message-Id: <1241827331.4903.75.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > > Copying Wey-Yi, but I think she's aware of this? It's definitely a
> > > driver issue. I _suspect_, but am not sure, that the driver kills the
> > > aggregation session when we disassoc or something and we only tell it
> > > about the STA removal after that, when it already killed the STA. Thus
> > > it would be a consequence of iwlwifi not implementing a proper
> > > sta_notify() callback.
> > 
> > I don't see it with nl80211 driver, but that might be pure luck.
> 
> Hmm, ok, that points to something else maybe... Now I wish I had my
> ftrace-mac80211 patch ready. Well, the patch is almost ready but we
> can't use ftrace in modules yet...
> 
> Maybe there's some timing issue. I still think it's iwlwifi getting
> confused about what mac80211 is telling it as described, but it seems
> it's a little more subtle than what I said.

something similar now happened during normal operation:

phy0: AddBA: ssn=277, dialog_token=1 tid=0 timeout=0ba_policy=1
addba: d0 08 40 01 00 16 eb 05 46 5c 00 1c f0 62 88 5b 
addba: 00 1c f0 62 88 5b e0 54 03 00 01 02 10 00 00 50 
addba: 11 
Rx A-MPDU request on tid 0 result 0
wlan0: CTS protection enabled (BSSID=00:1c:f0:xx:xx:xx)
wlan0: CTS protection disabled (BSSID=00:1c:f0:xx:xx:xx)
wlan0: no probe response from AP 00:1c:f0:xx:xx:xx - disassociating
Tx BA session stop requested for 00:1c:f0:xx:xx:xx tid 0
iwlagn 0000:03:00.0: Invalid station for AGG tid 0
------------[ cut here ]------------
WARNING: at net/mac80211/agg-tx.c:142 ___ieee80211_stop_tx_ba_session+0x6b/0x7e [mac80211]()
Hardware name: 7454CTO
Modules linked in: usb_storage option usbserial iwlagn iwlcore mac80211 cfg80211 tun fuse sco bluetooth binfmt_misc uinput snd_hda_codec_conexant snd_hda_inte
l snd_hda_codec snd_pcm snd_timer snd mbm uvcvideo soundcore cdc_ether i2400m usbnet cdc_acm cdc_wdm mii wimax snd_page_alloc uhci_hcd ehci_hcd [last unloaded
: cfg80211]
Pid: 27738, comm: phy0 Tainted: G        W  2.6.30-rc4-wl #17
Call Trace:
 [<ffffffff80234b58>] warn_slowpath+0xb1/0xe5
 [<ffffffffa0412bd2>] ? iwl_tx_agg_stop+0xc5/0x2bd [iwlcore]
 [<ffffffffa043612c>] ? iwl_mac_ampdu_action+0x2ab/0x332 [iwlagn]
 [<ffffffffa03d2b02>] ___ieee80211_stop_tx_ba_session+0x6b/0x7e [mac80211]
 [<ffffffffa03d2c80>] __ieee80211_stop_tx_ba_session+0x63/0x7b [mac80211]
 [<ffffffffa03d290c>] ieee80211_sta_tear_down_BA_sessions+0x1b/0x3b [mac80211]
 [<ffffffffa03d5a66>] ieee80211_set_disassoc+0xe4/0x2c9 [mac80211]
 [<ffffffffa03d6c77>] ieee80211_associated+0x18b/0x1b0 [mac80211]
 [<ffffffffa03d89c6>] ieee80211_sta_work+0x85d/0x8bb [mac80211]
 [<ffffffff80548227>] ? _spin_unlock_irqrestore+0x8/0x30
 [<ffffffffa03d8169>] ? ieee80211_sta_work+0x0/0x8bb [mac80211]
 [<ffffffff80244081>] worker_thread+0x132/0x1d8
 [<ffffffff80247c7e>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff80243f4f>] ? worker_thread+0x0/0x1d8
 [<ffffffff80243f4f>] ? worker_thread+0x0/0x1d8
 [<ffffffff8024791a>] kthread+0x56/0x83
 [<ffffffff8020bf6a>] child_rip+0xa/0x20
 [<ffffffff802478c4>] ? kthread+0x0/0x83
 [<ffffffff8020bf60>] ? child_rip+0x0/0x20
---[ end trace b434b88b93a5b684 ]---
Rx BA session stop requested for 00:1c:f0:xx:xx:xx tid 0
iwlagn 0000:03:00.0: Invalid station for AGG tid 0
HW problem - can not stop rx aggregation for tid 0
phy0: device now idle
phy0: Removed STA 00:1c:f0:xx:xx:xx
mac80211-phy0: failed to remove key (0, 00:1c:f0:xx:xx:xx) from hardware (-22)
phy0: Destroyed STA 00:1c:f0:xx:xx:xx
phy0: device no longer idle - scanning
phy0: device now idle
phy0: device no longer idle - in use
wlan0: authenticate with AP 00:1c:f0:xx:xx:xx
wlan0: authenticate with AP 00:1c:f0:xx:xx:xx
wlan0: authenticated
phy0: device now idle
phy0: device no longer idle - in use
wlan0: associate with AP 00:1c:f0:xx:xx:xx
wlan0: RX ReassocResp from 00:1c:f0:xx:xx:xx (capab=0x431 status=0 aid=4)
wlan0: associated
phy0: Allocated STA 00:1c:f0:xx:xx:xx
phy0: Inserted STA 00:1c:f0:xx:xx:xx
wmaster0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 txop=0
wmaster0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0
wmaster0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94
wmaster0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47
wlan0: switched to short barker preamble (BSSID=00:1c:f0:xx:xx:xx)
wlan0: switched to short slot time (BSSID=00:1c:f0:xx:xx:xx)
Open BA session requested for 00:1c:f0:xx:xx:xx tid 0
iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1c:f0:xx:xx:xx tid = 0
activated addBA response timer on tid 0
switched off addBA timer for tid 0 
Aggregation is on for tid 0 
phy0: AddBA: ssn=118, dialog_token=1 tid=0 timeout=0ba_policy=1
addba: d0 00 40 01 00 16 eb 05 46 5c 00 1c f0 62 88 5b 
addba: 00 1c f0 62 88 5b 30 8e 03 00 01 02 10 00 00 60 
addba: 07 
Rx A-MPDU request on tid 0 result 0

Regards

Marcel


