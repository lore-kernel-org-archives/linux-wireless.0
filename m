Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149173546EA;
	Sat, 17 Oct 2026 08:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792227393; cv=none; b=BACxFL0JiqM7EJB1njsgBWSWdi6ktnJehR/rnceY+jykgBsC08DnrEBOnzxI9tvPw9+drwIjvc8VC31vHNZufMluslBVzj83IXNIteqKQLdXg6ITaZ+A492j8ccKGqQwyEqQshVz2SO8RoXmT6ZHFNb0SKVD14Ilr7Q7Ghl41Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792227393; c=relaxed/simple;
	bh=0m2GuvobR0NltRnczQ5NqcSqRIEDMPT1oeazTDuVhOY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oodnl7iOGlLcPr3rAl92qb0T4PpefjVPZrcQSAUg6Efx643r+dwqfuP4B1mxCykF8oekVKlN3he3GUpVHxzFT/aXDy5ua0LZ5nEkfmds/5cac2UjxEQZKr8Wrwvx7sTmjaKvLyOfgqZI2TWiVVO0rb2tqrzDsptLuHimL+biCI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256:X25519MLKEM768)
	 (Exim 4.100.1)
	(envelope-from <daniel@makrotopia.org>)
	id 1xI0DN-000000004GX-3ZWY;
	Sat, 17 Oct 2026 08:56:29 +0000
Date: Sat, 17 Oct 2026 09:56:27 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Hans de Goede <hansg@kernel.org>, driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH v4 1/4] driver core: add device_schedule_reprobe()
Message-ID: <4ffa0608d32b6a68e064b41b17b6d35096b9a7fc.1792203271.git.daniel@makrotopia.org>
References: <cover.1792203271.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1792203271.git.daniel@makrotopia.org>

iwlwifi and hci_h5 re-probe their own device from a work item in module
text that ends with module_put(THIS_MODULE). Once the count drops, a
concurrent rmmod can free the module while the work still runs: the
text of its epilogue and, with lockdep, the work's lock class key. Nor
is the re-probe tied to the binding that scheduled it, which a driver
cannot check from outside device_reprobe().

Add device_schedule_reprobe(), a delayed detach and re-probe run from
built-in work. One request per device is kept in struct device_private
and cancelled by device_unbind_cleanup(), so it ends with the binding
that scheduled it, by an unbind, a removal or a failed probe. The
caller is the bound driver, in a context its ->remove() waits for; no
lock is taken there, so the device lock may be held. Buses that take
the parent lock to bind are refused, as the parent can change before
the work runs.

Assisted-by: LLM
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
v4: reworked as patch 3/6 of the mxl862xx devlink flash series, v13 to
    v19 [1][2], mostly after Sashiko AI review there: one request per
    device, cancelled with the binding, replaces the driver pointer
    check and shutdown_done; parent-lock buses are refused, the parent
    is not pinned; no lock in the caller's context; freezable work; no
    error message of its own; Hans de Goede's tags dropped
    [1] https://lore.kernel.org/all/cover.1788783126.git.daniel@makrotopia.org/
    [2] https://lore.kernel.org/all/cover.1791035885.git.daniel@makrotopia.org/
v3: use dev_err_probe() for the re-probe error path, so a re-probe
    deferred at resume no longer logs a spurious error (Hans de Goede)
v2: pin the parent across the deferred work and re-lock it across
    device_attach() on need_parent_lock buses; schedule on system_dfl_wq
    rather than the deprecated system_unbound_wq (found reviewing the
    mxl862xx v12 posting)
v1: initial RFC

