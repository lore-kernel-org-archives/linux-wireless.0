Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34411 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070AbbEFBB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 21:01:58 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: rusty@rustcorp.com.au, dhowells@redhat.com, ming.lei@canonical.com,
	seth.forshee@canonical.com, kyle@kernel.org
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	keescook@chromium.org, casey@schaufler-ca.com, tiwai@suse.de,
	mjg59@srcf.ucam.org, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org, jlee@suse.com,
	linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v1 07/12] firmware: add generic system data helpers with signature support
Date: Tue,  5 May 2015 17:44:25 -0700
Message-Id: <1430873070-7290-8-git-send-email-mcgrof@do-not-panic.com> (sfid-20150506_030220_318262_A09B9A22)
In-Reply-To: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
References: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

The Linux kernel has use cases for non-firmware file requests
from the filesystem. Some drivers, for instance the p54 driver,
uses the request_firmware() API to upload default EEPROM overrides.
Likewise, since the kernel already has cryptographic digital
signature verification support subsystems which have userspace
agents which historically have required cyptographic digital file
verification checks can replace those agents by using the kernel's
own digital verification checks on files requested from userspace.

At least for 802.11 and CRDA's [0] case for example, this is required
since CRDA has historically always had enabled digital signature
suppport on most distributions for the regulatory.bin file used to
store the 802.11 regulatory database. Providing an in-kernel replacement
should meet these same requirements unless of course distributions
start enabling digital firmware signature verification for all
required firmware. The keys for the signing regulatory data has
also been historically different than distribution's own keys
used for module signing.

There are a few motivations to replace userespace agents with these
crypto optional requirements:

  * there is a need for userspace / kernel sync up

  * the regulatory database ASCII format requires a binary
    converter and its format also needs to kept in sync
    for users that wish to have the regulatory database built
    into the kernel. Currently the ASCII db.txt file is parsed
    on the kernel through a fragile awk script. Keeping things
    in sync as the schema grows proves complex.

  * the kernel already has firmware-built-in support (see
    EXTRA_FIRMWARE) which can replace our own ASCII to db
    parser by letting us keep the firmware as binary in the
    kernel

The Linux integrity subsystem (IMA) provides a means [1] to enable
appraisal of files in userspace, this can also be used, however CRDA
has historically been used to vet for authenticity and integrity of
the regulatory database used for in-kernel 802.11 functionality.
Use of IMA is optional, support for digital signatures for files
used in-kernel can be have different subsystem specific requirements.

There's a few issues with extending the exisitng APIs however with
dynamic and custom cryptographic support. We keep pushing firmware
APIs by extending the number of arguments needed as requirements
grow or by adding new flags used internally for the different types
of new APIs exported. Behaviour can vary depending on whether a
usermode helper alternative is required, and we provide two types of
modes of operation: synchronous and asynchronous. Instead of
extending each of all these APIs with private flags this provides a
slim down implementation of what is required to get system data from
userspace to callers, without usermode helper alternative support
ripped out and by allowing the APIs to be extensible over time
depending on whether or not they are synchronous or asynchronous.

For now this initial implementation only provides an optional
requirement for subsystems to be able to override digital
signature support, for instance, even though firmware signing
might not have been enabled this lets distributions which have
had digital signature requirements for specifici files to upkeep
that tradition.

-- Consider this patch is incomplete as it still does not
   allow custom key specification, if distributions decided
   to only allow signed firmware we might be able to live with
   having distributions sign their own firmware and just stuff
   reguatory.bin into /lib/firmware. Distributions might wish
   to also make this call on their own as well.

   This patch is intended to help bring discussion about what
   we wish to do for the above requirements and also to help
   plan and coordinate future extensions to the firmware module
   and its APIs.

