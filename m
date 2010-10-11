Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42057 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab0JKR3E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 13:29:04 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] wireless:  Print wiphy name in sysfs.
Date: Mon, 11 Oct 2010 10:28:59 -0700
Message-Id: <1286818139-1746-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The index cannot be used to reliably reconstruct a phy
name, so explicitly add the phy name to sysfs so that scripts
can figure out the parent phy device for a particular
wireless interface.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 74a9e3c... 4294fa2... M	net/wireless/sysfs.c
 net/wireless/sysfs.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 74a9e3c..4294fa2 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -35,6 +35,14 @@ SHOW_FMT(index, "%d", wiphy_idx);
 SHOW_FMT(macaddress, "%pM", wiphy.perm_addr);
 SHOW_FMT(address_mask, "%pM", wiphy.addr_mask);
 
+static ssize_t name_show(struct device *dev,
+			 struct device_attribute *attr,
+			 char *buf) {
+	struct wiphy *wiphy = &dev_to_rdev(dev)->wiphy;
+	return sprintf(buf, "%s\n", dev_name(&wiphy->dev));
+}
+
+
 static ssize_t addresses_show(struct device *dev,
 			      struct device_attribute *attr,
 			      char *buf)
@@ -57,6 +65,7 @@ static struct device_attribute ieee80211_dev_attrs[] = {
 	__ATTR_RO(macaddress),
 	__ATTR_RO(address_mask),
 	__ATTR_RO(addresses),
+	__ATTR_RO(name),
 	{}
 };
 
-- 
1.7.2.2

