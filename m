Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:36122 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841AbZLXHoB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2009 02:44:01 -0500
Received: by iwn1 with SMTP id 1so5636825iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2009 23:43:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1261639870-17469-1-git-send-email-yi.zhu@intel.com>
References: <1261639870-17469-1-git-send-email-yi.zhu@intel.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 23 Dec 2009 23:43:39 -0800
Message-ID: <43e72e890912232343u79e6c3c9l1f45ef593b0ee73@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: remove generated/utsrelease.h dependency
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 23, 2009 at 11:31 PM, Zhu Yi <yi.zhu@intel.com> wrote:
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

Why is a version even needed?

  Luis
