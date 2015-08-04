Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34348 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbbHDXOI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 19:14:08 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: gregkh@linuxfoundation.org, ming.lei@canonical.com
Cc: corbet@lwn.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, dwmw2@infradead.org,
	dhowells@redhat.com, seth.forshee@canonical.com,
	rusty@rustcorp.com.au, mmarek@suse.cz, mjg59@srcf.ucam.org,
	kyle@kernel.org, linux-security-module@vger.kernel.org,
	keyrings@linux-nfs.org, luto@amacapital.net, keescook@chromium.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v1] firmware: add an extensible system data helpers
Date: Tue,  4 Aug 2015 16:13:56 -0700
Message-Id: <1438730036-22913-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20150805_011428_781455_1390EB27)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

The firmware API has evolved over the years slowly, as it
grows we extend it by adding new routines or at times we extend
existing routines with more or less arguments. This doesn't scale
well, when new arguments are added to existing routines it means
we need to traverse the kernel with a slew of collateral
evolutions to adjust old driver users. The firmware API is also
now being used for things outside of the scope of what typically
would be considered "firmware", an example here is the p54 driver
enables users to provide a custom EEPROM through this interface.
Another example is optional CPU microcode updates.

There are other subsystems which would like to make use of the
APIs for similar things but have different requirements and
criteria which they'd like to be met for the requested file.
If different requirements are needed it would again mean adding
more arguments and making a slew of collateral evolutions, or
adding yet-another-new-API-call.

Instead of extending the existing firmware API even more this
provides an new extensible API which can be used to supercede the
old firmware API without causing a series of collateral evolutions
as requirements grow. This leaves the old firmware API as-is,
ignores all consideration for usermode-helpers, labels the new API
to reflect its broad use outside of the scope of firmware: system
data helpers, and builds on top of the original firmware core code.

The new extensible "system data" set of helpers accepts that there
really are only two types of requests for accessing system data:

a) synchronous requests
b) asynchronous requests

Both of these requests may have a different set of requirements
which must be met. These requirements can simply be passed as a
descriptors to each type of request. The descriptor can be extended
over time to support different requirements as the kernel evolves.

Using the new system data helpers is only necessary if you have
requirements outside of what the existing old firmware API accepts.
We encourage developers to leave the old API as-is and extend the
new descriptors and system data code to provide support for new
features.

A few simple features added as part of the new set of system data
request APIs, other than making the new API easily extensible for
the future:

 - By default the kernel will free the system data file for you after
   your callbacks are called, you however are allowed to request to that
   you wish to keep the system data file on the descriptor. This is
   dealt with by requiring a consumer callback for the system data file.
 - Allow both asynchronous and synchronous request to specify that system data
   files are optional. With the old APIs we had added one full API call,
   request_firmware_direct() just for this purpose -- although it should be
   noted another of its goal was to also skip the usermode helper.
   The system data request APIs allow for you to annotate that a system
   data file is optional for both synchronous or asynchronous requests
   through the same two basic set of APIs.
 - Usermode helpers are completely ignored, always
 - The system data request APIs currently match the old synchronous firmware
   API calls to refcounted firmware_class module, but it should be easy
   to add support now to enable also refcounting the caller's module
   should it be be needed. Likewise the system data request APIs match the
   old asynchronous firmware API call and refcounts the caller's module.

In order to try to help phase out user mode helpers this makes no use of
the old user mode helper code *at all*, and if we wish to can easily
phase this code out with time then.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---

Although the design and goals behind firmware signing are still being
discussed, one thing is clear: we need an extensible firmware API. This
patch set then just address the extensibility of the firmware_class and
leave firmware signing to be addressed later.

