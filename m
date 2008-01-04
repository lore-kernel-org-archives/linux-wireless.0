Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:62284 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbYADWF5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2008 17:05:57 -0500
Received: by nf-out-0910.google.com with SMTP id g13so511314nfb.21
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jan 2008 14:05:56 -0800 (PST)
To: linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: fix compilation warning in 'iwl-4965.c'
Date: Fri, 4 Jan 2008 23:05:54 +0100
Cc: linux-wireless@vger.kernel.org, yi.zhu@intel.com,
	linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200801042305.55188.mboton@gmail.com> (sfid-20080104_220606_832873_45A8E776)
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a compilation warning in 'iwl-4965.c'.

Signed-off-by: Miguel Bot=C3=B3n <mboton@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wire=
less/iwlwifi/iwl-4965.c
index 74999af..92237cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3616,7 +3616,7 @@ static void iwl4965_add_radiotap(struct iwl4965_p=
riv *priv,
 	if (skb_headroom(skb) < sizeof(*iwl4965_rt)) {
 		if (net_ratelimit())
 			printk(KERN_ERR "not enough headroom [%d] for "
-			       "radiotap head [%d]\n",
+			       "radiotap head [%ld]\n",
 			       skb_headroom(skb), sizeof(*iwl4965_rt));
 		return;
 	}

--=20
	Miguel Bot=C3=B3n
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
