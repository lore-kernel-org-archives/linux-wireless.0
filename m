Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53559 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727Ab0DEXeg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Apr 2010 19:34:36 -0400
Received: by pwj9 with SMTP id 9so763342pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Apr 2010 16:34:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40101cc31003200759u447b625ct6f48aa6003593dac@mail.gmail.com>
References: <40101cc31003200759u447b625ct6f48aa6003593dac@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 5 Apr 2010 16:34:15 -0700
Message-ID: <t2g43e72e891004051634i8233e5dan23d60ce985613726@mail.gmail.com>
Subject: Re: Compat wireless with kernel 2.6.33
To: Matteo Croce <technoboy85@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 20, 2010 at 7:59 AM, Matteo Croce <technoboy85@gmail.com> wrote:
> This patch allows compat wireless to compile with a kernel >= 2.6.33
>
> Index: compat-wireless-2010-03-19/scripts/gen-compat-autoconf.sh
> ===================================================================
> --- compat-wireless-2010-03-19.orig/scripts/gen-compat-autoconf.sh      2010-03-20
> 15:26:22.604720545 +0100
> +++ compat-wireless-2010-03-19/scripts/gen-compat-autoconf.sh   2010-03-20
> 15:27:49.212236531 +0100
> @@ -145,7 +145,11 @@
>  kernel_version_req $OLDEST_KERNEL_SUPPORTED
>
>  # Handle core kernel wireless depenencies here
> +echo '#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,33)'
> +define_config_req CONFIG_CFG80211_WEXT
> +echo '#else'
>  define_config_req CONFIG_WIRELESS_EXT
> +echo '#endif'
>
>  # For each CONFIG_FOO=x option
>  for i in $(grep '^CONFIG_' $COMPAT_CONFIG); do

Sorry been meaning to reply, reason I haven't applied it is this seems
wrong, we should be able to build kernels with 802.11 without wext
crap on new kernels. Perhaps only add the requirement for kernels
older than 2.6.33?

  Luis
