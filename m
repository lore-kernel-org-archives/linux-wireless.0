Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61292 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2DVTuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 15:50:44 -0400
Received: by wejx9 with SMTP id x9so7059353wej.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Apr 2012 12:50:43 -0700 (PDT)
From: Zefir Kurtisi <zefir.kurtisi@gmail.com>
To: linville@tuxdriver.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com, achadd@qca.qualcomm.com,
	chunkeey@googlemail.com, Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 0/4] ath9k: integrate DFS detection
Date: Sun, 22 Apr 2012 21:50:19 +0200
Message-Id: <1335124223-15439-1-git-send-email-zefir.kurtisi@gmail.com> (sfid-20120422_215049_230804_155F09FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zefir Kurtisi <zefir.kurtisi@neratec.com>

These are the remaining knobs required to turn to get DFS
detection working in ath9k.

---

Testing mini-HowTo

Building:
On top of the patches, building a DFS capable driver requires
* setting CONFIG_ATH9K_DFS_CERTIFIED=y
* change hw.c:ath9k_hw_dfs_tested() to return true for the
  chip-set you are testing
  (tested so far: AR9280, AR9390 and AR9580)

Setting CONFIG_ATH_DEBUG=y will allow you to log detailed pulse
event information by setting the DFS_DEBUG bit (0x20000) in
ath9k/debug, while radar detection events are logged generally.

Also, set CONFIG_ATH9K_DFS_DEBUGFS=y to enable pulse and
pattern detection statistics along with pool utilization stats
in phyX/ath9k/dfs_stats. Ensure to have recent
'[PATCH] ath9k: extend DFS detector stats in dfs_debugfs'
applied for the full set of DFS statistics.

Testing:
You need wireless tools built with
* crda: add support to send DFS master region
* wireless-regdb: Add master DFS region support
* wireless-regdb: set ETSI as DFS region for EU
(all upstream since 2012-01)

1) setup ath9k monitor
   sudo iw phy phy0 interface add moni0 type monitor
   sudo iw dev moni0 set freq 5500 HT20
   sudo ifconfig moni0 up
2) set ETSI countrycode, e.g.
   sudo iw reg set CH
3) fire some ETSI radars at device and check log and dfs_stats


Note: due to the lack of DFS master support, only monitor mode
      can be tested. Furthermore, at this stage the detector
      supports ETSI defined radar patterns only. With other
      DFS domains you still are able to test pulse detections,
      but any pulse event will be accounted as radar event
      in the stats/logs.

Zefir Kurtisi (4):
  ath9k: set detector DFS domain in reg notifyer
  ath9k: set PHYRADAR in RX filter when on DFS channel
  ath9k: forward pulse events to DFS pulse detector
  ath9k: set radar config if switching to DFS channel

 drivers/net/wireless/ath/ath9k/init.c |    4 ++++
 drivers/net/wireless/ath/ath9k/main.c |   10 ++++++++++
 drivers/net/wireless/ath/ath9k/recv.c |    9 +++++++++
 3 files changed, 23 insertions(+), 0 deletions(-)

-- 
1.7.4.1

