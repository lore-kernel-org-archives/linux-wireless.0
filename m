Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:9459 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086AbbJQJn2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2015 05:43:28 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: kernel-janitors@vger.kernel.org,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] NFC: delete null dereference
Date: Sat, 17 Oct 2015 11:32:19 +0200
Message-Id: <1445074340-21955-2-git-send-email-Julia.Lawall@lip6.fr> (sfid-20151017_114445_075548_072EC232)
In-Reply-To: <1445074340-21955-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1445074340-21955-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The exit label performs device_unlock(&dev->dev);, which will fail when dev
is NULL, and nfc_put_device(dev);, which is not useful when dev is NULL, so
just exit the function immediately.

Problem found using scripts/coccinelle/null/deref_null.cocci

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 net/nfc/netlink.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 853172c..f040532 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1109,10 +1109,8 @@ static int nfc_genl_llc_sdreq(struct sk_buff *skb, struct genl_info *info)
 	idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
 
 	dev = nfc_get_device(idx);
-	if (!dev) {
-		rc = -ENODEV;
-		goto exit;
-	}
+	if (!dev)
+		return -ENODEV;
 
 	device_lock(&dev->dev);
 

