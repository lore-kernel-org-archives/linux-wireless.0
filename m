Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3068 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab2ISUVi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 16:21:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/13] brcmfmac: change struct brcmf_cfg80211_priv
 comments to kernel-doc
Date: Wed, 19 Sep 2012 22:21:17 +0200
Message-ID: <1348086078-19183-13-git-send-email-arend@broadcom.com> (sfid-20120919_222146_466148_5286C722)
In-Reply-To: <1348086078-19183-1-git-send-email-arend@broadcom.com>
References: <1348086078-19183-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Small step to fix structure commenting using kernel-doc syntax.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |  118 +++++++++++++-------
 1 file changed, 77 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index b5c3fd9..a2138c1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -376,51 +376,87 @@ struct brcmf_pno_scanresults_le {
 	__le32 count;
 };
 
-/* dongle private data of cfg80211 interface */
+/**
+ * struct brcmf_cfg80211_priv - dongle private data of cfg80211 interface
+ *
+ * @wdev: representing wl cfg80211 device.
+ * @conf: dongle configuration.
+ * @scan_request: cfg80211 scan request object.
+ * @el: main event loop.
+ * @evt_q_list: used for event queue.
+ * @evt_q_lock: for event queue synchronization.
+ * @usr_sync: mainly for dongle up/down synchronization.
+ * @bss_list: bss_list holding scanned ap information.
+ * @scan_results: results of the last scan.
+ * @scan_req_int: internal scan request object.
+ * @bss_info: bss information for cfg80211 layer.
+ * @ie: information element object for internal purpose.
+ * @profile: holding dongle profile.
+ * @iscan: iscan controller information.
+ * @conn_info: association info.
+ * @pmk_list: wpa2 pmk list.
+ * @event_work: event handler work struct.
+ * @status: current dongle status.
+ * @pub: common driver information.
+ * @channel: current channel.
+ * @iscan_on: iscan on/off switch.
+ * @iscan_kickstart: indicate iscan already started.
+ * @active_scan: current scan mode.
+ * @sched_escan: e-scan for scheduled scan support running.
+ * @ibss_starter: indicates this sta is ibss starter.
+ * @link_up: link/connection up flag.
+ * @pwr_save: indicate whether dongle to support power save mode.
+ * @dongle_up: indicate whether dongle up or not.
+ * @roam_on: on/off switch for dongle self-roaming.
+ * @scan_tried: indicates if first scan attempted.
+ * @dcmd_buf: dcmd buffer.
+ * @extra_buf: mainly to grab assoc information.
+ * @debugfsdir: debugfs folder for this device.
+ * @escan_on: escan on/off switch.
+ * @escan_info: escan information.
+ * @escan_timeout: Timer for catch scan timeout.
+ * @escan_timeout_work: scan timeout worker.
+ * @escan_ioctl_buf: dongle command buffer for escan commands.
+ * @ci: used to link this structure to netdev private data.
+ */
 struct brcmf_cfg80211_priv {
-	struct wireless_dev *wdev;	/* representing wl cfg80211 device */
-	struct brcmf_cfg80211_conf *conf;	/* dongle configuration */
-	struct cfg80211_scan_request *scan_request;	/* scan request
-							 object */
-	struct brcmf_cfg80211_event_loop el;	/* main event loop */
-	struct list_head evt_q_list;	/* used for event queue */
-	spinlock_t	 evt_q_lock;	/* for event queue synchronization */
-	struct mutex usr_sync;	/* maily for dongle up/down synchronization */
-	struct brcmf_scan_results *bss_list;	/* bss_list holding scanned
-						 ap information */
+	struct wireless_dev *wdev;
+	struct brcmf_cfg80211_conf *conf;
+	struct cfg80211_scan_request *scan_request;
+	struct brcmf_cfg80211_event_loop el;
+	struct list_head evt_q_list;
+	spinlock_t	 evt_q_lock;
+	struct mutex usr_sync;
+	struct brcmf_scan_results *bss_list;
 	struct brcmf_scan_results *scan_results;
-	struct brcmf_cfg80211_scan_req *scan_req_int;	/* scan request object
-						 for internal purpose */
-	struct wl_cfg80211_bss_info *bss_info;	/* bss information for
-						 cfg80211 layer */
-	struct brcmf_cfg80211_ie ie;	/* information element object for
-					 internal purpose */
-	struct brcmf_cfg80211_profile *profile;	/* holding dongle profile */
-	struct brcmf_cfg80211_iscan_ctrl *iscan;	/* iscan controller */
-	struct brcmf_cfg80211_connect_info conn_info; /* association info */
-	struct brcmf_cfg80211_pmk_list *pmk_list;	/* wpa2 pmk list */
-	struct work_struct event_work;	/* event handler work struct */
-	unsigned long status;		/* current dongle status */
+	struct brcmf_cfg80211_scan_req *scan_req_int;
+	struct wl_cfg80211_bss_info *bss_info;
+	struct brcmf_cfg80211_ie ie;
+	struct brcmf_cfg80211_profile *profile;
+	struct brcmf_cfg80211_iscan_ctrl *iscan;
+	struct brcmf_cfg80211_connect_info conn_info;
+	struct brcmf_cfg80211_pmk_list *pmk_list;
+	struct work_struct event_work;
+	unsigned long status;
 	void *pub;
-	u32 channel;		/* current channel */
-	bool iscan_on;		/* iscan on/off switch */
-	bool iscan_kickstart;	/* indicate iscan already started */
-	bool active_scan;	/* current scan mode */
-	bool sched_escan;	/* e-scan for scheduled scan support running */
-	bool ibss_starter;	/* indicates this sta is ibss starter */
-	bool link_up;		/* link/connection up flag */
-	bool pwr_save;		/* indicate whether dongle to support
-					 power save mode */
-	bool dongle_up;		/* indicate whether dongle up or not */
-	bool roam_on;		/* on/off switch for dongle self-roaming */
-	bool scan_tried;	/* indicates if first scan attempted */
-	u8 *dcmd_buf;		/* dcmd buffer */
-	u8 *extra_buf;		/* maily to grab assoc information */
+	u32 channel;
+	bool iscan_on;
+	bool iscan_kickstart;
+	bool active_scan;
+	bool sched_escan;
+	bool ibss_starter;
+	bool link_up;
+	bool pwr_save;
+	bool dongle_up;
+	bool roam_on;
+	bool scan_tried;
+	u8 *dcmd_buf;
+	u8 *extra_buf;
 	struct dentry *debugfsdir;
-	bool escan_on;		/* escan on/off switch */
-	struct escan_info escan_info;   /* escan information */
-	struct timer_list escan_timeout;   /* Timer for catch scan timeout */
-	struct work_struct escan_timeout_work;	/* scan timeout worker */
+	bool escan_on;
+	struct escan_info escan_info;
+	struct timer_list escan_timeout;
+	struct work_struct escan_timeout_work;
 	u8 *escan_ioctl_buf;
 	u8 ci[0] __aligned(NETDEV_ALIGN);
 };
-- 
1.7.9.5


