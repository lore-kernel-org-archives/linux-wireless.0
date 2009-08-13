Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:34020 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752531AbZHMJLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 05:11:13 -0400
Date: Thu, 13 Aug 2009 12:11:03 +0300
From: Jouni Malinen <j@w1.fi>
To: Zhu Yi <yi.zhu@intel.com>
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] nl80211 connect API support
Message-ID: <20090813091103.GA1826@jm.kir.nu>
References: <1250153731-17208-1-git-send-email-yi.zhu@intel.com> <1250153731-17208-2-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1250153731-17208-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 13, 2009 at 04:55:31PM +0800, Zhu Yi wrote:

> -	 * authenticate - Request driver to authenticate
> +	 * authenticate - Request driver to authenticate (deprecated)

> +	 * This is an optional function that to make compatibility for wireless
> +	 * stack that doesn't support connect API when driver SME is used
> +	 * (WPA_DRIVER_FLAGS_SME).

Thanks for the patch. If I understood this correctly, wpa_supplicant
would be converted to use the new connect command whenever it is
supported. While it is nice to get support for connect added, this is
not how it should be done as it breaks all the new work we have been
enabling with mac80211. The separate auth/assoc commands should be the
default operation and only if the driver does not support this, should
the connect command be used.

-- 
Jouni Malinen                                            PGP id EFC895FA