In my previous firmware signing patch set I had added firmware signing
*first* and later introduced this set of APIs *after* with the idea to
let callers be able to override system defaults and provide custom signature
requirements. For instance I had considered the possibility of having
cfg80211 customize its signing requirements under its own Kconfig option
outside of the scope of firmware signing in order to replace CRDA with
in-kernel functionality. To support this we'd have to enable callers to
customize their firmware signing requirements somehow. Recently its been
discussed that perhaps we may want to let all callers from the start to
provide a specific a sha256sum of a key which we could then use to vet a
signature for. In order to support that we'd need to be able to let callers
specify more arguments into the firmware_class API *prior* to adding
firmware signing code.

Having an extensible firmware API in place first would enable the flexibility
to let us decide what requirements we want to put in place for firmware signing
without concern for making a slew of collateral evolutions. This also gives us
the option, if we want it, to enable firmware signing to be an explicit
driver opt-in feature rather than a huge automatic tree wide effect as with
module signing. It does not have to be this way -- but we'd have this
flexibility with the system data API going in first. For instance, one big
difference here obviously is that these new exports are all EXPORT_SYMBOL_GPL()
therefore proprietary drivers would not technically be able to make use of of
firmware signing if we wanted it that way. I'll note that this was not my
original intention, my first series added firmware signing support behind the
scenes to all firmware_request*() APIs, however, if we want to be able to
customize signing requests from the start, then this could mean making this
a feature only for drivers that wish to opt-in to this new feature set.

As noted, firmware signing design is still being discussed, but as a hint,
the way I'd envision this is that once we decide how keys would be managed and
purposed we'd also enable LSM hooks to review the system data request
descriptor, and these hooks would enable the LSM hooks to tell firmware_class
it can skip over the internal system data signing verification if the LSM hook
can meet the criteria requested in the descriptor.

Lastly, I think its time to phase out the usermode helper, and I think this
would provide an outlet of how to do this.

 Documentation/firmware_class/system_data.txt |  71 +++++++
 drivers/base/firmware_class.c                | 291 +++++++++++++++++++++++++++
 include/linux/sysdata.h                      | 208 +++++++++++++++++++
 3 files changed, 570 insertions(+)
 create mode 100644 Documentation/firmware_class/system_data.txt
 create mode 100644 include/linux/sysdata.h

diff --git a/Documentation/firmware_class/system_data.txt b/Documentation/firmware_class/system_data.txt
new file mode 100644
index 000000000000..1fe0ecd29324
--- /dev/null
+++ b/Documentation/firmware_class/system_data.txt
@@ -0,0 +1,71 @@
+System data requests API
+========================
+
+As the kernel evolves we keep extending the firmware_class set of APIs
+with more or less arguments, this creates a slew of collateral evolutions.
+The set of users of firmware request APIs has also grown now to include
+users which are not looking for "firmware" per se, but instead general
+system data files which for one reason or another has been decided to be
+kept oustide of the kernel, and/or to allow dynamic updates. The system data
+request set of APIs addresses rebranding of firmware as generic system data
+files, and provides a way to enable these APIs to easily be extended without
+much collateral evolutions.
+
+System data modes of operation
+==============================
+
+There are only two types of modes of operation for system data requests:
+
+  * synchronous  - sysdata_file_request()
+  * asynchronous - sysdata_file_request_async()
+
+Synchronous requests expect requests to be done immediately, asynchronous
+requests enable requests to be scheduled for a later time.
+
+System data file descriptor
+===========================
+
+Variations of types of system data requests are specified by a system  data
+request descriptor. The system data request descriptor can grow as with new
+fields as requirements grow. The old firmware API provides two synchronous
+requests: request_firmware() and request_firmware_direct(), the later allowing
+the caller to specify that the "system data file" is optional. The system data
+request API allows a caller to set the optional nature of the system data file
+on the system data file descriptor using the same synchronous API. Since this
+requirement is part of the descriptor it also allows asynchronous requests
+to specify that the system data file is optional.
+
+Reference counting and releasing the system data file
+=====================================================
+
+As with the old firmware API both the device and module are bumped with
+reference counts during the system data requests. This prevents removal
+of the device and module making the system data request call until the
+system data request callbacks have completed, either synchronously or
+asynchronously.
+
+The old firmware APIs refcounted the firmware_class module for synchronous
+requests, meanwhile asynchronous requests refcounted the caller's module.
+The system data request API currently mimic this behaviour, for synchronous
+requests the firmware_class module is refcounted through the use of
+dfl_sync_reqs, although if in the future we may later enable use of
+also refcounting the caller's module as well. Likewise in the future we
+may extend asynchronous calls to refcount the firmware_class module.
+
+Typical use of the old synchronous firmware APIs consist of the caller
+requesting for "system data", consuming it after a request and finally
+freeing it. Typical asynchronous use of the old firmware APIs consist of
+the caller requesting for "system data" and then finally freeing it on
+asynchronous callback.
+
+The system data request API enables callers to provide a callback for both
+synchronous and asynchronous requests and since consumption can be expected
+in these callbacks it frees it for you by default after callback handlers
+are issued. If you wish to keep the system data around after your callbacks
+you must specify this through the system data request descriptor.
+
+User mode helper
+================
+
+The old firmware API provided support for an optional user mode helper. The
+new system data request API abandons all notions of the usermode helper.
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index dcc7036b4ad2..8c7389d9d17d 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -18,6 +18,7 @@
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 #include <linux/highmem.h>
+#include <linux/sysdata.h>
 #include <linux/firmware.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
