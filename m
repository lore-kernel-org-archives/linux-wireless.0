Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C94C3BBA0D
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 08:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789028246; cv=none; b=ln9KrudCzw/WnBmKLuSam45FqSP1y58C2De8Nt3sSxigbDbV9SfMKHwFRfdpWjBr6dwEVfUH9Zf6uuAjO3ZPoWAerpnYsMdQIcME4YQT51kG0wE6RwqBml/9/f0rw4SHrQ1mN0rE8rcp7IMawv9PF+26GsgxgHb2EOe8TZjMMmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789028246; c=relaxed/simple;
	bh=Pf9FGUuu4T99qrISQwcUth/SFnfHhXZMk0vraXLaX2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Od8QRvRTsAIeof9yXZ9Nna5EetYzYwwh/kX94RigvZ6XXt1UdwiLja/kBVIDEFajzwy8HogV7dyHenlDNt+WV7VpSsr0GT+tBKrra4v5k5JT+kvT9P6yF0Q9GMUBvwnFEluXHQ3NH6K1z6AfTbCcMEhGW4VGuM9AwcbWghYdEbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q5nlhSDN; arc=none smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q5nlhSDN"
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910ca5aa6so151696685a.0
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 01:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789028242; x=1789633042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/Qa2OeELdjZHS87D2WN6hbNeXUfzKq/fcfCAU9P6xlU=;
        b=q5nlhSDNNmF6ra3GhNynpWwwriXDFG4/MuCqh3di7r2o5Q7qx5Xs3X9YPNz7Wvsk6o
         4dTYZSwIAS4wwzjc7U2hQV6oqUN0NEu2/+kXEkoTVGx+X4QFGFdoFjiulNcvS1Sf1Tv8
         sesZOB1HqWTsSCcRHE9kq84oiepUAv7ryduZOWSrZAguzggvr46OLATcF2h4QXOjcDs3
         VXGAfnAe1pBpDyL8tN/8/Ej4TQ1k88pwwZw4YLchcFvxCNMPC8+t6XbA731AoxCTIIZD
         4GwsrWum6LPkViwSMVm++Y/UziuM8XP7zhvzEtWMKB16y8BWLwIyGbiGdQatzXXCMlOR
         onmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789028242; x=1789633042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/Qa2OeELdjZHS87D2WN6hbNeXUfzKq/fcfCAU9P6xlU=;
        b=KfDmOBfFr7fO9TG0NT/jId1QSNNcmzrNg5Vq2rigx46/nUkcb95pM8azIkYJ3PjW9L
         DYty4mWfpfQpEhvKk+k0bL9bz3S9C/wC+Fx4Z1gp57tHH8wjilorKa5+ZqJ4mrUgf9n3
         pPXe0fUzUDsR4P0Rcqk8IaIbjC5oYGzBhJ6rE0wlX/D7EQTgNXxLCSZRSq9X5KvrpNPv
         c8uVT90kMPaKAket/HdDKQqiCebt/r3x9fSVeCRmenzSQtoxCNRABsx4QXgmVK7olZEL
         aflSs3oCLtuJE/XXaPKxZnAoLZOTQ02TLZMGuHFh9g6L6gK3taaheeZ773vvPNzpRns5
         XxiQ==
X-Forwarded-Encrypted: i=1; AKwUvBwECy37YFUO4YuDvjLI0FrQfxKFXUpPE7QWledU6riAwIBH6V0TzC0jiVzSEUuxMSettuxGsRzDYSjJajRnKg==@vger.kernel.org
X-Gm-Message-State: AFuF++k6rAczwRCyxq+rRphwME9Qx7HxhOqxojTbgVF/W4Is+waNIA0o
	98JcJsLY+i/umG+OgbLcj76H93PRdgK3bFm9Nnv96TGfKCChIRsE4MM8bO76z6nM
X-Gm-Gg: AYBFou1L3RSCAdXUE6jfZ4ARmm+/gCgOQpE1HlVKdqd279r+2rLslQfs2JtIxDkahDe
	xO/Mn4iZxuDVfeGznsiBeOvXF3gfCRv2j1i+dBRUr/E096z1OPM3yW3dJQ2z44V7dmmfwU3Q+yd
	bvcvqmfwM4AgdIJxymloAE+Sz+7dxyAZZzASqc5T8l2JJWnM8uNVZUQsanwDvj3Q5G58uoJvJr9
	/iVI0HvdxK7eXGEVmdduk7V+NlQ+cEyCe8LRCcsljCfWmVqfkf7ocvWnJhzymP6A08iFqfPJULg
	Y1F/aXaglnKW2gMMoPiHyoUXRcU2e5oJjJ18cyBK1JJRibKNjay649VB8G3UM0D/TYbHOgs8CRO
	W6Wuov+lHHm3KVkxLnGqHmM1QWF7zdxBqpEWrbbTahMO7WRJ9SrcEZGDmkjj1KG5nmxVyhrzLLe
	iscuxf6xTcRXhxtMWHJ7KJOwXN5voZBRBP0bY9gJjczE5dpfGI2ve6XXqlctNZBHvwI2MP38v4C
	ym1
