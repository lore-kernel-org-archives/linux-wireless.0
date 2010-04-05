Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44777 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439Ab0DEWRR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Apr 2010 18:17:17 -0400
Received: by pwj9 with SMTP id 9so731245pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Apr 2010 15:17:16 -0700 (PDT)
Message-ID: <4BBA6186.2030108@gmail.com>
Date: Mon, 05 Apr 2010 15:17:42 -0700
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: Matteo Croce <technoboy85@gmail.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Compat wireless with kernel 2.6.33
References: <40101cc31003200759u447b625ct6f48aa6003593dac@mail.gmail.com>
In-Reply-To: <40101cc31003200759u447b625ct6f48aa6003593dac@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis,

It would be nice to see this pushed into the latest compat-wireless.

It's helpful for people using a 2.6.33 kernel and needing the latest b43 
updates for our Atom-based netbooks! :)

John Daiker

On 03/20/2010 07:59 AM, Matteo Croce wrote:
> This patch allows compat wireless to compile with a kernel>= 2.6.33
>
> Index: compat-wireless-2010-03-19/scripts/gen-compat-autoconf.sh
> ===================================================================
> --- compat-wireless-2010-03-19.orig/scripts/gen-compat-autoconf.sh	2010-03-20
> 15:26:22.604720545 +0100
> +++ compat-wireless-2010-03-19/scripts/gen-compat-autoconf.sh	2010-03-20
> 15:27:49.212236531 +0100
> @@ -145,7 +145,11 @@
>   kernel_version_req $OLDEST_KERNEL_SUPPORTED
>
>   # Handle core kernel wireless depenencies here
> +echo '#if LINUX_VERSION_CODE>= KERNEL_VERSION(2,6,33)'
> +define_config_req CONFIG_CFG80211_WEXT
> +echo '#else'
>   define_config_req CONFIG_WIRELESS_EXT
> +echo '#endif'
>
>   # For each CONFIG_FOO=x option
>   for i in $(grep '^CONFIG_' $COMPAT_CONFIG); do
>
>

