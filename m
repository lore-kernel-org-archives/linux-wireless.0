Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45274 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab2L1GQW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2012 01:16:22 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr12so4677268wgb.35
        for <linux-wireless@vger.kernel.org>; Thu, 27 Dec 2012 22:16:21 -0800 (PST)
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 27 Dec 2012 22:07:57 -0800
Message-ID: <CA+55aFwpdyrtvE=86e1aHE9L5TR+_xP7e4PBBKtdcey3=f+Suw@mail.gmail.com> (sfid-20121228_071629_669558_1B7E47D4)
Subject: WARNING: at drivers/net/wireless/brcm80211/brcmsmac/main.c:7539
To: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, maybe somebody is interested in this.. I don't know what triggered
it, but maybe the few lines around it give some clue.

I think it's new to 3.8-rc1, because I haven't seen it before (well,
I'm running current -git - v3.8.0-rc1-00035-g101e5c7470eb to be exact
- but the networking changes since -rc1 are small and seem unrelated).
But maybe it just happens under certain circumstances.

                    Linus

---
[  573.596631] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp
filtering: enabled true, count 1 (implement)
[  584.154535] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete:
Pkt tx suppressed, illegal channel possibly 1
[  584.154628] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete:
Pkt tx suppressed, illegal channel possibly 1
[  584.925487] ------------[ cut here ]------------
[  584.925521] WARNING: at
drivers/net/wireless/brcm80211/brcmsmac/main.c:7539
brcms_c_wait_for_tx_completion+0xa3/0xc0 [brcmsmac]()
[  584.925525] Hardware name: MacBookAir4,1
[  584.925527] Modules linked in: brcmsmac brcmutil bcma
[  584.925541] Pid: 4312, comm: kworker/u:9 Not tainted
3.8.0-rc1-00035-g101e5c7470eb #4
[  584.925544] Call Trace:
[  584.925558]  [<ffffffff8104308a>] warn_slowpath_common+0x7a/0xb0
[  584.925565]  [<ffffffff810430d5>] warn_slowpath_null+0x15/0x20
[  584.925584]  [<ffffffffa0024b03>]
brcms_c_wait_for_tx_completion+0xa3/0xc0 [brcmsmac]
[  584.925597]  [<ffffffffa00181b6>] brcms_ops_flush+0x36/0x50 [brcmsmac]
[  584.925608]  [<ffffffff81785b3d>] ieee80211_scan_work+0x18d/0x520
[  584.925636]  [<ffffffff8105bc19>] process_one_work+0x129/0x480
[  584.925651]  [<ffffffff8105c345>] worker_thread+0x155/0x3f0
[  584.925674]  [<ffffffff8106097b>] kthread+0xbb/0xc0
[  584.925690]  [<ffffffff817c68ec>] ret_from_fork+0x7c/0xb0
[  584.925698]  [<ffffffff810608c0>] ? kthread_freezable_should_stop+0x60/0x60
[  584.925703] ---[ end trace eeea7613ef80ba9b ]---
[  588.284074] brcmsmac bcma0:0: frameid != txh->TxFrameID
[  588.284098] brcmsmac bcma0:0: MI_TFS: fatal
[  588.284103] brcmsmac bcma0:0: wl0: fatal error, reinitializing
[  588.286208] ieee80211 phy0: Hardware restart was requested
