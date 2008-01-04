Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.191]:8104 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbYADWeh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2008 17:34:37 -0500
Received: by mu-out-0910.google.com with SMTP id i10so5547392mue.5
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jan 2008 14:34:36 -0800 (PST)
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: fix compilation warning in 'iwl-4965.c'
Date: Fri, 4 Jan 2008 23:34:35 +0100
Cc: linux-wireless@vger.kernel.org, yi.zhu@intel.com,
	linville@tuxdriver.com
References: <200801042305.55188.mboton@gmail.com>
In-Reply-To: <200801042305.55188.mboton@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200801042334.36177.mboton@gmail.com> (sfid-20080104_223441_564756_B21C18C2)
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, there's a new patch.

This patch fixes a compilation warning in 'iwl-4965.c'.

"warning: format =E2=80=98%d=E2=80=99 expects type =E2=80=98int=E2=80=99=
, but argument 3 has type =E2=80=98long unsigned int=E2=80=99"

Signed-off-by: Miguel Bot=C3=B3n <mboton@gmail.com

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
+			       "radiotap head [%zd]\n",
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
