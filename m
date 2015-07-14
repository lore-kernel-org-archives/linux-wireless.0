Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:36802 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbbGNMiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2015 08:38:16 -0400
Received: by lagw2 with SMTP id w2so5191338lag.3
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2015 05:38:15 -0700 (PDT)
Subject: Re: [PATCH] iwlwifi: Deinline iwl_{read,write}{8,32}
To: Denys Vlasenko <dvlasenk@redhat.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
References: <1436876558-6674-1-git-send-email-dvlasenk@redhat.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <55A502B6.5090806@cogentembedded.com> (sfid-20150714_143822_393295_5F02E6CD)
Date: Tue, 14 Jul 2015 15:38:14 +0300
MIME-Version: 1.0
In-Reply-To: <1436876558-6674-1-git-send-email-dvlasenk@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 7/14/2015 3:22 PM, Denys Vlasenko wrote:

> With CONFIG_IWLWIFI_DEVICE_TRACING=y, these functions are rather large,
> too big for inlining.

> With this .config: http://busybox.net/~vda/kernel_config,
> after uninlining these functions have sizes and callsite counts
> as follows:

> iwl_read32  475 bytes, 51 callsites
> iwl_write32 477 bytes, 90 callsites
> iwl_write8  493 bytes, 3 callsites

> Reduction in size is about 74,000 bytes:

>      text     data      bss       dec     hex filename
> 90758147 17226024 36659200 144643371 89f152b vmlinux0
> 90687995 17221928 36659200 144569123 89df323 vmlinux.after

> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> CC: Johannes Berg <johannes.berg@intel.com>
> CC: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: Intel Linux Wireless <ilw@linux.intel.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> ---
>   drivers/net/wireless/iwlwifi/iwl-io.c |  7 +++++++
>   drivers/net/wireless/iwlwifi/iwl-io.h | 39 +++++++++++++++++++++--------------
>   2 files changed, 30 insertions(+), 16 deletions(-)

[...]
> diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
> index 705d12c..3c9d2a8 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-io.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-io.h
> @@ -32,24 +32,31 @@
>   #include "iwl-devtrace.h"
>   #include "iwl-trans.h"
>
[...]
> +#define IWL_READ_WRITE(static_inline) \
> +static_inline void iwl_write8(struct iwl_trans *trans, u32 ofs, u8 val) \
> +{ \
> +	trace_iwlwifi_dev_iowrite8(trans->dev, ofs, val); \
> +	iwl_trans_write8(trans, ofs, val); \
> +} \
> +static_inline void iwl_write32(struct iwl_trans *trans, u32 ofs, u32 val) \
> +{ \
> +	trace_iwlwifi_dev_iowrite32(trans->dev, ofs, val); \
> +	iwl_trans_write32(trans, ofs, val); \
> +} \
> +static_inline u32 iwl_read32(struct iwl_trans *trans, u32 ofs) \
> +{ \
> +	u32 val = iwl_trans_read32(trans, ofs); \
> +	trace_iwlwifi_dev_ioread32(trans->dev, ofs, val); \
> +	return val; \
>   }
[...]
> +#if !defined(CONFIG_IWLWIFI_DEVICE_TRACING)
> +IWL_READ_WRITE(static inline)

    Not static_inline?

> +#else
> +void iwl_write8(struct iwl_trans *trans, u32 ofs, u8 val);
> +void iwl_write32(struct iwl_trans *trans, u32 ofs, u32 val);
> +u32 iwl_read32(struct iwl_trans *trans, u32 ofs);
> +#endif

MBR, Sergei

