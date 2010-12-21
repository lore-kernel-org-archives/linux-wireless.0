Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:38945 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402Ab0LUPYS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 10:24:18 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.neratec.ch (Postfix) with ESMTP id 4DC5D664001
	for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 16:15:13 +0100 (CET)
Received: from mail.neratec.ch ([127.0.0.1])
	by localhost (mail.neratec.ch [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DSRV2MLxrWJK for <linux-wireless@vger.kernel.org>;
	Tue, 21 Dec 2010 16:15:12 +0100 (CET)
Received: from mail.neratec.ch (mail.neratec.ch [192.168.11.23])
	by mail.neratec.ch (Postfix) with ESMTP id 5F19B860D0
	for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 16:15:12 +0100 (CET)
Date: Tue, 21 Dec 2010 16:15:12 +0100 (CET)
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Message-ID: <1874584253.11108.1292944512342.JavaMail.root@idefix>
In-Reply-To: <2121764975.11097.1292943781910.JavaMail.root@idefix>
Subject: [PATCH 1/4] DFS: interface for common pattern detector
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 include/net/cfg80211.h |   41 +++++++++
 include/net/dfs.h      |  100 +++++++++++++++++++++
 2 files changed, 141 insertions(+), 0 deletions(-)
 create mode 100644 include/net/dfs.h

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 03b3bae..c3ace0e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1820,6 +1820,47 @@ struct ieee80211_rate *
 ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
 			    u32 basic_rates, int bitrate);
 
+
+/**
+ * DFS pattern detector interface
+ */
+
+/**
+ * ieee80211_add_radar_pulse - add a pulse detected by HW to detector
+ *
+ * @freq: channel frequency in [MHz]
+ * @ts: time stamp in [us]
+ * @rssi: rssi value for the deteced pulse
+ * @width: pulse width in [us]
+ *
+ * Each pulse the HW identified as radar is fed into the detector via this
+ * function. The three values for ts, rssi and width are those relevant for
+ * pattern matching, while freq is required to map the pulse to the correct
+ * DFS channel.
+ * No value is returned, assuming the HW does not need to know about the result
+ * of pattern matching. The further processing of matches is done at mac layer.
+ */
+extern void ieee80211_add_radar_pulse(u16 freq, u64 ts, u8 rssi, u8 width);
+
+/**
+ * ieee80211_radar_detected - notify mac that DFS radar was detected
+ *
+ * @freq: channel frequency in [MHz]
+ *
+ * This function is used to inform the mac that a DFS radar was detected on
+ * the given channel frequency. It might be called from the DFS pattern
+ * detector or from device drivers that do DFS detection in HW.
+ *
+ * It is meant to be the central hook that initiates all subsequent actions that
+ * need to be performed after the detection, including
+ *  - put channel to Unavailable list (or adjust channel state periods
+ *    in case channel was already not on Available list)
+ *  - everything else required to select new channel and initiate
+ *    channel switch
+ */
+extern void ieee80211_radar_detected(u16 freq);
+
+
 /*
  * Radiotap parsing functions -- for controlled injection support
  *
diff --git a/include/net/dfs.h b/include/net/dfs.h
new file mode 100644
index 0000000..1dccc10
--- /dev/null
+++ b/include/net/dfs.h
@@ -0,0 +1,100 @@
+#ifndef DFS_H
+#define DFS_H
+/*
+ * Copyright 2010, Neratec Solutions AG, <zefir.kurtisi@neratec.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/**
+ * DOC: Introduction
+ *
+ * DFS radar detector interface
+ *
+ * This is a proposal for a common DFS pattern detector interface.
+ *
+ * It should be used by devices that are able to detect radar pulses and need
+ * pattern matching (as defined by ETSI, FCC, JP regulatories).
+ *
+ * An instance of the proposed DFS handler is supposed to exist during an
+ * endpoint's lifetime within mac80211. WLAN devices should report the radar
+ * pulses they detect during their uptime, the DFS handler aggregates them and
+ * keeps track of channel states (as defined by regulatories).
+ *
+ * On channel state changes it notifies mac80211 to initiate all required
+ * processing.
+ */
+
+
+/* TODO: move those to more common place */
+enum dfs_domain {
+	DFS_INVALID_DOMAIN	= 0,	/* Uninitialized dfs domain */
+	DFS_FCC_DOMAIN		= 1,	/* FCC dfs domain */
+	DFS_ETSI_DOMAIN		= 2,	/* ETSI dfs domain */
+	DFS_JP_DOMAIN		= 3,	/* Japan dfs domain */
+};
+
+/* TODO: move dfs_state to more common place */
+enum channel_dfs_flags {
+	CHANNEL_INVALID		= 0x00,
+	CHANNEL_UNAVAILABLE	= 0x01,
+	CHANNEL_USABLE		= 0x02,
+	CHANNEL_AVAILABLE	= 0x04,
+	CHANNEL_OPERATING	= 0x08,
+};
+
+/**
+ * struct pulse_event - events fed to the dfs handler
+ *
+ * @ts: absolute time stamp for start of pulse in us (e.g. as TSF)
+ * @freq: channel frequency in [MHz]
+ * @rssi: rssi value for the given pulse
+ * @width: pulse width for given pulse in [us]
+ *
+ */
+struct pulse_event {
+	u64 ts;
+	u16 freq;
+	u8  rssi;
+	u8  width;
+};
+
+/**
+ * struct dfs_handler - DFS handler pseudo-OO interface
+ *
+ * @exit: terminate DFS handler and release all resources
+ * @add_pulse: add given pulse event to detector lines
+ *             returns 1 if added event triggered a pattern match
+ * @data: private instance data
+ *
+ * To easily attach pulse detectors implementing different types matching
+ * algorithms, a pseudo-OO design approach was taken with a tiny interface is
+ * chosen.
+ */
+struct dfs_handler {
+	/* VFT */
+	void (*exit)(struct dfs_handler *_this);
+	int (*add_pulse)(struct dfs_handler *_this, struct pulse_event *event);
+
+	/* private data */
+	struct dfs_data *data;
+};
+
+/**
+ * dfs_handler_init - DFS handler constructor
+ *
+ * @dfs_domain: DFS domain to detect radar patterns for
+ *
+ * A DFS handler instance is allocated via this constructor.
+ * On success the pointer to the fully initialized handler is returned that
+ * can be fed with radar pulses during its lifetime. Allocated resources are
+ * released upon calling the destructor.
+ *
+ * On failure NULL is returned.
+ */
+struct dfs_handler *dfs_handler_init(enum dfs_domain dfs_domain);
+
+
+#endif  /* DFS_H */
-- 
1.5.4.3
