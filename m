Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2819 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754927Ab3IYKLU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 06:11:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>, stable@vger.kernel.org,
	"Tod Jackson" <tod.jackson@gmail.com>,
	"Joe Perches" <joe@perches.com>,
	"Rafal Milecki" <zajec5@gmail.com>,
	"Hauke Mehrtens" <hauke@hauke-m.de>
Subject: [PATCH for-3.12 3/3] brcmsmac: call bcma_core_pci_power_save()
 from non-atomic context
Date: Wed, 25 Sep 2013 12:11:03 +0200
Message-ID: <1380103864-10447-4-git-send-email-arend@broadcom.com> (sfid-20130925_121129_952931_F1A091BA)
In-Reply-To: <1380103864-10447-1-git-send-email-arend@broadcom.com>
References: <1380103864-10447-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds explicit call to bcma_core_pci_power_save() from
a non-atomic context resolving 'scheduling while atomic' issue.

[   13.224317] BUG: scheduling while atomic: dhcpcd/1800/0x00000202
[   13.224322] Modules linked in: brcmsmac nouveau coretemp kvm_intel kvm cordic brcmutil bcma dell_wmi atl1c ttm mxm_wmi wmi
[   13.224354] CPU: 0 PID: 1800 Comm: dhcpcd Tainted: G        W    3.11.0-wl #1
[   13.224359] Hardware name: Alienware M11x R2/M11x R2, BIOS A04 11/23/2010
[   13.224363]  ffff880177c12c40 ffff880170fd1968 ffffffff8169af5b 0000000000000007
[   13.224374]  ffff880170fd1ad0 ffff880170fd1978 ffffffff81697ee2 ffff880170fd19f8
[   13.224383]  ffffffff816a19f5 00000000000f4240 000000000000d080 ffff880170fd1fd8
[   13.224391] Call Trace:
[   13.224399]  [<ffffffff8169af5b>] dump_stack+0x4f/0x84
[   13.224403]  [<ffffffff81697ee2>] __schedule_bug+0x43/0x51
[   13.224409]  [<ffffffff816a19f5>] __schedule+0x6e5/0x810
[   13.224412]  [<ffffffff816a1c34>] schedule+0x24/0x70
[   13.224416]  [<ffffffff816a04fc>] schedule_hrtimeout_range_clock+0x10c/0x150
[   13.224420]  [<ffffffff810684e0>] ? update_rmtp+0x60/0x60
[   13.224424]  [<ffffffff8106915f>] ? hrtimer_start_range_ns+0xf/0x20
[   13.224429]  [<ffffffff816a054e>] schedule_hrtimeout_range+0xe/0x10
[   13.224432]  [<ffffffff8104f6fb>] usleep_range+0x3b/0x40
[   13.224437]  [<ffffffffa003733a>] bcma_pcie_mdio_read.isra.5+0x8a/0x100 [bcma]
[   13.224442]  [<ffffffffa00374a5>] bcma_pcie_mdio_writeread.isra.6.constprop.13+0x25/0x30 [bcma]
[   13.224448]  [<ffffffffa00374f9>] bcma_core_pci_power_save+0x49/0x80 [bcma]
[   13.224452]  [<ffffffffa003765d>] bcma_core_pci_up+0x2d/0x60 [bcma]
[   13.224460]  [<ffffffffa03dc17c>] brcms_c_up+0xfc/0x430 [brcmsmac]
[   13.224467]  [<ffffffffa03d1a7d>] brcms_up+0x1d/0x20 [brcmsmac]
[   13.224473]  [<ffffffffa03d2498>] brcms_ops_start+0x298/0x340 [brcmsmac]
[   13.224478]  [<ffffffff81600a12>] ? cfg80211_netdev_notifier_call+0xd2/0x5f0
[   13.224483]  [<ffffffff815fa53d>] ? packet_notifier+0xad/0x1d0
[   13.224487]  [<ffffffff81656e75>] ieee80211_do_open+0x325/0xf80
[   13.224491]  [<ffffffff8106ac09>] ? __raw_notifier_call_chain+0x9/0x10
[   13.224495]  [<ffffffff81657b41>] ieee80211_open+0x71/0x80
[   13.224498]  [<ffffffff81526267>] __dev_open+0x87/0xe0
[   13.224502]  [<ffffffff8152650c>] __dev_change_flags+0x9c/0x180
[   13.224505]  [<ffffffff815266a3>] dev_change_flags+0x23/0x70
[   13.224509]  [<ffffffff8158cd68>] devinet_ioctl+0x5b8/0x6a0
[   13.224512]  [<ffffffff8158d5c5>] inet_ioctl+0x75/0x90
[   13.224516]  [<ffffffff8150b38b>] sock_do_ioctl+0x2b/0x70
[   13.224519]  [<ffffffff8150b681>] sock_ioctl+0x71/0x2a0
[   13.224523]  [<ffffffff8114ed47>] do_vfs_ioctl+0x87/0x520
[   13.224528]  [<ffffffff8113f159>] ? ____fput+0x9/0x10
[   13.224533]  [<ffffffff8106228c>] ? task_work_run+0x9c/0xd0
[   13.224537]  [<ffffffff8114f271>] SyS_ioctl+0x91/0xb0
[   13.224541]  [<ffffffff816aa252>] system_call_fastpath+0x16/0x1b

Cc: <stable@vger.kernel.org> # 3.11.x
Cc: Tod Jackson <tod.jackson@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Rafal Milecki <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 3a65447..edc5d10 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -457,6 +457,8 @@ static int brcms_ops_start(struct ieee80211_hw *hw)
 	if (err != 0)
 		brcms_err(wl->wlc->hw->d11core, "%s: brcms_up() returned %d\n",
 			  __func__, err);
+
+	bcma_core_pci_power_save(wl->wlc->hw->d11core->bus, true);
 	return err;
 }
 
@@ -479,6 +481,8 @@ static void brcms_ops_stop(struct ieee80211_hw *hw)
 		return;
 	}
 
+	bcma_core_pci_power_save(wl->wlc->hw->d11core->bus, false);
+
 	/* put driver in down state */
 	spin_lock_bh(&wl->lock);
 	brcms_down(wl);
-- 
1.7.10.4


