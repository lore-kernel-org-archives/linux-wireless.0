Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout6.freenet.de ([195.4.92.96]:36517 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab2DPXHZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 19:07:25 -0400
Received: from [195.4.92.142] (helo=mjail2.freenet.de)
	by mout6.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1SJuPJ-0000PO-LI
	for linux-wireless@vger.kernel.org; Tue, 17 Apr 2012 00:28:25 +0200
Received: from localhost ([::1]:60855 helo=mjail2.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SJuPJ-0001wH-Ax
	for linux-wireless@vger.kernel.org; Tue, 17 Apr 2012 00:28:25 +0200
Received: from [195.4.92.27] (port=50654 helo=17.mx.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SJuMe-0000Zw-BI
	for linux-wireless@vger.kernel.org; Tue, 17 Apr 2012 00:25:40 +0200
Received: from [2002:4fde:fd:2:5054:ff:feb8:40bd] (port=60367 helo=mail.maya.org)
	by 17.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1SJuMe-00032G-1X
	for linux-wireless@vger.kernel.org; Tue, 17 Apr 2012 00:25:40 +0200
Message-Id: <201204162225.q3GMPTrS006633@mail.maya.org> (sfid-20120417_010729_288371_503D726E)
Date: Tue, 17 Apr 2012 00:25:28 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rt2x00: Don't let mac80211 send a BAR when an AMPDU
 subframe fails
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are connection stalls or very poor throughputs with rt2800
hardware using 802.11n in AP mode since patch "mac80211: retry sending
failed BAR frames later instead of tearing down aggr"[1][2].

Since rt2800 hardware is not able to correctly report the tx status of
BAR frames, this patch removes as workaround the existing error handling
on AP side, which lets mac80211 send a BAR when an AMPDU subframe fails.

As a result, most wifi clients (aside from Intel STAs on Windows)
instead will timeout now the reorder buffer and request the lost frame
again.

The correct solution would be, to tear down BA session on AP side.

This patch was born on the basis of "[RFT] rt2x00: Tear down BA
session on QoS frame failure"[3].

Thanks to Helmut Schaa for his support!

[1] http://thread.gmane.org/gmane.linux.kernel.wireless.general/83297/focus=83304
[2] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=f0425beda4d404a6e751439b562100b902ba9c98
[3] http://thread.gmane.org/gmane.linux.drivers.rt2x00.user/569

Signed-off-by: Andreas Hartmann <andihartmann@01019freenet.de>
---
Index: a/drivers/net/wireless/rt2x00/rt2x00dev.c
===================================================================================
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c	2012-02-02 22:12:56.000000000 +0100
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c	2012-04-16 23:26:46.100458775 +0200
@@ -387,9 +387,10 @@
 		tx_info->flags |= IEEE80211_TX_STAT_AMPDU;
 		tx_info->status.ampdu_len = 1;
 		tx_info->status.ampdu_ack_len = success ? 1 : 0;
-
-		if (!success)
-			tx_info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
+		/*
+		 * TODO: Need to tear down BA session here
+		 * if not successful.
+		 */
 	}
 
 	if (rate_flags & IEEE80211_TX_RC_USE_RTS_CTS) {
