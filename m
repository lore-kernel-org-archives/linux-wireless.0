Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:55323 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755873Ab2BMUf2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 15:35:28 -0500
Message-ID: <1329165326.4939.16.camel@joe2Laptop> (sfid-20120213_213538_821382_5BE919B4)
Subject: Re: RTLWIFI_DEBUG bug
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 13 Feb 2012 12:35:26 -0800
In-Reply-To: <1329142387.3365.6.camel@jlt3.sipsolutions.net>
References: <1329142387.3365.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-02-13 at 15:13 +0100, Johannes Berg wrote:
> config RTLWIFI_DEBUG
>         tristate "Additional debugging output"
>         depends on RTL8192CE || RTL8192CU || RTL8192SE || RTL8192DE
>         default y
> 
> should be
> 
> config RTLWIFI_DEBUG
>         bool "..."
> 
> as otherwise
> 
> +#ifdef CONFIG_RTLWIFI_DEBUG
> can never be true in a modular build.

If you know the correct solution,
perhaps you should submit a patch.

