Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:4082 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbXJ0LZL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 07:25:11 -0400
Received: by nf-out-0910.google.com with SMTP id g13so973044nfb
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2007 04:25:10 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/21] rt2x00: Disable RX when switching antenna
Date: Sat, 27 Oct 2007 13:39:28 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200710271334.34192.IvDoorn@gmail.com>
In-Reply-To: <200710271334.34192.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710271339.28475.IvDoorn@gmail.com> (sfid-20071027_124131_988293_1800DD62)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Antenna switching will be ignored when RX is enabled
during the switch. Make sure we disable the RX during
the switch and don't forget to reenable it later.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00config.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index b4fad74..9f0733b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -103,6 +103,13 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	libconf.ant.tx = tx;
 
 	/*
+	 * Antenna setup changes require the RX to be disabled,
+	 * else the changes will be ignored by the device.
+	 */
+	if (test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
+		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
+
+	/*
 	 * Write new antenna setup to device and reset the link tuner.
 	 * The latter is required since we need to recalibrate the
 	 * noise-sensitivity ratio for the new setup.
@@ -112,6 +119,9 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00dev->link.ant.active.rx = libconf.ant.rx;
 	rt2x00dev->link.ant.active.tx = libconf.ant.tx;
+
+	if (test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
+		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
 }
 
 void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
-- 
1.5.3.4

