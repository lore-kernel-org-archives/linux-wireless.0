Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:60748 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760391Ab3DCPFc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 11:05:32 -0400
Received: by mail-ie0-f175.google.com with SMTP id c12so1748628ieb.20
        for <linux-wireless@vger.kernel.org>; Wed, 03 Apr 2013 08:05:31 -0700 (PDT)
Message-ID: <515C4538.7090104@lwfinger.net> (sfid-20130403_170537_022616_195B4ED8)
Date: Wed, 03 Apr 2013 10:05:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Chen, Chien-Chia" <machen@suse.com>
CC: linux-wireless@vger.kernel.org, zhiyuan_yang@realsil.com.cn,
	page_he@realsil.com.cn, mmarek@suse.cz
Subject: Re: [PATCH] rtlwifi: rtl8188ee: Fix wrong header path
References: <1364979082-24226-1-git-send-email-machen@suse.com>
In-Reply-To: <1364979082-24226-1-git-send-email-machen@suse.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2013 03:51 AM, Chen, Chien-Chia wrote:
> From: "Chen, Chien-Chia" <machen@suse.com>
>
> This patch is to fix some wrong header file path.
> It has caused the build failed.
>
> Signed-off-by: Chen, Chien-Chia <machen@suse.com>
> Cc: larry.finger@lwfinger.net
> Cc: zhiyuan_yang@realsil.com.cn
> Cc: page_he@realsil.com.cn
> Cc: mmarek@suse.cz

Is this different than the version you sent yesterday?

Larry

> ---
>   drivers/net/wireless/rtlwifi/rtl8188ee/dm.c        |    6 +++---
>   drivers/net/wireless/rtlwifi/rtl8188ee/fw.c        |    6 +++---
>   drivers/net/wireless/rtlwifi/rtl8188ee/hw.c        |   14 +++++++-------
>   drivers/net/wireless/rtlwifi/rtl8188ee/led.c       |    4 ++--
>   drivers/net/wireless/rtlwifi/rtl8188ee/phy.c       |    6 +++---
>   drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.h |    2 +-
>   drivers/net/wireless/rtlwifi/rtl8188ee/rf.c        |    2 +-
>   drivers/net/wireless/rtlwifi/rtl8188ee/sw.c        |    6 +++---
>   drivers/net/wireless/rtlwifi/rtl8188ee/trx.c       |    8 ++++----
>   9 files changed, 27 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/dm.c b/drivers/net/wireless/rtlwifi/rtl8188ee/dm.c
> index 0a338cc..21a5cf0 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8188ee/dm.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8188ee/dm.c
> @@ -27,9 +27,9 @@
>    *
>    *****************************************************************************/
>
> -#include "wifi.h"
> -#include "base.h"
> -#include "pci.h"
> +#include "../wifi.h"
> +#include "../base.h"
> +#include "../pci.h"
>   #include "reg.h"
>   #include "def.h"
>   #include "phy.h"
> diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/fw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/fw.c
> index 66ff30b..57e4cc5 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8188ee/fw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8188ee/fw.c
> @@ -27,9 +27,9 @@
>    *
>    *****************************************************************************/
>
> -#include "wifi.h"
> -#include "pci.h"
> -#include "base.h"
> +#include "../wifi.h"
> +#include "../pci.h"
> +#include "../base.h"
>   #include "reg.h"
>   #include "def.h"
>   #include "fw.h"
> diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
> index d734d19..0f464d0 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
> @@ -27,13 +27,13 @@
>    *
>    *****************************************************************************/
>
> -#include "wifi.h"
> -#include "efuse.h"
> -#include "base.h"
> -#include "regd.h"
> -#include "cam.h"
> -#include "ps.h"
> -#include "pci.h"
> +#include "../wifi.h"
> +#include "../efuse.h"
> +#include "../base.h"
> +#include "../regd.h"
> +#include "../cam.h"
> +#include "../ps.h"
> +#include "../pci.h"
>   #include "reg.h"
>   #include "def.h"
>   #include "phy.h"
> diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/led.c b/drivers/net/wireless/rtlwifi/rtl8188ee/led.c
> index 95d42af..c81a9cb 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8188ee/led.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8188ee/led.c
> @@ -27,8 +27,8 @@
>    *
>    *****************************************************************************/
>
> -#include "wifi.h"
> -#include "pci.h"
> +#include "../wifi.h"
> +#include "../pci.h"
>   #include "reg.h"
>   #include "led.h"
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/phy.c b/drivers/net/wireless/rtlwifi/rtl8188ee/phy.c
> index c285631..224f801 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8188ee/phy.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8188ee/phy.c
> @@ -27,9 +27,9 @@
>    *
>    *****************************************************************************/
>
> -#include "wifi.h"
> -#include "pci.h"
> -#include "ps.h"
> +#include "../wifi.h"
> +#include "../pci.h"
> +#include "../ps.h"
>   #include "reg.h"
>   #include "def.h"
>   #include "phy.h"
> diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.h b/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.h
> index 622ea7e..70456ab 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.h
> @@ -30,7 +30,7 @@
>   #ifndef __RTL8723E_PWRSEQCMD_H__
>   #define __RTL8723E_PWRSEQCMD_H__
>
> -#include "wifi.h"
> +#include "../wifi.h"
>   /*---------------------------------------------*/
>   /* The value of cmd: 4 bits */
>   /*---------------------------------------------*/
> diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/rf.c b/drivers/net/wireless/rtlwifi/rtl8188ee/rf.c
> index e62bcab..4faafdb 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8188ee/rf.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8188ee/rf.c
> @@ -27,7 +27,7 @@
>    *
>    *****************************************************************************/
>
> -#include "wifi.h"
> +#include "../wifi.h"
>   #include "reg.h"
>   #include "def.h"
>   #include "phy.h"
> diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
> index e8ce189..c254693 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
> @@ -27,9 +27,9 @@
>    *
>    *****************************************************************************/
>
> -#include "wifi.h"
> -#include "core.h"
> -#include "pci.h"
> +#include "../wifi.h"
> +#include "../core.h"
> +#include "../pci.h"
>   #include "reg.h"
>   #include "def.h"
>   #include "phy.h"
> diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
> index 2518531..d075237 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
> @@ -27,10 +27,10 @@
>    *
>    *****************************************************************************/
>
> -#include "wifi.h"
> -#include "pci.h"
> -#include "base.h"
> -#include "stats.h"
> +#include "../wifi.h"
> +#include "../pci.h"
> +#include "../base.h"
> +#include "../stats.h"
>   #include "reg.h"
>   #include "def.h"
>   #include "phy.h"
>

