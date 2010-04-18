Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:56654 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab0DROPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Apr 2010 10:15:16 -0400
Message-ID: <20100418101514.q7rwgz9zwgk8sg0k-cebfxv@webmail.spamcop.net>
Date: Sun, 18 Apr 2010 10:15:14 -0400
From: Pavel Roskin <proski@gnu.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
Subject: Re: [PATCH 1/3] compat-wireless: backport convert multicast list
	to list_head.
References: <1271597784-4811-1-git-send-email-hauke@hauke-m.de>
	<1271597784-4811-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1271597784-4811-2-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, Hauke!

Thank you for doing this effort!  I would prefer that we avoid  
patching as much as possible.  Patches tend to break as the code  
changes.  I think there are several cases where patching can be  
eliminated.

> ++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
> + 	struct netdev_hw_addr *ha;
> ++#else
> ++	struct dev_mc_list *ha;
> ++#endif

We could simply use this in some header:

#define dev_mc_list netdev_hw_addr

> + 	/* comoute mc addresses' hash value ,and put it into hash table */

Someone had a bout of dyslexia, and it will be fixed, breaking the patch :-)

> + 	netdev_for_each_mc_addr(ha, netdev) {
> ++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
> + 		hash_value = atl1c_hash_mc_addr(hw, ha->addr);
> ++#else
> ++		hash_value = atl1c_hash_mc_addr(hw, ha->dmi_addr);
> ++#endif

#define addr dmi_addr

OK, this is likely to break if done in a header, but maybe it could be  
done in the C code away from the rest of the code.

> ++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
> + 	__hw_addr_unsync(&local->mc_list, &dev->mc, dev->addr_len);
> ++#else
> ++	__dev_addr_unsync(&local->mc_list, &local->mc_count,
> ++			  &dev->mc_list, &dev->mc_count);
> ++#endif

Cannot we reimplement __hw_addr_unsync()?

> ++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
> +
> + 	__hw_addr_init(&local->mc_list);
> +
> ++#endif

That could be an empty function.

-- 
Regards,
Pavel Roskin
