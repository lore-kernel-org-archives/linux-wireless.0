Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55410 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZLXIUF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2009 03:20:05 -0500
Received: by ewy19 with SMTP id 19so7094526ewy.21
        for <linux-wireless@vger.kernel.org>; Thu, 24 Dec 2009 00:20:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1261639870-17469-1-git-send-email-yi.zhu@intel.com>
References: <1261639870-17469-1-git-send-email-yi.zhu@intel.com>
Date: Thu, 24 Dec 2009 09:20:01 +0100
Message-ID: <2d0a357f0912240020g4e0b6fa3j56426babc488a4d1@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: remove generated/utsrelease.h dependency
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Note:
This patch is for upstream (2.6.33) and occured after having merged
linux-kbuild tree [1] in linus-tree.

- Sedat -

[1] http://repo.or.cz/w/linux-kbuild.git

On Thu, Dec 24, 2009 at 8:31 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> Commit 900bb717424e5df12b1ef7ebb017be2a8915b806 uses UTS_RELEASE
> as the the in-tree iwlwifi driver version. However the inclusion
> of generated/utsrelease.h makes it a unpleasant behaviour to
> recompile the driver everytime when utsrelease.h is updated. In
> fact, the driver module is already built with the UTS_RELEASE
> information via vermagic of modinfo. Mark the in-tree driver
> with the version string "in-tree" to distinguish with those old
> out-of-tree drivers.
>
> Reported-by: David Miller <davem@davemloft.net>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-core.h |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
> index 308f679..375226b 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-core.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-core.h
> @@ -63,8 +63,6 @@
>  #ifndef __iwl_core_h__
>  #define __iwl_core_h__
>
> -#include <generated/utsrelease.h>
> -
>  /************************
>  * forward declarations *
>  ************************/
> @@ -72,7 +70,7 @@ struct iwl_host_cmd;
>  struct iwl_cmd;
>
>
> -#define IWLWIFI_VERSION UTS_RELEASE "-k"
> +#define IWLWIFI_VERSION "in-tree:"
>  #define DRV_COPYRIGHT  "Copyright(c) 2003-2009 Intel Corporation"
>  #define DRV_AUTHOR     "<ilw@linux.intel.com>"
>
> --
> 1.6.3.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
