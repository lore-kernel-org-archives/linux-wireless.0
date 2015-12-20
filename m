Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21302 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304AbbLTLwT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2015 06:52:19 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] mac80211: fix PS-Poll handling
Date: Sun, 20 Dec 2015 11:52:14 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E942E91@hasmsx107.ger.corp.intel.com> (sfid-20151220_125221_839272_148BD137)
References: <1450612200-6726-1-git-send-email-emmanuel.grumbach@intel.com>
In-Reply-To: <1450612200-6726-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> My commit below broken PS-Poll handling. In case the driver
> has no frames buffered, driver_release_tids will be 0, but
> calling find_highest_prio_tid() with 0 as a parameter is
> not a good idea:
> fls(0) - 1 = -1.
> This bug caused mac80211 to think that frames were buffered
> in the driver which in turn was confused because mac80211
> was asking to release frames that were not reported to
> exist.
> On iwlwifi, this led to the WARNING below:
> 
> WARNING: CPU: 0 PID: 11230 at
> drivers/net/wireless/intel/iwlwifi/mvm/sta.c:1733
> iwl_mvm_sta_modify_sleep_tx_count+0x2af/0x320 [iwlmvm]()
> ffffffffc0627c60 ffff8800069b7648 ffffffff81888913 0000000000000000
> 0000000000000000 ffff8800069b7688 ffffffff81089d6a ffff8800069b7678
> 0000000000000001 ffff88003b35abf0 ffff88000698b128 ffff8800069b76d4
> Call Trace:
> [<ffffffff81888913>] dump_stack+0x4c/0x65
> [<ffffffff81089d6a>] warn_slowpath_common+0x8a/0xc0
> [<ffffffff81089e5a>] warn_slowpath_null+0x1a/0x20
> [<ffffffffc05f36bf>] iwl_mvm_sta_modify_sleep_tx_count+0x2af/0x320
> [iwlmvm]
> [<ffffffffc05dae41>] iwl_mvm_mac_release_buffered_frames+0x31/0x40
> [iwlmvm]
> [<ffffffffc045d8b6>] ieee80211_sta_ps_deliver_response+0x6e6/0xd80
> [mac80211]
> [<ffffffffc0461296>] ieee80211_sta_ps_deliver_poll_response+0x26/0x30
> [mac80211]
> [<ffffffffc048f743>] ieee80211_rx_handlers+0xa83/0x2900 [mac80211]
> [<ffffffffc04917ad>] ieee80211_prepare_and_rx_handle+0x1ed/0xa70
> [mac80211]
> [<ffffffffc045e3d5>] ? sta_info_get_bss+0x5/0x4a0 [mac80211]
> [<ffffffffc04925b6>] ieee80211_rx_napi+0x586/0xcd0 [mac80211]
> [<ffffffffc05eaa3e>] iwl_mvm_rx_rx_mpdu+0x59e/0xc60 [iwlmvm]
> 
> Fixes: 0ead2510f8ce ("mac80211: allow the driver to send EOSP when
> needed")
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  net/mac80211/sta_info.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index b346544..8ea94d3 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -1563,7 +1563,7 @@ ieee80211_sta_ps_deliver_response(struct
> sta_info *sta,
> 
>  	more_data = ieee80211_sta_ps_more_data(sta, ignored_acs,
> reason, driver_release_tids);
> 
> -	if (reason == IEEE80211_FRAME_RELEASE_PSPOLL)
> +	if (driver_release_tids && reason ==
> IEEE80211_FRAME_RELEASE_PSPOLL)
>  		driver_release_tids =
>  			BIT(find_highest_prio_tid(driver_release_tids));
> 

Maybe it'd be cleaner to move all this into the else branch a bit lower in the code. Don't know. A matter of taste a guess.
