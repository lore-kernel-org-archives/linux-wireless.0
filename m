Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:43446 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbZEGSje (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2009 14:39:34 -0400
Date: Thu, 7 May 2009 20:41:00 +0200
From: Daniel Wagner <wagi@monom.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] Simulate medium behavior
Message-ID: <20090507184007.GA6684@newton.monom.org>
References: <20090422092159.GA24586@toronto053.server4you.de> <1240393088.21756.3.camel@johannes.local> <20090422113556.GB24586@toronto053.server4you.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090422113556.GB24586@toronto053.server4you.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 22, 2009 at 01:35:56PM +0200, Daniel Wagner wrote:
> On Wed, Apr 22, 2009 at 11:38:08AM +0200, Johannes Berg wrote:
> > Hi,
> > 
> > > Writing a 0 to /debug/ieee80211/phy*/hwsim/medium enables rx/tx for
> > > the specific phy. Writing anything but 0 disables rx/tx.  Not a very
> > > good API. It could be made something more realistic like reception
> > > quality is 80% associated some statistical dropping algorithm. Any
> > > thoughts?
> > > 
> > > Is this the right direction I'm heading to?
> > 
> > This looks like a very simple knob, just a little more work could get
> > you much further -- have you seen this email/thread?
> > 
> > http://thread.gmane.org/gmane.linux.kernel.wireless.general/25001
> 
> No, I haven't. Yep, my solution is really too simple.  I like the
> virtual air grouping. I'll implement it.

After a bit studying how to use configfs (and getting a bit lost)
I found netconsole.c which uses configfs. So this version is a copy&past
thing. Of course, this needs more work. 

Is this what do did have in mind?

How it works:

# modprobe mac80211_hwsim
# mount -t configfs none /config

Make phy0 radio member of group 1: 
# mkdir /config/mac80211_hwsim/phy0
# echo "phy0" > /config/mac80211_hwsim/phy0/dev_name
# echo 1 > /config/mac80211_hwsim/phy0/group
# echo 1 > /config/mac80211_hwsim/phy0/enable

I have only tested it very short, no problems found. Works as expected :)
 
cheers,
daniel

---
 drivers/net/wireless/Kconfig          |    9 +
 drivers/net/wireless/mac80211_hwsim.c |  324 ++++++++++++++++++++++++++++++++-
 2 files changed, 332 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 2d8434f..5316675 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -481,6 +481,15 @@ config MAC80211_HWSIM
 	  To compile this driver as a module, choose M here: the module will be
 	  called mac80211_hwsim.  If unsure, say N.
 
+config MAC80211_HWSIM_VGROUP
+	bool "enable virtual air grouping"
+	depends on MAC80211_HWSIM
+	default y
+	help
+	  This option enables virtual air grouping.
+
+	  If unsure, say N.
+
 config MWL8K
 	tristate "Marvell 88W8xxx PCI/PCIe Wireless support"
 	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index d4fdc8b..bafe451 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -21,6 +21,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/etherdevice.h>
 #include <linux/debugfs.h>
+#include <linux/configfs.h>
 
 MODULE_AUTHOR("Jouni Malinen");
 MODULE_DESCRIPTION("Software simulator of 802.11 radio(s) for mac80211");
@@ -291,6 +292,8 @@ struct mac80211_hwsim_data {
 	bool ps_poll_pending;
 	struct dentry *debugfs;
 	struct dentry *debugfs_ps;
+
+	unsigned int group;
 };
 
 
@@ -412,7 +415,8 @@ static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 
 		if (!data2->started || !data2->radio_enabled ||
 		    !hwsim_ps_rx_ok(data2, skb) ||
-		    data->channel->center_freq != data2->channel->center_freq)
+		    data->channel->center_freq != data2->channel->center_freq ||
+		    !(data->group & data2->group))
 			continue;
 
 		nskb = skb_copy(skb, GFP_ATOMIC);
@@ -877,6 +881,320 @@ DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_ps, hwsim_fops_ps_read, hwsim_fops_ps_write,
 			"%llu\n");
 
 
