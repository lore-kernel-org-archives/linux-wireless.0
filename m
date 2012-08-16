Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49560 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab2HPTTm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 15:19:42 -0400
Message-ID: <1345144775.4665.2.camel@jlt3.sipsolutions.net> (sfid-20120816_211955_424062_89EC3657)
Subject: Re: [PATCH 1/4] compat: fix SIMPLE_DEV_PM_OPS() on kernel 2.6.29
From: Johannes Berg <johannes@sipsolutions.net>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: mcgrof@gmail.com, linux-wireless@vger.kernel.org,
	lf_driver_backport@lists.linux-foundation.org
Date: Thu, 16 Aug 2012 21:19:35 +0200
In-Reply-To: <1344645007-26757-2-git-send-email-hauke@hauke-m.de> (sfid-20120811_023023_267459_29EC29DD)
References: <1344645007-26757-1-git-send-email-hauke@hauke-m.de>
	 <1344645007-26757-2-git-send-email-hauke@hauke-m.de>
	 (sfid-20120811_023023_267459_29EC29DD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-08-11 at 02:30 +0200, Hauke Mehrtens wrote:
> This patch reworks this commit:
> commit 8e661d67b1965afcfd9d3672803e2fc37765f6ef
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Thu Aug 2 22:15:05 2012 +0200
> 
>     compat: handle pci suspend/resume on kernel 2.6.29
> 
> The functions for pci suspend and resume are now created by
> compat_pci_suspend and compat_pci_resume and then used by
> SIMPLE_DEV_PM_OPS. This way attributes like static, const and so on are
> forwarded in the struct dev_pm_ops define on all kernel versions.
> 
> In addition this patch adds an own SIMPLE_DEV_PM_OPS() for kernel
> 2.6.32 overwriting the original, because in kernel 2.6.32 const is
> needed for struct dev_pm_ops in pci drivers.
> 
> This is based on work done by Johannes Berg.

Thanks!

johannes

