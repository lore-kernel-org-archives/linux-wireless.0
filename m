Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:29318 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaKKM67 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 07:58:59 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>,
	<stable@vger.kernel.org>
Subject: [PATCH for-3.18] brcmfmac: fix conversion of channel width 20MHZ_NOHT
Date: Tue, 11 Nov 2014 13:58:44 +0100
Message-ID: <1415710735-7184-1-git-send-email-arend@broadcom.com> (sfid-20141111_135910_289871_261620CF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function chandef_to_chanspec() failed when converting a
chandef with bandwidth set to NL80211_CHAN_WIDTH_20_NOHT. This
was reported by user running the device in AP mode.

------------[ cut here ]------------
WARNING: CPU: 0 PID: 304 at
	drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:381
		chandef_to_chanspec.isra.11+0x158/0x184()

Modules linked in:

CPU: 0 PID: 304 Comm: hostapd Not tainted 3.16.0-rc7-abb+g64aa90f #8

[<c0014bb4>] (unwind_backtrace) from [<c0012314>] (show_stack+0x10/0x14)
[<c0012314>] (show_stack) from [<c001d3f8>] (warn_slowpath_common+0x6c/0x8c)
[<c001d3f8>] (warn_slowpath_common) from [<c001d4b4>] (warn_slowpath_null+0x1c/0x24)
[<c001d4b4>] (warn_slowpath_null) from [<c03449a4>] (chandef_to_chanspec.isra.11+0x158/0x184)
[<c03449a4>] (chandef_to_chanspec.isra.11) from [<c0348e00>] (brcmf_cfg80211_start_ap+0x1e4/0x614)
[<c0348e00>] (brcmf_cfg80211_start_ap) from [<c04d1468>] (nl80211_start_ap+0x288/0x414)
[<c04d1468>] (nl80211_start_ap) from [<c043d144>] (genl_rcv_msg+0x21c/0x38c)
[<c043d144>] (genl_rcv_msg) from [<c043c740>] (netlink_rcv_skb+0xac/0xc0)
[<c043c740>] (netlink_rcv_skb) from [<c043cf14>] (genl_rcv+0x20/0x34)
[<c043cf14>] (genl_rcv) from [<c043c0a0>] (netlink_unicast+0x150/0x20c)
[<c043c0a0>] (netlink_unicast) from [<c043c4b8>] (netlink_sendmsg+0x2b8/0x398)
[<c043c4b8>] (netlink_sendmsg) from [<c04066a4>] (sock_sendmsg+0x84/0xa8)
[<c04066a4>] (sock_sendmsg) from [<c0407c5c>] (___sys_sendmsg.part.29+0x268/0x278)
[<c0407c5c>] (___sys_sendmsg.part.29) from [<c0408bdc>] (__sys_sendmsg+0x4c/0x7c)
[<c0408bdc>] (__sys_sendmsg) from [<c000ec60>] (ret_fast_syscall+0x0/0x44)
---[ end trace 965ee2158c9905a2 ]---

Cc: stable@vger.kernel.org # v3.17
Reported-by: Pontus Fuchs <pontusf@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 28fa25b..39b45c0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -299,6 +299,7 @@ static u16 chandef_to_chanspec(struct brcmu_d11inf *d11inf,
 	primary_offset = ch->center_freq1 - ch->chan->center_freq;
 	switch (ch->width) {
 	case NL80211_CHAN_WIDTH_20:
+	case NL80211_CHAN_WIDTH_20_NOHT:
 		ch_inf.bw = BRCMU_CHAN_BW_20;
 		WARN_ON(primary_offset != 0);
 		break;
@@ -323,6 +324,10 @@ static u16 chandef_to_chanspec(struct brcmu_d11inf *d11inf,
 				ch_inf.sb = BRCMU_CHAN_SB_LU;
 		}
 		break;
+	case NL80211_CHAN_WIDTH_80P80:
+	case NL80211_CHAN_WIDTH_160:
+	case NL80211_CHAN_WIDTH_5:
+	case NL80211_CHAN_WIDTH_10:
 	default:
 		WARN_ON_ONCE(1);
 	}
@@ -333,6 +338,7 @@ static u16 chandef_to_chanspec(struct brcmu_d11inf *d11inf,
 	case IEEE80211_BAND_5GHZ:
 		ch_inf.band = BRCMU_CHAN_BAND_5G;
 		break;
+	case IEEE80211_BAND_60GHZ:
 	default:
 		WARN_ON_ONCE(1);
 	}
-- 
1.9.1

