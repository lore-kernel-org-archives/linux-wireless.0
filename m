Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34590 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933332Ab2JZOY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 10:24:29 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 17/18] brcmsmac: Add tracepoint for AMPDU session information
Date: Fri, 26 Oct 2012 09:23:32 -0500
Message-Id: <1351261413-20821-18-git-send-email-seth.forshee@canonical.com> (sfid-20121026_162435_448312_31E8DEDE)
In-Reply-To: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 .../brcm80211/brcmsmac/brcms_trace_events.h        |   28 ++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmsmac/dma.c      |    8 ++++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h b/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h
index 2ef7580..871781e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h
@@ -156,6 +156,34 @@ TRACE_EVENT(brcms_txstatus,
 		  __entry->ackphyrxsh)
 );
 
+TRACE_EVENT(brcms_ampdu_session,
+	TP_PROTO(const struct device *dev, unsigned max_ampdu_len,
+		 u16 max_ampdu_frames, u16 ampdu_len, u16 ampdu_frames,
+		 u16 dma_len),
+	TP_ARGS(dev, max_ampdu_len, max_ampdu_frames, ampdu_len, ampdu_frames,
+		dma_len),
+	TP_STRUCT__entry(
+		__string(dev, dev_name(dev))
+		__field(unsigned, max_ampdu_len)
+		__field(u16, max_ampdu_frames)
+		__field(u16, ampdu_len)
+		__field(u16, ampdu_frames)
+		__field(u16, dma_len)
+	),
+	TP_fast_assign(
+		__assign_str(dev, dev_name(dev));
+		__entry->max_ampdu_len = max_ampdu_len;
+		__entry->max_ampdu_frames = max_ampdu_frames;
+		__entry->ampdu_len = ampdu_len;
+		__entry->ampdu_frames = ampdu_frames;
+		__entry->dma_len = dma_len;
+	),
+	TP_printk("[%s] ampdu session max_len=%u max_frames=%u len=%u frames=%u dma_len=%u",
+		  __get_str(dev), __entry->max_ampdu_len,
+		  __entry->max_ampdu_frames, __entry->ampdu_len,
+		  __entry->ampdu_frames, __entry->dma_len)
+);
+
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM brcmsmac_msg
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index 5b5dd3c..f860324 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -29,6 +29,7 @@
 #include "scb.h"
 #include "ampdu.h"
 #include "brcms_debug.h"
+#include "brcms_trace_events.h"
 
 /*
  * dma register field offset calculation
@@ -1311,6 +1312,13 @@ static void ampdu_finalize(struct dma_info *di)
 	struct brcms_ampdu_session *session = &di->ampdu_session;
 	struct sk_buff *p;
 
+	trace_brcms_ampdu_session(&session->wlc->hw->d11core->dev,
+				  session->max_ampdu_len,
+				  session->max_ampdu_frames,
+				  session->ampdu_len,
+				  skb_queue_len(&session->skb_list),
+				  session->dma_len);
+
 	if (WARN_ON(skb_queue_empty(&session->skb_list)))
 		return;
 
-- 
1.7.9.5