@@ -38,6 +39,12 @@ MODULE_AUTHOR("Manuel Estrada Sainz");
 MODULE_DESCRIPTION("Multi purpose firmware loading support");
 MODULE_LICENSE("GPL");
 
+static const struct sysdata_file_sync_reqs dfl_sync_reqs = {
+	.mode = SYNCDATA_SYNC,
+	.module = THIS_MODULE,
+	.gfp = GFP_KERNEL,
+};
+
 /* Builtin firmware support */
 
 #ifdef CONFIG_FW_LOADER
@@ -1272,6 +1279,182 @@ void release_firmware(const struct firmware *fw)
 }
 EXPORT_SYMBOL(release_firmware);
 
+static void sysdata_file_update(struct sysdata_file *sysdata)
+{
+	struct firmware *fw;
+	struct firmware_buf *buf;
+
+	if (!sysdata || !sysdata->priv)
+		return;
+
+	fw = sysdata->priv;
+	if (!fw->priv)
+		return;
+
+	buf = fw->priv;
+
+	sysdata->size = buf->size;
+	sysdata->data = buf->data;
+
+	pr_debug("%s: fw-%s buf=%p data=%p size=%u",
+		 __func__, buf->fw_id, buf, buf->data,
+		 (unsigned int)buf->size);
+}
+
+/*
+ * prepare firmware and firmware_buf structs;
+ * return 0 if a firmware is already assigned, 1 if need to load one,
+ * or a negative error code
+ */
+static int
+_request_sysdata_prepare(struct sysdata_file **sysdata_p, const char *name,
+			  struct device *device)
+{
+	struct sysdata_file *sysdata;
+	struct firmware *fw;
+	int ret;
+
+	*sysdata_p = sysdata = kzalloc(sizeof(*sysdata), GFP_KERNEL);
+	if (!sysdata) {
+		dev_err(device, "%s: kmalloc(struct sysdata) failed\n",
+			__func__);
+		return -ENOMEM;
+	}
+
+	ret = _request_firmware_prepare(&fw, name, device);
+	if (ret >= 0)
+		sysdata->priv = fw;
+
+	return ret;
+}
+
+/**
+ * release_sysdata_file: - release the resource associated with the sysdata file
+ * @sysdata_file: sysdata resource to release
+ **/
+void release_sysdata_file(const struct sysdata_file *sysdata)
+{
+	struct firmware *fw;
+
+	if (sysdata) {
+		if (sysdata->priv) {
+			fw = sysdata->priv;
+			release_firmware(fw);
+		}
+	}
+	kfree(sysdata);
+}
+EXPORT_SYMBOL_GPL(release_sysdata_file);
+
+/*
+ * sysdata_p is always set to be NULL unless a proper system
+ * data file was found.
+ */
+static int _sysdata_file_request(const struct sysdata_file **sysdata_p,
+				 const char *name,
+				 const struct sysdata_file_desc *desc,
+				 struct device *device)
+{
+	struct sysdata_file *sysdata = NULL;
+	struct firmware *fw = NULL;
+	int ret = -EINVAL;
+
+	if (!sysdata_p)
+		goto out;
+
+	if (!desc)
+		goto out;
+
+	if (!name || name[0] == '\0')
+		goto out;
+
+	ret = _request_sysdata_prepare(&sysdata, name, device);
+	if (ret <= 0) /* error or already assigned */
+		goto out;
+
+	fw = sysdata->priv;
+
+	ret = fw_get_filesystem_firmware(device, fw->priv);
+	if (ret && !desc->optional)
+		pr_err("Direct system data load for %s failed with error %d\n",
+		       name, ret);
+
+	if (!ret)
+		ret = assign_firmware_buf(fw, device, FW_OPT_UEVENT);
+
+ out:
+	if (ret < 0) {
+		release_sysdata_file(sysdata);
+		sysdata = NULL;
+	}
+
+	sysdata_file_update(sysdata);
+
+	*sysdata_p = sysdata;
+
+	return ret;
+}
+
+/**
+ * sysdata_file_request - synchronous request for a system data file
+ * @name: name of the system data file
+ * @desc: system data file descriptor, it provides all the requirements
+ * 	which must be met for the file being requested.
+ * @device: device for which firmware is being loaded
+ *
+ * This performs a synchronous system data file lookup with the requirements
+ * specified on @desc, if the file was found meeting the criteria requested
+ * 0 is returned. Access to the system data file data can be accessed through
+ * an optional callback set on the @desc. If the system data file is optional
+ * you must specify that on the @desc and if set you may provide an alternative
+ * callback which if set would be run if the system data file was not found.
+ *
+ * The system data file passed to the callbacks will always be NULL unless
+ * the it was found matching all the criteria on @desc. 0 is always returned
+ * if the file was found unless a callback was provided, in which case the
+ * callback's return value will be passed. Unless the desc->keep was set the
+ * kernel will release the system data file for you after your callbacks
+ * were processed.
+ *
+ * Reference counting is used during the duration of this call on both the
+ * device and module that made the request. This prevents any callers from
+ * freeing either the device or module prior to completion of this call.
+ */
+int sysdata_file_request(const char *name,
+			 const struct sysdata_file_desc *desc,
+			 struct device *device)
+{
+	const struct sysdata_file *sysdata;
+	const struct sysdata_file_sync_reqs *sync_reqs;
+	int ret;
+
+	if (!device || !desc || !name)
+		return -EINVAL;
+
+	if (desc->sync_reqs.mode != SYNCDATA_SYNC)
+		return -EINVAL;
+
+	sync_reqs = &dfl_sync_reqs;
+
+	__module_get(sync_reqs->module);
+	get_device(device);
+
+	ret = _sysdata_file_request(&sysdata, name, desc, device);
+	if (ret && desc->optional)
+		ret = desc_sync_opt_call_cb(desc);
+	else
+		ret = desc_sync_found_call_cb(desc, sysdata);
+
+	if (!desc->keep)
+		release_sysdata_file(sysdata);
+
+	put_device(device);
+	module_put(sync_reqs->module);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sysdata_file_request);
+
 /* Async support */
 struct firmware_work {
 	struct work_struct work;
@@ -1360,6 +1543,114 @@ request_firmware_nowait(
 }
 EXPORT_SYMBOL(request_firmware_nowait);
 
+struct sysdata_file_work {
+	struct work_struct work;
+	const char *name;
+	struct sysdata_file_desc desc;
+	struct device *device;
+};
+
+static void request_sysdata_file_work_func(struct work_struct *work)
+{
+	struct sysdata_file_work *sys_work;
+	const struct sysdata_file_desc *desc;
+	const struct sysdata_file_sync_reqs *sync_reqs;
+	const struct sysdata_file *sysdata;
+	int ret;
+
+	sys_work = container_of(work, struct sysdata_file_work, work);
+	desc = &sys_work->desc;
+	sync_reqs = &desc->sync_reqs;
+
+	ret = _sysdata_file_request(&sysdata, sys_work->name,
+				    desc, sys_work->device);
+	if (ret && desc->optional)
+		desc_async_opt_call_cb(desc);
+	else
+		desc_async_found_call_cb(sysdata, desc);
+
+	if (!desc->keep)
+		release_sysdata_file(sysdata);
+
+	put_device(sys_work->device);
+	module_put(sync_reqs->module);
+
+	kfree_const(sys_work->name);
+	kfree(sys_work);
+}
+
+/**
+ * sysdata_file_request_async - asynchronous request for a system data file
+ * @name: name of the system data file
+ * @desc: system data file descriptor, it provides all the requirements
+ * 	which must be met for the file being requested.
+ * @device: device for which firmware is being loaded
+ *
+ * This performs an asynchronous system data file lookup with the requirements
+ * specified on @desc. The request for the actual system data file lookup will
+ * be scheduled with schedule_work() to be run at a later time. 0 is returned
+ * if we were able to schedlue the work to be run.
+ *
+ * Reference counting is used during the duration of this scheduled call on
+ * both the device and module that made the request. This prevents any callers
+ * from freeing either the device or module prior to completion of the
+ * scheduled work.
+ *
+ * Access to the system data file data can be accessed through an optional
+ * callback set on the @desc. If the system data file is optional you must
+ * specify that on the @desc and if set you may provide an alternative
+ * callback which if set would be run if the system data file was not found.
+ *
+ * The system data file passed to the callbacks will always be NULL unless
+ * the it was found matching all the criteria on @desc. Unless the desc->keep
+ * was set the kernel will release the system data file for you after your
+ * callbacks were processed on the scheduled work.
+ *
+ */
+int sysdata_file_request_async(const char *name,
+			       const struct sysdata_file_desc *desc,
+			       struct device *device)
+{
+	struct sysdata_file_work *sys_work;
+	const struct sysdata_file_sync_reqs *sync_reqs;
+
+	if (!device || !desc || !name)
+		return -EINVAL;
+
+	if (WARN_ON(desc->sync_reqs.mode != SYNCDATA_ASYNC))
+		return -EINVAL;
+
+	sync_reqs = &desc->sync_reqs;
+
+	if (!sync_reqs->module)
+		return -EINVAL;
+
+	sys_work = kzalloc(sizeof(struct sysdata_file_work), sync_reqs->gfp);
+	if (!sys_work)
+		return -ENOMEM;
+
+	sys_work->device = device;
+	memcpy(&sys_work->desc, desc, sizeof(struct sysdata_file_desc));
+	sys_work->name = kstrdup_const(name, sync_reqs->gfp);
+	if (!sys_work->name) {
+		kfree(sys_work);
+		return -ENOMEM;
+	}
+
+	if (!try_module_get(sync_reqs->module)) {
+		kfree_const(sys_work->name);
+		kfree(sys_work);
+		return -EFAULT;
+	}
+
+	get_device(sys_work->device);
+	INIT_WORK(&sys_work->work, request_sysdata_file_work_func);
+	schedule_work(&sys_work->work);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sysdata_file_request_async);
+
 #ifdef CONFIG_PM_SLEEP
 static ASYNC_DOMAIN_EXCLUSIVE(fw_cache_domain);
 
diff --git a/include/linux/sysdata.h b/include/linux/sysdata.h
new file mode 100644
index 000000000000..a69cf5ef082c
--- /dev/null
+++ b/include/linux/sysdata.h
@@ -0,0 +1,208 @@
+#ifndef _LINUX_SYSDATA_H
+#define _LINUX_SYSDATA_H
+
+#include <linux/types.h>
+#include <linux/compiler.h>
+#include <linux/gfp.h>
+
+/*
+ * System Data internals
+ *
+ * Copyright (C) 2015 Luis R. Rodriguez <mcgrof@do-not-panic.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+struct sysdata_file {
+	size_t size;
+	const u8 *data;
+
+	/* sysdata loader private fields */
+	void *priv;
+};
+
+/**
+ * enum sync_data_mode - system data mode of operation
+ *
+ * SYNCDATA_SYNC: your call to request system data is synchronous. We will
+ * 	look for the system data file you have requested immediatley.
+ * SYNCDATA_ASYNC: your call to request system data is asynchronous. We will
+ * 	schedule the search for your system data file to be run at a later
+ * 	time.
+ */
+enum sync_data_mode {
+	SYNCDATA_SYNC,
+	SYNCDATA_ASYNC,
+};
+
+/* one per sync_data_mode */
+union sysdata_file_cbs {
+	struct {
+		int __must_check (*found_cb)(void *, const struct sysdata_file *);
+		void *found_context;
+
+		int __must_check (*opt_fail_cb)(void *);
+		void *opt_fail_context;
+	} sync;
+	struct {
+		void (*found_cb)(const struct sysdata_file *, void *);
+		void *found_context;
+
+		void (*opt_fail_cb)(void *);
+		void *opt_fail_context;
+	} async;
+};
+
+struct sysdata_file_sync_reqs {
+	enum sync_data_mode mode;
+	struct module *module;
+	gfp_t gfp;
+};
+
+/**
+ * struct sysdata_file_desc - system data file descriptor
+ * @optional: if true it is not a hard requirement by the caller that this
+ *	file be present. An error will not be recorded if the file is not
+ *	found.
+ * @keep: if set the caller wants to claim ownership over the system data
+ *	through one of its callbacks, it must later free it with
+ *	release_sysdata_file(). By default this is set to false and the kernel
+ *	will release the system data file for you after callback processing
+ *	has completed.
+ * @sync_reqs: synchronization requirements, this will be taken care for you
+ *	by default if you are usingy sdata_file_request(), otherwise you
+ *	should provide your own requirements.
+ *
+ * This structure is set the by the driver and passed to the system data
+ * file helpers sysdata_file_request() or sysdata_file_request_async().
+ * It is intended to carry all requirements and specifications required
+ * to complete the task to get the requested system date file to the caller.
+ * If you wish to extend functionality of system data file requests you
+ * should extend this data structure and make use of the extensions on
+ * the callers to avoid unnecessary collateral evolutions.
+ *
+ * You are allowed to provide a callback to handle if a system data file was
+ * found or not. You do not need to provide a callback. You may also set
+ * an optional flag which would enable you to declare that the system data
+ * file is optional and that if it is not found an alternative callback be
+ * run for you.
+ *
+ * Refer to sysdata_file_request() and sysdata_file_request_async() for more
+ * details.
+ */
+struct sysdata_file_desc {
+	bool optional;
+	bool keep;
+	struct sysdata_file_sync_reqs sync_reqs;
+	union sysdata_file_cbs cbs;
+};
+
+/*
+ * We keep these template definitions to a minimum for the most
+ * popular requests.
+ */
+
+/* Typical sync data case */
+#define SYSDATA_SYNC_FOUND(__found_cb, __context)			\
+	.cbs.sync.found_cb = __found_cb,				\
+	.cbs.sync.found_context = __context
+
+/* If you have one fallback routine */
+#define SYSDATA_SYNC_OPT_CB(__found_cb, __context)			\
+	.cbs.sync.opt_fail_cb = __found_cb,				\
+	.cbs.sync.opt_fail_context = __context
+
+/*
+ * Used to define the default asynchronization requirements for
+ * sysdata_file_request_async(). Drivers can override.
+ */
+#define SYSDATA_DEFAULT_ASYNC(__found_cb, __context)			\
+	.sync_reqs = {							\
+		.mode = SYNCDATA_ASYNC,					\
+		.module = THIS_MODULE,					\
+		.gfp = GFP_KERNEL,					\
+	},								\
+	.cbs.async = {							\
+		.found_cb = __found_cb,					\
+		.found_context = __context,				\
+	}
+
+#define desc_sync_found_cb(desc)	(desc->cbs.sync.found_cb)
+#define desc_sync_found_context(desc)	(desc->cbs.sync.found_context)
+static inline int desc_sync_found_call_cb(const struct sysdata_file_desc *desc,
+					  const struct sysdata_file *sysdata)
+{
+	BUG_ON(desc->sync_reqs.mode != SYNCDATA_SYNC);
+	if (!desc_sync_found_cb(desc)) {
+		if (sysdata)
+			return 0;
+		return -ENOENT;
+	}
+	return desc_sync_found_cb(desc)(desc_sync_found_context(desc),
+					sysdata);
+}
+
+#define desc_sync_opt_cb(desc)		(desc->cbs.sync.opt_fail_cb)
+#define desc_sync_opt_context(desc)	(desc->cbs.sync.opt_fail_context)
+static inline int desc_sync_opt_call_cb(const struct sysdata_file_desc *desc)
+{
+	BUG_ON(desc->sync_reqs.mode != SYNCDATA_SYNC);
+	if (!desc_sync_opt_cb(desc))
+		return 0;
+	return desc_sync_opt_cb(desc)(desc_sync_opt_context(desc));
+}
+
+#define desc_async_found_cb(desc)	(desc->cbs.async.found_cb)
+#define desc_async_found_context(desc)	(desc->cbs.async.found_context)
+static inline void desc_async_found_call_cb(const struct sysdata_file *sysdata,
+					    const struct sysdata_file_desc *desc)
+{
+	BUG_ON(desc->sync_reqs.mode != SYNCDATA_ASYNC);
+	if (!desc_async_found_cb(desc))
+		return;
+	desc_async_found_cb(desc)(sysdata, desc_async_found_context(desc));
+}
+
+#define desc_async_opt_cb(desc)		(desc->cbs.async.opt_fail_cb)
+#define desc_async_opt_context(desc)	(desc->cbs.async.opt_fail_context)
+static inline void desc_async_opt_call_cb(const struct sysdata_file_desc *desc)
+{
+	BUG_ON(desc->sync_reqs.mode != SYNCDATA_ASYNC);
+	if (!desc_async_opt_cb(desc))
+		return;
+	desc_async_opt_cb(desc)(desc_async_opt_context(desc));
+}
+
+
+#if defined(CONFIG_FW_LOADER) || (defined(CONFIG_FW_LOADER_MODULE) && defined(MODULE))
+int sysdata_file_request(const char *name,
+			 const struct sysdata_file_desc *desc,
+			 struct device *device);
+int sysdata_file_request_async(const char *name,
+			       const struct sysdata_file_desc *desc,
+			       struct device *device);
+void release_sysdata_file(const struct sysdata_file *sysdata);
+#else
+static inline int sysdata_file_request(const char *name,
+				       const struct sysdata_file_desc *desc,
+				       struct device *device)
+{
+	return -EINVAL;
+}
+
+static inline int sysdata_file_request_async(const char *name,
+					     const struct sysdata_file_desc *desc,
+					     struct device *device);
+{
+	return -EINVAL;
+}
+
+static inline void release_sysdata_file(const struct sysdata_file *sysdata)
+{
+}
+#endif
+
+#endif /* _LINUX_SYSDATA_H */
-- 
2.3.2.209.gd67f9d5.dirty