+#ifdef CONFIG_MAC80211_HWSIM_VGROUP
+
+/* Linked list of all configured targets */
+static LIST_HEAD(target_list);
+
+/* XXX document the spinlock */
+static DEFINE_SPINLOCK(target_list_lock);
+
+/**
+ * struct mac80211_hwsim_target - Represents a configured mac80211_hwsim target.
+ * @list:	Links this target into the target_list.
+ * @item:	Links us into the configfs subsystem hierarchy.
+ * @enabled:	On / off knob to enable / disable target.
+ *		Visible from userspace (read-write).
+ *		Contains the other userspace visible parameters:
+ *		dev_name	(read-write)
+ *		local_port	(read-write)
+ *		group		(read-write)
+ */
+struct mac80211_hwsim_target {
+	struct list_head	list;
+	struct config_item	item;
+	int			enabled;
+	char		        dev_name[IFNAMSIZ];
+	long			group;
+};
+
+
+/*
+ * Our subsystem hierarchy is:
+ *
+ * /config/mac80211_hwsim/
+ *				|
+ *				<target>/
+ *				|	enabled
+ *				|	dev_name
+ *				|	group
+ *				|
+ *				<target>/...
+ */
+
+struct mac80211_hwsim_target_attr {
+	struct configfs_attribute	attr;
+	ssize_t				(*show)(struct mac80211_hwsim_target *nt,
+						char *buf);
+	ssize_t				(*store)(struct mac80211_hwsim_target *nt,
+						 const char *buf,
+						 size_t count);
+};
+
+static struct mac80211_hwsim_target *to_target(struct config_item *item)
+{
+	return item ?
+		container_of(item, struct mac80211_hwsim_target, item) :
+		NULL;
+}
+
+
+/*
+ * Attribute operations for mac80211_hwsim_target.
+ */
+
+static ssize_t show_enabled(struct mac80211_hwsim_target *nt, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", nt->enabled);
+}
+
+static ssize_t show_dev_name(struct mac80211_hwsim_target *nt, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%s\n", nt->dev_name);
+}
+
+static ssize_t show_group(struct mac80211_hwsim_target *nt, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%ld\n", nt->group);
+}
+
+
+static ssize_t store_enabled(struct mac80211_hwsim_target *nt,
+			     const char *buf,
+			     size_t count)
+{
+	char *p = (char *) buf;
+	int tmp;
+	struct mac80211_hwsim_data *data;
+
+	tmp = simple_strtoul(p, &p, 10);
+	if (!p || (*p && (*p != '\n')))
+		return -EINVAL;
+
+	if (tmp != 0 && tmp != 1)
+		return -ERANGE;
+
+	spin_lock(&hwsim_radio_lock);
+	list_for_each_entry(data, &hwsim_radios, list) {
+		if (strcmp(wiphy_name(data->hw->wiphy), nt->dev_name) == 0) {
+			data->group = nt->group;
+			break;
+		}
+	}
+	spin_unlock(&hwsim_radio_lock);
+
+	nt->enabled = tmp;
+
+	return strnlen(buf, count);
+}
+
+static ssize_t store_dev_name(struct mac80211_hwsim_target *nt,
+			      const char *buf,
+			      size_t count)
+{
+	size_t len;
+
+	if (nt->enabled) {
+		printk(KERN_ERR "mac80211_hwsim: target (%s) is enabled, "
+				"disable to update parameters\n",
+				config_item_name(&nt->item));
+		return -EINVAL;
+	}
+
+	strlcpy(nt->dev_name, buf, IFNAMSIZ);
+
+	/* Get rid of possible trailing newline from echo(1) */
+	len = strnlen(nt->dev_name, IFNAMSIZ);
+	if (nt->dev_name[len - 1] == '\n')
+		nt->dev_name[len - 1] = '\0';
+
+	return strnlen(buf, count);
+}
+
+static ssize_t store_group(struct mac80211_hwsim_target *nt,
+			   const char *buf,
+			   size_t count)
+{
+	char *p = (char *) buf;
+
+	if (nt->enabled) {
+		printk(KERN_ERR "mac80211_hwsim: target (%s) is enabled, "
+				"disable to update parameters\n",
+				config_item_name(&nt->item));
+		return -EINVAL;
+	}
+	
+	nt->group = simple_strtoul(p, &p, 16);
+
+	return strnlen(buf, count);
+}
+
+
+/*
+ * Attribute definitions for mac80211_hwsim_target.
+ */
+
+#define MAC80211_HWSIM_TARGET_ATTR_RO(_name)				\
+static struct mac80211_hwsim_target_attr mac80211_hwsim_target_##_name =	\
+	__CONFIGFS_ATTR(_name, S_IRUGO, show_##_name, NULL)
+
+#define MAC80211_HWSIM_TARGET_ATTR_RW(_name)				\
+static struct mac80211_hwsim_target_attr mac80211_hwsim_target_##_name =	\
+	__CONFIGFS_ATTR(_name, S_IRUGO | S_IWUSR, show_##_name, store_##_name)
+
+MAC80211_HWSIM_TARGET_ATTR_RW(enabled);
+MAC80211_HWSIM_TARGET_ATTR_RW(dev_name);
+MAC80211_HWSIM_TARGET_ATTR_RW(group);
+
+static struct configfs_attribute *mac80211_hwsim_target_attrs[] = {
+	&mac80211_hwsim_target_enabled.attr,
+	&mac80211_hwsim_target_dev_name.attr,
+	&mac80211_hwsim_target_group.attr,
+	NULL,
+};
+
+/*
+ * Item operations and type for mac80211_hwsim_target.
+ */
+
+static void mac80211_hwsim_target_release(struct config_item *item)
+{
+	kfree(to_target(item));
+}
+
+static ssize_t mac80211_hwsim_target_attr_show(struct config_item *item,
+					   struct configfs_attribute *attr,
+					   char *buf)
+{
+	ssize_t ret = -EINVAL;
+	struct mac80211_hwsim_target *nt = to_target(item);
+	struct mac80211_hwsim_target_attr *na =
+		container_of(attr, struct mac80211_hwsim_target_attr, attr);
+
+	if (na->show)
+		ret = na->show(nt, buf);
+
+	return ret;
+}
+
+static ssize_t mac80211_hwsim_target_attr_store(struct config_item *item,
+					    struct configfs_attribute *attr,
+					    const char *buf,
+					    size_t count)
+{
+	ssize_t ret = -EINVAL;
+	struct mac80211_hwsim_target *nt = to_target(item);
+	struct mac80211_hwsim_target_attr *na =
+		container_of(attr, struct mac80211_hwsim_target_attr, attr);
+
+	if (na->store)
+		ret = na->store(nt, buf, count);
+
+	return ret;
+}
+
+static struct configfs_item_operations mac80211_hwsim_target_item_ops = {
+	.release		= mac80211_hwsim_target_release,
+	.show_attribute		= mac80211_hwsim_target_attr_show,
+	.store_attribute	= mac80211_hwsim_target_attr_store,
+};
+
+static struct config_item_type mac80211_hwsim_target_type = {
+	.ct_attrs		= mac80211_hwsim_target_attrs,
+	.ct_item_ops		= &mac80211_hwsim_target_item_ops,
+	.ct_owner		= THIS_MODULE,
+};
+
+/*
+ * Group operations and type for mac80211_hwsim_subsys.
+ */
+
+static struct config_item *make_mac80211_hwsim_target(struct config_group *group,
+						  const char *name)
+{
+	unsigned long flags;
+	struct mac80211_hwsim_target *nt;
+
+	/*
+	 * Allocate and initialize with defaults.
+	 * Target is disabled at creation (enabled == 0).
+	 */
+	nt = kzalloc(sizeof(*nt), GFP_KERNEL);
+	if (!nt) {
+		printk(KERN_ERR "mac80211_hwsim: failed to allocate memory\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* Initialize the config_item member */
+	config_item_init_type_name(&nt->item, name, &mac80211_hwsim_target_type);
+
+	/* Adding, but it is disabled */
+	spin_lock_irqsave(&target_list_lock, flags);
+	list_add(&nt->list, &target_list);
+	spin_unlock_irqrestore(&target_list_lock, flags);
+
+	return &nt->item;
+}
+
+static void drop_mac80211_hwsim_target(struct config_group *group,
+				   struct config_item *item)
+{
+	unsigned long flags;
+	struct mac80211_hwsim_target *nt = to_target(item);
+
+	spin_lock_irqsave(&target_list_lock, flags);
+	list_del(&nt->list);
+	spin_unlock_irqrestore(&target_list_lock, flags);
+
+
+	config_item_put(&nt->item);
+}
+
+static struct configfs_group_operations mac80211_hwsim_subsys_group_ops = {
+	.make_item	= make_mac80211_hwsim_target,
+	.drop_item	= drop_mac80211_hwsim_target,
+};
+
+static struct config_item_type mac80211_hwsim_subsys_type = {
+	.ct_group_ops	= &mac80211_hwsim_subsys_group_ops,
+	.ct_owner	= THIS_MODULE,
+};
+
+/* The mac80211_hwsim configfs subsystem */
+static struct configfs_subsystem mac80211_hwsim_subsys = {
+	.su_group	= {
+		.cg_item	= {
+			.ci_namebuf	= "mac80211_hwsim",
+			.ci_type	= &mac80211_hwsim_subsys_type,
+		},
+	},
+};
+
+static int __init configfs_mac80211_hwsim_init(void)
+{
+	config_group_init(&mac80211_hwsim_subsys.su_group);
+	mutex_init(&mac80211_hwsim_subsys.su_mutex);
+	return configfs_register_subsystem(&mac80211_hwsim_subsys);
+}
+
+static void __exit configfs_mac80211_hwsim_exit(void)
+{
+	configfs_unregister_subsystem(&mac80211_hwsim_subsys);
+}
+
+#else /* !CONFIg_MAC80211_HWSIM_VGROUP */
+
+static int __init configfs_mac80211_hwsim_init(void)
+{
+	return 0;
+}
+
+static void __exit configfs_mac80211_hwsim_exit(void)
+{
+}
+
+#endif /* CONFIG_MAC80211_HWSIM_VGROUP */
+
 static int __init init_mac80211_hwsim(void)
 {
 	int i, err = 0;
@@ -1122,6 +1440,9 @@ static int __init init_mac80211_hwsim(void)
 	if (err < 0)
 		goto failed_mon;
 
+	err = configfs_mac80211_hwsim_init();
+	if (err)
+		goto failed_mon;
 
 	err = register_netdevice(hwsim_mon);
 	if (err < 0)
@@ -1152,6 +1473,7 @@ static void __exit exit_mac80211_hwsim(void)
 	printk(KERN_DEBUG "mac80211_hwsim: unregister radios\n");
 
 	unregister_netdev(hwsim_mon);
+	configfs_mac80211_hwsim_exit();
 	mac80211_hwsim_free();
 }
 
-- 
1.6.2.4

