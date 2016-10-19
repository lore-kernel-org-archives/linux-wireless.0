Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:58533 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943119AbcJSPBK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 11:01:10 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Wim Van Sebroeck <wim@iguana.be>,
        Guenter Roeck <linux@roeck-us.net>
Cc: Alexander Usyskin <alexander.usyskin@intel.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 5/5] mei: bus: remove rx callback context
Date: Wed, 19 Oct 2016 16:33:31 +0300
Message-Id: <1476884011-20645-6-git-send-email-tomas.winkler@intel.com> (sfid-20161019_170339_588591_99C04C93)
In-Reply-To: <1476884011-20645-1-git-send-email-tomas.winkler@intel.com>
References: <1476884011-20645-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The callback context is redunant as all the information can be
retrived from the device struture of its private data.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c     | 6 ++----
 drivers/nfc/mei_phy.c      | 5 ++---
 drivers/watchdog/mei_wdt.c | 6 ++----
 include/linux/mei_cl_bus.h | 6 ++----
 4 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 8cac7ef9ad0d..89a694ca624c 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -228,7 +228,7 @@ static void mei_cl_bus_event_work(struct work_struct *work)
 	bus = cldev->bus;
 
 	if (cldev->event_cb)
-		cldev->event_cb(cldev, cldev->events, cldev->event_context);
+		cldev->event_cb(cldev, cldev->events);
 
 	cldev->events = 0;
 
@@ -301,7 +301,6 @@ bool mei_cl_bus_rx_event(struct mei_cl *cl)
  * @cldev: me client devices
  * @event_cb: callback function
  * @events_mask: requested events bitmask
- * @context: driver context data
  *
  * Return: 0 on success
  *         -EALREADY if an callback is already registered
@@ -309,7 +308,7 @@ bool mei_cl_bus_rx_event(struct mei_cl *cl)
  */
 int mei_cldev_register_event_cb(struct mei_cl_device *cldev,
 				unsigned long events_mask,
-				mei_cldev_event_cb_t event_cb, void *context)
+				mei_cldev_event_cb_t event_cb)
 {
 	struct mei_device *bus = cldev->bus;
 	int ret;
@@ -320,7 +319,6 @@ int mei_cldev_register_event_cb(struct mei_cl_device *cldev,
 	cldev->events = 0;
 	cldev->events_mask = events_mask;
 	cldev->event_cb = event_cb;
-	cldev->event_context = context;
 	INIT_WORK(&cldev->event_work, mei_cl_bus_event_work);
 
 	if (cldev->events_mask & BIT(MEI_CL_EVENT_RX)) {
diff --git a/drivers/nfc/mei_phy.c b/drivers/nfc/mei_phy.c
index 66dfd81ffb18..07b4239585fa 100644
--- a/drivers/nfc/mei_phy.c
+++ b/drivers/nfc/mei_phy.c
@@ -297,8 +297,7 @@ static int mei_nfc_recv(struct nfc_mei_phy *phy, u8 *buf, size_t length)
 }
 
 
-static void nfc_mei_event_cb(struct mei_cl_device *cldev, u32 events,
-			     void *context)
+static void nfc_mei_event_cb(struct mei_cl_device *cldev, u32 events)
 {
 	struct nfc_mei_phy *phy = mei_cldev_get_drvdata(cldev);
 
@@ -360,7 +359,7 @@ static int nfc_mei_phy_enable(void *phy_id)
 	}
 
 	r = mei_cldev_register_event_cb(phy->cldev, BIT(MEI_CL_EVENT_RX),
-				     nfc_mei_event_cb, phy);
+					nfc_mei_event_cb);
 	if (r) {
 		pr_err("Event cb registration failed %d\n", r);
 		goto err;
diff --git a/drivers/watchdog/mei_wdt.c b/drivers/watchdog/mei_wdt.c
index 116be477c8fd..e0af52265511 100644
--- a/drivers/watchdog/mei_wdt.c
+++ b/drivers/watchdog/mei_wdt.c
@@ -501,10 +501,8 @@ static void mei_wdt_notify_event(struct mei_cl_device *cldev)
  *
  * @cldev: bus device
  * @events: event mask
- * @context: callback context
  */
-static void mei_wdt_event(struct mei_cl_device *cldev,
-			  u32 events, void *context)
+static void mei_wdt_event(struct mei_cl_device *cldev, u32 events)
 {
 	if (events & BIT(MEI_CL_EVENT_RX))
 		mei_wdt_event_rx(cldev);
@@ -626,7 +624,7 @@ static int mei_wdt_probe(struct mei_cl_device *cldev,
 	ret = mei_cldev_register_event_cb(wdt->cldev,
 					  BIT(MEI_CL_EVENT_RX) |
 					  BIT(MEI_CL_EVENT_NOTIF),
-					  mei_wdt_event, NULL);
+					  mei_wdt_event);
 
 	/* on legacy devices notification is not supported
 	 * this doesn't fail the registration for RX event
diff --git a/include/linux/mei_cl_bus.h b/include/linux/mei_cl_bus.h
index e6fbd98ea90e..4adb2e7c9f84 100644
--- a/include/linux/mei_cl_bus.h
+++ b/include/linux/mei_cl_bus.h
@@ -9,7 +9,7 @@ struct mei_cl_device;
 struct mei_device;
 
 typedef void (*mei_cldev_event_cb_t)(struct mei_cl_device *cldev,
-				     u32 events, void *context);
+				     u32 events);
 
 /**
  * struct mei_cl_device - MEI device handle
@@ -27,7 +27,6 @@ typedef void (*mei_cldev_event_cb_t)(struct mei_cl_device *cldev,
  * @event_work: async work to execute event callback
  * @event_cb: Drivers register this callback to get asynchronous ME
  *	events (e.g. Rx buffer pending) notifications.
- * @event_context: event callback run context
  * @events_mask: Events bit mask requested by driver.
  * @events: Events bitmask sent to the driver.
  *
@@ -46,7 +45,6 @@ struct mei_cl_device {
 
 	struct work_struct event_work;
 	mei_cldev_event_cb_t event_cb;
-	void *event_context;
 	unsigned long events_mask;
 	unsigned long events;
 
@@ -92,7 +90,7 @@ ssize_t  mei_cldev_recv(struct mei_cl_device *cldev, u8 *buf, size_t length);
 
 int mei_cldev_register_event_cb(struct mei_cl_device *cldev,
 				unsigned long event_mask,
-				mei_cldev_event_cb_t read_cb, void *context);
+				mei_cldev_event_cb_t read_cb);
 
 #define MEI_CL_EVENT_RX 0
 #define MEI_CL_EVENT_TX 1
-- 
2.7.4
