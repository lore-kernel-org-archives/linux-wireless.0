Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40016 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab2BMVpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 16:45:13 -0500
Received: by iacb35 with SMTP id b35so5028952iac.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2012 13:45:13 -0800 (PST)
Message-ID: <4F398466.6010607@lwfinger.net> (sfid-20120213_224519_458566_15AC3C32)
Date: Mon, 13 Feb 2012 15:45:10 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Joe Perches <joe@perches.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTLWIFI_DEBUG bug
References: <1329142387.3365.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1329142387.3365.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/13/2012 08:13 AM, Johannes Berg wrote:
> config RTLWIFI_DEBUG
>          tristate "Additional debugging output"
>          depends on RTL8192CE || RTL8192CU || RTL8192SE || RTL8192DE
>          default y
>
> should be
>
> config RTLWIFI_DEBUG
>          bool "..."
>
> as otherwise
>
> +#ifdef CONFIG_RTLWIFI_DEBUG
>
> can never be true in a modular build.
>
> johannes

Johannes,

It is OK as is. The appropriate section of my .config has

CONFIG_RTL8192CE=m
CONFIG_RTL8192SE=m
CONFIG_RTL8192DE=m
CONFIG_RTL8192CU=m
CONFIG_RTLWIFI=m
CONFIG_RTLWIFI_DEBUG=m
CONFIG_RTL8192C_COMMON=m

Larry

