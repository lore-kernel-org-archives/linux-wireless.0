Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678E64CDDD4
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 11:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790767755; cv=none; b=IjhGYw5go2Oxj8YhF8AF86jhbNb4UjXCixeSWI2+VNs3f+Cf73rkNfbH8FfI/dp+jVhYOt3RTcPsyy02MIB8e8qe5JHZFOGp98PpcfxxX0cYQgOZwSS3Wtz2PUTosAMId2TQVVJeXGh+JMODftPrfCKAs6CNCmQvouGXgTnGW64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790767755; c=relaxed/simple;
	bh=yaWJo1yaHY7FTp6z5elpYODFms8u9nCWewz4vye/UYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4d2tn+dyo0qyhA1Vo/hjRzHMTLlpMYzFdD27AkTUdY75rBF2Z9skfLMaF3nB9RIq3BMYZKpfsBtDcREXdxxT6pl/8t0MkgVu3Jpeb3rHhIhhLHUTEqc5lUd+xX399lrGRkRj4tt7n44SFyTAbQPkYaht4NLVcntdMh8LuWRJ8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cjtwdpuW; arc=none smtp.client-ip=74.125.228.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cjtwdpuW"
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc433d52421so1881571a12.3
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 04:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790767753; x=1791372553; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CL0Y1VoSDGzjgEsyQ72S63U8D3jO1axWiityZmhT6lM=;
        b=cjtwdpuWAN8GCms2uU2xabsVi49zct4NUna2q6mzyYYkzLOJKXv6I83CbL/EwyWyLU
         rw0W2niKhFIO9lZA3m3x9jx1OywE5BXSHzhYeEtMdpULWgzRgquFY9UxgMR8SkbyRyIN
         /QcxLVURponb3eMhlIKgQx1EDutJGF9Vmy1Ikn7vgBbdaqLrUEslC8zRE1zVNmMZv88+
         Ove0QpoACUY5Um5v4h7fbw6GFNcQ/hIGI7urrM2YobNTIcvZeTx9dyMKl20KRyFTlMTV
         ApgixakuW3cesSHrkMJU9xXe/oGxHW9FQfiJcDo5my+p1Eo0lvA0t59LRp3TPgWRsRo7
         EylA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790767753; x=1791372553;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CL0Y1VoSDGzjgEsyQ72S63U8D3jO1axWiityZmhT6lM=;
        b=jTLKwb9ky2g54RAQIVlU7RGZfnJt+TNZMjc0usYd+7aZ3pHkEHZ35ycFvgv8aKpnCB
         UOs2uz91iGC4zt8/q1vyTsQQLzev+zB858ppzmKhe+D2ZcgWN7ocVVsFcEJx+E0k+tdR
         AS5xM3V9vOlzTS7RSH6U3KU6kBxSPoJC1DcenCll2GpVX0Ln3z48ES7BO3iQNceqWEZv
         GKHoni+u9kenyxz1/Y8ViCfp6tRdHjVm8YvSRWOwfkri0wHS/Swn88VZ5V6Q1o4uA/g3
         6HaSVq1h5KoIa3x7hgO08T44B27E5vbo1MBAsiEecBEyF0GdRbEG6j7VhXF9Per6SEz1
         WyeA==
X-Forwarded-Encrypted: i=1; AKwUvBwmJNcz8k4oK50mop+oDZDDv1zoHLOoSRupMnA8XKwN57lmkR3Y7DMoPh1oHs6SKj1F8kXAC20jAcq3S9TPNw==@vger.kernel.org
X-Gm-Message-State: AFuF++mVENKoIb6ZmU404UTZssLXPwcW5ZwAsDTrxL9Z8Zvm1b/aHL9g
	IzTbsdPP2sxW7pkUkmFeEHhk3f0c9Qox8L/qulBohJs7z+0T9fqerPo7
X-Gm-Gg: AYBFou0R4Sa9dXR1uBso0kyxL79s4/oDmxxuhVWPtrHjxycLiJuamL5R40hiKosYrdx
	cH/Uyd0PrNX79omaDii95IXDstbKDdarBC1yWn5qM/k1EuMcg0ptBvuqWcRwQyXLE5y9ssZ3Ads
	3P+HQCDUxHBUrhEWvGQY8u2+Nh+6nLk2JIJCJfzZaI6p7Ii3TVBTmjU5n+CyLlV47jXlZywokXq
	G75p+gOoGTrOJZbQpYOQ/M3rGmpePxTBU+4gR7Kcv0lobzhuI2s0d5w7q6w6inBkfvBG5pEy/6r
	ulzQ/v3MXdkergQ0kuddoj+fCTqExoOHfd6BH4qLNSd5PDcr+QlGeTcZXxR6WLBUhRMuYErpofP
	qASz7K0sSRmZKJLbTae0K/WKgpdaFewYFN/wMfDfZrnwaIR1Hh51UwMni/O1OuxQWJlzyUDGTPm
	fBm0x1C9fjBlIugIGYOygclA6i+CU6ScQYwXGfJz465OLzLiFNKQPXZwhoxeqIQ4PXLCczumnik
	/Bplzo5WOh4gQXmv0CbVPG3P97RPPlIHkVNgQXuJmV9
