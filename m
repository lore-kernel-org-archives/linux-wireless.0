Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-156-71.gdrpmi.dsl-w.verizon.net ([71.115.156.71]:44880
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbZBCAZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 19:25:41 -0500
Received: from [IPv6:2001:4978:142:0:290:f5ff:fe3e:e3c7] (unknown [IPv6:2001:4978:142:0:290:f5ff:fe3e:e3c7])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by s0be.servebeer.com (Postfix) with ESMTPSA id AC932252A84
	for <linux-wireless@vger.kernel.org>; Mon,  2 Feb 2009 19:25:39 -0500 (EST)
Message-ID: <49878F03.5070705@erley.org> (sfid-20090203_012545_205136_2BCC2E79)
Date: Mon, 02 Feb 2009 19:25:39 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [patch resend] iw: align output for HT capabilities
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The HT capabilities have an additional space in front of them causing
them not to line up with the rest of the listed outputs.  This patch
removes that space.

Signed-off-by: Pat Erley <pat-lkml@erley.org>

---

Fixed my thunderbird settings (hopefully, thought I had done that last 
time)...

diff --git a/info.c b/info.c
index bf3b8bd..69be500 100644
--- a/info.c
+++ b/info.c
@@ -70,7 +70,7 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 #ifdef NL80211_BAND_ATTR_HT_CAPA
 		if (tb_band[NL80211_BAND_ATTR_HT_CAPA]) {
 			unsigned short cap = nla_get_u16(tb_band[NL80211_BAND_ATTR_HT_CAPA]);
-#define PCOM(fmt, args...) do { printf("\t\t\t * " fmt "\n", ##args); } while (0)
+#define PCOM(fmt, args...) do { printf("\t\t\t* " fmt "\n", ##args); } while (0)
 #define PBCOM(bit, args...) if (cap & (bit)) PCOM(args)
 			printf("\t\tHT capabilities: 0x%.4x\n", cap);
 			PBCOM(0x0001, "LPDC coding");
