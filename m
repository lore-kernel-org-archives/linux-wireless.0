Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:52249 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274Ab2LGLaz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 06:30:55 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless:  Fix ethtool stats and other ops.
References: <1354729192-22945-1-git-send-email-greearb@candelatech.com>
	<87a9ts4c1q.fsf@nemi.mork.no> <50BF8C18.9060504@candelatech.com>
	<20121206122528.GG2502@redhat.com> <50C0FCE0.2090507@candelatech.com>
	<20121207095012.GB11933@redhat.com>
Date: Fri, 07 Dec 2012 12:30:12 +0100
In-Reply-To: <20121207095012.GB11933@redhat.com> (Stanislaw Gruszka's message
	of "Fri, 7 Dec 2012 10:50:13 +0100")
Message-ID: <87zk1q3xrv.fsf@nemi.mork.no> (sfid-20121207_123059_212875_E2F2F1B5)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Stanislaw Gruszka <sgruszka@redhat.com> writes:
> On Thu, Dec 06, 2012 at 12:15:28PM -0800, Ben Greear wrote:
>> I don't have time to work on this today...maybe not tomorrow either.
>>=20
>> So, if someone else feels like fixing it, please feel free.
>
> Ok, I'll try to fix that. However this could require modification
> of all cfg80211 drivers, so could not be fast.

I wonder if that strategy isn't just adding unnecessary complexity?  How
about using something like the (completely untested) patch below instead?


Bj=C3=B8rn


--=-=-=
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: inline;
 filename=0001-net-fix-ethtool_ops-for-wireless.patch
Content-Transfer-Encoding: quoted-printable

>From 6b6ce488f64d5530e1886072f64b034d5a65e5f7 Mon Sep 17 00:00:00 2001
From: =3D?UTF-8?q?Bj=3DC3=3DB8rn=3D20Mork?=3D <bjorn@mork.no>
Date: Fri, 7 Dec 2012 12:14:02 +0100
Subject: [RFC] net: fix ethtool_ops for wireless
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

commit 2c60db03 ("net: provide a default dev->ethtool_ops") made
tests for unset ethtool_ops always fail.  This caused a regression
for wireless drivers relying on the wireless specific ethtool_ops
default.

Adding a new test for code which need to know whether ethtool_ops
was changed after netdev allocation, and update the wireless core
to use it.

Signed-off-by: Bj=C3=B8rn Mork <bjorn@mork.no>
---
 include/linux/netdevice.h |   14 ++++++++++++++
 net/core/dev.c            |    1 +
 net/wireless/core.c       |    2 +-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 18c5dc9..95741f1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2707,6 +2707,20 @@ static inline bool netif_supports_nofcs(struct net_d=
evice *dev)
=20
 extern struct pernet_operations __net_initdata loopback_net_ops;
=20
+extern struct ethtool_ops default_ethtool_ops;
+
+/**
+ *	netdev_has_default_ethtool_ops - test for default ethtool_ops
+ *	@dev: device
+ *
+ *	This function returns true if dev is using the generic default
+ *	ethtool_ops
+ */
+static inline bool netdev_has_default_ethtool_ops(struct net_device *dev)
+{
+	return dev->ethtool_ops && (dev->ethtool_ops =3D=3D &default_ethtool_ops);
+}
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
=20
 /* netdev_printk helpers, similar to dev_printk */
diff --git a/net/core/dev.c b/net/core/dev.c
index 0aea3fe..0b20be5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6107,6 +6107,7 @@ struct netdev_queue *dev_ingress_queue_create(struct =
net_device *dev)
 }
=20
 static const struct ethtool_ops default_ethtool_ops;
+EXPORT_SYMBOL_GPL(default_ethtool_ops);
=20
 /**
  *	alloc_netdev_mqs - allocate network device
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 14d9904..95467d0 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -866,7 +866,7 @@ static int cfg80211_netdev_notifier_call(struct notifie=
r_block *nb,
 		/* allow mac80211 to determine the timeout */
 		wdev->ps_timeout =3D -1;
=20
-		if (!dev->ethtool_ops)
+		if (netdev_has_default_ethtool_ops(dev)
 			dev->ethtool_ops =3D &cfg80211_ethtool_ops;
=20
 		if ((wdev->iftype =3D=3D NL80211_IFTYPE_STATION ||
--=20
1.7.10.4


--=-=-=--
