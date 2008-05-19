Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32386 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbYESDlr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 May 2008 23:41:47 -0400
Subject: Re: iwlwifi Makefile issue in compat-wireless-2008-05-18
From: Zhu Yi <yi.zhu@intel.com>
To: John Goulah <jgoulah@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <183c1cc10805181143v526fcc86l4bec27b12805748f@mail.gmail.com>
References: <183c1cc10805181143v526fcc86l4bec27b12805748f@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 19 May 2008 11:41:15 +0800
Message-Id: <1211168475.31033.9.camel@debian.sh.intel.com> (sfid-20080519_054153_291014_42F196E1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-05-18 at 14:43 -0400, John Goulah wrote:
> Hello,
> 
>  Went to install the new version and found that it wasn't installing
> the iwl4965 driver.  I did a diff against my last good version (back
> in April so not sure how long its been like this)

We introduced the virtual CONFIG_IWLWIFI in recent wireless-testing. It
is a tristate when either CONFIG_IWL3945 or CONFIG_IWLCORE is selected.
It doesn't appear in the old kernel you are compiling against. Maybe
someone need to make a patch for Kconfig in compact-wireless?

Thanks,
-yi

> I noticed this change, and when I reverted it back, the driver built fine:
> 
> 
> compat-wireless-2008-05-18$ diff -u
> /usr/local/src/compat-wireless-2008-04-08/drivers/net/wireless/Makefile
>  drivers/net/wireless/Makefile
> --- /usr/local/src/compat-wireless-2008-04-08/drivers/net/wireless/Makefile
>     2008-04-08 00:12:21.000000000 -0400
> +++ drivers/net/wireless/Makefile       2008-05-18 00:11:30.000000000 -0400
> @@ -23,12 +23,9 @@
> 
>  obj-$(CONFIG_ADM8211)  += adm8211.o
> 
> -obj-$(CONFIG_IWL3945)  += iwlwifi/
> -obj-$(CONFIG_IWL4965)  += iwlwifi/
> +obj-$(CONFIG_IWLWIFI)  += iwlwifi/
>  obj-$(CONFIG_RT2X00)   += rt2x00/
> 
> 
> 
> 
> 
> Hope this helps to straighten this issue out.
> 
> 
> Thanks,
> John
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

