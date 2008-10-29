Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28618 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbYJ2RKc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 13:10:32 -0400
Subject: Re: 2.6.28-rc regression: Can't stop Rx DMA
From: reinette chatre <reinette.chatre@intel.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20081029002713.GA16554@isilmar.linta.de>
References: <1ba2fa240810181630t781468dbi23b103e656f64153@mail.gmail.com>
	 <20081019075916.GA12904@isilmar.linta.de>
	 <1225145468.1115.139.camel@rc-desk>
	 <20081027230326.GA23250@isilmar.linta.de>
	 <1225154823.1115.149.camel@rc-desk>
	 <20081028194323.GA14303@isilmar.linta.de>
	 <1225225434.1115.217.camel@rc-desk> <1225235731.1369.8.camel@johannes.berg>
	 <1225236760.1115.245.camel@rc-desk>
	 <20081028233841.GA12554@isilmar.linta.de>
	 <20081029002713.GA16554@isilmar.linta.de>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 10:10:52 -0700
Message-Id: <1225300252.1115.266.camel@rc-desk> (sfid-20081029_181040_978514_838DF7EC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-10-28 at 17:27 -0700, Dominik Brodowski wrote:
> With CONFIG_WIRELESS_OLD_REGULATORY=y, both the old and the new firmware
> works. Without, only the old firmware works.

(I assume you mean "only the new firmware works")

> 
> I'd think that at least the error message could be clarified a bit
> (is it really a "Microcode SW error"?)... also, it might be a corner case
> whether the new firmware would better be called -2 because of this
> incompatibility?

We can do away with the error message with a driver change. This patch
should take care of it:

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 0758f8f..ab7c93d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6219,6 +6219,11 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 					      n_probes,
 			(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
 
+	if (scan->channel_count == 0) {
+		IWL_DEBUG_SCAN("channel count %d\n", scan->channel_count);
+		goto done;
+	}
+
 	cmd.len += le16_to_cpu(scan->tx_cmd.len) +
 	    scan->channel_count * sizeof(struct iwl3945_scan_channel);
 	cmd.data = scan;