X-Received: by 2002:a05:620a:4552:b0:939:9eb4:888a with SMTP id af79cd13be357-939d4924ccfmr797682585a.1.1789028242237;
        Thu, 10 Sep 2026 01:17:22 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939a57535a1sm1087723885a.0.2026.09.10.01.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 01:17:21 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v3 2/3] wifi: rtw88: usb: only let the frames a dozing station needs use the after-DTIM queue
Date: Thu, 10 Sep 2026 10:17:15 +0200
Message-ID: <20260910081716.769081-3-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910081716.769081-1-mehmet.fide@gmail.com>
References: <20260910081716.769081-1-mehmet.fide@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

With the budget in place the high queue can no longer take the chip
down, but ordinary chatter still competes with the frames a sleeping
station actually needs. mac80211 marks every broadcast and multicast
frame with IEEE80211_TX_CTL_SEND_AFTER_DTIM while a station dozes,
mDNS and SSDP included, so under normal traffic the budget is spent on
frames nobody waits for.

Do what the vendor driver does with its default "allow special" high
queue filter: admit only ARP, EAPOL and DHCP to the after-DTIM path,
the frames a station coming out of power save has to see; everything
else goes out on its access category queue at line rate. The frames
are classified the way rtw89_core_tx_btc_spec_pkt_notify() does it,
from skb->protocol and the network and transport header offsets that
mac80211 keeps from the netdev path; EAPOL is the control port flag.
Frames the AP relays between its own stations arrive as ETH_P_802_3
and are not inspected, they leave on the access category queue.

With the filter in place the page pool stays at 1803 through the same
180 second storm, a DHCP flood still takes the after-DTIM path (and is
then held by the budget), and join/ping cycling without power save is
unchanged (10/10).

Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
---
v3:
- the IP/UDP test written in positive form (Ping-Ke)

 drivers/net/wireless/realtek/rtw88/usb.c | 27 ++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index a03896260f1a..715a2ce342d9 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -2,9 +2,11 @@
 /* Copyright(c) 2018-2019  Realtek Corporation
  */
 
+#include <linux/ip.h>
 #include <linux/module.h>
-#include <linux/usb.h>
 #include <linux/mutex.h>
+#include <linux/udp.h>
+#include <linux/usb.h>
 #include "main.h"
 #include "debug.h"
 #include "mac.h"
@@ -562,6 +564,27 @@ static int rtw_usb_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
 	return rtw_usb_write_data(rtwdev, &pkt_info, buf);
 }
 
+static bool rtw_usb_bmc_needs_dtim(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct udphdr *udphdr;
+
+	if (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO)
+		return true;
+
+	if (skb->protocol == htons(ETH_P_ARP))
+		return true;
+
+	if (skb->protocol == htons(ETH_P_IP) &&
+	    ip_hdr(skb)->protocol == IPPROTO_UDP) {
+		udphdr = udp_hdr(skb);
+
+		return udphdr->dest == htons(67) || udphdr->dest == htons(68);
+	}
+
+	return false;
+}
+
 #define RTW_USB_HIQ_REFILL_INTERVAL	(HZ / 10)	/* one unit of budget per 100 ms */
 #define RTW_USB_HIQ_BUDGET_MAX		16
 
@@ -604,7 +627,7 @@ static u8 rtw_usb_tx_queue_mapping_to_qsel(struct rtw_usb *rtwusb,
 	else if (is_broadcast_ether_addr(hdr->addr1) ||
 		 is_multicast_ether_addr(hdr->addr1))
 		qsel = (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) &&
-		       rtw_usb_hiq_take_budget(rtwusb) ?
+		       rtw_usb_bmc_needs_dtim(skb) && rtw_usb_hiq_take_budget(rtwusb) ?
 		       TX_DESC_QSEL_HIGH : skb->priority;
 	else if (skb_get_queue_mapping(skb) <= IEEE80211_AC_BK)
 		qsel = skb->priority;
-- 
2.55.0

