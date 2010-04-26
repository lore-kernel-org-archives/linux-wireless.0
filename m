Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:32568 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475Ab0DZDYU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Apr 2010 23:24:20 -0400
Subject: Re: bug report: potential ERR_PTR dereference in iwm_debugfs_init()
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Carpenter <error27@gmail.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1272024227.17055.0.camel@jlt3.sipsolutions.net>
References: <20100422095929.GS29647@bicker>
	 <1271990911.14773.24.camel@debian>  <20100423114358.GD29093@bicker>
	 <1272024227.17055.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Apr 2010 11:22:23 +0800
Message-ID: <1272252143.14773.4126.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-04-23 at 20:03 +0800, Johannes Berg wrote:
> > The bit that was problematic in this code for me is that passing
> > ERR_PTR(-ENODEV) to debugfs_create_dir() on line 447 will cause an
> oops.
> > But, as you point out, the check on line 442 is never true because
> we
> > already established that debugfs is enabled.
> 
> I don't think so. See, that function will only return -ENODEV when
> debugfs is not compiled into the kernel, and in that case the argument
> to debugfs_create_dir is never used anyway. 

Yes, there won't be any kernel oops anyway. But the iwm debugfs code is
a little misleading. Dan, please feel free to send a patch to clean up
this. On the error path, either NULL or ERR_PTR(-ENODEV) (no other
errno) is returned. Since all the debugfs functions are defined as no-op
if CONFIG_DEBUG_FS is not selected, maybe we only check against NULL is
enough.

Thanks,
-yi

