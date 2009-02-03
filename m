Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-156-71.gdrpmi.dsl-w.verizon.net ([71.115.156.71]:51748
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbZBCAKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 19:10:55 -0500
Received: from [IPv6:2001:4978:142:0:290:f5ff:fe3e:e3c7] (unknown [IPv6:2001:4978:142:0:290:f5ff:fe3e:e3c7])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by s0be.servebeer.com (Postfix) with ESMTPSA id 69B99252A84
	for <linux-wireless@vger.kernel.org>; Mon,  2 Feb 2009 19:10:54 -0500 (EST)
Message-ID: <49878B8B.4020005@erley.org> (sfid-20090203_011100_708554_3B99B242)
Date: Mon, 02 Feb 2009 19:10:51 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [patch] iw: align output for HT capabilities
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The HT capabilities have an additional space in front of them causing
them not to line up with the rest of the listed outputs.  This patch
removes that space.

Signed-off-by: Pat Erley <pat-lkml@erley.org>

---

diff --git a/info.c b/info.c
index bf3b8bd..69be500 100644
--- a/info.c
+++ b/info.c
@@ -70,7 +70,7 @@ static int print_phy_handler(struct nl_msg *msg, void
*arg)
 #ifdef NL80211_BAND_ATTR_HT_CAPA
 		if (tb_band[NL80211_BAND_ATTR_HT_CAPA]) {
 			unsigned short cap = nla_get_u16(tb_band[NL80211_BAND_ATTR_HT_CAPA]);
-#define PCOM(fmt, args...) do { printf("\t\t\t * " fmt "\n", ##args); }
while (0)
+#define PCOM(fmt, args...) do { printf("\t\t\t* " fmt "\n", ##args); }
while (0)
 #define PBCOM(bit, args...) if (cap & (bit)) PCOM(args)
 			printf("\t\tHT capabilities: 0x%.4x\n", cap);
 			PBCOM(0x0001, "LPDC coding");
