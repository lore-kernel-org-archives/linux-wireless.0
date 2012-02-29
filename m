Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57431 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab2B2PU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 10:20:56 -0500
Received: by vbbff1 with SMTP id ff1so2782368vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 07:20:56 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 29 Feb 2012 20:50:56 +0530
Message-ID: <CAD2nsn1b0FtbY3MX9MhWxkRwv9KvNvRD7p5jM8GDA=PqS_yiqA@mail.gmail.com> (sfid-20120229_162101_034433_80440D21)
Subject: BUG: sleeping function called from invalid context at drivers/net/wireless/iwlwifi/iwl-trans.h:452
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Emmanuel,

was debugging some issue in ath9k with UDP bidirectional traffic and
then used my inbuilt iwlwifi with bidirectional UDP had this warnings

* iwlagn_mac_ampdu_action->iwlagn_tx_agg_start ->  (we take spinlock
'sta_lock' ) -> iwl_trans_tx_agg_alloc (which has might_sleep)
* iwlagn_mac_ampdu_action->iwlagn_tx_agg_stop ->  (we take spinlock
'sta_lock' ) -> iwl_trans_tx_agg_disable (which has might_sleep)

BUG:  sleeping function called from invalid context at
drivers/net/wireless/iwlwifi/iwl-trans.h:452
[ 1424.360233] in_atomic(): 1, irqs_disabled(): 1, pid: 2824, name: kworker/u:3
[ 1424.360236] 5 locks held by kworker/u:3/2824:
[ 1424.360238]  #0:  (wiphy_name(local->hw.wiphy)){.+.+.+}, at:
[<c0150e3b>] process_one_work+0x11b/0x520
[ 1424.360249]  #1:  ((&sta->ampdu_mlme.work)){+.+...}, at:
[<c0150e3b>] process_one_work+0x11b/0x520
[ 1424.360256]  #2:  (&sta->ampdu_mlme.mtx){+.+.+.}, at: [<f908db43>]
ieee80211_ba_session_work+0x43/0x1e0 [mac80211]
[ 1424.360275]  #3:  (&priv->shrd->mutex){+.+.+.}, at: [<f97a9f20>]
iwlagn_mac_ampdu_action+0xc0/0x3a0 [iwlwifi]
[ 1424.360288]  #4:  (&(&priv->shrd->sta_lock)->rlock){..-...}, at:
[<f97b090a>] iwlagn_tx_agg_start+0xda/0x2a0 [iwlwifi]
[ 1424.360301] irq event stamp: 4366
[ 1424.360302] hardirqs last  enabled at (4365): [<c0202fba>]
__free_pages_ok+0x9a/0xd0
[ 1424.360307] hardirqs last disabled at (4366): [<c069ac59>]
_raw_spin_lock_irqsave+0x29/0xa0
[ 1424.360313] softirqs last  enabled at (4330): [<f908dbbf>]
ieee80211_ba_session_work+0xbf/0x1e0 [mac80211]
[ 1424.360331] softirqs last disabled at (4328): [<c069ae04>]
_raw_spin_lock_bh+0x14/0x80
[ 1424.360336] Pid: 2824, comm: kworker/u:3 Not tainted 3.3.0-rc5-wl+ #13
[ 1424.360338] Call Trace:
[ 1424.360342]  [<c0163e75>] __might_sleep+0x125/0x1c0
[ 1424.360351]  [<f97b0946>] iwlagn_tx_agg_start+0x116/0x2a0 [iwlwifi]
[ 1424.360359]  [<f97aa0a0>] iwlagn_mac_ampdu_action+0x240/0x3a0 [iwlwifi]
[ 1424.360367]  [<f97a9e60>] ? iwlagn_mac_flush+0x200/0x200 [iwlwifi]
[ 1424.360379]  [<f908f03a>]
ieee80211_tx_ba_session_handle_start+0xfa/0x590 [mac80211]
[ 1424.360392]  [<f908dbc8>] ieee80211_ba_session_work+0xc8/0x1e0 [mac80211]
[ 1424.360395]  [<c0150eb4>] process_one_work+0x194/0x520
[ 1424.360398]  [<c0150e3b>] ? process_one_work+0x11b/0x520
[ 1424.360401]  [<c01527f6>] ? worker_thread+0x1f6/0x320
[ 1424.360413]  [<f908db00>] ?
ieee80211_ht_cap_ie_to_sta_ht_cap+0x170/0x170 [mac80211]
[ 1424.360417]  [<c015273b>] worker_thread+0x13b/0x320
[ 1424.360420]  [<c01915cb>] ? trace_hardirqs_on+0xb/0x10
[ 1424.360423]  [<c0152600>] ? manage_workers+0x1e0/0x1e0
[ 1424.360426]  [<c01574b4>] kthread+0x84/0x90
[ 1424.360430]  [<c0157430>] ? __init_kthread_worker+0x60/0x60
[ 1424.360434]  [<c06a3146>] kernel_thread_helper+0x6/0x10
[ 1424.360631] activated addBA response timer on tid 0
[ 1424.361847] switched off addBA timer for tid 0


