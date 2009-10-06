Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932888AbZJFOtG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 10:49:06 -0400
Date: Tue, 6 Oct 2009 16:48:02 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 08/13] iwlwifi: device tracing
Message-ID: <20091006144801.GA3827@dhcp-lab-161.englab.brq.redhat.com>
References: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com> <1254516247-4085-9-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1254516247-4085-9-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 02, 2009 at 01:44:02PM -0700, Reinette Chatre wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> 
> In order to have an easier way to debug issues, create
> trace events (using the ftrace framework) that will
> allow us to follow exactly what the driver is doing
> with the device.

Cool.

> The text format isn't all that useful, but the binary
> format can also be obtained easily via debugfs and
> then analysed on the fly or offline with debugging
> tools.

What particular tool is most useful here (Yes, I didn't read
Documentation/trace yet) ?

Shouldn't we also remove or at least rewrite IWL_DEBUG_{IO,TX,RX}
to simplify things and remove double functionality ? 
 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.c b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
> new file mode 100644
> index 0000000..4ef5aca
> --- /dev/null
> +++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
> @@ -0,0 +1,13 @@
> +#include <linux/module.h>
> +
> +/* sparse doesn't like tracepoint macros */
> +#ifndef __CHECKER__
> +#define CREATE_TRACE_POINTS
> +#include "iwl-devtrace.h"
> +
> +EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ioread32);
> +EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_iowrite32);
> +EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_rx);

Missed EXPORT_TRACEPOINT_SYMBOL(iwlwif_dev_tx) ?

> +EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_event);
> +EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_error);
> +#endif

Beside, shouldn't we have two trace point - one when sending data to device
second when getting ACK in rx queue ? 

Stanislaw
