Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:57166 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755151Ab2ARDMT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 22:12:19 -0500
Message-ID: <1326856336.20922.22.camel@joe2Laptop> (sfid-20120118_041222_726719_AE15DBE2)
Subject: Re: [PATCH] rtlwifi: Move pr_fmt macros to a single location
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 17 Jan 2012 19:12:16 -0800
In-Reply-To: <4f1636b2.D5g8MJEc04WZglzi%Larry.Finger@lwfinger.net>
References: <4f1636b2.D5g8MJEc04WZglzi%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-01-17 at 21:04 -0600, Larry Finger wrote:
> Although the rtlwifi family of devices contains 11 copies of the pr_fmt
> macro, the macro is not defined for all routines that need it. By moving
> the macro to wifi.h, a single copy is available for all routines.
[]
> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
> @@ -172,6 +172,8 @@ enum hardware_type {
>  	 _pdesc->rxmcs == DESC92_RATE5_5M ||		\
>  	 _pdesc->rxmcs == DESC92_RATE11M)
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

This #define should be before any #include of kernel.h/printk.h
or any other #include that might use it indirectly.