29 19:09:50 shafi-laptop kernel: [ 2684.644136] BUG: sleeping function
called from invalid context at
drivers/net/wireless/iwlwifi/iwl-trans.h:441
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644149] in_atomic(): 1,
irqs_disabled(): 1, pid: 39, name: kworker/u:1
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644158] 5 locks held by
kworker/u:1/39:
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644164]  #0:
(wiphy_name(local->hw.wiphy)){.+.+.+}, at: [<c0150e3b>]
process_one_work+0x11b/0x520
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644194]  #1:
((&sta->ampdu_mlme.work)){+.+...}, at: [<c0150e3b>]
process_one_work+0x11b/0x520
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644215]  #2:
(&sta->ampdu_mlme.mtx){+.+.+.}, at: [<f908db43>]
ieee80211_ba_session_work+0x43/0x1e0 [mac80211]
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644275]  #3:
(&priv->shrd->mutex){+.+.+.}, at: [<f97a9f20>]
iwlagn_mac_ampdu_action+0xc0/0x3a0 [iwlwifi]
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644316]  #4:
(&(&priv->shrd->lock)->rlock){..-...}, at: [<f97b0be2>]
iwlagn_tx_agg_stop+0x112/0x2b0 [iwlwifi]
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644357] irq event stamp: 1301302
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644363] hardirqs last
enabled at (1301301): [<c06986da>] __mutex_lock_common+0x25a/0x390
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644378] hardirqs last
disabled at (1301302): [<c069ac59>] _raw_spin_lock_irqsave+0x29/0xa0
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644391] softirqs last
enabled at (1301278): [<f908e9e7>]
___ieee80211_stop_tx_ba_session+0x147/0x380 [mac80211]
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644436] softirqs last
disabled at (1301276): [<c069ae04>] _raw_spin_lock_bh+0x14/0x80
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644452] Pid: 39, comm:
kworker/u:1 Not tainted 3.3.0-rc5-wl+ #13
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644459] Call Trace:
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644474]  [<c0163e75>]
__might_sleep+0x125/0x1c0
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644504]  [<f97b0bfb>]
iwlagn_tx_agg_stop+0x12b/0x2b0 [iwlwifi]
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644536]  [<f97a9fcc>]
iwlagn_mac_ampdu_action+0x16c/0x3a0 [iwlwifi]
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644583]  [<f908eaba>]
___ieee80211_stop_tx_ba_session+0x21a/0x380 [mac80211]
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644612]  [<f97a9e60>] ?
iwlagn_mac_flush+0x200/0x200 [iwlwifi]
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644655]  [<f908dc75>]
ieee80211_ba_session_work+0x175/0x1e0 [mac80211]
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644667]  [<c0150eb4>]
process_one_work+0x194/0x520
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644678]  [<c0150e3b>] ?
process_one_work+0x11b/0x520
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644688]  [<c01527f6>] ?
worker_thread+0x1f6/0x320
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644730]  [<f908db00>] ?
ieee80211_ht_cap_ie_to_sta_ht_cap+0x170/0x170 [mac80211]
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644746]  [<c015273b>]
worker_thread+0x13b/0x320
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644757]  [<c01915cb>] ?
trace_hardirqs_on+0xb/0x10
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644768]  [<c0152600>] ?
manage_workers+0x1e0/0x1e0
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644779]  [<c01574b4>]
kthread+0x84/0x90
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644791]  [<c0157430>] ?
__init_kthread_worker+0x60/0x60
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.644804]  [<c06a3146>]
kernel_thread_helper+0x6/0x10
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.645426] Stopping Tx BA
session for 00:03:7f:40:02:c0 tid 0
Feb 29 19:09:50 shafi-laptop kernel: [ 2684.705473] ath: NETWORK SLEEP -> AWAKE


-- 
thanks,
shafi
