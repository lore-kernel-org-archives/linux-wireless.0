Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C21E8C67863
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 21:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C07F220652
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 21:42:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C07F220652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbeJWGCq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 02:02:46 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52598 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728334AbeJWGCq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 02:02:46 -0400
Received: by mail-wm1-f67.google.com with SMTP id 189-v6so11806678wmw.2
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2018 14:42:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J5A1SgarWE2keXTQDCc6y5zmdGpltFFlVNvvNh3IyLk=;
        b=OmSravNgxCJ20gXmopSdUW30axEwojIp78vtgLCmbu2HgA5pUbsUanWguLh3mHaIEf
         9PCA1HCftRx8REcyoOtjHW51SAZxZlb6qKTbuBTjJ/PgtZuOpOKRFyo2OYRpwLrN0tub
         ulWPL+33h/agZq5NO825nKQMCRHcdKhJxuKdtIpNrNL/TnJ0Nw4GDVMi1mK5tNN8ID2e
         UNLzy3WVmY8lmjmx+QjJqnT3oPxixXhTSkqTB4XTb5wHCYlDQrgboSp9CESmLxJHlIqp
         Vyhu3UCrGYFwvscd25W1saAupia+VbiTIl1EEdg5l1Y/XqGZerr0+TCzDUwxxt4ybbe8
         PS+A==
X-Gm-Message-State: ABuFfoi3mCwGXA+S/K5ZpkoUuAh/lPbhXATxyalp848BV7fLCsUKEd0i
        Eqqo2VbYI2X2awUP2PfGvP3aEQ==
X-Google-Smtp-Source: ACcGV62fbO1XdCEw/I61ZidYC/YHQWoJUAfNntEsby07/5jm9Y0VaDnuYggDHilBKkH/2uNqcdH0Ww==
X-Received: by 2002:a1c:a90:: with SMTP id 138-v6mr18109284wmk.49.1540244543590;
        Mon, 22 Oct 2018 14:42:23 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id l125-v6sm21857187wmb.1.2018.10.22.14.42.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Oct 2018 14:42:23 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mt76: move dfs support in mt76x02-lib module
Date:   Mon, 22 Oct 2018 23:42:12 +0200
Message-Id: <f8163cd9867d3f1ca68d14494b4e3fa6ed9dee4b.1540243910.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1540243910.git.lorenzo.bianconi@redhat.com>
References: <cover.1540243910.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x2 DFS support in mt76x02-lib module in order to
be reused by mt76x0 driver and unlock DFS frequencies

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Makefile   |   3 +-
 .../mt76/{mt76x2/pci_dfs.c => mt76x02_dfs.c}  | 135 ++++++++++--------
 .../net/wireless/mediatek/mt76/mt76x02_dfs.h  |   4 +
 .../wireless/mediatek/mt76/mt76x2/Makefile    |   2 +-
 .../net/wireless/mediatek/mt76/mt76x2/dfs.h   |  25 ----
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |   1 -
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  13 +-
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  |   2 +-
 8 files changed, 83 insertions(+), 102 deletions(-)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2/pci_dfs.c => mt76x02_dfs.c} (86%)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/dfs.h

diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index a737a518802f..1a45cb30f39f 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -14,7 +14,8 @@ CFLAGS_mt76x02_trace.o := -I$(src)
 
 mt76x02-lib-y := mt76x02_util.o mt76x02_mac.o mt76x02_mcu.o \
 		 mt76x02_eeprom.o mt76x02_phy.o mt76x02_mmio.o \
-		 mt76x02_txrx.o mt76x02_trace.o mt76x02_debugfs.o
+		 mt76x02_txrx.o mt76x02_trace.o mt76x02_debugfs.o \
+		 mt76x02_dfs.o
 
 mt76x02-usb-y := mt76x02_usb_mcu.o mt76x02_usb_core.o
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
similarity index 86%
rename from drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c
rename to drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
index 8d66952400a8..21e7b8c9f824 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
@@ -14,7 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "mt76x2.h"
+#include "mt76x02.h"
 
 #define RADAR_SPEC(m, len, el, eh, wl, wh,		\
 		   w_tolerance, tl, th, t_tolerance,	\
@@ -151,8 +151,7 @@ static const struct mt76x02_radar_specs jp_w53_radar_specs[] = {
 };
 
 static void
