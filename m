Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36433 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932545Ab2AETgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 14:36:24 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Rit6s-0003dl-OM
	for linux-wireless@vger.kernel.org; Thu, 05 Jan 2012 20:36:22 +0100
Subject: [PATCH] compat: backport dma_alloc_coherent
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Jan 2012 20:36:23 +0100
Message-ID: <1325792183.3339.9.camel@jlt3.sipsolutions.net> (sfid-20120105_203629_404449_7994E655)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is needed now for some wireless drivers.
Simply copy the upstream implementation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---

--- a/include/linux/compat-3.2.h
+++ b/include/linux/compat-3.2.h
@@ -10,6 +10,15 @@
 
 #define PMSG_IS_AUTO(msg)	(((msg).event & PM_EVENT_AUTO) != 0)
 
+static inline void *dma_zalloc_coherent(struct device *dev, size_t size,
+					dma_addr_t *dma_handle, gfp_t flag)
+{
+	void *ret = dma_alloc_coherent(dev, size, dma_handle, flag);
+	if (ret)
+		memset(ret, 0, size);
+	return ret;
+}
+
 /**
  * skb_frag_page - retrieve the page refered to by a paged fragment
  * @frag: the paged fragment


