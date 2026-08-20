Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A173D145B27;
	Thu, 20 Aug 2026 00:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787185969; cv=none; b=N9l7aR7XawkVH7USfg9QphrZl8ck3lCcMERiAXRRuMDSCElnnTtRMebt+Ct7iBWy4NlZh/26TZmuI1/gurNZWmRcz2UWqTvI8BHLxYbtpPm1PeEdHhEfFJBXORuZ/gnit6yHrFQ8DEWGecx4M8ZheIkrLQMfhaK74WIWq3W052A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787185969; c=relaxed/simple;
	bh=bbdZhujjUIckkzXYljJVPdiyqz7YMfqri6fpn1ZB/oY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T1NFLHXf4BzYNj+bPBl4tMCIWnzkuR5UBfrBwsgnMfHsXsLvkZtULoNoarrKcTOWuM9jXva8cRIVqzWZdTlMwLrjUYsB7WUW2k21u8oFlnvCyBXxfDQHQz+5pnA8ZrmNmychY44FBfX0wbiEspw73fTb2euAWc3EwjVCwjFU47c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1wwqi4-000000007Ct-0qED;
	Thu, 20 Aug 2026 00:32:44 +0000
Date: Thu, 20 Aug 2026 01:32:41 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	driver-core@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Hans de Goede <johannes.goede@oss.qualcomm.com>
Subject: [PATCH v2 1/4] driver core: add device_schedule_reprobe()
Message-ID: <08dc37c0d20896f5dc899a53c857935e91c6740f.1787185594.git.daniel@makrotopia.org>
References: <cover.1787185594.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1787185594.git.daniel@makrotopia.org>

Three in-tree drivers schedule a deferred re-probe of their own device
from a work item whose work function lives in module text: iwlwifi
(iwl_trans_schedule_reprobe(), firmware crash recovery when a lighter
restart is not sufficient), hci_h5 (h5_btrtl_resume(), RTL devices
lose their firmware state over suspend) and btintel_pcie (synchronous
device_reprobe() from its own reset work, with a hand-rolled locking
contract spanning several comments).

Two bug classes affect the hand-rolled implementations:

1. The work function ends with put_device(); kfree();
   module_put(THIS_MODULE); in module text. After the atomic decrement
   a concurrent rmmod can free the module text before the function
   epilogue has finished executing. This is exactly the race
   module_put_and_kthread_exit() exists to close for kthreads; there
   is no work-item equivalent.

2. There is no synchronization between the deferred device_reprobe()
   and device_shutdown() or a driver unbind. The drivers do not check
   any bound state before calling device_reprobe(), so a stale
   re-probe can undo an administrative unbind, and the detach half can
   run against a device whose ->shutdown() callback has already run.
   The core already blocks the attach half during shutdown
   (device_shutdown() calls device_block_probing() before any
   callback, and really_probe() honors defer_all_probes), but nothing
   blocks the detach half. For drivers which clear their drvdata in
   ->shutdown() so that a subsequent ->remove() becomes a no-op this
   escalates to use-after-free of driver state which other subsystem
   structures still reference.

Both classes disappear when the driver core owns the deferred work.
Add device_schedule_reprobe(), which schedules a detach and re-probe
of a device after a caller-specified delay:

- The work function is builtin text, so callers do not need to hold a
  module reference. If the driver module is unloaded before the work
  runs, driver_unregister() has already unbound the device, the bound
  driver no longer matches the driver recorded at scheduling time and
  the work does nothing.

- The recorded driver pointer is only ever compared, never
  dereferenced, so it may legitimately point to freed memory.

- The bound-state check and __device_release_driver() run under a
  single __device_driver_lock() hold, the same lock dance
  device_release_driver_internal() uses. This closes the
  check-vs-detach TOCTOU that drivers cannot close themselves,
  because device_reprobe() takes the device lock internally.

- Both @dev and its parent are pinned for the lifetime of the work.
  __device_driver_lock() and the attach half lock the parent, and an
  unregister of @dev drops @dev's reference to the parent, so without
  a reference of our own the parent could be freed before the work
  runs.

- A new shutdown_done flag in struct device_private, set under the
  device lock once device_shutdown() reaches a device, suppresses the
  detach half during shutdown. It occupies a spare bit in an existing
  byte, mirroring how kill_device() sets the dead flag.

- The attach half is plain device_attach(), which already honors both
  the dead flag and defer_all_probes: a re-probe landing during
  system suspend detaches immediately and the probe is deferred until
  device_restore_probing() at resume time. The detach half
  deliberately does not check defer_all_probes so that a re-probe
  scheduled before suspend is not silently dropped. The parent is
  re-locked across device_attach() on buses that set
  need_parent_lock, mirroring bus_rescan_devices_helper().

