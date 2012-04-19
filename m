Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63045 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab2DSUPT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 16:15:19 -0400
Subject: Re: net-next iwlwifi breaks compile - was Re: pull request:
 wireless-next 2012-04-18
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: David Miller <davem@davemloft.net>
Cc: meenakshi.venkataraman@intel.com, socketcan@hartkopp.net,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, david.spinadel@intel.com
In-Reply-To: <20120419.154954.1322943404183128381.davem@davemloft.net>
References: <20120418.153653.2130740499995307564.davem@davemloft.net>
	 <4F8F9977.9040703@hartkopp.net>
	 <4595B4D22AB93C4FABBA84AAD5AA37FD1258AA@ORSMSX103.amr.corp.intel.com>
	 <20120419.154954.1322943404183128381.davem@davemloft.net>
Content-Type: multipart/mixed; boundary="=-B2nZZ3zKDzg+6F64Aab2"
Date: Thu, 19 Apr 2012 13:10:41 -0700
Message-ID: <1334866241.27767.156.camel@wwguy-huron> (sfid-20120419_221527_259364_B80EDDEB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-B2nZZ3zKDzg+6F64Aab2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi David,


On Thu, 2012-04-19 at 15:49 -0400, David Miller wrote:
> From: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
> Date: Thu, 19 Apr 2012 19:47:58 +0000
> 
> > It was fixed internally in a subsequent patch, but that patch has
> > not made it into net-next. I don't see it in the public iwlwifi
> > repository either. We'll add the fix to the repository so you can
> > pick it up.
> 
> That's not how this works.
> 
> You should submit a patch to fix the build directly to me, immediately,
> so that I can push it directly into net-next as fast as possible.

The patch "iwlwifi-Remove-inconsistent-and-redundant-declaratio.patch"
already being push to John to address this issue

Thanks
Wey 

--=-B2nZZ3zKDzg+6F64Aab2
Content-Disposition: attachment; filename*0=0012-iwlwifi-Remove-inconsistent-and-redundant-declaratio.pat; filename*1=ch
Content-Type: text/x-patch; name="0012-iwlwifi-Remove-inconsistent-and-redundant-declaratio.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From c27cf685d185cc4604776252fdcaca5ad24abcca Mon Sep 17 00:00:00 2001
From: David Spinadel <david.spinadel@intel.com>
Date: Tue, 27 Mar 2012 10:22:29 +0200
Subject: [PATCH 12/15] iwlwifi: Remove inconsistent and redundant declaration

Remove declaration of iwl_alloc_traffic_mem from iwl-agn.h,
from methods that was exposed to support MVM.

MVM doesn't have to use this declaration.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 67cd123..3d6f3e2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -510,7 +510,6 @@ void iwl_setup_deferred_work(struct iwl_priv *priv);
 int iwl_send_wimax_coex(struct iwl_priv *priv);
 int iwl_send_bt_env(struct iwl_priv *priv, u8 action, u8 type);
 void iwl_debug_config(struct iwl_priv *priv);
-int iwl_alloc_traffic_mem(struct iwl_priv *priv);
 void iwl_set_hw_params(struct iwl_priv *priv);
 void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags);
 int iwl_init_drv(struct iwl_priv *priv);
-- 
1.7.0.4


--=-B2nZZ3zKDzg+6F64Aab2--

