Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:56765 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab2BEOCQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Feb 2012 09:02:16 -0500
Subject: [PATCH] zd1211rw: firmware needs duration_id to be set zero for
 frames other than pspoll
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Tomas.Vanek@fbl.cz, "John W. Linville" <linville@tuxdriver.com>
Date: Sun, 05 Feb 2012 15:51:53 +0200
Message-ID: <20120205135153.4342.81123.stgit@localhost6.localdomain6> (sfid-20120205_150245_029166_DC5F24FC)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Vanek <Tomas.Vanek@fbl.cz>

Some devices (iwl5100) cannot connect to zd1211rw based AP. It appears that
zd1211 firmware messes up duration_id field if it is not set to zero by driver.

Sniffing traffic shows that zd1211 is transmitting frames with duration_id bits
14 and 15 set and other bits appearing random. Setting duration_id at driver to
zero results zd1211 outputting sane duration_id. This means that firmware is
setting correct values itself and expects duration_id to be zero in first
place.

Looking at vendor driver shows that only PSPoll frames have duration_id set by
driver, for other frames duration_id left zero.

Original bug-report and attached patch at:
  http://sourceforge.net/mailarchive/message.php?msg_id=28759111

Reported-by: Tomas Vanek <Tomas.Vanek@fbl.cz>
[modified original patch from bug-report, added check for pspoll frame]
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 0a70149..98a574a 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -866,6 +866,14 @@ static int fill_ctrlset(struct zd_mac *mac,
 
 	ZD_ASSERT(frag_len <= 0xffff);
 
+	/*
+	 * Firmware computes the duration itself (for all frames except PSPoll)
+	 * and needs the field set to 0 at input, otherwise firmware messes up
+	 * duration_id and sets bits 14 and 15 on.
+	 */
+	if (!ieee80211_is_pspoll(hdr->frame_control))
+		hdr->duration_id = 0;
+
 	txrate = ieee80211_get_tx_rate(mac->hw, info);
 
 	cs->modulation = txrate->hw_value;

