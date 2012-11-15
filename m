Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58949 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767963Ab2KOOI6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 09:08:58 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Daniel Wagner <wagi@monom.org>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v2 20/22] brcmsmac: Add tracepoint for macintstatus
Date: Thu, 15 Nov 2012 08:08:10 -0600
Message-Id: <1352988492-21340-21-git-send-email-seth.forshee@canonical.com> (sfid-20121115_150913_727497_AB321CD0)
In-Reply-To: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Acked-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 .../brcm80211/brcmsmac/brcms_trace_events.h        |   20 ++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |    8 ++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h b/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h
index 96a962a..2ef7580 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h
@@ -85,6 +85,26 @@ TRACE_EVENT(brcms_dpc,
 	)
 );
 
+TRACE_EVENT(brcms_macintstatus,
+	TP_PROTO(const struct device *dev, int in_isr, u32 macintstatus,
+		 u32 mask),
+	TP_ARGS(dev, in_isr, macintstatus, mask),
+	TP_STRUCT__entry(
+		__string(dev, dev_name(dev))
+		__field(int, in_isr)
+		__field(u32, macintstatus)
+		__field(u32, mask)
+	),
+	TP_fast_assign(
+		__assign_str(dev, dev_name(dev));
+		__entry->in_isr = in_isr;
+		__entry->macintstatus = macintstatus;
+		__entry->mask = mask;
+	),
+	TP_printk("[%s] in_isr=%d macintstatus=%#x mask=%#x", __get_str(dev),
+		  __entry->in_isr, __entry->macintstatus, __entry->mask)
+);
+
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM brcmsmac_tx
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 289f283..f7da9b3 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -2552,13 +2552,13 @@ static inline u32 wlc_intstatus(struct brcms_c_info *wlc, bool in_isr)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
 	struct bcma_device *core = wlc_hw->d11core;
-	u32 macintstatus;
+	u32 macintstatus, mask;
 
 	/* macintstatus includes a DMA interrupt summary bit */
 	macintstatus = bcma_read32(core, D11REGOFFS(macintstatus));
+	mask = in_isr ? wlc->macintmask : wlc->defmacintmask;
 
-	brcms_dbg_int(core, "wl%d: macintstatus: 0x%x\n", wlc_hw->unit,
-		      macintstatus);
+	trace_brcms_macintstatus(&core->dev, in_isr, macintstatus, mask);
 
 	/* detect cardbus removed, in power down(suspend) and in reset */
 	if (brcms_deviceremoved(wlc))
@@ -2571,7 +2571,7 @@ static inline u32 wlc_intstatus(struct brcms_c_info *wlc, bool in_isr)
 		return 0;
 
 	/* defer unsolicited interrupts */
-	macintstatus &= (in_isr ? wlc->macintmask : wlc->defmacintmask);
+	macintstatus &= mask;
 
 	/* if not for us */
 	if (macintstatus == 0)
-- 
1.7.9.5

