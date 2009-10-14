Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55174 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbZJNAvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 20:51:19 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, ic.felix@gmail.com,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: fix SME warning by removing stale BSS upon assoc failure
Date: Tue, 13 Oct 2009 20:50:42 -0400
Message-Id: <1255481442-27130-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you try to authenticate with an AP we will keep track of the
AP's BSS and expect to eventually either give up on the AP or complete
an association cycle with it. If an AP rejects our association though
mac80211 currently insists on telling cfg80211 a BSS authenticated
correctly, this is wrong as it leaves a bogus BSS lingering around.

When this happens you can get from userspace stale APs as follows:

mcgrof@tesla ~ $ iw dev wlan0 link
Authenticated with <BSS-MAC-address-01> (on wlan0)
Authenticated with <BSS-MAC-address-02> (on wlan0)
Not connected.

We fix this by telling cfg80211 it needs to deauthenticate from the
BSS if an association is rejected by an AP on mac80211.

>From the looks of it this was just a typo.

This fixes the cfg80211 SME warning for me:

http://kerneloops.org/guilty.php?guilty=__cfg80211_disconnected&version=2.6.32-rc&start=2097152&end=2129919&class=warn

wlan0: deauthenticating from <BSS-mac-address-03> by local choice (reason=3)
------------[ cut here ]------------
WARNING: at net/wireless/sme.c:620 __cfg80211_disconnected+0x20c/0x220 [cfg80211]()
Hardware name: 7660A14
deauth failed: -67
Modules linked in: ath5k mac80211 ath cfg80211 <etc>
Pid: 2930, comm: wpa_supplicant Tainted: G        W  2.6.32-rc4-wl #12
Call Trace:
 [<fc0da43c>] ? __cfg80211_disconnected+0x20c/0x220 [cfg80211]
 [<fc0da43c>] ? __cfg80211_disconnected+0x20c/0x220 [cfg80211]
 [<c0142cfc>] warn_slowpath_common+0x6c/0xc0
 [<fc0da43c>] ? __cfg80211_disconnected+0x20c/0x220 [cfg80211]
 [<c0142d96>] warn_slowpath_fmt+0x26/0x30
 [<fc0da43c>] __cfg80211_disconnected+0x20c/0x220 [cfg80211]
 [<fc0d7201>] ? nl80211_send_deauth+0x21/0x30 [cfg80211]
 [<fc0d83c2>] __cfg80211_send_deauth+0x1b2/0x250 [cfg80211]
 [<c0493d2d>] ? __alloc_skb+0x4d/0x130
 [<fc78804a>] ieee80211_send_deauth_disassoc+0x11a/0x170 [mac80211]
 [<fc789587>] ieee80211_mgd_deauth+0xf7/0x110 [mac80211]
 [<fc78f396>] ieee80211_deauth+0x16/0x20 [mac80211]
 [<fc0d7616>] __cfg80211_mlme_deauth+0xd6/0x110 [cfg80211]
 [<fc0daada>] __cfg80211_disconnect+0x15a/0x1b0 [cfg80211]
 [<fc0dd5a5>] cfg80211_wext_siwmlme+0x75/0x80 [cfg80211]
 [<c054ef4c>] ioctl_standard_call+0x16c/0x360
 [<c049dd1d>] ? __dev_get_by_name+0x7d/0xa0
 [<c049dd1d>] ? __dev_get_by_name+0x7d/0xa0
 [<c054ea28>] wext_handle_ioctl+0x188/0x190
 [<fc0dd530>] ? cfg80211_wext_siwmlme+0x0/0x80 [cfg80211]
 [<c049e887>] dev_ioctl+0x467/0x530
 [<c048ca50>] ? sock_ioctl+0x0/0x260
 [<c048cb3d>] sock_ioctl+0xed/0x260
 [<c048ca50>] ? sock_ioctl+0x0/0x260
 [<c01fd1e8>] vfs_ioctl+0x28/0x90
 [<c01fd39a>] do_vfs_ioctl+0x6a/0x5f0
 [<c010a8cc>] ? restore_i387_xstate+0x10c/0x200
 [<c02d715f>] ? security_file_permission+0xf/0x20
 [<c01ef3c4>] ? rw_verify_area+0x54/0xd0
 [<c01efbfd>] ? vfs_read+0x17d/0x190
 [<c0102332>] ? restore_sigcontext+0xc2/0xe0
 [<c01fd983>] sys_ioctl+0x63/0x70
 [<c010301c>] sysenter_do_call+0x12/0x28
---[ end trace e43f356f9c17e54c ]---

Cc: ic.felix@gmail.com
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 33a696f..a884672 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1463,11 +1463,11 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	if (status_code != WLAN_STATUS_SUCCESS) {
 		printk(KERN_DEBUG "%s: AP denied association (code=%d)\n",
 		       sdata->dev->name, status_code);
 		list_del(&wk->list);
 		kfree(wk);
-		return RX_MGMT_CFG80211_ASSOC;
+		return RX_MGMT_CFG80211_DEAUTH;
 	}
 
 	if ((aid & (BIT(15) | BIT(14))) != (BIT(15) | BIT(14)))
 		printk(KERN_DEBUG "%s: invalid aid value %d; bits 15:14 not "
 		       "set\n", sdata->dev->name, aid);
-- 
1.6.0.4

