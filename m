Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.178]:10823 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbYGQLFO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 07:05:14 -0400
Received: by el-out-1112.google.com with SMTP id z25so1198806ele.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2008 04:05:13 -0700 (PDT)
Message-ID: <1ba2fa240807170405i5f47b4e0m3cf9253dd8b7d169@mail.gmail.com> (sfid-20080717_130519_851713_0B5C9C7A)
Date: Thu, 17 Jul 2008 14:05:13 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Denis V. Lunev" <den@openvz.org>
Subject: Re: [PATCH net-next 1/2] iwlwifi: compilation error when CONFIG_IWLWIFI_DEBUG is not set
Cc: davem@davemloft.net, yi.zhu@intel.com, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <1216286365-11703-1-git-send-email-den@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1216286365-11703-1-git-send-email-den@openvz.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 17, 2008 at 12:19 PM, Denis V. Lunev <den@openvz.org> wrote:
> CC [M]  drivers/net/wireless/iwlwifi/iwl-rfkill.o
> drivers/net/wireless/iwlwifi/iwl-led.c: In function 'iwl_led_brightness_set':
> drivers/net/wireless/iwlwifi/iwl-led.c:198: error: 'led_type_str' undeclared (first use in this function)
> drivers/net/wireless/iwlwifi/iwl-led.c:198: error: (Each undeclared identifier is reported only once
> drivers/net/wireless/iwlwifi/iwl-led.c:198: error: for each function it appears in.)
>
> The problem is that led_type_str is defined under CONFIG_IWLWIFI_DEBUG
> while IWL_DEBUG is a static inline function in this case. Replace it
> with macro.
>
> Signed-off-by: Denis V. Lunev <den@openvz.org>
> ---
>  drivers/net/wireless/iwlwifi/iwl-debug.h |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
> index 5838480..d6d729e 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-debug.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
> @@ -68,12 +68,8 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv);
>  #endif
>
>  #else
> -static inline void IWL_DEBUG(int level, const char *fmt, ...)
> -{
> -}
> -static inline void IWL_DEBUG_LIMIT(int level, const char *fmt, ...)
> -{
> -}
> +#define IWL_DEBUG(level, fmt, args...)
> +#define IWL_DEBUG_LIMIT(level, fmt, args...)
>  #endif                         /* CONFIG_IWLWIFI_DEBUG */
>
ACK
Tomas