One pre-existing window remains: __device_release_driver()
transiently drops the locks while consumer device links are busy, so
for devices with busy consumers a ->shutdown() can still interleave
in the middle of the release. That window exists identically for
every unbind path in the kernel, sysfs unbind included, and is not
made worse by this helper.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/base/base.h    |  5 +++
 drivers/base/core.c    |  3 ++
 drivers/base/dd.c      | 99 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h |  2 +
 4 files changed, 109 insertions(+)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index a5b7abc10ff0..6234e37de7e9 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -106,6 +106,10 @@ struct driver_private {
  * @dead: This device is currently either in the process of or has been
  *	  removed from the system. Any asynchronous events scheduled for this
  *	  device should exit without taking any action.
+ * @shutdown_done: Set once device_shutdown() has reached this device, under
+ *	  the device lock, before any shutdown callback runs. Read under the
+ *	  device lock. A deferred re-probe scheduled with
+ *	  device_schedule_reprobe() must not detach the device anymore.
  *
  * Nothing outside of the driver core should ever touch these fields.
  */
@@ -120,6 +124,7 @@ struct device_private {
 	char *deferred_probe_reason;
 	struct device *device;
 	u8 dead:1;
+	u8 shutdown_done:1;
 };
 #define to_device_private_parent(obj)	\
 	container_of(obj, struct device_private, knode_parent)
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 4d026682944f..8a7dbe4e8362 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -4906,6 +4906,9 @@ void device_shutdown(void)
 			device_lock(parent);
 		device_lock(dev);
 
+		if (dev->p)
+			dev->p->shutdown_done = true;
+
 		/* Don't allow any more runtime suspends */
 		pm_runtime_get_noresume(dev);
 		pm_runtime_barrier(dev);
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 60c005223844..3394b1c7ed18 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -1436,3 +1436,102 @@ void driver_detach(const struct device_driver *drv)
 		put_device(dev);
 	}
 }
+
+struct device_reprobe {
+	struct delayed_work work;
+	struct device *dev;
+	struct device *parent;
+	const struct device_driver *drv;
+};
+
+static void device_reprobe_work_fn(struct work_struct *work)
+{
+	struct device_reprobe *rp = container_of(work, struct device_reprobe,
+						 work.work);
+	struct device *dev = rp->dev;
+	struct device *parent = rp->parent;
+	bool detached = false;
+
+	__device_driver_lock(dev, parent);
+	/*
+	 * rp->drv is only ever compared, never dereferenced: the driver it
+	 * points to may have been unregistered and freed by now.
+	 */
+	if (!dev->p->dead && !dev->p->shutdown_done &&
+	    dev->driver && dev->driver == rp->drv) {
+		__device_release_driver(dev, parent);
+		detached = true;
+	}
+	__device_driver_unlock(dev, parent);
+
+	if (detached) {
+		/*
+		 * device_attach() must run with the parent locked on buses
+		 * that require it, mirroring bus_rescan_devices_helper().
+		 */
+		if (parent && dev->bus->need_parent_lock)
+			device_lock(parent);
+		if (device_attach(dev) < 0)
+			dev_err(dev, "re-probe failed, device left unbound\n");
+		if (parent && dev->bus->need_parent_lock)
+			device_unlock(parent);
+	}
+
+	put_device(dev);
+	put_device(parent);
+	kfree(rp);
+}
+
+/**
+ * device_schedule_reprobe - schedule a deferred detach and re-probe
+ * @dev: device to detach and re-probe
+ * @delay_ms: delay in milliseconds before the re-probe runs
+ *
+ * Schedule a detach and re-probe of @dev after @delay_ms milliseconds.
+ * The re-probe is skipped if, by the time the scheduled work runs, the
+ * device has been removed, the system shutdown sequence has reached the
+ * device, or @dev is no longer bound to the driver that was bound at
+ * scheduling time. In particular an administrative unbind is never
+ * undone by a stale re-probe.
+ *
+ * The work function is built-in text, so the bound driver may call this
+ * from its own code without holding a module reference. If the driver
+ * module is unloaded before the work runs, driver unregistration unbinds
+ * @dev first and the scheduled work does nothing.
+ *
+ * Multiple pending re-probes for the same device are individually safe;
+ * a caller that wants at most one pending re-probe must gate scheduling
+ * itself.
+ *
+ * May only be called from process context.
+ *
+ * Returns: 0 on success, -EINVAL if @dev is not a registered device
+ * bound to a driver, -ENOMEM on allocation failure.
+ */
+int device_schedule_reprobe(struct device *dev, unsigned int delay_ms)
+{
+	struct device_reprobe *rp;
+
+	if (!dev->bus || !dev->p || !device_is_registered(dev))
+		return -EINVAL;
+	if (!dev->driver)
+		return -EINVAL;
+
+	rp = kzalloc_obj(*rp);
+	if (!rp)
+		return -ENOMEM;
+
+	rp->dev = get_device(dev);
+	/*
+	 * Pin the parent too: the work locks it, and an unregister of @dev
+	 * would otherwise drop the last reference before the work runs.
+	 */
+	rp->parent = get_device(dev->parent);
+	rp->drv = READ_ONCE(dev->driver);
+	INIT_DELAYED_WORK(&rp->work, device_reprobe_work_fn);
+	queue_delayed_work(system_dfl_wq, &rp->work,
+			   msecs_to_jiffies(delay_ms));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(device_schedule_reprobe);
diff --git a/include/linux/device.h b/include/linux/device.h
index aee79fd6b32b..7a9916950577 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1314,6 +1314,8 @@ int  __must_check device_attach(struct device *dev);
 int __must_check driver_attach(const struct device_driver *drv);
 void device_initial_probe(struct device *dev);
 int __must_check device_reprobe(struct device *dev);
+int __must_check device_schedule_reprobe(struct device *dev,
+					 unsigned int delay_ms);
 
 bool device_is_bound(struct device *dev);
 
-- 
2.55.0
