Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F36E491587
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 11:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791374348; cv=none; b=J2Z8g0j2Bo6f5IhfulFw94VVwyjve2PTCtmyyMAGrcSERx03FFd7nsgLdrnCgy1vzHEYp7O4pL73Z10eGQBm+uWY8xHKJeIOjwsa3UxXihmYfmua56+GefyxQjrIhPSO80IlHs+8qsBoNnySK9CuYLnTBTwSaUR4mNVD0o4k6eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791374348; c=relaxed/simple;
	bh=IgbYzH2C6hbv015jsEN0i3YOMqCP9cu1G2VmEtmOUcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZYrjS01LP98ZmCOpJBC6LB8ectjDrHraaHxKgBMAXq8fyPRZ96Lad7Yp5OOPKZU9k/jsyq6mVgyMaMCRB2seFGehIMecXR/ggpTnardTXcD3/0+Es1tvpqO2FDyqrubHr7G18c9t/vaAZXuia+S5pydn7TNHl0mADPz2PXMLr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W1CWFtwD; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W1CWFtwD"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3a886d6ad51so1076231a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 04:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791374331; x=1791979131; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DI4d2s8GvHpPglm8OhsdKL/5L5SEzceEtpEBmwHSvtg=;
        b=W1CWFtwDRhGm6wFzO3wNOwXblISsIaic4qhZDw6i5ImihoBM2XjSjwlExQAle0XpSs
         2+6khvVP9dKK4FAG/cqOsr6hum9RIOafLMj1nhVPzo+Fbp93bcRkhV+yHTU0/gfzPMd5
         +DrmqZmBSJvzjJ/w3lOGo02NcF+nP950UK9HSX0j/m6bdmxq32UqRV+QDKNgkQbsfG6Z
         sP0oB48tpyN6CP8SMqcRxA/trhYphpZnd8vVSBPSYQ9mmQiLdUW8+9psXOCcNS4Xy4ab
         7VjRToaNxeynEd9fIQjfvHXVRe4iFxHw00ptfkKU/EH846NzacsFqMM+gUA7YTbjtlMp
         fJcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791374331; x=1791979131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DI4d2s8GvHpPglm8OhsdKL/5L5SEzceEtpEBmwHSvtg=;
        b=AvB3JXaFIg6RclcnlJjibOSMNebZTR8pMRirLUqlafCiXniq+1PCX9OWm9BZ4qXNg3
         DeS4Vp7AIobJwNM+pJhuuJmvHY25nIPm7NHWxevJDNEx1y8mWHncicJ2UvC69w8UCDyX
         eg4KGftAVPmqc4tN/ccO+uHrvBJqn8Tt6P3MsjqEF1F6+TKeOcACUouMsuFwg1twYCJD
         ZhW/H2z8E5E61+kxgpd5/Kgi/PUIXAzKqfflNwtHHT7gCiXHJpqpjxg3HM5zVzBSknga
         NmyQtsWLTfBYHZIbS9uvSklo6QqGwzo9+B0RLY1iXRuVuG3zlBD6m2W5sddi2y5qNuXF
         sInQ==
X-Forwarded-Encrypted: i=1; AKwUvBywh8kpe37VLJaG9hT++s6QL215kU+OEM9bZmcS6Bi+LVOWdndMgi8xJS5aqr1dBytw/69I5i/X0fLg3fmSUA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLenHAFGxP/4mLNT6TCxo2URtDGNewUTtVAxfCJ3i54j6YJ6ZMo
	ONYMuLERaUmtfF9fJTTyZAwIvfrMgSV44+395ACojb3izEtxAkr9aV5e
X-Gm-Gg: AYBFou2txOXoAJDwwGs1EamkdUpRCCV6KE8gaFokpR5dWRFULPv4Sn/Urb5HdLM7Bly
	HvoP7kOq1rZQGm3PSAP0zpJItEy8Q6caewqrwb1TvI1Rw9U5EKWFSfClHJUUhykQm6ZAPzLKrLQ
	HKx2EqGQcSdNd9jED6CZSwcSOJAXf7A8tLWeSPjUmdyIBi2Xyw+M/jZu3fv1TTCSSyrKX+2gGzx
	zKpMyChJg5YJ+mbNIqVWnVbnffuABO/JsE7Fou7w33YcWrEDo0+/PCFuE22myzMIc8UGhVmBQ0H
	p0KaBxsMJ1r+SKJTVVgu+F9BA+6H0pDHsd+b9//zFw3RKnnESser/Z1CDB+JjcW19gomt4aZCdc
	anb00eiXM9gCatNs6MAzkxm9NHXpx2DONFB1lJRdh+liKKjLpCZCLFkcRFrB2oMuI1HwtWrFaTU
	MFiq+zgwX6DBxUb47aYGeeIv0HLT+QuUB7vE6dOBAzuoZd/TW3+CAPEOCjkGSnnqDbNfTeCaHeB
	9dJYEiJezncCUuEs+3oLjdYup3Rlb868jPI/DvE6+5hAp+vopVSk2G7gsNa4srGRUVzDi/RAdn6
