Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44973 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab1GWJB7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 05:01:59 -0400
Received: by qwk3 with SMTP id 3so1455983qwk.19
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jul 2011 02:01:58 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1311409276-3316-1-git-send-email-weiyi.huang@gmail.com>
References: <1311409276-3316-1-git-send-email-weiyi.huang@gmail.com>
Date: Sat, 23 Jul 2011 11:01:58 +0200
Message-ID: <CA+icZUWC8SBifLJ4V+PavDkHvNxz4PeEYk3cTD8agug9icg8jQ@mail.gmail.com> (sfid-20110723_110202_810952_57954F57)
Subject: Re: [PATCH] ath5k: remove duplicated #include
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Huang Weiyi <weiyi.huang@gmail.com>
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	Pavel Roskin <proski@gnu.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>,
	Nick Kossifidis <mickflemm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 23, 2011 at 10:21 AM, Huang Weiyi <weiyi.huang@gmail.com> wrote:
> Remove duplicated #include('s) in
>  drivers/net/wireless/ath/ath5k/ahb.c
>
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
> ---
>  drivers/net/wireless/ath/ath5k/ahb.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
> index ba682a0..705e0f0 100644
> --- a/drivers/net/wireless/ath/ath5k/ahb.c
> +++ b/drivers/net/wireless/ath/ath5k/ahb.c
> @@ -24,7 +24,6 @@
>  #include "debug.h"
>  #include "base.h"
>  #include "reg.h"
> -#include "debug.h"
>
>  /* return bus cachesize in 4B word units */
>  static void ath5k_ahb_read_cachesize(struct ath_common *common, int *csz)
> --
> 1.5.6.4
>

[ CCing some ath5k developers and ML ]

Against which linux-version or GIT tree is this patch for?
Recent wireless-next (here I am on linux-next) was cleaned, the
includes list looks like this now:

[ drivers/net/wireless/ath/ath5k/ahb.c ]

#include <linux/nl80211.h>
#include <linux/platform_device.h>
#include <linux/etherdevice.h>
#include <ar231x_platform.h>
#include "ath5k.h"
#include "debug.h"
#include "base.h"
#include "reg.h"

- Sedat -
