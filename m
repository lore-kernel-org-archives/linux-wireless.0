Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51694 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754484AbZC0P6N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 11:58:13 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH 2/4] rfkill: expose global switches through sysfs
Date: Fri, 27 Mar 2009 12:58:03 -0300
Message-Id: <1238169485-29298-3-git-send-email-hmh@hmh.eng.br> (sfid-20090327_165819_482121_94AD4D2F)
In-Reply-To: <1238169485-29298-1-git-send-email-hmh@hmh.eng.br>
References: <1238169485-29298-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Expose global switches through sysfs.  This allows userspace to:

1. Enumerate all rfkill switch types (attr. available_types);

2. Read the full state of each global switch (one per type);

3. Manipulate te state of a global switch (block/unblock all
   transmitters of that type).

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/rfkill/rfkill.c |  238 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 238 insertions(+), 0 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 1369b56..703eb4d 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -377,6 +377,10 @@ static ssize_t rfkill_name_show(struct device *dev,
 	return sprintf(buf, "%s\n", rfkill->name);
 }
 
+/*
+ * Rules for type names: must match regexp [a-z0-9_]+
+ * (i.e. no spaces, only lowercase, numbers and '_')
+ */
 static const char *rfkill_get_type_str(enum rfkill_type type)
 {
 	switch (type) {
@@ -903,7 +907,47 @@ struct rfkill_dev_attr {
 	unsigned int index;
 };
 
+struct rfkill_gsw_attr_ptrs {
+	struct rfkill_dev_attr *state;
+	struct rfkill_dev_attr *saved_state;
+	struct rfkill_dev_attr *name;
+	struct device_attribute *eol;
+};
+
+struct rfkill_gsw_attrs {
+	struct rfkill_dev_attr state, saved_state, name;
+};
+
+static struct attribute_group *rfkill_gsw_attr_groups;
+static struct rfkill_gsw_attr_ptrs *rfkill_gsw_attr_ptrs;
+static struct rfkill_gsw_attrs *rfkill_gsw_devattrs;
+
+
+static ssize_t rfkill_attr_available_types_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	unsigned int i;
+	ssize_t s = PAGE_SIZE;
+	ssize_t c = 0;
+	int u;
+
+	for (i = 0; i < RFKILL_TYPE_MAX && s > 4; i++) {
+		u = snprintf(&buf[c], s, "%s ", rfkill_get_type_str(i));
+		c += u;
+		s -= u;
+	}
+	if (i != RFKILL_TYPE_MAX)
+		return -EIO;
+
+	if (i > 0)
+		buf[c-1] = '\n';
+
+	return c;
+}
+
 static struct device_attribute rfkill_g_attrs[] = {
+	__ATTR(available_types, S_IRUGO,
+		rfkill_attr_available_types_show, NULL),
 	__ATTR_NULL
 };
 
@@ -938,6 +982,192 @@ static void rfkill_destroy_g_attrs(struct platform_device *pdev)
 	}
 }
 
