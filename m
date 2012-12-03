Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45191 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2LCSxI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 13:53:08 -0500
Received: by mail-wi0-f170.google.com with SMTP id hq7so33692wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Dec 2012 10:53:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201212031611.57351.s.L-H@gmx.de>
References: <201212031611.57351.s.L-H@gmx.de>
Date: Mon, 3 Dec 2012 19:53:06 +0100
Message-ID: <CAGXE3d-xwQArEMM030ht04JDJueHTX3YJp+O6Mmt+LVaPpp1Cg@mail.gmail.com> (sfid-20121203_195316_293660_8445BF89)
Subject: Re: rt2500usb/ kernel 3.7+: WARNING: at net/wireless/core.c:389
 wiphy_register+0x3fd/0x431 [cfg80211]()
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 3, 2012 at 4:11 PM, Stefan Lippers-Hollmann <s.L-H@gmx.de> wrote:
> Using kernel v3.7-rc7-176-g7e5530a (current mainline HEAD), I notice
> the following WARN_ON() triggering with rt2500usb and no wireless
> interface appears.

Mind to try the patch below?

Thanks,
Helmut



>From 4e4223674e2e76ca7a8e449fccd1e0a2d326fc7b Mon Sep 17 00:00:00 2001
From: Helmut Schaa <helmut.schaa@googlemail.com>
Date: Mon, 3 Dec 2012 19:45:42 +0100
Subject: [PATCH] rt2x00: Only specify interface combinations if more then one
 interface is possible

Otherwise this triggers a warning in cfg80211, from net/wireless/core.c:

	/* Combinations with just one interface aren't real */
	if (WARN_ON(c->max_interfaces < 2))

This was introduced in commit 55d2e9da744ba11eae900b4bfc2da72eace3c1e1:
rt2x00: Replace open coded interface checking with interface combinations.

Reported-by: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c
b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 69097d1..dafb448 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1123,6 +1123,9 @@ static inline void
rt2x00lib_set_if_combinations(struct rt2x00_dev *rt2x00dev)
 	struct ieee80211_iface_limit *if_limit;
 	struct ieee80211_iface_combination *if_combination;

+	if (rt2x00dev->ops->max_ap_intf < 2)
+		return;
+
 	/*
 	 * Build up AP interface limits structure.
 	 */
-- 
1.8.0