[0] https://wireless.wiki.kernel.org/en/developers/regulatory/crda
[1] http://sourceforge.net/p/linux-ima/wiki/Home/

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: Kyle McMartin <kyle@kernel.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/base/firmware_class.c | 256 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/sysdata.h       | 189 ++++++++++++++++++++++++++++++-
 2 files changed, 444 insertions(+), 1 deletion(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 55091b4..b46472b 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -39,6 +39,13 @@ MODULE_AUTHOR("Manuel Estrada Sainz");
 MODULE_DESCRIPTION("Multi purpose firmware loading support");
 MODULE_LICENSE("GPL");
 
+/* Should be a hot path as its the default */
+static const struct sysdata_file_sync_reqs __read_mostly dfl_sync_reqs = {
+	.mode = SYNCDATA_SYNC,
+	.module = THIS_MODULE,
+	.gfp = GFP_KERNEL,
+};
+
 static bool fw_sig_enforce = IS_ENABLED(CONFIG_FIRMWARE_SIG_FORCE);
 #ifndef CONFIG_FIRMWARE_SIG_FORCE
 module_param(fw_sig_enforce, bool_enable_only, 0644);
@@ -1266,6 +1273,179 @@ void release_firmware(const struct firmware *fw)
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
+	sysdata->sig_ok = buf->sig_ok;
+
+	pr_debug("%s: fw-%s buf=%p data=%p size=%u sig_ok=%d\n",
+		 __func__, buf->fw_id, buf, buf->data,
+		 (unsigned int)buf->size, buf->sig_ok);
+}
+
+#ifdef CONFIG_FIRMWARE_SIG_FORCE
+static int sysdata_file_sig_check(const struct sysdata_file_desc *desc,
+				  struct firmware *fw)
+{
+	return firmware_sig_check(fw);
+}
+#else
+static int sysdata_file_sig_check(const struct sysdata_file_desc *desc,
+				  struct firmware *fw)
+{
+	int ret;
+
+	ret = firmware_sig_check(fw);
+	if (ret && !desc->signature_required)
+		ret = 0;
+
+	return ret;
+}
+#endif
+
+/* prepare firmware and firmware_buf structs;
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
+static int _sysdata_file_request(const struct sysdata_file **sysdata_p,
+				 const char *name,
+				 const struct sysdata_file_desc *desc,
+				 struct device *device)
+{
+	struct sysdata_file *sysdata;
+	struct firmware *fw = NULL;
+	int ret;
+
+	if (!sysdata_p)
+		return -EINVAL;
+
+	if (!desc)
+		return -EINVAL;
+
+	if (!name || name[0] == '\0')
+		return -EINVAL;
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
+	if (ret >= 0)
+		ret = sysdata_file_sig_check(desc, fw);
+
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
+	/*
+	 * XXX: This Follows old behaviour which pegs onto *this* module,
+	 * but if we wanted to, if we knew all callers had
+	 * a valid THIS_MODULE, we'd peg this into their own
+	 * module instead.
+	 */
+	sync_reqs = &dfl_sync_reqs;
+
+	if (sync_reqs->mode != SYNCDATA_SYNC)
+		return -EINVAL;
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
@@ -1350,6 +1530,82 @@ request_firmware_nowait(
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
+	put_device(sys_work->device);
+	module_put(sync_reqs->module);
+
+	kfree_const(sys_work->name);
+	kfree(sys_work);
+}
+
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
+	if (desc->sync_reqs.mode != SYNCDATA_ASYNC)
+		return -EINVAL;
+
+	if (!desc_async_found_cb(desc))
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
+	sys_work->desc = *desc;
+	sys_work->device = device;
+	sys_work->name = kstrdup_const(name, sync_reqs->gfp);
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
index b40b873..b37c39d 100644
--- a/include/linux/sysdata.h
+++ b/include/linux/sysdata.h
@@ -1,6 +1,17 @@
-/* System Data internals
+#ifndef _LINUX_SYSDATA_H
+#define _LINUX_SYSDATA_H
+
+#include <linux/types.h>
+#include <linux/compiler.h>
+#include <linux/gfp.h>
+#include <linux/firmware.h>
+
+/*
+ * System Data internals
  *
  * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2015 Luis R. Rodriguez <mcgrof@do-not-panic.com>
+ *
  * Written by David Howells (dhowells@redhat.com)
  *
  * This program is free software; you can redistribute it and/or
@@ -9,5 +20,181 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
+struct sysdata_file {
+	size_t size;
+	const u8 *data;
+	bool sig_ok;
+
+	/* sysdata loader private fields */
+	void *priv;
+};
+
+enum sync_data_mode {
+	SYNCDATA_SYNC,
+	SYNCDATA_ASYNC,
+};
+
+/* one per sync_data_mode */
+union sysdata_file_cbs {
+	struct {
+		//int __must_check (*found_cb)(void *, const u8 *, const size_t);
+		int (*found_cb)(void *, const struct sysdata_file *);
+		void *found_context;
+
+		int (*opt_fail_cb)(void *);
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
+ * struct sysdata_file_desc - system data file description
+ * @optional: if true it is not a hard requirement by the caller that this
+ *	file be present. An error will not be recorded if the file is not
+ *	found.
+ * @signature_required: if true a digital signature is required for this file.
+ * 	This is always true if you have a system with CONFIG_FIRMWARE_SIG_FORCE
+ * 	enabled.
+ * @sync_reqs: synchronization requirements, this will be taken care for you
+ *	by default if you are usingy sdata_file_request(), otherwise you
+ *	should provide your own requirements
+ *
+ * This structure is set the by the driver and passed to the system data
+ * file helpers sysdata_file_request() or sysdata_file_request_async().
+ * It is intended to carry all requirements and specifications required
+ * to complete the task to get the requested system date file to the caller.
+ * If you wish to extend functionality of system data file requests you
+ * should extend this data structure and make use of the extensions on
+ * the callers to avoid unnecessary collateral evolutions.
+ */
+struct sysdata_file_desc {
+	bool optional;
+	bool signature_required;
+	struct sysdata_file_sync_reqs sync_reqs;
+	union sysdata_file_cbs cbs;
+};
+
+#define SYSDATA_SYNC_FOUND(__found_cb, __context)			\
+	.cbs.sync.found_cb = __found_cb,				\
+	.cbs.sync.found_context = __context
+
+#define SYSDATA_SYNC_OPT_CB(__found_cb, __context)			\
+	.cbs.sync.opt_fail_cb = __found_cb,				\
+	.cbs.sync.opt_fail_context = __context
+
+/*
+ * Used to define the default asynchronization requirements for
+ * sysdata_file_request(). Drivers can only override callbacks.
+ */
+#define SYSDATA_DEFAULT_SYNC(__found_cb, __context)			\
+	.sync_reqs = {							\
+		.mode = SYNCDATA_SYNC,					\
+		.module = THIS_MODULE,					\
+		.gfp = GFP_KERNEL,					\
+	},								\
+	SYSDATA_SYNC_FOUND(__found_cb, __context)
+
+
+#define SYSDATA_ASYNC_FOUND(__found_cb, __context)			\
+	.cbs.async.found_cb = __found_cb,				\
+	.cbs.async.found_context = __context
+
+#define SYSDATA_ASYNC_OPT_CB(__found_cb, __context)			\
+	.cbs.async.opt_fail_cb = __found_cb,				\
+	.cbs.async.opt_fail_context = __context
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
+	SYSDATA_ASYNC_FOUND(__found_cb, __context)
+
+#define desc_sync_found_cb(desc)	(desc->cbs.sync.found_cb)
+#define desc_sync_found_context(desc)	(desc->cbs.sync.found_context)
+static inline int desc_sync_found_call_cb(const struct sysdata_file_desc *desc,
+					  const struct sysdata_file *sysdata)
+{
+	if (!desc_sync_found_cb(desc))
+		return 0;
+	return desc_sync_found_cb(desc)(desc_sync_found_context(desc),
+					sysdata);
+}
+
+#define desc_sync_opt_cb(desc)		(desc->cbs.sync.opt_fail_cb)
+#define desc_sync_opt_context(desc)	(desc->cbs.sync.opt_fail_context)
+static inline int desc_sync_opt_call_cb(const struct sysdata_file_desc *desc)
+{
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
+	if (!desc_async_found_cb(desc))
+		return;
+	desc_async_found_cb(desc)(sysdata, desc_async_found_context(desc));
+}
+
+#define desc_async_opt_cb(desc)		(desc->cbs.async.opt_fail_cb)
+#define desc_async_opt_context(desc)	(desc->cbs.async.opt_fail_context)
+static inline void desc_async_opt_call_cb(const struct sysdata_file_desc *desc)
+{
+	if (!desc_async_opt_cb(desc))
+		return;
+	desc_async_opt_cb(desc)(desc_async_opt_context(desc));
+}
+
 extern int sysdata_verify_sig(const void *data, unsigned long *_len);
 #define SYSDATA_SIG_STRING "~System data signature appended~\n"
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