+static ssize_t rfkill_gsw_attr_state_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct rfkill_dev_attr *p = container_of(attr,
+					struct rfkill_dev_attr,
+					devattr);
+	int i = p->index;
+	BUG_ON(i < 0 || i >= RFKILL_TYPE_MAX);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			rfkill_global_states[i].current_state);
+}
+
+static ssize_t rfkill_gsw_attr_state_store(struct device *dev,
+			struct device_attribute *attr, const char *buf,
+			size_t count)
+{
+	struct rfkill_dev_attr *p = container_of(attr,
+					struct rfkill_dev_attr,
+					devattr);
+	int i = p->index;
+	int error;
+	unsigned long state;
+
+	BUG_ON(i < 0 || i >= RFKILL_TYPE_MAX);
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	error = strict_strtoul(buf, 0, &state);
+	if (error)
+		return error;
+
+	if (state != RFKILL_STATE_UNBLOCKED &&
+	    state != RFKILL_STATE_SOFT_BLOCKED)
+		return -EINVAL;
+
+	if (rfkill_epo_lock_active)
+		return -EPERM;
+
+	rfkill_switch_all(i, state);
+
+	return count;
+}
+
+static ssize_t rfkill_gsw_attr_saved_state_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct rfkill_dev_attr *p = container_of(attr,
+					struct rfkill_dev_attr,
+					devattr);
+	int i = p->index;
+	BUG_ON(i < 0 || i >= RFKILL_TYPE_MAX);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			rfkill_global_states[i].default_state);
+}
+
+static ssize_t rfkill_gsw_attr_name_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct rfkill_dev_attr *p = container_of(attr,
+					struct rfkill_dev_attr,
+					devattr);
+	int i = p->index;
+	BUG_ON(i < 0 || i >= RFKILL_TYPE_MAX);
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", rfkill_get_type_str(i));
+}
+
+static void __init rfkill_add_gsw_attr(const enum rfkill_type type)
+{
+	#define RFKILL_GSW_DEVATTR(_name, _mode, _show, _store) \
+	do { \
+		rfkill_gsw_devattrs[type]._name.devattr.attr.name = \
+							__stringify(_name); \
+		rfkill_gsw_devattrs[type]._name.devattr.attr.mode = _mode; \
+		rfkill_gsw_devattrs[type]._name.devattr.show = _show; \
+		rfkill_gsw_devattrs[type]._name.devattr.store = _store; \
+		rfkill_gsw_devattrs[type]._name.index = type; \
+		rfkill_gsw_attr_ptrs[type]._name = \
+					&rfkill_gsw_devattrs[type]._name; \
+	} while (0)
+
+	RFKILL_GSW_DEVATTR(state, S_IWUSR | S_IRUGO,
+			rfkill_gsw_attr_state_show,
+			rfkill_gsw_attr_state_store);
+	RFKILL_GSW_DEVATTR(saved_state, S_IRUGO,
+			rfkill_gsw_attr_saved_state_show, NULL);
+	RFKILL_GSW_DEVATTR(name, S_IRUGO,
+			rfkill_gsw_attr_name_show, NULL);
+
+	#undef RFKILL_GSW_DEVATTR
+}
+
+static void rfkill_deallocate_gsw_devattrs(void)
+{
+	kfree(rfkill_gsw_devattrs);
+	rfkill_gsw_devattrs = NULL;
+}
+
+/* error unwind done by caller through rfkill_deallocate_gsw_devattrs() */
+static int __init rfkill_allocate_gsw_devattrs(void)
+{
+	rfkill_gsw_devattrs = kcalloc(RFKILL_TYPE_MAX,
+					sizeof(*rfkill_gsw_devattrs),
+					GFP_KERNEL);
+	if (!rfkill_gsw_devattrs)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int __init rfkill_create_gsw_groups(struct platform_device *pdev)
+{
+	int i;
+	int error;
+
+	rfkill_gsw_attr_ptrs = kcalloc(RFKILL_TYPE_MAX,
+					sizeof(*rfkill_gsw_attr_ptrs),
+					GFP_KERNEL);
+	if (!rfkill_gsw_attr_ptrs)
+		return -ENOMEM;
+
+	rfkill_gsw_attr_groups = kcalloc(RFKILL_TYPE_MAX,
+					sizeof(*rfkill_gsw_attr_groups),
+					GFP_KERNEL);
+	if (!rfkill_gsw_attr_groups) {
+		error = -ENOMEM;
+		goto err_alloc_1;
+	}
+
+	error = rfkill_allocate_gsw_devattrs();
+	if (error < 0)
+		goto err_exit;
+
+	error = 0;
+	i = 0;
+	while (!error && i < RFKILL_TYPE_MAX) {
+		rfkill_add_gsw_attr(i);
+
+		rfkill_gsw_attr_groups[i].name = rfkill_get_type_str(i);
+		rfkill_gsw_attr_groups[i].attrs =
+				(struct attribute **)(&rfkill_gsw_attr_ptrs[i]);
+
+		error = sysfs_create_group(&pdev->dev.kobj,
+					   &rfkill_gsw_attr_groups[i]);
+		i++;
+	}
+	if (error) {
+		i--;
+		while (i > 0) {
+			i--;
+			sysfs_remove_group(&pdev->dev.kobj,
+					   &rfkill_gsw_attr_groups[i]);
+		}
+		goto err_exit;
+	}
+
+	return 0;
+
+err_exit:
+	rfkill_deallocate_gsw_devattrs();
+	kfree(rfkill_gsw_attr_groups);
+	rfkill_gsw_attr_groups = NULL;
+err_alloc_1:
+	kfree(rfkill_gsw_attr_ptrs);
+	rfkill_gsw_attr_ptrs = NULL;
+	return error;
+}
+
+static void __exit rfkill_destroy_gsw_attr(struct platform_device *pdev)
+{
+	int i;
+
+	if (rfkill_gsw_attr_groups) {
+		for (i = 0; i < RFKILL_TYPE_MAX; i++) {
+			sysfs_remove_group(&pdev->dev.kobj,
+					   &rfkill_gsw_attr_groups[i]);
+		}
+		kfree(rfkill_gsw_attr_groups);
+	}
+	rfkill_deallocate_gsw_devattrs();
+	kfree(rfkill_gsw_attr_ptrs);
+}
+
 static struct platform_driver rfkill_pdrv = {
 	.driver = {
 		.name = RFKILL_PDEV_NAME,
@@ -992,8 +1222,15 @@ static int __init rfkill_init(void)
 	if (error)
 		goto err_unregister_pdev;
 
+	error = rfkill_create_gsw_groups(rfkill_pdev);
+	if (error)
+		goto err_unregister_pdev_attr;
+
 	return 0;
 
+err_unregister_pdev_attr:
+	rfkill_destroy_g_attrs(rfkill_pdev);
+
 err_unregister_pdev:
 	platform_device_unregister(rfkill_pdev);
 
@@ -1013,6 +1250,7 @@ err_class_unregister:
 static void __exit rfkill_exit(void)
 {
 #if defined(CONFIG_RFKILL_GLOBAL_UAPI) && !defined(CONFIG_RFKILL_NO_CORE_UAPI)
+	rfkill_destroy_gsw_attr(rfkill_pdev);
 	rfkill_destroy_g_attrs(rfkill_pdev);
 	platform_device_unregister(rfkill_pdev);
 	platform_driver_unregister(&rfkill_pdrv);
-- 
1.6.2.1