---
 drivers/base/base.h    |   4 +
 drivers/base/dd.c      | 171 +++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h |   2 +
 3 files changed, 177 insertions(+)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index a5b7abc10ff02..3a6883de7cef3 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -106,6 +106,9 @@ struct driver_private {
  * @dead: This device is currently either in the process of or has been
  *	  removed from the system. Any asynchronous events scheduled for this
  *	  device should exit without taking any action.
+ * @reprobe: request scheduled with device_schedule_reprobe(), held until
+ *	     its work has released the driver; cancelled when the binding
+ *	     that scheduled it ends
  *
  * Nothing outside of the driver core should ever touch these fields.
  */
@@ -119,6 +122,7 @@ struct device_private {
 	const struct device_driver *async_driver;
 	char *deferred_probe_reason;
 	struct device *device;
+	struct device_reprobe *reprobe;
 	u8 dead:1;
 };
 #define to_device_private_parent(obj)	\
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index f6525a7ee8c54..1ec740f0e4816 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -590,6 +590,40 @@ static ssize_t state_synced_show(struct device *dev,
 }
 static DEVICE_ATTR_RW(state_synced);
 
+struct device_reprobe {
+	struct delayed_work work;
+	struct device *dev;
+};
+
+/* Ties the slot in struct device_private to the queueing of its work. */
+static DEFINE_SPINLOCK(device_reprobe_lock);
+
+static void device_reprobe_free(struct device_reprobe *rp)
+{
+	put_device(rp->dev);
+	kfree(rp);
+}
+
+/*
+ * The slot holds a request from its scheduling until its work has released
+ * the driver. A pending work is freed here; a running one finds the slot no
+ * longer its own and frees itself.
+ */
+static void device_reprobe_cancel(struct device *dev)
+{
+	struct device_reprobe *rp;
+	bool pending = false;
+
+	spin_lock(&device_reprobe_lock);
+	rp = dev->p->reprobe;
+	WRITE_ONCE(dev->p->reprobe, NULL);
+	if (rp)
+		pending = cancel_delayed_work(&rp->work);
+	spin_unlock(&device_reprobe_lock);
+	if (pending)
+		device_reprobe_free(rp);
+}
+
 static void device_unbind_cleanup(struct device *dev)
 {
 	if (dev->driver->p_cb.post_unbind_rust)
@@ -599,6 +633,7 @@ static void device_unbind_cleanup(struct device *dev)
 	kfree(dev->dma_range_map);
 	dev->dma_range_map = NULL;
 	device_set_driver(dev, NULL);
+	device_reprobe_cancel(dev);
 	dev_set_drvdata(dev, NULL);
 	dev_pm_domain_detach(dev, dev->power.detach_power_off);
 	if (dev->pm_domain && dev->pm_domain->dismiss)
@@ -1436,3 +1471,139 @@ void driver_detach(const struct device_driver *drv)
 		put_device(dev);
 	}
 }
