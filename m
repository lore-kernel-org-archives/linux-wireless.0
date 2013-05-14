Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:37759 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755424Ab3ENBP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 21:15:29 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@laptop.org>, Paul Fox <pgf@laptop.org>,
	Tim Shepard <shep@laptop.org>,
	Jason Abele <jabele@chromium.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 04/17] mwifiex: abort remaining scan commands when association started
Date: Mon, 13 May 2013 18:14:48 -0700
Message-ID: <1368494101-23651-5-git-send-email-bzhao@marvell.com> (sfid-20130514_031531_684123_C8AB5F28)
In-Reply-To: <1368494101-23651-1-git-send-email-bzhao@marvell.com>
References: <1368494101-23651-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A full-channel scan is split to multiple scan commands in driver
before they are sent to firmware. When each scan result is back
the SSID entries are parsed and informed to cfg80211 directly.

It's observed that sometimes userspace may initiate association
as soon as the target AP is found. During the 4-way handshake
firmware may go off-channel to scan the remaining channels.
This causes the 4-way handshake to fail.

Fix it by checking 'scan_block' flag and aborting the remaining
scan in this case. 'scan_block' flag is set after association
and before 4-way handshake. It gets cleared after 4-way handshake
is completed.

Tested-by: Jason Abele <jabele@chromium.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 7b2566b..801b6b7 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1793,7 +1793,8 @@ check_next_scan:
 			dev_dbg(adapter->dev, "info: scan already aborted\n");
 		}
 	} else {
-		if (priv->scan_aborting && !priv->scan_request) {
+		if ((priv->scan_aborting && !priv->scan_request) ||
+		    priv->scan_block) {
 			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 					       flags);
 			adapter->scan_delay_cnt = MWIFIEX_MAX_SCAN_DELAY_CNT;
-- 
1.8.2.3

