Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:50593 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751007Ab1BWPYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 10:24:16 -0500
Received: by wyf19 with SMTP id 19so5117240wyf.15
        for <linux-wireless@vger.kernel.org>; Wed, 23 Feb 2011 07:24:00 -0800 (PST)
Subject: pull request: wl12xx 2011-02-23
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 17:23:57 +0200
Message-ID: <1298474637.2104.71.camel@pimenta>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Yet another pull request for 2.6.39.  The most important change is PS
support in AP-mode, by Arik.  The other patches are mainly bugfixes and
small cleanups.

Please pull or let me know if there's any problem.  This tree is based
on wireless-next/master.

Thanks!

The following changes since commit 320d6c1b56de5f461c6062625b9664095f90ee95:

  ath9k_hw: Fix power on reset (2011-02-21 15:40:00 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linville

Arik Nemtsov (9):
      wl12xx: avoid blocking while holding rcu lock on bss info change
      wl12xx: fix potential race condition with TX queue watermark
      wl12xx: AP-mode - fix race condition on sta connection
      wl12xx: AP-mode - TX queue per link in AC
      wl12xx: report invalid TX rate when returning non-TX-ed skbs
      wl12xx: AP-mode - support HW based link PS monitoring
      wl12xx: AP mode - fix bug in cleanup of wl1271_op_sta_add()
      wl12xx: AP-mode - count free FW TX blocks per link
      wl12xx: AP-mode - management of links in PS-mode

Dan Carpenter (1):
      wl12xx: change type from u8 to int

Eliad Peller (4):
      wl12xx: fix identification of beacon packets (debug)
      wl12xx: declare support for IEEE80211_HW_REPORTS_TX_ACK_STATUS
      wl12xx: use standard ALIGN() macro
      wl12xx: always set mac_address when configuring ht caps

Gery Kahn (1):
      wl12xx: update PLT initialization for new firmware

Luciano Coelho (1):
      wl12xx: fix MODULE_AUTHOR email address

 drivers/net/wireless/wl12xx/acx.c    |   28 ++++-
 drivers/net/wireless/wl12xx/acx.h    |    9 ++
 drivers/net/wireless/wl12xx/init.c   |    2 +-
 drivers/net/wireless/wl12xx/main.c   |  147 +++++++++++++++++----
 drivers/net/wireless/wl12xx/ps.c     |   78 +++++++++++
 drivers/net/wireless/wl12xx/ps.h     |    2 +
 drivers/net/wireless/wl12xx/rx.c     |    6 +-
 drivers/net/wireless/wl12xx/rx.h     |    4 -
 drivers/net/wireless/wl12xx/tx.c     |  237 ++++++++++++++++++++++++++++-----
 drivers/net/wireless/wl12xx/tx.h     |    5 +-
 drivers/net/wireless/wl12xx/wl12xx.h |   37 ++++++
 11 files changed, 478 insertions(+), 77 deletions(-)


--
Cheers,
Luca.


