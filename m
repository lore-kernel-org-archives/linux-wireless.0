Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28090 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbXLSGXa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 01:23:30 -0500
Subject: Re: [PATCH] ipw2200: prevent alloc of unspecified size on stack
From: Zhu Yi <yi.zhu@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	viro@zeniv.linux.org.uk
In-Reply-To: <1198044062-25201-1-git-send-email-reinette.chatre@intel.com>
References: <1198044062-25201-1-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain
Date: Wed, 19 Dec 2007 14:20:40 +0800
Message-Id: <1198045240.2857.320.camel@debian.sh.intel.com> (sfid-20071219_062333_413256_396067A1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 2007-12-18 at 22:01 -0800, Reinette Chatre wrote:
> if log_len is larger than 4K then we are killing the stack.
> allocate on heap instead and limit size to what practically can
> be used (PAGE_SIZE)
> 
> Is it possible for this to get into 2.6.24?
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

ACK.

> ---
> +       /* not using min() because of its strict type checking */
> +       log_size = sizeof(*log) * log_len < PAGE_SIZE ?
> +                       sizeof(*log) * log_len : PAGE_SIZE;

A (u32) cast should work. But I don't think it's a big issue.

Thanks,
-yi

