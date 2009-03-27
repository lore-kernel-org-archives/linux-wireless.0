Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33003 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754140AbZC0P6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 11:58:12 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH 3/4] rfkill: expose global state to sysfs
Date: Fri, 27 Mar 2009 12:58:04 -0300
Message-Id: <1238169485-29298-4-git-send-email-hmh@hmh.eng.br> (sfid-20090327_165818_210031_57B3E8D1)
In-Reply-To: <1238169485-29298-1-git-send-email-hmh@hmh.eng.br>
References: <1238169485-29298-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Expose the global state of rfkill through sysfs.  Userspace can now:

1. Check the current state, enter or exit EPO through the
emergency_power_off attribute;

2. Restore to the state before the last EPO through a write to the
restore_saved_state attribute;

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/rfkill/rfkill.c |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 703eb4d..901e6c2 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -945,9 +945,73 @@ static ssize_t rfkill_attr_available_types_show(struct device *dev,
 	return c;
 }
 
+static ssize_t rfkill_attr_emergency_power_off_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+			rfkill_epo_lock_active ? 1 : 0);
+}
+
+static ssize_t rfkill_attr_emergency_power_off_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	unsigned long l;
+	int error;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	error = strict_strtoul(buf, 0, &l);
+	if (error)
+		return error;
+
+	if (l > 1)
+		return -EINVAL;
+
+	if (l)
+		rfkill_epo();
+	else
+		rfkill_remove_epo_lock();
+
+	return count;
+}
+
+static ssize_t rfkill_attr_restore_saved_state_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	unsigned long l;
+	int error;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	error = strict_strtoul(buf, 0, &l);
+	if (error)
+		return error;
+
+	if (l > 1)
+		return -EINVAL;
+
+	/* For userspace, require explicit unlock */
+	if (rfkill_epo_lock_active)
+		return -EPERM;
+
+	if (l)
+		rfkill_restore_states();
+
+	return count;
+}
+
 static struct device_attribute rfkill_g_attrs[] = {
 	__ATTR(available_types, S_IRUGO,
 		rfkill_attr_available_types_show, NULL),
+	__ATTR(emergency_power_off, S_IWUSR | S_IRUGO,
+		rfkill_attr_emergency_power_off_show,
+		rfkill_attr_emergency_power_off_store),
+	__ATTR(restore_saved_state, S_IWUSR,
+		NULL, rfkill_attr_restore_saved_state_store),
 	__ATTR_NULL
 };
 
-- 
1.6.2.1