-mt76x2_dfs_set_capture_mode_ctrl(struct mt76x02_dev *dev,
-				 u8 enable)
+mt76x02_dfs_set_capture_mode_ctrl(struct mt76x02_dev *dev, u8 enable)
 {
 	u32 data;
 
@@ -160,8 +159,8 @@ mt76x2_dfs_set_capture_mode_ctrl(struct mt76x02_dev *dev,
 	mt76_wr(dev, MT_BBP(DFS, 36), data);
 }
 
-static void mt76x2_dfs_seq_pool_put(struct mt76x02_dev *dev,
-				    struct mt76x02_dfs_sequence *seq)
+static void mt76x02_dfs_seq_pool_put(struct mt76x02_dev *dev,
+				     struct mt76x02_dfs_sequence *seq)
 {
 	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 
@@ -172,7 +171,7 @@ static void mt76x2_dfs_seq_pool_put(struct mt76x02_dev *dev,
 }
 
 static struct mt76x02_dfs_sequence *
-mt76x2_dfs_seq_pool_get(struct mt76x02_dev *dev)
+mt76x02_dfs_seq_pool_get(struct mt76x02_dev *dev)
 {
 	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 	struct mt76x02_dfs_sequence *seq;
@@ -192,7 +191,7 @@ mt76x2_dfs_seq_pool_get(struct mt76x02_dev *dev)
 	return seq;
 }
 
-static int mt76x2_dfs_get_multiple(int val, int frac, int margin)
+static int mt76x02_dfs_get_multiple(int val, int frac, int margin)
 {
 	int remainder, factor;
 
@@ -214,7 +213,7 @@ static int mt76x2_dfs_get_multiple(int val, int frac, int margin)
 	return factor;
 }
 
-static void mt76x2_dfs_detector_reset(struct mt76x02_dev *dev)
+static void mt76x02_dfs_detector_reset(struct mt76x02_dev *dev)
 {
 	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 	struct mt76x02_dfs_sequence *seq, *tmp_seq;
@@ -231,11 +230,11 @@ static void mt76x2_dfs_detector_reset(struct mt76x02_dev *dev)
 
 	list_for_each_entry_safe(seq, tmp_seq, &dfs_pd->sequences, head) {
 		list_del_init(&seq->head);
-		mt76x2_dfs_seq_pool_put(dev, seq);
+		mt76x02_dfs_seq_pool_put(dev, seq);
 	}
 }
 
-static bool mt76x2_dfs_check_chirp(struct mt76x02_dev *dev)
+static bool mt76x02_dfs_check_chirp(struct mt76x02_dev *dev)
 {
 	bool ret = false;
 	u32 current_ts, delta_ts;
@@ -256,8 +255,8 @@ static bool mt76x2_dfs_check_chirp(struct mt76x02_dev *dev)
 	return ret;
 }
 
-static void mt76x2_dfs_get_hw_pulse(struct mt76x02_dev *dev,
-				    struct mt76x02_dfs_hw_pulse *pulse)
+static void mt76x02_dfs_get_hw_pulse(struct mt76x02_dev *dev,
+				     struct mt76x02_dfs_hw_pulse *pulse)
 {
 	u32 data;
 
@@ -276,8 +275,8 @@ static void mt76x2_dfs_get_hw_pulse(struct mt76x02_dev *dev,
 	pulse->burst = mt76_rr(dev, MT_BBP(DFS, 22));
 }
 
-static bool mt76x2_dfs_check_hw_pulse(struct mt76x02_dev *dev,
-				      struct mt76x02_dfs_hw_pulse *pulse)
+static bool mt76x02_dfs_check_hw_pulse(struct mt76x02_dev *dev,
+				       struct mt76x02_dfs_hw_pulse *pulse)
 {
 	bool ret = false;
 
@@ -290,7 +289,7 @@ static bool mt76x2_dfs_check_hw_pulse(struct mt76x02_dev *dev,
 			break;
 
 		if (pulse->engine == 3) {
-			ret = mt76x2_dfs_check_chirp(dev);
+			ret = mt76x02_dfs_check_chirp(dev);
 			break;
 		}
 
@@ -334,7 +333,7 @@ static bool mt76x2_dfs_check_hw_pulse(struct mt76x02_dev *dev,
 			break;
 
 		if (pulse->engine == 3) {
-			ret = mt76x2_dfs_check_chirp(dev);
+			ret = mt76x02_dfs_check_chirp(dev);
 			break;
 		}
 
@@ -371,8 +370,8 @@ static bool mt76x2_dfs_check_hw_pulse(struct mt76x02_dev *dev,
 	return ret;
 }
 
-static bool mt76x2_dfs_fetch_event(struct mt76x02_dev *dev,
-				   struct mt76x02_dfs_event *event)
+static bool mt76x02_dfs_fetch_event(struct mt76x02_dev *dev,
+				    struct mt76x02_dfs_event *event)
 {
 	u32 data;
 
@@ -398,8 +397,8 @@ static bool mt76x2_dfs_fetch_event(struct mt76x02_dev *dev,
 	return true;
 }
 
-static bool mt76x2_dfs_check_event(struct mt76x02_dev *dev,
-				   struct mt76x02_dfs_event *event)
+static bool mt76x02_dfs_check_event(struct mt76x02_dev *dev,
+				    struct mt76x02_dfs_event *event)
 {
 	if (event->engine == 2) {
 		struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
@@ -417,8 +416,8 @@ static bool mt76x2_dfs_check_event(struct mt76x02_dev *dev,
 	return true;
 }
 
-static void mt76x2_dfs_queue_event(struct mt76x02_dev *dev,
-				   struct mt76x02_dfs_event *event)
+static void mt76x02_dfs_queue_event(struct mt76x02_dev *dev,
+				    struct mt76x02_dfs_event *event)
 {
 	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 	struct mt76x02_dfs_event_rb *event_buff;
@@ -435,9 +434,9 @@ static void mt76x2_dfs_queue_event(struct mt76x02_dev *dev,
 					     MT_DFS_EVENT_BUFLEN);
 }
 
-static int mt76x2_dfs_create_sequence(struct mt76x02_dev *dev,
-				      struct mt76x02_dfs_event *event,
-				      u16 cur_len)
+static int mt76x02_dfs_create_sequence(struct mt76x02_dev *dev,
+				       struct mt76x02_dfs_event *event,
+				       u16 cur_len)
 {
 	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 	struct mt76x02_dfs_sw_detector_params *sw_params;
@@ -497,7 +496,7 @@ static int mt76x2_dfs_create_sequence(struct mt76x02_dev *dev,
 		while (j != end) {
 			cur_event = &event_rb->data[j];
 			cur_pri = event->ts - cur_event->ts;
-			factor = mt76x2_dfs_get_multiple(cur_pri, seq.pri,
+			factor = mt76x02_dfs_get_multiple(cur_pri, seq.pri,
 						sw_params->pri_margin);
 			if (factor > 0) {
 				seq.first_ts = cur_event->ts;
@@ -509,7 +508,7 @@ static int mt76x2_dfs_create_sequence(struct mt76x02_dev *dev,
 		if (seq.count <= cur_len)
 			goto next;
 
-		seq_p = mt76x2_dfs_seq_pool_get(dev);
+		seq_p = mt76x02_dfs_seq_pool_get(dev);
 		if (!seq_p)
 			return -ENOMEM;
 
@@ -522,8 +521,8 @@ static int mt76x2_dfs_create_sequence(struct mt76x02_dev *dev,
 	return 0;
 }
 
-static u16 mt76x2_dfs_add_event_to_sequence(struct mt76x02_dev *dev,
-					    struct mt76x02_dfs_event *event)
+static u16 mt76x02_dfs_add_event_to_sequence(struct mt76x02_dev *dev,
+					     struct mt76x02_dfs_event *event)
 {
 	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 	struct mt76x02_dfs_sw_detector_params *sw_params;
@@ -535,7 +534,7 @@ static u16 mt76x2_dfs_add_event_to_sequence(struct mt76x02_dev *dev,
 	list_for_each_entry_safe(seq, tmp_seq, &dfs_pd->sequences, head) {
 		if (event->ts > seq->first_ts + MT_DFS_SEQUENCE_WINDOW) {
 			list_del_init(&seq->head);
-			mt76x2_dfs_seq_pool_put(dev, seq);
+			mt76x02_dfs_seq_pool_put(dev, seq);
 			continue;
 		}
 
@@ -543,8 +542,8 @@ static u16 mt76x2_dfs_add_event_to_sequence(struct mt76x02_dev *dev,
 			continue;
 
 		pri = event->ts - seq->last_ts;
-		factor = mt76x2_dfs_get_multiple(pri, seq->pri,
-						 sw_params->pri_margin);
+		factor = mt76x02_dfs_get_multiple(pri, seq->pri,
+						  sw_params->pri_margin);
 		if (factor > 0) {
 			seq->last_ts = event->ts;
 			seq->count++;
@@ -554,7 +553,7 @@ static u16 mt76x2_dfs_add_event_to_sequence(struct mt76x02_dev *dev,
 	return max_seq_len;
 }
 
-static bool mt76x2_dfs_check_detection(struct mt76x02_dev *dev)
+static bool mt76x02_dfs_check_detection(struct mt76x02_dev *dev)
 {
 	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 	struct mt76x02_dfs_sequence *seq;
@@ -571,34 +570,34 @@ static bool mt76x2_dfs_check_detection(struct mt76x02_dev *dev)
 	return false;
 }
 
-static void mt76x2_dfs_add_events(struct mt76x02_dev *dev)
+static void mt76x02_dfs_add_events(struct mt76x02_dev *dev)
 {
 	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 	struct mt76x02_dfs_event event;
 	int i, seq_len;
 
 	/* disable debug mode */
-	mt76x2_dfs_set_capture_mode_ctrl(dev, false);
+	mt76x02_dfs_set_capture_mode_ctrl(dev, false);
 	for (i = 0; i < MT_DFS_EVENT_LOOP; i++) {
-		if (!mt76x2_dfs_fetch_event(dev, &event))
+		if (!mt76x02_dfs_fetch_event(dev, &event))
 			break;
 
 		if (dfs_pd->last_event_ts > event.ts)
-			mt76x2_dfs_detector_reset(dev);
+			mt76x02_dfs_detector_reset(dev);
 		dfs_pd->last_event_ts = event.ts;
 
-		if (!mt76x2_dfs_check_event(dev, &event))
+		if (!mt76x02_dfs_check_event(dev, &event))
 			continue;
 
-		seq_len = mt76x2_dfs_add_event_to_sequence(dev, &event);
-		mt76x2_dfs_create_sequence(dev, &event, seq_len);
+		seq_len = mt76x02_dfs_add_event_to_sequence(dev, &event);
+		mt76x02_dfs_create_sequence(dev, &event, seq_len);
 
-		mt76x2_dfs_queue_event(dev, &event);
+		mt76x02_dfs_queue_event(dev, &event);
 	}
-	mt76x2_dfs_set_capture_mode_ctrl(dev, true);
+	mt76x02_dfs_set_capture_mode_ctrl(dev, true);
 }
 
-static void mt76x2_dfs_check_event_window(struct mt76x02_dev *dev)
+static void mt76x02_dfs_check_event_window(struct mt76x02_dev *dev)
 {
 	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 	struct mt76x02_dfs_event_rb *event_buff;
@@ -621,7 +620,7 @@ static void mt76x2_dfs_check_event_window(struct mt76x02_dev *dev)
 	}
 }
 
-static void mt76x2_dfs_tasklet(unsigned long arg)
+static void mt76x02_dfs_tasklet(unsigned long arg)
 {
 	struct mt76x02_dev *dev = (struct mt76x02_dev *)arg;
 	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
@@ -637,16 +636,16 @@ static void mt76x2_dfs_tasklet(unsigned long arg)
 
 		dfs_pd->last_sw_check = jiffies;
 
-		mt76x2_dfs_add_events(dev);
-		radar_detected = mt76x2_dfs_check_detection(dev);
+		mt76x02_dfs_add_events(dev);
+		radar_detected = mt76x02_dfs_check_detection(dev);
 		if (radar_detected) {
 			/* sw detector rx radar pattern */
 			ieee80211_radar_detected(dev->mt76.hw);
-			mt76x2_dfs_detector_reset(dev);
+			mt76x02_dfs_detector_reset(dev);
 
 			return;
 		}
-		mt76x2_dfs_check_event_window(dev);
+		mt76x02_dfs_check_event_window(dev);
 	}
 
 	engine_mask = mt76_rr(dev, MT_BBP(DFS, 1));
@@ -660,9 +659,9 @@ static void mt76x2_dfs_tasklet(unsigned long arg)
 			continue;
 
 		pulse.engine = i;
-		mt76x2_dfs_get_hw_pulse(dev, &pulse);
+		mt76x02_dfs_get_hw_pulse(dev, &pulse);
 
-		if (!mt76x2_dfs_check_hw_pulse(dev, &pulse)) {
+		if (!mt76x02_dfs_check_hw_pulse(dev, &pulse)) {
 			dfs_pd->stats[i].hw_pulse_discarded++;
 			continue;
 		}
@@ -670,7 +669,7 @@ static void mt76x2_dfs_tasklet(unsigned long arg)
 		/* hw detector rx radar pattern */
 		dfs_pd->stats[i].hw_pattern++;
 		ieee80211_radar_detected(dev->mt76.hw);
-		mt76x2_dfs_detector_reset(dev);
+		mt76x02_dfs_detector_reset(dev);
 
 		return;
 	}
@@ -682,7 +681,7 @@ static void mt76x2_dfs_tasklet(unsigned long arg)
 	mt76x02_irq_enable(dev, MT_INT_GPTIMER);
 }
 
-static void mt76x2_dfs_init_sw_detector(struct mt76x02_dev *dev)
+static void mt76x02_dfs_init_sw_detector(struct mt76x02_dev *dev)
 {
 	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 
@@ -708,7 +707,7 @@ static void mt76x2_dfs_init_sw_detector(struct mt76x02_dev *dev)
 	}
 }
 
-static void mt76x2_dfs_set_bbp_params(struct mt76x02_dev *dev)
+static void mt76x02_dfs_set_bbp_params(struct mt76x02_dev *dev)
 {
 	const struct mt76x02_radar_specs *radar_specs;
 	u8 i, shift;
@@ -803,16 +802,16 @@ static void mt76x2_dfs_set_bbp_params(struct mt76x02_dev *dev)
 	mt76_wr(dev, 0x212c, 0x0c350001);
 }
 
-void mt76x2_dfs_init_params(struct mt76x02_dev *dev)
+void mt76x02_dfs_init_params(struct mt76x02_dev *dev)
 {
 	struct cfg80211_chan_def *chandef = &dev->mt76.chandef;
 
 	if ((chandef->chan->flags & IEEE80211_CHAN_RADAR) &&
 	    dev->dfs_pd.region != NL80211_DFS_UNSET) {
-		mt76x2_dfs_init_sw_detector(dev);
-		mt76x2_dfs_set_bbp_params(dev);
+		mt76x02_dfs_init_sw_detector(dev);
+		mt76x02_dfs_set_bbp_params(dev);
 		/* enable debug mode */
-		mt76x2_dfs_set_capture_mode_ctrl(dev, true);
+		mt76x02_dfs_set_capture_mode_ctrl(dev, true);
 
 		mt76x02_irq_enable(dev, MT_INT_GPTIMER);
 		mt76_rmw_field(dev, MT_INT_TIMER_EN,
@@ -829,8 +828,9 @@ void mt76x2_dfs_init_params(struct mt76x02_dev *dev)
 			       MT_INT_TIMER_EN_GP_TIMER_EN, 0);
 	}
 }
+EXPORT_SYMBOL_GPL(mt76x02_dfs_init_params);
 
-void mt76x2_dfs_init_detector(struct mt76x02_dev *dev)
+void mt76x02_dfs_init_detector(struct mt76x02_dev *dev)
 {
 	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 
@@ -838,20 +838,31 @@ void mt76x2_dfs_init_detector(struct mt76x02_dev *dev)
 	INIT_LIST_HEAD(&dfs_pd->seq_pool);
 	dfs_pd->region = NL80211_DFS_UNSET;
 	dfs_pd->last_sw_check = jiffies;
-	tasklet_init(&dfs_pd->dfs_tasklet, mt76x2_dfs_tasklet,
+	tasklet_init(&dfs_pd->dfs_tasklet, mt76x02_dfs_tasklet,
 		     (unsigned long)dev);
 }
+EXPORT_SYMBOL_GPL(mt76x02_dfs_init_detector);
 
-void mt76x2_dfs_set_domain(struct mt76x02_dev *dev,
-			   enum nl80211_dfs_regions region)
+static void
+mt76x02_dfs_set_domain(struct mt76x02_dev *dev,
+		       enum nl80211_dfs_regions region)
 {
 	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 
 	if (dfs_pd->region != region) {
 		tasklet_disable(&dfs_pd->dfs_tasklet);
 		dfs_pd->region = region;
-		mt76x2_dfs_init_params(dev);
+		mt76x02_dfs_init_params(dev);
 		tasklet_enable(&dfs_pd->dfs_tasklet);
 	}
 }
 
+void mt76x02_regd_notifier(struct wiphy *wiphy,
+			   struct regulatory_request *request)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct mt76x02_dev *dev = hw->priv;
+
+	mt76x02_dfs_set_domain(dev, request->dfs_region);
+}
+EXPORT_SYMBOL_GPL(mt76x02_regd_notifier);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.h b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.h
index 7e177c934592..59e1524ff98b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.h
@@ -137,4 +137,8 @@ struct mt76x02_dfs_pattern_detector {
 	struct tasklet_struct dfs_tasklet;
 };
 
+void mt76x02_dfs_init_params(struct mt76x02_dev *dev);
+void mt76x02_dfs_init_detector(struct mt76x02_dev *dev);
+void mt76x02_regd_notifier(struct wiphy *wiphy,
+			   struct regulatory_request *request);
 #endif /* __MT76x02_DFS_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
index eec18e293407..9297b850bbba 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
@@ -7,7 +7,7 @@ mt76x2-common-y := \
 
 mt76x2e-y := \
 	pci.o pci_main.o pci_init.o pci_mcu.o \
-	pci_phy.o pci_dfs.o
+	pci_phy.o
 
 mt76x2u-y := \
 	usb.o usb_init.o usb_main.o usb_mac.o usb_mcu.o \
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/dfs.h b/drivers/net/wireless/mediatek/mt76/mt76x2/dfs.h
deleted file mode 100644
index a11babbf292d..000000000000
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/dfs.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- * Copyright (C) 2016 Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#ifndef __DFS_H
-#define __DFS_H
-
-void mt76x2_dfs_init_params(struct mt76x02_dev *dev);
-void mt76x2_dfs_init_detector(struct mt76x02_dev *dev);
-void mt76x2_dfs_set_domain(struct mt76x02_dev *dev,
-			   enum nl80211_dfs_regions region);
-
-#endif /* __DFS_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index 4dfd49190735..e5846a85d6ab 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -33,7 +33,6 @@
 
 #include "../mt76x02.h"
 #include "mac.h"
-#include "dfs.h"
 
 static inline bool is_mt7612(struct mt76x02_dev *dev)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 41c0cb62a919..b6144e03047f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -338,15 +338,6 @@ struct mt76x02_dev *mt76x2_alloc_device(struct device *pdev)
 	return dev;
 }
 
-static void mt76x2_regd_notifier(struct wiphy *wiphy,
-				 struct regulatory_request *request)
-{
-	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
-	struct mt76x02_dev *dev = hw->priv;
-
-	mt76x2_dfs_set_domain(dev, request->dfs_region);
-}
-
 static void mt76x2_led_set_config(struct mt76_dev *mt76, u8 delay_on,
 				  u8 delay_off)
 {
@@ -423,11 +414,11 @@ int mt76x2_register_device(struct mt76x02_dev *dev)
 	wiphy->addresses = dev->macaddr_list;
 	wiphy->n_addresses = ARRAY_SIZE(dev->macaddr_list);
 
-	wiphy->reg_notifier = mt76x2_regd_notifier;
+	wiphy->reg_notifier = mt76x02_regd_notifier;
 
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
 
-	mt76x2_dfs_init_detector(dev);
+	mt76x02_dfs_init_detector(dev);
 
 	/* init led callbacks */
 	dev->mt76.led_cdev.brightness_set = mt76x2_led_set_brightness;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index ec585b92d6c0..3d73926837bf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -74,7 +74,7 @@ mt76x2_set_channel(struct mt76x02_dev *dev, struct cfg80211_chan_def *chandef)
 	mt76_rr(dev, MT_CH_IDLE);
 	mt76_rr(dev, MT_CH_BUSY);
 
-	mt76x2_dfs_init_params(dev);
+	mt76x02_dfs_init_params(dev);
 
 	mt76x2_mac_resume(dev);
 	tasklet_enable(&dev->dfs_pd.dfs_tasklet);
-- 
2.19.1

