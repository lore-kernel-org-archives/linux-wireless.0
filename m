Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:45179 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab2JCGHd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 02:07:33 -0400
Date: Wed, 3 Oct 2012 09:07:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Brett Rudley <brudley@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	kernel-janitors@vger.kernel.org
Subject: [patch 3/3] brcmfmac: Using zero instead of NULL
Message-ID: <20121003060713.GC3802@elgon.mountain> (sfid-20121003_080737_617346_0CF6D343)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sparse complains that we use zero instead of NULL here.  In fact, the
initialization is wrong and should be removed.  Doing these kinds of
bogus initializations means that GCC can't detect unitialized variables
and leads to bugs.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index ed83b54..9ddafc2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3973,7 +3973,7 @@ brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
 	u8  *curr_ie_buf;
 	u8  *mgmt_ie_buf = NULL;
 	int mgmt_ie_buf_len;
-	u32 *mgmt_ie_len = 0;
+	u32 *mgmt_ie_len;
 	u32 del_add_ie_buf_len = 0;
 	u32 total_ie_buf_len = 0;
 	u32 parsed_ie_buf_len = 0;