X-Received: by 2002:a05:6a21:748a:b0:3de:6796:5eeb with SMTP id adf61e73a8af0-3de9e78ef25mr1072963637.40.1790767752606;
        Wed, 30 Sep 2026 04:29:12 -0700 (PDT)
Received: from m-upc-A520M-HDV.lan ([2400:2410:3f60:500:3fb:270c:7df4:18f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc7dab46db6sm712637a12.31.2026.09.30.04.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 04:29:12 -0700 (PDT)
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
Subject: [PATCH net-next v9 3/6] net: add a generation counter for dev->mc changes
Date: Wed, 30 Sep 2026 20:28:39 +0900
Message-ID: <20260930112842.21323-4-sigefriedhyy@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260930112842.21323-1-sigefriedhyy@gmail.com>
References: <20260930112842.21323-1-sigefriedhyy@gmail.com>
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
netdev_hw_addr_list an owner, set for the lists of a device and NULL
for snapshots and other standalone lists, and bump the counter of
dev_net(owner) from the count helpers when the list is dev->mc. That
covers the dev_mc_* helpers, both lists of a sync, the hardware sync
helpers drivers call from their rx mode callbacks or their own workers
and the reconciliation after an asynchronous rx mode update. It is
atomic since the writers only hold the address lock of their own
device.

Used by the following patch for the AF_PACKET multicast dump.

Signed-off-by: Yuyang Huang <sigefriedhyy@gmail.com>
---
 include/linux/netdevice.h   |  5 +++++
 include/net/net_namespace.h |  1 +
 net/core/dev_addr_lists.c   | 20 ++++++++++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 97dc053f234cc..d409c56a02459 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -257,6 +257,11 @@ struct netdev_hw_addr_list {
 
 	/* Auxiliary tree for faster lookup on addition and deletion */
 	struct rb_root		tree;
+
+	/* The device a list belongs to, NULL for snapshots and other
+	 * standalone lists
+	 */
+	struct net_device	*owner;
 };
 
 #define netdev_hw_addr_list_count(l) ((l)->_count)
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 46b4c67e2966f..d8c681ab5c749 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -71,6 +71,7 @@ struct net {
 	spinlock_t		rules_mod_lock;
 
 	unsigned int		dev_base_seq;	/* protected by rtnl_mutex */
+	atomic_t		dev_mc_genid;	/* bumped on dev->mc changes */
 	u32			ifindex;
 
 	spinlock_t		nsid_lock;
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index 23f5db99a702d..783c62895249b 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -16,9 +16,21 @@
 
 #include "dev.h"
 
+/* Only dev->mc is tracked, RTM_GETMULTICAST dumps use the netns generation
+ * counter to detect changes between dump rounds.
+ */
+static void __hw_addr_changed(struct netdev_hw_addr_list *list)
+{
+	struct net_device *dev = list->owner;
+
+	if (dev && list == &dev->mc)
+		atomic_inc(&dev_net(dev)->dev_mc_genid);
+}
+
 static void __hw_addr_count_add(struct netdev_hw_addr_list *list, int value)
 {
 	list->_count += value;
+	__hw_addr_changed(list);
 }
 
 static void __hw_addr_count_inc(struct netdev_hw_addr_list *list)
@@ -33,7 +45,10 @@ static void __hw_addr_count_dec(struct netdev_hw_addr_list *list)
 
 static void __hw_addr_count_reset(struct netdev_hw_addr_list *list)
 {
+	if (!list->_count)
+		return;
 	list->_count = 0;
+	__hw_addr_changed(list);
 }
 
 /*
@@ -521,6 +536,7 @@ void __hw_addr_init(struct netdev_hw_addr_list *list)
 	INIT_LIST_HEAD(&list->list);
 	list->_count = 0;
 	list->tree = RB_ROOT;
+	list->owner = NULL;
 }
 EXPORT_SYMBOL(__hw_addr_init);
 
@@ -705,6 +721,7 @@ int dev_addr_init(struct net_device *dev)
 	/* rtnl_mutex must be held here */
 
 	__hw_addr_init(&dev->dev_addrs);
+	dev->dev_addrs.owner = dev;
 	memset(addr, 0, sizeof(addr));
 	err = __hw_addr_add(&dev->dev_addrs, addr, sizeof(addr),
 			    NETDEV_HW_ADDR_T_LAN);
@@ -982,6 +999,7 @@ EXPORT_SYMBOL(dev_uc_flush);
 void dev_uc_init(struct net_device *dev)
 {
 	__hw_addr_init(&dev->uc);
+	dev->uc.owner = dev;
 }
 EXPORT_SYMBOL(dev_uc_init);
 
@@ -1197,6 +1215,7 @@ EXPORT_SYMBOL(dev_mc_flush);
 void dev_mc_init(struct net_device *dev)
 {
 	__hw_addr_init(&dev->mc);
+	dev->mc.owner = dev;
 }
 EXPORT_SYMBOL(dev_mc_init);
 
@@ -1368,6 +1387,7 @@ static void netif_rx_mode_retry(struct timer_list *t)
 void netif_rx_mode_init(struct net_device *dev)
 {
 	__hw_addr_init(&dev->rx_mode_addr_cache);
+	dev->rx_mode_addr_cache.owner = dev;
 	timer_setup(&dev->rx_mode_retry_timer, netif_rx_mode_retry, 0);
 }
 
-- 
2.43.0

