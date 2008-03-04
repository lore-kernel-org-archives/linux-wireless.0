Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935418AbYCDX1k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 18:27:40 -0500
Message-Id: <200803042326.m24NQ9bB003292@imap1.linux-foundation.org> (sfid-20080304_232751_806240_32E5AFD6)
Subject: [patch 04/10] prism54: convert acl->sem in a mutex
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	matthias@kaehlcke.net, flamingice@sourmilk.net,
	mcgrof@winlab.rutgers.edu
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2008 15:26:09 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matthias Kaehlcke <matthias@kaehlcke.net>

The semaphore acl->sem is used as mutex, convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Michael Wu <flamingice@sourmilk.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/prism54/isl_ioctl.c  |   28 ++++++++++----------
 drivers/net/wireless/prism54/islpci_dev.h |    2 -
 2 files changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/net/wireless/prism54/isl_ioctl.c~convert-acl-sem-in-a-mutex drivers/net/wireless/prism54/isl_ioctl.c
--- a/drivers/net/wireless/prism54/isl_ioctl.c~convert-acl-sem-in-a-mutex
+++ a/drivers/net/wireless/prism54/isl_ioctl.c
@@ -1780,7 +1780,7 @@ prism54_set_raw(struct net_device *ndev,
 void
 prism54_acl_init(struct islpci_acl *acl)
 {
-	sema_init(&acl->sem, 1);
+	mutex_init(&acl->lock);
 	INIT_LIST_HEAD(&acl->mac_list);
 	acl->size = 0;
 	acl->policy = MAC_POLICY_OPEN;
@@ -1792,10 +1792,10 @@ prism54_clear_mac(struct islpci_acl *acl
 	struct list_head *ptr, *next;
 	struct mac_entry *entry;
 
-	down(&acl->sem);
+	mutex_lock(&acl->lock);
 
 	if (acl->size == 0) {
-		up(&acl->sem);
+		mutex_unlock(&acl->lock);
 		return;
 	}
 
@@ -1806,7 +1806,7 @@ prism54_clear_mac(struct islpci_acl *acl
 		kfree(entry);
 	}
 	acl->size = 0;
-	up(&acl->sem);
+	mutex_unlock(&acl->lock);
 }
 
 void
@@ -1833,13 +1833,13 @@ prism54_add_mac(struct net_device *ndev,
 
 	memcpy(entry->addr, addr->sa_data, ETH_ALEN);
 
-	if (down_interruptible(&acl->sem)) {
+	if (mutex_lock_interruptible(&acl->lock)) {
 		kfree(entry);
 		return -ERESTARTSYS;
 	}
 	list_add_tail(&entry->_list, &acl->mac_list);
 	acl->size++;
-	up(&acl->sem);
+	mutex_unlock(&acl->lock);
 
 	return 0;
 }
@@ -1856,18 +1856,18 @@ prism54_del_mac(struct net_device *ndev,
 	if (addr->sa_family != ARPHRD_ETHER)
 		return -EOPNOTSUPP;
 
-	if (down_interruptible(&acl->sem))
+	if (mutex_lock_interruptible(&acl->lock))
 		return -ERESTARTSYS;
 	list_for_each_entry(entry, &acl->mac_list, _list) {
 		if (memcmp(entry->addr, addr->sa_data, ETH_ALEN) == 0) {
 			list_del(&entry->_list);
 			acl->size--;
 			kfree(entry);
-			up(&acl->sem);
+			mutex_unlock(&acl->lock);
 			return 0;
 		}
 	}
-	up(&acl->sem);
+	mutex_unlock(&acl->lock);
 	return -EINVAL;
 }
 
@@ -1882,7 +1882,7 @@ prism54_get_mac(struct net_device *ndev,
 
 	dwrq->length = 0;
 
-	if (down_interruptible(&acl->sem))
+	if (mutex_lock_interruptible(&acl->lock))
 		return -ERESTARTSYS;
 
 	list_for_each_entry(entry, &acl->mac_list, _list) {
@@ -1891,7 +1891,7 @@ prism54_get_mac(struct net_device *ndev,
 		dwrq->length++;
 		dst++;
 	}
-	up(&acl->sem);
+	mutex_unlock(&acl->lock);
 	return 0;
 }
 
@@ -1955,11 +1955,11 @@ prism54_mac_accept(struct islpci_acl *ac
 	struct mac_entry *entry;
 	int res = 0;
 
-	if (down_interruptible(&acl->sem))
+	if (mutex_lock_interruptible(&acl->lock))
 		return -ERESTARTSYS;
 
 	if (acl->policy == MAC_POLICY_OPEN) {
-		up(&acl->sem);
+		mutex_unlock(&acl->lock);
 		return 1;
 	}
 
@@ -1970,7 +1970,7 @@ prism54_mac_accept(struct islpci_acl *ac
 		}
 	}
 	res = (acl->policy == MAC_POLICY_ACCEPT) ? !res : res;
-	up(&acl->sem);
+	mutex_unlock(&acl->lock);
 
 	return res;
 }
diff -puN drivers/net/wireless/prism54/islpci_dev.h~convert-acl-sem-in-a-mutex drivers/net/wireless/prism54/islpci_dev.h
--- a/drivers/net/wireless/prism54/islpci_dev.h~convert-acl-sem-in-a-mutex
+++ a/drivers/net/wireless/prism54/islpci_dev.h
@@ -55,7 +55,7 @@ struct islpci_acl {
    enum { MAC_POLICY_OPEN=0, MAC_POLICY_ACCEPT=1, MAC_POLICY_REJECT=2 } policy;
    struct list_head mac_list;  /* a list of mac_entry */
    int size;   /* size of queue */
-   struct semaphore sem;   /* accessed in ioctls and trap_work */
+   struct mutex lock;   /* accessed in ioctls and trap_work */
 };
 
 struct islpci_membuf {
_
