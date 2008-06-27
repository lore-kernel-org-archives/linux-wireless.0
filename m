Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:9052 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756281AbYF0UUR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 16:20:17 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 5/5] hostap: use radiotap headers by default
To: Jouni Malinen <j@w1.fi>, John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 27 Jun 2008 16:20:16 -0400
Message-ID: <20080627202016.18603.59101.stgit@dv.roinet.com> (sfid-20080627_222024_753980_F4969B57)
In-Reply-To: <20080627201952.18603.98308.stgit@dv.roinet.com>
References: <20080627201952.18603.98308.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/hostap/hostap_hw.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index 936f52e..6c158a5 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -3204,6 +3204,7 @@ prism2_init_local_data(struct prism2_helper_functions *funcs, int card_idx,
 	local->auth_algs = PRISM2_AUTH_OPEN | PRISM2_AUTH_SHARED_KEY;
 	local->sram_type = -1;
 	local->scan_channel_mask = 0xffff;
+	local->monitor_type = PRISM2_MONITOR_RADIOTAP;
 
 	/* Initialize task queue structures */
 	INIT_WORK(&local->reset_queue, handle_reset_queue);
