Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.skyhub.de ([78.46.96.112]:39956 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab2DBRRj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 13:17:39 -0400
Date: Mon, 2 Apr 2012 19:17:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Joe Perches <joe@perches.com>
Subject: Re: CONFIG_RTLWIFI_DEBUG default y
Message-ID: <20120402171733.GB13264@x1.osrc.amd.com> (sfid-20120402_191756_430184_2094561A)
References: <20120402164920.GA13264@x1.osrc.amd.com>
 <1333385618.15422.17.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1333385618.15422.17.camel@joe2Laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 02, 2012 at 09:53:38AM -0700, Joe Perches wrote:
> To keep all the "printk(KERN_DEBUG" to "pr_debug(" conversion
> output the same as the it was prior to the patch.
> 
> Larry can default it to off if he wants.

>From looking at one user of this -
drivers/net/wireless/rtlwifi/rtl8192ce/hw.c - some of the messages look
like important ones which you wanna have enabled always, f.e. error
handling in rtl92ce_hw_init().

It probably needs splitting into debugging messages which are default n
and always-on messages.

Thanks.

-- 
Regards/Gruss,
Boris.
