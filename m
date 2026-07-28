Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39401A0B0E;
	Tue, 28 Jul 2026 23:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785283071; cv=none; b=UBkw8oVUVAmFfsaSl5VwLrlUzEKKvTmDt4xuZkTW4WRoQm/YHWZ2TghimRgfEp0g5KvTd5Zr7LIZQt7kdovr9hjQSTL1MP89f+7kitapnHrV600h2P/zc9HwSEYwSZay3hk5wJhx9t8lQo2HRgtCjP7VqdGYzRNrS5GBatRWyAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785283071; c=relaxed/simple;
	bh=GOrP0259BEWsxw+0E8ctPWjrFbxNuWCGjJ84MbEVK/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iTBRq7WIrfhEPF/TH+bCOi8YTFF1ON9lk/+C8LDftEg/U7PayAlmTjDSP6gyrX3MNbf+onrF9GYpqWjgdQ8ars0L7YZAutUSZoOzGP1d1VSc1ljNKAA26qeWMq6wVfm49I+nrqBsuSd+FQDZeQExkf+frbFVXUlISQoxCNeFe2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=EQ4oOUv5; arc=none smtp.client-ip=148.163.129.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="EQ4oOUv5"
Received: from dispatch1-us1.ppe-hosted.com (ip6-localhost [127.0.0.1])
	by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2DC2C2A5A43;
	Tue, 28 Jul 2026 23:57:49 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2A5EE240071;
	Tue, 28 Jul 2026 23:57:39 +0000 (UTC)
Received: from pk2.candelatech.com (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 54E1813C2B0;
	Tue, 28 Jul 2026 16:57:37 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 54E1813C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1785283057;
	bh=GOrP0259BEWsxw+0E8ctPWjrFbxNuWCGjJ84MbEVK/Y=;
	h=From:To:Cc:Subject:Date:From;
	b=EQ4oOUv5QJjX1NtAnkhecpIDBbIHIrLC7ZkYNXXAwwXKttGcspG0JvOzZEytMYY9x
	 lw/bVYH+tQd8XZFgJrKHs79jqxuaBv3NGyrTe3LD435RdpaIz0XaQug9Pt5gqeO69C
	 U9DtC2FLxQBK8tYITcPjeJkWTi32jxe996Ydre84=
From: Rory Little <roryl@candelatech.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next] wifi: cfg80211: add fw_version device attribute for sysfs
Date: Tue, 28 Jul 2026 16:47:25 -0700
Message-ID: <20260728234726.27479-1-roryl@candelatech.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MDID: 1785283061-v2rS0vNrBpoz
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1785283061;v2rS0vNrBpoz;<roryl@candelatech.com>;45f0d7970863e41367ffff0782cafe38
X-PPE-TRUSTED: V=1;DIR=OUT;

The firmware version is already exposed via ethtool, but is not
accessible without an attached interface to create a netdev. Expose this
info in sysfs to allow users to query it without the use of ethtool.

Signed-off-by: Rory Little <roryl@candelatech.com>
---
 Documentation/ABI/testing/sysfs-class-ieee80211 |  7 +++++++
 MAINTAINERS                                     |  1 +
 net/wireless/sysfs.c                            | 14 ++++++++++++++
 3 files changed, 22 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-ieee80211

diff --git a/Documentation/ABI/testing/sysfs-class-ieee80211 b/Documentation/ABI/testing/sysfs-class-ieee80211
new file mode 100644
index 000000000000..caaf4f3fd4b4
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-ieee80211
@@ -0,0 +1,7 @@
+What:		/sys/class/ieee80211/<phyname>/fw_version
+Date:		July 2026
+Contact:	linux-wireless@vger.kernel.org
+Description:	Read-only firmware version string provided by the driver for
+		this wireless device. The read data will match the information
+		provided by ethtool get_drvinfo. As drivers are not required to
+		provide this information, reading may yield no data.
diff --git a/MAINTAINERS b/MAINTAINERS
index 2d420d40782e..56181edb718f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -117,6 +117,7 @@ W:	https://wireless.wiki.kernel.org/
 Q:	https://patchwork.kernel.org/project/linux-wireless/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git
+F:	Documentation/ABI/testing/sysfs-class-ieee80211
 F:	Documentation/driver-api/80211/cfg80211.rst
 F:	Documentation/networking/regulatory.rst
 F:	include/linux/ieee80211.h
diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 3ec25d3f004e..e63b6d1fa411 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -65,12 +65,26 @@ static ssize_t addresses_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(addresses);
 
+static ssize_t fw_version_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct wiphy *wiphy = &dev_to_rdev(dev)->wiphy;
+
+	if (!wiphy->fw_version[0])
+		return 0;
+
+	return sysfs_emit(buf, "%s\n", wiphy->fw_version);
+}
+static DEVICE_ATTR_RO(fw_version);
+
 static struct attribute *ieee80211_attrs[] = {
 	&dev_attr_index.attr,
 	&dev_attr_macaddress.attr,
 	&dev_attr_address_mask.attr,
 	&dev_attr_addresses.attr,
 	&dev_attr_name.attr,
+	&dev_attr_fw_version.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(ieee80211);
-- 
2.52.0

