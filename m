Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:22541 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbaAFLk6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 06:40:58 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 11/15] brcmfmac: inform cfg80211 when changing the CONNECTED state
Date: Mon, 6 Jan 2014 12:40:46 +0100
Message-ID: <1389008450-28529-12-git-send-email-arend@broadcom.com> (sfid-20140106_124126_851546_7A7BB2BD)
In-Reply-To: <1389008450-28529-1-git-send-email-arend@broadcom.com>
References: <1389008450-28529-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upon unload of the brcmfmac driver it gave a kernel warning because
cfg80211 still believed to be connected to an AP. The brcmfmac had
already transitioned to disconnected state during unload. This patch
adds informing cfg80211 about this transition. This will get rid of
warning from cfg80211 seen upon module unload:

 ------------[ cut here ]------------
 WARNING: CPU: 3 PID: 24303 at net/wireless/core.c:952
	cfg80211_netdev_notifier_call+0x193/0x640 [cfg80211]()
 Modules linked in: brcmfmac(O-) brcmutil(O) cfg80211(O) ... [last unloaded: bcma]
 CPU: 3 PID: 24303 Comm: rmmod Tainted: G        W  O 3.13.0-rc4-wl-testing-x64-00002-gb472b6d-dirty #1
 Hardware name: Dell Inc. Latitude E6410/07XJP9, BIOS A07 02/15/2011
  00000000000003b8 ffff8800b211faf8 ffffffff815a7fcd 0000000000000007
  0000000000000000 ffff8800b211fb38 ffffffff8104819c ffff880000000000
  ffff8800c889d008 ffff8800b2000220 ffff8800c889a000 ffff8800c889d018
 Call Trace:
  [<ffffffff815a7fcd>] dump_stack+0x46/0x58
  [<ffffffff8104819c>] warn_slowpath_common+0x8c/0xc0
  [<ffffffff810481ea>] warn_slowpath_null+0x1a/0x20
  [<ffffffffa173fd83>] cfg80211_netdev_notifier_call+0x193/0x640 [cfg80211]
  [<ffffffff81521ca8>] ? arp_ifdown+0x18/0x20
  [<ffffffff8152d75a>] ? fib_disable_ip+0x3a/0x50
  [<ffffffff815b143d>] notifier_call_chain+0x4d/0x70
  [<ffffffff8106d6e6>] raw_notifier_call_chain+0x16/0x20
  [<ffffffff814b9ae0>] call_netdevice_notifiers_info+0x40/0x70
  [<ffffffff814b9b26>] call_netdevice_notifiers+0x16/0x20
  [<ffffffff814bb59d>] rollback_registered_many+0x17d/0x280
  [<ffffffff814bb74d>] rollback_registered+0x2d/0x40
  [<ffffffff814bb7c8>] unregister_netdevice_queue+0x68/0xd0
  [<ffffffff814bb9c0>] unregister_netdev+0x20/0x30
  [<ffffffffa180069e>] brcmf_del_if+0xce/0x180 [brcmfmac]
  [<ffffffffa1800b3c>] brcmf_detach+0x6c/0xe0 [brcmfmac]

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index a7c1afe..8cc9444 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1095,10 +1095,10 @@ static void brcmf_link_down(struct brcmf_cfg80211_vif *vif)
 					     BRCMF_C_DISASSOC, NULL, 0);
 		if (err) {
 			brcmf_err("WLC_DISASSOC failed (%d)\n", err);
-			cfg80211_disconnected(vif->wdev.netdev, 0,
-					      NULL, 0, GFP_KERNEL);
 		}
 		clear_bit(BRCMF_VIF_STATUS_CONNECTED, &vif->sme_state);
+		cfg80211_disconnected(vif->wdev.netdev, 0, NULL, 0, GFP_KERNEL);
+
 	}
 	clear_bit(BRCMF_VIF_STATUS_CONNECTING, &vif->sme_state);
 	clear_bit(BRCMF_SCAN_STATUS_SUPPRESS, &cfg->scan_status);
@@ -1758,6 +1758,7 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 		return -EIO;
 
 	clear_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state);
+	cfg80211_disconnected(ndev, reason_code, NULL, 0, GFP_KERNEL);
 
 	memcpy(&scbval.ea, &profile->bssid, ETH_ALEN);
 	scbval.val = cpu_to_le32(reason_code);
-- 
1.7.10.4