+
+/* Retry interval while probing is blocked; the caller's delay may be 0. */
+#define DEVICE_REPROBE_BLOCKED_RETRY	HZ
+
+static void device_reprobe_work_fn(struct work_struct *work)
+{
+	struct device_reprobe *rp = container_of(work, struct device_reprobe,
+						 work.work);
+	struct device *dev = rp->dev;
+	bool rearm;
+	int ret;
+
+	device_lock(dev);
+	/* The slot still holding rp means the binding that scheduled it does. */
+	if (dev->p->dead || READ_ONCE(dev->p->reprobe) != rp) {
+		device_unlock(dev);
+		goto out;
+	}
+	/* A stale read means one more retry or a probe that defers itself. */
+	if (data_race(defer_all_probes)) {
+		device_unlock(dev);
+		spin_lock(&device_reprobe_lock);
+		rearm = dev->p->reprobe == rp &&
+			(system_state < SYSTEM_HALT ||
+			 system_state == SYSTEM_SUSPEND) &&
+			queue_delayed_work(system_freezable_wq, &rp->work,
+					   DEVICE_REPROBE_BLOCKED_RETRY);
+		spin_unlock(&device_reprobe_lock);
+		if (rearm)
+			return;
+		goto out;
+	}
+	/* Releasing the driver clears the slot, which was this request. */
+	__device_release_driver(dev, NULL);
+	device_unlock(dev);
+
+	/* A failed probe is logged by the probe path, as for a first probe. */
+	ret = device_attach(dev);
+	dev_dbg(dev, "re-probe: device_attach() returned %d\n", ret);
+out:
+	spin_lock(&device_reprobe_lock);
+	if (dev->p->reprobe == rp)
+		WRITE_ONCE(dev->p->reprobe, NULL);
+	spin_unlock(&device_reprobe_lock);
+	device_reprobe_free(rp);
+}
+
+/**
+ * device_schedule_reprobe - schedule a deferred detach and re-probe
+ * @dev: device to detach and re-probe
+ * @delay_ms: delay in milliseconds before the re-probe runs
+ *
+ * Schedule a detach and re-probe of @dev after @delay_ms milliseconds,
+ * from built-in driver-core work rather than a driver-owned work item,
+ * so the bound driver may call it without pinning its own module.
+ *
+ * At most one request exists per device, from its scheduling until its
+ * work has released the driver, and the request identifies the binding
+ * that scheduled it. It is cancelled when that binding ends, whether by
+ * an unbind, by the deletion of @dev or by a failed probe, so neither an
+ * unbind followed by a rebind nor a module reload within the delay gets a
+ * re-probe it did not ask for; its reference on @dev is dropped with it,
+ * or once a work already running has finished. A request that fires
+ * while probing is blocked for a system suspend or a hibernation restore
+ * re-arms itself every second and runs once the system has resumed; one
+ * that fires while probing is blocked for a halt, power-off or restart is
+ * dropped. A failed re-probe leaves @dev unbound, as a failed initial
+ * probe would, and is logged by the probe path like one.
+ *
+ * This is device_reprobe() deferred, and shares its limitations; the
+ * release path of __device_release_driver() is untouched. The detach and
+ * the re-attach are not one locked operation, so an administrative unbind
+ * arriving between them may be undone. If @dev has managed consumers,
+ * detaching it unbinds them as any driver release does, so a re-probe a
+ * concurrent device_shutdown() overtakes may run ->remove() after
+ * ->shutdown(). None of this is specific to this helper.
+ *
+ * Buses that take the parent lock to bind (only usb_bus_type) are refused
+ * with -EINVAL: the parent would have to be recorded before either lock
+ * is held, where device_move() can replace it.
+ *
+ * Context: May sleep (allocates with %GFP_KERNEL). Must be called by the
+ * driver bound to @dev, from a process context its ->remove() waits for,
+ * so that the binding outlives the call; @dev's own device lock may be
+ * held. A request from ->probe() runs once the probe has returned and is
+ * cancelled if the probe fails.
+ *
+ * Returns: 0 on success, -EINVAL if @dev is not a registered device
+ * bound to a driver or sits on a bus which takes the parent lock to
+ * bind, -EBUSY if a re-probe of @dev is pending or has not yet released
+ * the driver, -ENOMEM on allocation failure.
+ */
+int device_schedule_reprobe(struct device *dev, unsigned int delay_ms)
+{
+	const struct device_driver *drv;
+	struct device_reprobe *rp;
+	int ret = 0;
+
+	drv = READ_ONCE(dev->driver);
+	/*
+	 * A bus taking the parent lock would need @dev's parent pinned until
+	 * the work runs, which device_move() can invalidate.
+	 */
+	if (!drv || !dev->bus || dev->bus->need_parent_lock || !dev->p ||
+	    !device_is_registered(dev))
+		return -EINVAL;
+
+	rp = kzalloc_obj(*rp);
+	if (!rp)
+		return -ENOMEM;
+
+	rp->dev = get_device(dev);
+	INIT_DELAYED_WORK(&rp->work, device_reprobe_work_fn);
+
+	/*
+	 * A release that got here first has cleared the driver before
+	 * cancelling, so a request published after its cancel is refused
+	 * here; one published before is cancelled by it.
+	 */
+	spin_lock(&device_reprobe_lock);
+	if (dev->p->reprobe)
+		ret = -EBUSY;
+	else if (READ_ONCE(dev->driver) != drv)
+		ret = -EINVAL;
+	else
+		WRITE_ONCE(dev->p->reprobe, rp);
+	if (!ret)
+		queue_delayed_work(system_freezable_wq, &rp->work,
+				   msecs_to_jiffies(delay_ms));
+	spin_unlock(&device_reprobe_lock);
+	if (ret)
+		device_reprobe_free(rp);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(device_schedule_reprobe);
diff --git a/include/linux/device.h b/include/linux/device.h
index aee79fd6b32b4..7a99169505772 100644
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
2.56.0