X-Received: by 2002:a17:90a:1c88:b0:3a8:c3dc:3c44 with SMTP id 98e67ed59e1d1-3a8c3dc621fmr387226a91.21.1791374331072;
        Wed, 07 Oct 2026 04:58:51 -0700 (PDT)
Received: from m-upc-A520M-HDV.lan (oki-109-236-14-10.jptransit.net. [109.236.14.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8987b09e2sm4456582a91.2.2026.10.07.04.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 04:58:50 -0700 (PDT)
Sender: Yuyang Huang <uyoko90@gmail.com>
From: Yuyang Huang <sigefriedhyy@gmail.com>
To: Yuyang Huang <sigefriedhyy@gmail.com>
Cc: Ajay Singh <ajay.kathat@microchip.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Donald Hunter <donald.hunter@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kees Cook <kees@kernel.org>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Nikolaos Gkarlis <nickgarlis@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Shuah Khan <shuah@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Stanislav Fomichev <sdf.kernel@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Willem de Bruijn <willemb@google.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH net-next v10 3/6] net: add a generation counter for dev->mc changes
Date: Wed,  7 Oct 2026 20:58:18 +0900
Message-ID: <20261007115821.11332-4-sigefriedhyy@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007115821.11332-1-sigefriedhyy@gmail.com>
References: <20261007115821.11332-1-sigefriedhyy@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A multi-part RTM_GETMULTICAST dump of dev->mc resumes by position, so
entries added or removed between two dump rounds can be skipped or
repeated. The IPv4 and IPv6 dumps report that with NLM_F_DUMP_INTR by
stamping cb->seq from a per netns generation counter combined with
dev_base_seq, see inet_base_seq().

Add the equivalent for the device multicast lists: a per netns counter
bumped whenever an entry is added to or removed from any dev->mc. The
list helpers do not know which device a list belongs to, so give
netdev_hw_addr_list an mc_dev pointer, set for dev->mc only, and bump
the counter of dev_net(mc_dev) from the count helpers. That covers the
dev_mc_* helpers, both lists of a sync, the hardware sync helpers
drivers call from their rx mode callbacks or their own workers and the
reconciliation after an asynchronous rx mode update. It is atomic
since the writers only hold the address lock of their own device.

Used by the following patch for the AF_PACKET multicast dump.

Signed-off-by: Yuyang Huang <sigefriedhyy@gmail.com>
---
 include/linux/netdevice.h   |  3 +++
 include/net/net_namespace.h |  1 +
 net/core/dev_addr_lists.c   | 15 +++++++++++++++
 3 files changed, 19 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3d9e3a70ca5c9..6c837ea34748e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -259,6 +259,9 @@ struct netdev_hw_addr_list {
 
 	/* Auxiliary tree for faster lookup on addition and deletion */
 	struct rb_root		tree;
+
+	/* Set for dev->mc only, the device the list belongs to */
+	struct net_device	*mc_dev;
 };
 
 #define netdev_hw_addr_list_count(l) ((l)->_count)
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 46b4c67e2966f..c29a22ca178fa 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -71,6 +71,7 @@ struct net {
 	spinlock_t		rules_mod_lock;
 
 	unsigned int		dev_base_seq;	/* protected by rtnl_mutex */
+	atomic_t		dev_mc_genid;	/* dev->mc membership changes */
 	u32			ifindex;
 
 	spinlock_t		nsid_lock;
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index d615192d1c3b1..3ab053cbf8b99 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -16,9 +16,19 @@
 
 #include "dev.h"
 
+/* RTM_GETMULTICAST dumps use the netns generation counter to detect
+ * changes of dev->mc between dump rounds.
+ */
+static void __hw_addr_changed(struct netdev_hw_addr_list *list)
+{
+	if (list->mc_dev)
+		atomic_inc(&dev_net(list->mc_dev)->dev_mc_genid);
+}
+
 static void __hw_addr_count_add(struct netdev_hw_addr_list *list, int value)
 {
 	list->_count += value;
+	__hw_addr_changed(list);
 }
 
 static void __hw_addr_count_inc(struct netdev_hw_addr_list *list)
@@ -33,7 +43,10 @@ static void __hw_addr_count_dec(struct netdev_hw_addr_list *list)
 
 static void __hw_addr_count_reset(struct netdev_hw_addr_list *list)
 {
+	if (!list->_count)
+		return;
 	list->_count = 0;
+	__hw_addr_changed(list);
 }
 
 /*
@@ -521,6 +534,7 @@ void __hw_addr_init(struct netdev_hw_addr_list *list)
 	INIT_LIST_HEAD(&list->list);
 	list->_count = 0;
 	list->tree = RB_ROOT;
+	list->mc_dev = NULL;
 }
 EXPORT_SYMBOL(__hw_addr_init);
 
@@ -1197,6 +1211,7 @@ EXPORT_SYMBOL(dev_mc_flush);
 void dev_mc_init(struct net_device *dev)
 {
 	__hw_addr_init(&dev->mc);
+	dev->mc.mc_dev = dev;
 }
 EXPORT_SYMBOL(dev_mc_init);
 
-- 
2.43.0

